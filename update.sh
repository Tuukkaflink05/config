#! /bin/sh
#file update.sh
#automatically get differences in config files add and commit them to git

GIT_GIT="/home/ubuntu/Desktop/config/git/.gitconfig"
GIT_NVIM="/home/ubuntu/Desktop/config/nvim/init.lua"
GIT_UBUNTU="/home/ubuntu/Desktop/config/ubuntu_terminal/.bash_aliases"
GIT_VSCODE="/home/ubuntu/Desktop/config/vscode/settings.json"

GIT="/home/ubuntu/.gitconfig"
NVIM="/home/ubuntu/.config/nvim/init.lua"
UBUNTU="/home/ubuntu/.bash_aliases"
VSCODE="/home/ubuntu/.config/Code/User/settings.json"

cd /home/ubuntu/Desktop/config || exit 1

difference() {
    if diff -q $1 $2 > /dev/null; then
        echo "no difference between files"

    else
        echo "difference in files"
        diff -u $1 $2 > fix.patch
        patch $1 < fix.patch
        git add -A
        SUMMARY=$(grep -E '^(---|\+\+\+|@@ )' fix.patch)
        echo $SUMMARY
        git commit -m "Update config auto comm" -m "$SUMMARY"
    fi
}

difference $GIT_GIT $GIT



