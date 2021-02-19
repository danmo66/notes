# make soft link
rm -rf ~/storage
cat <<EOF|tee $PREFIX/etc/profile.d/direnv.sh
# add sdcard
export sdcard=/storage/emulated/0
EOF

# change greeting
echo "Wellcome to Termux!">/data/data/com.termux/files/usr/etc/motd

# change repo
sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.bfsu.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.bfsu.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.bfsu.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
apt update

checkStoragePermission(){
    if [ ! -w /storage/emulated/0 ];then
        echo "Permission denied"
        exit
    fi
}