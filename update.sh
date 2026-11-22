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

COMMITED=false

cd /home/ubuntu/Desktop/config || exit 1

echo "config update running \n"

difference() {
    if diff -q $1 $2 > /dev/null; then
        return 1
        #echo "no difference between files $1 and $2"
        #notify-send "config file checked no differences"

    else
        COMMITED=true
        echo "difference in files $1 and $2"
        diff -u $1 $2 > fix.patch
        patch $1 < fix.patch
        rm fix.patch
        git add -A
        SUMMARY=$(grep -E '^(---|\+\+\+|@@ )' fix.patch)
        echo $SUMMARY
        git commit -m "update.sh auto commit" -m "$SUMMARY"
    fi
}

difference $GIT_GIT $GIT
difference $GIT_NVIM $NVIM
difference $GIT_UBUNTU $UBUNTU
difference $GIT_VSCODE $VSCODE

echo "\n"

if "$COMMITED"; then
    echo "\n\n differences in config files trying to push \n"

    if GIT_TERMINAL_PROMPT=0 git push; then
        echo "automatically Pushed to remote"
    else
        echo "push failed check and push manually"
    fi
else
    echo "update script ran but no differences so no pushes"
fi
