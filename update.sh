#! /bin/sh
#file update.sh
#automatically get differences in config files add and commit them to git, perhaps even push

cd /home/$USERNAME/Desktop/config || exit 1

USERNAME="flink"

GIT_GIT="/home/$USERNAME/Desktop/config/git/.gitconfig"
GIT_NVIM="/home/$USERNAME/Desktop/config/nvim/init.lua"
GIT_UBUNTU="/home/$USERNAME/Desktop/config/ubuntu_terminal/.bash_aliases"
GIT_VSCODE="/home/$USERNAME/Desktop/config/vscode/settings.json"

GIT="/home/$USERNAME/.gitconfig"
NVIM="/home/$USERNAME/.config/nvim/init.lua"
UBUNTU="/home/$USERNAME/.bash_aliases"
VSCODE="/home/$USERNAME/.config/Code/User/settings.json"

PACKAGES="/home/$USERNAME/Desktop/config/apt_packages/packages.txt"

COMMITED=false


echo "config update running \n"

difference() {
    if diff -q $1 $2 > /dev/null; then
        return 1
        #echo "no difference between files $1 and $2"
        #notify-send "config file checked no differences"

    else
        echo "difference in files $1 and $2"
        diff -u $1 $2 > fix.patch
        patch $1 < fix.patch
        SUMMARY=$(grep -E '^(---|\+\+\+|@@ )' fix.patch)
        rm fix.patch
        add_commit $SUMMARY
    fi
}

add_commit() {
    COMMITED=true
    git add -A
    echo $1
    git commit -m "update.sh auto commit" -m "$1"
}

difference $GIT_GIT $GIT
difference $GIT_NVIM $NVIM
difference $GIT_UBUNTU $UBUNTU
difference $GIT_VSCODE $VSCODE

apt-mark showmanual > $PACKAGES

if git diff $PACKAGES; then
    add_commit "update packages"
fi
##
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
