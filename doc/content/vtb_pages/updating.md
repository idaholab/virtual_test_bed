!config navigation breadcrumbs=False scrollspy=False

# Updating the VTB

The VTB is very regularly updated. This is because NEAMS tools are always evolving and inputs are rapidly deprecated if
they are not kept up-to-date with the latest syntax. To update your local copy of the repository, first navigate to your
local repository (here, assumed to located in `~/projects/virtual_test_bed/`). If you have uncommitted changes to
your local repository (modified existing input files, etc.), then you should first commit these changes to some branch
other than `main` or `devel`.

```
cd ~/projects/virtual_test_bed/
git pull origin main
```

This will update the `main` branch. If you are working on modifying inputs in a local branch, you may
use the following instead to rebase your branch on top of the latest state:

```
git fetch origin
git rebase origin/main
```

If your branch and the main VTB repository conflict, this will give a warning and let you address the conflicts.

Please [contact us](vtb_pages/contact.md) if you need assistance with `git`.
