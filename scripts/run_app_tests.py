#!/usr/bin/env python
import sys, os

current_path = os.getcwd()

# Detect apps folder path
if 'scripts' in current_path:
    apps_folder = current_path.replace('scripts', 'apps')
else:
    apps_folder = current_path + '/apps'

# Search apps/ folder for installed apps to run tests with
for app in os.listdir(apps_folder):

    # Run each apps's VTB test suite
    if (os.path.exists(apps_folder+'/'+app+'/run_tests')):
        print("Running tests for", app)
        os.system(apps_folder+'/'+app+'/run_tests  --pedantic-checks -j 16 --spec-file ../.. -i tests -t --longest-jobs=20')
    else:
        print("App", app, "not installed. init/update/make it")
