# https://wiki.termux.com/wiki/Backing_up_Termux

# define presets
workplace="/storage/emulated/0/termux/backups"
root="/data/data/com.termux/files"

# define backup and restore
# backup

# check storage permission
checkStoragePermission(){
    if [ ! -w /storage/emulated/0 ];then
        echo "Permission denied"
        exit
    fi
}
backup(){
    echo "now running backup"
    echo "type the name for backup"
    echo "if empty will use termux.tar.gz"
    read name
    if [ -z $name ];then 
    name="termux.tar.gz"
    fi
    echo "will create "$name
    clean
    echo "backing system up..."
    cd $root
    tar -czvf $workplace/$name ./home ./usr
    echo -e "\033[0;32m backing up finished! \033[0m"
}
# restore
restore(){
    echo "now running restore"
    echo "choose a backup file:"
    ls $workplace
    read file
    while [ ! -f $workplace/$file ]
    do
        echo "no match, try again!"
        read file
    done
    echo "start restoring!"
    rm -rf $root/home $root/usr/
    tar -xzvf $workplace/$file -C $root/
    echo -e "\033[0;32m restoring finished! \033[0m"

}
# clean
clean(){
    echo "start cleaning"
    termuxBashHistory=$root"/home/.bash_history"
    if [ -f $termuxBashHistory ];then
        echo "clean termuxBashHistory"
        rm $termuxBashHistory
    fi
    debianBashHistory=$root"/home/debian-fs/root/.bash_history"
    if [ -f $debianBashHistory ];then
        echo "clean debianBashHistory"
        rm $debianBashHistory
    fi
}

# start
checkStoragePermission
echo "this script will backup/restore termux"
echo "choose to backup or restore"
echo "b to backup, r to restore"
read option
case $option in
    "b") backup
        ;;
    "r") restore
        ;;
    *) echo "no match, quitting!"
        exit
        ;;
esac


