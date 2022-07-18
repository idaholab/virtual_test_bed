# Create a new branch of off the current devel
git fetch origin
git checkout origin/devel
export BRANCH_NAME=submodule_update_`date +%y_%m_%d`
git checkout -b $BRANCH_NAME

# Update all submodules to the current remote head
git submodule update --remote
git commit -am "Submodule update, refs #0"

# Make a new PR
git push origin --set-upstream $BRANCH_NAME
gh pr create -r GiudGiud -B devel -b "New submodules for all apps" -t "General automatic submodule udpate"
