if [ ! -f ~/.gitconfig ];then
    git config --global user.name zongou
    git config --global user.email zongou@outlook.com
    git config credential.helper store
fi
echo "cwd: "$(pwd) && git add -A && git commit -m update && git push
