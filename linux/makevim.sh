sudo apt-get install -y libncurses5-dev libncurses5 libgtk2.0-dev libatk1.0-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev python3-dev ruby-dev lua5.1 lua5.1-dev checkinstall

    # rm -rf ~/vim82
    # git clone https://gitee.com/chxuan/vim82.git ~/vim82
    cd ~/vim
    ./configure --with-features=huge \
        --enable-multibyte \
        --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
        --enable-gui=gtk3 \
        --prefix=/usr/local
    make
    sudo checkinstall
