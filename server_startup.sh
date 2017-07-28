#!/bin/bash

###############################################################################
# FILE NAME : server_startup.sh
# AUTHOR : J.Enochs
# CREATION DATE : 07-Mar-2017
# LAST MODIFIED : 27-Jul-2017
# DESCRIPTION : [ DRAFT: DO NOT USE THIS SCRIPT! ]
#               This script is only to be used when you first bring up a fresh
#               instance of the command line CTF server. This script is needed
#               because there are some Python tools that do not install 
#               properly when called from the yaml file (??). The yaml file 
#               copies this script to roots home directory so it's the first 
#               thing you see after you log-in.
#
#               Before running this script, you must Create a file named 
#               "roster.txt" containing the last names of the students. 
#               Just the last name, one name on each line, not case sensitive. 
#               Place file here:/root/Virtualenv/CTF-Server/Server/roster.txt
#               
#               You must insert your gitlab username & password on the 
#               2nd line. 
#
###############################################################################/
ENV=CTF-Server
source ~/.bashrc
cd /root/Virtualenv/
DirPath=/root/Virtualenv/CTF-Server
if [ ! -d "$DirPath" ]; then
    # TODO: this url changed - replace
    git clone https://username:password@git.cybbh.space/c-programming/CTF-Server.git
    cd /root/Virtualenv/CTF-Server
    # TODO: ez_setup.py is deprecated - replace
    wget https://bootstrap.pypa.io/ez_setup.py
    python ez_setup.py
    easy_install pip
    pip install virtualenv
    pip install virtualenvwrapper
    if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
        cd /usr/local/bin
        virtualenvwrapper.sh
        source virtualenvwrapper.sh
    else
        echo "virtualenvwrapper.sh not found!"
    fi
    source /root/.bashrc
    mkvirtualenv CTF-Server
    setvirtualenvproject /root/Virtualenv/CTF-Server
    pip install netifaces
else
    echo "SERVER ALREADY INSTALLED"
    if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
        cd /usr/local/bin
        virtualenvwrapper.sh
        source virtualenvwrapper.sh
    else
        echo "virtualenvwrapper.sh not found!"
    fi
fi
DirPath=/root/Repos
if [ ! -d "$DirPath" ]; then
    cd /root/Virtualenv/CTF-Server/Scripts
    ./accounts_create.sh
else
    echo "ACCOUNTS ALREADY CREATED"
fi
source ~/.bashrc
source $WORKON_HOME/$ENV/bin/activate
workon CTF-Server
cd /root/Virtualenv/CTF-Server/Server
./server.py &
