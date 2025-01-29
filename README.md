rfriends_volumioはvolumio環境でrfriends3を動作させるスクリプトです  
  
cd ~/  
sudo apt install git  
rm -rf rfriends_volumio  
git clone https://github.com/rfriends/rfriends_volumio.git  
cd rfriends_volumio  
sh rfriends_volumio.sh  

インストール中に以下のメッセージが出たら時刻が正しくありません。  
E: Release file for http://raspbian.raspberrypi.org/raspbian/dists/buster/InRelease is not valid yet  
手動で時刻合わせ  
$ sudo date --set='2025/01/01 01:23:45'  
その後、インストールを再実行してください。  
  
インストール方法は以下を参照してください。  
https://github.com/rfriends/rfriends/blob/gh-pages/distro/volumio.md
  
