#!/usr/bin/env python
import sys, os, shutil

current_path = os.getcwd()

# Detect apps folder path
if 'scripts' in current_path:
    apps_folder = current_path.replace('scripts', 'apps')
else:
    apps_folder = current_path + '/apps'

# Search apps/ folder for installed apps to run tests with
for app in os.listdir(apps_folder):

    # Sometimes we only want to run tests for a single or so app
    if (len(sys.argv) > 1 and app not in sys.argv):
        continue

    # Run each apps's VTB test suite from the app folder
    if (os.path.exists(apps_folder+'/'+app+'/run_tests')):
        print("Running tests for", app)
        os.chdir(apps_folder+'/'+app)
        # Try to use the HPC module
        if (shutil.which(app + '-opt') is not None):
            os.system('echo "'+app+'-opt \"\$@\"" > ' + app + '-opt')
            os.system('chmod +x ' + app + '-opt')

        # Run the tests
        os.system('./run_tests --pedantic-checks -j 16 --spec-file ../.. -i tests -t --longest-jobs=5')

        print("Tests finished for", app, "\n\n\n")
        os.system('cd ../../')
    else:
        print("App", app, "not installed. init/update/make it")
