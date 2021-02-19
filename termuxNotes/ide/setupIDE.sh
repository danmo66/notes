workdir="/storage/emulated/0/termux"

# make soft link
rm -rf ~/storage
cat <<EOF|tee $PREFIX/etc/profile.d/direnv.sh
# add sdcard
export sdcard=/storage/emulated/0
EOF

# change repo
sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
apt update

# change greeting
echo "Wellcome to Termux!">/data/data/com.termux/files/usr/etc/motd

# install neccesary programs
apt install vim nodejs git ttyd clang -y

# configure JDK
installjdk="$workdir/jdk/termux-jdk/jvdroid/install.sh"
bash $installjdk

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

# configure jdt.ls
jdtls="$workdir/vim/jdt-language-server-0.64.0-*.tar.gz"
jdtdir=~/".config/coc/extensions/coc-java-data/server"

mkdir -p $jdtdir
tar -xzvf $jdtls -C $jdtdir/

# install coc plugins
vim -c "CocInstall coc-java coc-snippets coc-clangd" -c "echo 'after coc plugins installed, all done'"
