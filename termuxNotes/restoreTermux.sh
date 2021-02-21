# https://wiki.termux.com/wiki/Backing_up_Termux

# define presets
backupDir="/storage/emulated/0/termux/backups"
termuxRoot="/data/data/com.termux"

# check environment mode
mode="NULL"
if command -v termux-info >/dev/null 2>&1; then 
    echo '[NORMAL MODE]' 
    mode="NORMAL"
else 
    echo '[FAILSAFE MODE]' 
    mode="FAILSAFE"
fi

# check storage permission
checkStoragePermission(){
    if [ ! -w /storage/emulated/0 ];then
        echo "Permission denied"
        exit
    fi
}
backup(){
    # check if in NORMAL MODE
    # backup will fail when other linux system is installed, force running in NORMAL mode
    if [ "$mode"x = "NORMAL"x ];then 
        echo "now running backup"
        echo "type the name for backup"
        echo "if empty will use termux.tar.gz"
        read name
        if [ -z $name ];then 
            name="termux.tar.gz"
        fi
        echo "will create "$name
        cleanHistory
        echo "backing system up..."
        cd $termuxRoot/files
        tar -czvf $backupDir/$name ./home ./usr
        echo -e "\033[0;32m backing up finished! \033[0m"
    else 
        echo "backup not supported in [FAILSAFE MODE], exiting..."
    fi
}

restore(){
    echo "now running restore"
    echo "choose a backup file:"
    ls $backupDir
    read file
    while [ ! -f $backupDir/$file ]
    do
        echo "no match, try again!"
        read file
    done
    echo "start restoring!"
    # use seperate steps is more compatible for lower version of toybox
    if [ "$mode"x = "FAILSAFE"x ];then
        gzip -dc $backupDir/$file | tar -xvf - -C $termuxRoot/files
    fi
    if [ "$mode"x = "NORMAL"x ];then
        cleanAllButkeepCoreFunctions
        tar -xzvf $backupDir/$file -C $termuxRoot/files
    fi
    echo -e "\033[0;32m restoring finished! \033[0m"
}

cleanHistory(){
    echo "start cleaning"
    termuxBashHistory=$termuxRoot"/files/home/.bash_history"
    if [ -f $termuxBashHistory ];then
        echo "clean termuxBashHistory"
        rm $termuxBashHistory
    fi
    debianBashHistory=$termuxRoot"/files/home/debian-fs/root/.bash_history"
    if [ -f $debianBashHistory ];then
        echo "clean debianBashHistory"
        rm $debianBashHistory
    fi
}

# clear all but keep coreutils, to replace original 'rm' command
cleanAllButkeepCoreFunctions(){
    # remove files dir
    cd $termuxRoot/files
    find * | grep -vw 'usr' | xargs rm -rf
    # clean $PREFIX dir
    cd $termuxRoot/files/usr
    find * | grep -vw '\(bin\|lib\)' | xargs rm -rf
# clean bin dir
    cd $termuxRoot/files/usr/bin
    find * | grep -vw '\(coreutils\|rm\|ls\|dash\|xargs\|find\|grep\|tar\|gzip\)' | xargs rm -rf
# clear lib dir
    cd $termuxRoot/files/usr/lib
    find * | grep -vw '\(libandroid-glob.so\|libtermux-exec.so\|libiconv.so\|libandroid-support.so\)' | xargs rm -rf
# clean none exact utils, aggressively

# dependencies:
# ls libandroid-support.so libgmp.so
# tar libandroid-glob libtermux-exec.so libiconv.so
#find * | grep -v '\(libandroid-glob.so\|libtermux-exec.so\|libiconv.so\|libandroid-support.so\|libgmp.so\)' | xargs rm -rf

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
