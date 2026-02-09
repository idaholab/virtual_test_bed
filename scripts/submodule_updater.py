#!/usr/bin/env python

"""
To use this script to update the VTBs submodules, from the scripts directory,
run the following command:
python submodule_updater.py ..
"""

import os
import argparse
import yaml
import re
import textwrap
import subprocess
import sys
import shlex

import git
import gitlab # available through the 'python-gitlab' conda package
import github # avialable through the 'pygithub' conda package

def parse_args():
    parser = argparse.ArgumentParser(prog = 'appupdate', description = 'Update submodules in an application', formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument('--no-push', action='store_true', help='Do not push and open a PR/MR')
    parser.add_argument('--no-pr', action='store_true', help='Do not open a PR/MR')
    parser.add_argument('--skip-submodules', nargs='?', help='Submodules to skip')
    parser.add_argument('--force', '-f', action='store_true', help='Do force pushes')

    parser.add_argument('--head-branch', default='submodule_update', help='The head branch, default: \'submodule_update\'')
    parser.add_argument('--head-remote', default='origin', help='The head remote, default: \'origin\'')
    parser.add_argument('--base-branch', default='devel', help='The base branch, default: \'devel\'')
    parser.add_argument('--base-remote', default='upstream', help='The base remote, default: \'upstream\'')

    parser.add_argument('repo', help='Path to the repository')
    parser.add_argument('--use-hpc-submodules', action='store_true', help='Whether to update submodule to the latest HPC versions. This should be run on HPC only.')
    parser.add_argument('submodule:sha1', nargs='?',
                        help='Submodule name and its version to update to. If not specified, `origin/master` or the latest hpc submodule if --use-hpc-submodules is specified.')

    parser.add_argument('--config-file', default="./config.yaml",
                        help=textwrap.dedent("""\
                        Path to yaml file containing the personal access token to the repository being updated.
                        The file should have the following format:
                        tokens:
                          your_personal_access_token_here
                        """))


    return parser.parse_args()

def load_remote(repo, remote, config_tokens):
    if not hasattr(repo.remotes, remote):
        raise SystemExit(f'Repo {repo.working_dir} is missing remote \'{remote}\'')

    url = getattr(repo.remotes, remote).url
    pattern = r'^(git@|https://)([0-9a-zA-Z_.-]+)(:|/)([0-9a-zA-Z_.-]+)/([0-9a-zA-Z_-]+)(?:\.git)?'
    match_remote = re.match(pattern, url)
    if match_remote:
        host = match_remote.group(2)
        namespace = match_remote.group(4)
        repo_name = match_remote.group(5)
    else:
        raise SystemExit(f'Failed to parse repo from {url}')

    if host not in config_tokens:
        raise SystemExit(f'API token for {host} not found')

    if 'github' in host:
        github_kwargs = {'auth': github.Auth.Token(config_tokens[host])}
        if host != 'github.com':
            github_kwargs['gh_url'] = 'https://' + host + '/api/v3'
        gh = github.Github(**github_kwargs)
        repo_api = gh.get_repo(f'{namespace}/{repo_name}')

    else:
        raise SystemExit(f'Host \'{host}\' not supported.')

    return host, namespace, repo_name, repo_api

def mask_config_file_arg(argv):
    masked = []
    skip_next = False
    for arg in argv:
        if skip_next:
            masked.append(os.path.join('<redacted>', os.path.basename(arg)))
            skip_next = False
            continue
        if arg == '--config-file':
            masked.append(arg)
            skip_next = True
            continue
        if arg.startswith('--config-file='):
            config_path = arg.split('=', 1)[1]
            masked_path = os.path.join('<redacted>', os.path.basename(config_path))
            masked.append(f'--config-file={masked_path}')
            continue
        masked.append(arg)
    return masked

def quote_arg(arg):
    if arg.startswith('<redacted>/') or arg.startswith('--config-file=<redacted>/'):
        return arg
    return shlex.quote(arg)

if __name__ == "__main__":
    # Parse arguments
    args = parse_args()
    head_remote = args.head_remote
    head_branch = args.head_branch
    base_remote = args.base_remote
    base_branch = args.base_branch
    config_file = args.config_file

    # Load the config
    with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), config_file), 'r') as f:
        config = yaml.safe_load(f)

    # Load the git repo
    repo_path = os.path.realpath(args.repo)
    try:
        git_repo = git.Repo(repo_path)
    except:
        raise SystemExit(repo_path + ' is not a valid git repository')

    # Load the remotes
    head_host, head_namespace, head_repo, head_repo_api = load_remote(git_repo, head_remote, config['tokens'])
    base_host, base_namespace, base_repo, base_repo_api = load_remote(git_repo, base_remote, config['tokens'])

    # Sanity check on the same remotes
    if head_host != base_host:
       raise SystemExit(f'Host mismatch between remotes \'{head_remote}\' and \'{base_remote}\'')
    host = head_host

    # Get list of active modules
    submodules = []
    for submodule in git_repo.submodules:
        if submodule.module_exists():
            submodules.append(submodule)

    masked_argv = mask_config_file_arg(sys.argv[1:])
    pr_command = "python " + " ".join(quote_arg(a) for a in [sys.argv[0]] + masked_argv)
    pr_header = ("This PR was generated by running the following command from the repository root:\n"
                 f"{pr_command}\n")
    print(pr_header)
    pr_body_text = pr_header + "\nUpdates application submodules:\n"

    submodule_sha1 = {}
    # Load the hpc submodules if requested
    if args.use_hpc_submodules:
        info = 'Looking for hpc submodule versions'
        print(info)
        pr_body_text += f"{info}\n"
        for submodule in submodules:
            sm_name = submodule.name.split('apps/')[-1].replace('_', '').lower()
            # This regex assumes the latest date is the last line
            cmd = rf"module spider {sm_name}-openmpi |& grep -Po '^\s*{sm_name}-.*/\d{{4}}\.\d{{2}}\.\d{{2}}-\K[0-9a-f]{{7}}' | tail -n1"
            try:
                sha1 = subprocess.check_output(cmd, shell=True, text=True).strip()
                if sha1 == '':
                    raise ValueError
                submodule_sha1[submodule.name] = sha1
                info = f"  - Found hpc sha {sha1} for submodule {sm_name}"
                print(info)
                pr_body_text += f"{info}\n"
            except:
                info = f"  - Could not determine hpc version for {sm_name}. Falling back to default behavior."
                print(info)
                pr_body_text += f"{info}\n"
                continue

    # Load the user-provided submodules
    submodule_sha1_args = vars(args)['submodule:sha1']
    if submodule_sha1_args is not None:
        for ss1 in submodule_sha1_args:
            (sm_name, sha1) = ss1.split(':')
            submodule_sha1[sm_name] = sha1

    has_head_branch = head_branch in [branch.name for branch in git_repo.branches]
    if has_head_branch:
        print(f'Checking out branch \'{head_branch}\'')
        git_repo.git.checkout(head_branch)
    else:
        print(f'Creating branch \'{head_branch}\'')
        git_repo.git.checkout('-b', head_branch)

    print(f'Resetting {head_branch} in {repo_path} to latest {base_remote}/{base_branch}')
    git_repo.git.fetch(base_remote)
    git_repo.git.reset(f'{base_remote}/{base_branch}', hard=True)
    print('Syncing submodules to superproject commits')
    for submodule in submodules:
        if args.skip_submodules is not None and submodule.name in args.skip_submodules:
            info = f'  - {submodule} SKIPPED (sync)'
            print(info)
            pr_body_text += f"{info}\n"
            continue
        try:
            git_repo.git.submodule('update', '--', submodule.path)
        except git.exc.GitCommandError as e:
            err_text = (e.stderr or '').strip()
            info = f'  - WARNING: {submodule} sync failed; skipping ({err_text})'
            print(info)
            pr_body_text += f"{info}\n"

    info = '\nUpdating submodules'
    print(info)
    pr_body_text += f"{info}\n"
    submodules_left = list(submodule_sha1.keys())
    for submodule in submodules:
        if submodule.name in submodule_sha1:
            sha1 = submodule_sha1[submodule.name]
            submodules_left.remove(submodule.name)
        else:
            sha1 = 'origin/master'
        if args.skip_submodules is not None and submodule.name in args.skip_submodules:
            info = f'  - {submodule} SKIPPED'
            print(info)
            pr_body_text += f"{info}\n"
            continue
        sm_git_repo = git.Repo(os.path.join(repo_path, submodule.path))
        try:
            sm_git_repo.git.fetch('origin')
        except git.exc.GitCommandError as e:
            err_text = (e.stderr or '').strip()
            info = f'  - WARNING: {submodule} fetch failed; skipping update'
            if err_text:
                info += f' ({err_text})'
            print(info)
            pr_body_text += f"{info}\n"
            continue
        current_sha = sm_git_repo.head.commit.hexsha[:7]
        info = f'  - {submodule} from {current_sha} to {sha1}'
        print(info)
        pr_body_text += f"{info}\n"
        if args.use_hpc_submodules and submodule.name in submodule_sha1:
            hpc_sha = submodule_sha1[submodule.name]
            if hpc_sha != current_sha:
                try:
                    current_dt = sm_git_repo.head.commit.committed_datetime
                    hpc_dt = sm_git_repo.commit(hpc_sha).committed_datetime
                    if current_dt > hpc_dt:
                        current_dt_str = current_dt.isoformat()
                        hpc_dt_str = hpc_dt.isoformat()
                        info = (f'  - WARNING: {submodule} current ({current_sha}, {current_dt_str}) '
                                f'is newer than HPC ({hpc_sha}, {hpc_dt_str}); skipping update')
                        print(info)
                        pr_body_text += f"{info}\n"
                        continue
                except git.exc.GitCommandError:
                    info = (f'  - WARNING: Could not compare {submodule} current ({current_sha}) '
                            f'with HPC ({hpc_sha}); proceeding with update')
                    print(info)
                    pr_body_text += f"{info}\n"
        sm_git_repo.git.checkout(sha1)
        git_repo.git.add(submodule.name)

    for submodule_name in submodules_left:
        info = f'  User-specified submodule {submodule_name} SKIPPED (not a valid submodule)'
        print(info)
        pr_body_text += f"{info}\n"

    # If there is a diff between HEAD and the index
    # i.e., if there is something to commit
    if len(git_repo.head.commit.diff()) > 0:
        git_repo.git.commit('-m', 'Update submodules\n\nRefs #0')

    if not args.no_push:
        print(f'Pushing \'{head_branch}\' to {head_host}:{head_namespace}/{head_repo}')

        # In the case that the head branch already existed, we need to force push
        # because we have reset local to base_remote/base_branch.
        extra_args = []
        if args.force or has_head_branch:
            extra_args.append('-f')

        git_repo.git.push(*extra_args, head_remote, head_branch)

        if not args.no_pr:
            print(f'Creating PR at {base_host}/{base_namespace}/{base_repo}')
            if 'github' in host:
                has_pr = False
                for pr in base_repo_api.get_pulls():
                    if (pr.head.repo.full_name == f'{head_namespace}/{head_repo}'
                        and pr.head.ref == head_branch):
                        has_pr = True
                        print(f'PR already exists at {pr.html_url}')
                        break

                if not has_pr:
                    pr = base_repo_api.create_pull(title='Submodule update',
                                                    body=pr_body_text,
                                                    head=f'{head_namespace}:{head_branch}',
                                                    base=base_branch)
                    print(f'Created pull request {pr.html_url}')

    git_repo.close()
