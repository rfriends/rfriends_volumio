#!/bin/bash
# -----------------------------------------
# install rfriends for volumio
# -----------------------------------------
# 1.0 2024/08/22
# 1.1 2024/08/25 dir
# 1.2 2024/08/25 usr2 smb.conf,radiru
# 1.3 2024/08/28 vim,pulseaudio
# 1.4 2024/09/02 pulseaudio
# 1.5 2024/09/03 crontab
# 1.6 2024/09/03 fstab
# 1.7 2024/09/03 seekable
# 1.8 2024/09/20 pulseaudio
# 1.9 2024/10/29 add webdav
# 2.0 2024/12/14 github
# 2.1 2025/01/03 fix
# -----------------------------------------
ver=2.1
echo
echo rfriends3 for volumio $ver
echo
# -----------------------------------------
dir=$(cd $(dirname $0);pwd)
user=`whoami`
userstr="s/rfriendsuser/${user}/g"
# -----------------------------------------
sudo apt-get update && sudo apt-get upgrade -y

cd ~/
rm -rf rfriends3_core
git clone https://github.com/rfriends/rfriends3_core.git
if [ $? != 0 ]; then
  echo クローンに失敗しました。
  echo 少し時間をおいて再度実行してください。
  exit 1
fi
cd rfriends3_core

export distro="ubuntu"
export optlighttpd="on"

sh common.sh 2>&1 | tee common.log
# -----------------------------------------
cd $dir
echo
echo fstab
echo
cat /etc/fstab | grep "/home/$user/tmp"
ret=$?

if [ $ret = 1 ]; then
    cp -p /etc/fstab $dir/fstab
    sed -e ${userstr} $dir/fstab.skel >> $dir/fstab
    sudo cp -p $dir/fstab /etc/fstab
else
    echo 'fstab already editted.'
fi
# -----------------------------------------
echo
echo configure samba for volumio
echo
cd $dir
cat /etc/samba/smb.conf | grep 'force user = '
ret=$?

if [ $ret = 1 ]; then
    sudo cp -p /etc/samba/smb.conf /etc/samba/smb.conf.org
    sed "/Internal Storage/a force user = $user" /etc/samba/smb.conf > $dir/smb.conf
    sudo cp -p $dir/smb.conf /etc/samba/smb.conf
else
    echo 'smb.conf already editted.'
fi
# -----------------------------------------
echo
echo configure usrdir
echo
cd $dir
mkdir -p /data/INTERNAL/usr2/
mkdir -p /home/$user/tmp/
sudo chown $user /home/$user/tmp/
sudo chgrp $user /home/$user/tmp/
sudo chmod 777   /home/$user/tmp/

cat <<EOF > /home/$user/rfriends3/config/usrdir.ini
usrdir = "/data/INTERNAL/usr2/"
tmpdir = "/home/$user/tmp/"
EOF
# -----------------------------------------
echo
echo crontab
echo
sed -e ${userstr} $dir/crontab.skel > $dir/crontab
#crontab crontab
#
echo webradio
sudo cp -p $dir/my-web-radio /data/favourites/.

# -----------------------------------------
ip=`ip -4 -br a`
echo
echo ip address is $ip .
echo
echo 再起動後、以下にアクセスしてください
echo http://IPアドレス:8000
echo
# -----------------------------------------
# finish
# -----------------------------------------
echo Installation completed
# -----------------------------------------
