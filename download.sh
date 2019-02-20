#!/bin/sh
SSHD=false

ARCHSETUP=false

FREEBSDSETUP=false

SUDOSETUP=false

BASHSETUP=false

OPT=false

HELP=false

while getopts SafsBh option
do
  case "${option}"
  in    
  S) SSHD=true;;
  a) ARCHSETUP=true;;
  f) FREEBSDSETUP=true;;
  s) SUDOSETUP=true;;
  B) BASHSETUP=true;;
  h) HELP=true;;
  esac
  OPT=true
done

#header() works with Normal FreeBSD and ArchLinux but not with FreeNAS.
#Why?
header() {
  HEADER=$1
  STRLENGTH=$(echo -n $HEADER | wc -m)
  DISPLAY="  " #65
  center=`expr $STRLENGTH / 2`
  max=`expr 33 - $center`
  echo $max
  for i in $(seq 1 $max)
  do
    DISPLAY+="-"    
  done
  DISPLAY+=" "$HEADER" "
  
  STRLENGTH=$(echo -n $DISPLAY | wc -m)
  max=`expr 65 - $STRLENGTH`
  for i in $(seq 1 $max)
  do
    DISPLAY+="-"
  done
    
  clear
  echo "  =================================================================="
  echo "$DISPLAY"
  echo "  =================================================================="
  echo ""
}

help() {
  header "Help"
  echo "If you pass this script no options it will ask you what software you wish to install."
  echo ""
  echo "-S download sshd.sh script."
  echo "-a download arch_setup.sh script."
  echo "-f download freebsd_setup.sh script."
  echo "-s download sudo_setup.sh script."
  echo "-B download bash_setup.sh script."
  echo "-h this Help Text."
  echo ""
  echo "IE: ./download.sh -S -f -s -B"
}

fetch_dw() {
  DOWNLOAD=$1
  if [ -f /usr/bin/fetch ]; then
    echo "fetch $DOWNLOAD"
    fetch $DOWNLOAD   
  else
    echo "fetch not installed!"
  fi
}

curl_dw() {
  DOWNLOAD=$1
  if ([ -f /usr/bin/curl ] || [ -f /usr/local/bin/curl ]); then
    echo "curl -O $DOWNLOAD"
    curl -O $DOWNLOAD
    #curl -o $DOWNLOAD.sh http://www.richardallenonline.com/sites/default/files/$DOWNLOAD.txt
  else
    echo "curl not installed!"
  fi
}

download() {
  DOWNLOAD=$1
  NAME=$2
  
  if [ "$(uname)" == 'Linux' ]; then
    curl_dw $DOWNLOAD
  elif [ "$(uname)" == 'FreeBSD' ]; then
    fetch_dw $DOWNLOAD
  fi
  
  if [ -f $NAME ]; then
    chmod 755 $NAME
  else
    echo "File not download!?"
  fi
}

sshd_dw() {
  if [ $SSHD = true ]; then
    echo "Download sshd.sh script."
    echo ""
    download "https://raw.githubusercontent.com/SumGuyV5/ShellScripts/master/sshd.sh" sshd.sh
  fi
}

arch_dw() {
  if [ $ARCHSETUP = true ]; then
    echo "Download arch_setup.sh script."
    echo ""
    download "https://raw.githubusercontent.com/SumGuyV5/ArchScripts/master/arch_setup.sh" arch_setup.sh
  fi
}

freebsd_dw() {
  if [ $FREEBSDSETUP = true ]; then
    echo "Download freebsd_setup.sh script."
    echo ""
    download "https://raw.githubusercontent.com/SumGuyV5/FreeBSDScripts/master/freebsd_setup.sh" freebsd_setup.sh
  fi
}

sudo_dw() {
  if [ $SUDOSETUP = true ]; then
    echo "Download sudo_setup.sh script."
    echo ""
    download "https://raw.githubusercontent.com/SumGuyV5/ShellScripts/master/sudo_setup.sh" sudo_setup.sh
  fi
}

bash_dw() {
  if [ $BASHSETUP = true ]; then
    echo "Download bash_setup.sh script."
    echo ""
    download "https://raw.githubusercontent.com/SumGuyV5/FreeBSDScripts/master/bash_setup.sh" bash_setup.sh
  fi
}

question() {
  HEADER=$1
  QUESTION=$2
  RTN=0
  
  header "$HEADER"
  echo "    $QUESTION? [Y/N]"
  
  read yesno
  
  case $yesno in
    [Yy]* ) RTN=1;;
    [Nn]* ) RTN=0;;
  esac
  
  return $RTN
}

ask_questions() {
  question "SSHD Setup." "Would you like to download ssh.sh script"
  if [ "$?" = 1 ]; then
    SSHD=true
  fi
  
  question "Arch Setup." "Would you like to download arch_setup.sh script"
  if [ "$?" = 1 ]; then
    ARCHSETUP=true
  fi
  
  question "FreeBSD Setup." "Would you like to download freebsd_setup.sh script"
  if [ "$?" = 1 ]; then
    FREEBSDSETUP=true
  fi
  
  question "sudo Setup." "Would you like to download sudo_setup.sh script"
  if [ "$?" = 1 ]; then
    SUDOSETUP=true
  fi
  
  question "bash Setup." "Would you like to download bash_setup.sh script"
  if [ "$?" = 1 ]; then
    BASHSETUP=true
  fi
}

execute_selection() {
  header "Downloading..."
  
  sshd_dw
  
  arch_dw
  
  freebsd_dw
  
  sudo_dw
  
  bash_dw
}

#------------------------------------------
#-    Main
#------------------------------------------
if [ $HELP = true ]; then
  help
  exit 1
fi

#If no flags have been passed we ask the user what they would like to do.
if [ $OPT = false ]; then
  ask_questions
fi

execute_selection