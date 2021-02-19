workdir="/storage/emulated/0/termux"

# make soft link
rm -rf ~/storage
cat <<EOF|tee $PREFIX/etc/profile.d/direnv.sh
# add sdcard
export sdcard=/storage/emulated/0
EOF

# change greeting
echo "Wellcome to Termux!">/data/data/com.termux/files/usr/etc/motd

# install neccesary programs
apt install vim nodejs git ttyd -y


# configure vim
vimplug="$workdir/vim/autoload/plug.vim"
vimrc="$workdir/vim/vimrc"
colordir="$workdir/vim/colors"

mkdir -p ~/.vim/autoload
cp $vimplug ~/.vim/autoload/
cp -r $colordir ~/.vim
cp $vimrc ~/.vimrc
# install vimplug plugins
vim -c "PlugInstall" -c "q" -c "q"


# install coc plugins
# vim -c "CocInstall coc-sh coc-snippets" -c "echo 'after coc plugins installed, all done'"

# clean
apt clean


