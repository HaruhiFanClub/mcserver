#!/bin/bash
cd `dirname $0`
# systemctl stop mcs

# sleep 2m
sudo -u norl find ./cold -type f -mtime +30 -exec rm -f {} \;

sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/tellraw @a [{"text":"[Server酱] ","color":"dark_purple","bold":true},{"text":"服务器将在 ","color":"gold","bold":false},{"text":"5分钟","color":"red","bold":true},{"text":" 后关闭以进行全局冷备份!","color":"gold","bold":false}]\n'
sleep 2m
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/tellraw @a [{"text":"[Server酱] ","color":"dark_purple","bold":true},{"text":"服务器将在 ","color":"gold","bold":false},{"text":"3分钟","color":"red","bold":true},{"text":" 后关闭以进行全局冷备份!","color":"gold","bold":false}]\n'
sleep 2m
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/tellraw @a [{"text":"[Server酱] ","color":"dark_purple","bold":true},{"text":"服务器将在 ","color":"gold","bold":false},{"text":"1分钟","color":"red","bold":true},{"text":" 后关闭以进行全局冷备份!","color":"gold","bold":false}]\n'
sleep 30s
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/tellraw @a [{"text":"[Server酱] ","color":"dark_purple","bold":true},{"text":"服务器将在 ","color":"gold","bold":false},{"text":"30秒","color":"red","bold":true},{"text":" 后关闭以进行全局冷备份!","color":"gold","bold":false}]\n'
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/title @a title [{"text":"!注    意!","color":"red","bold":true}]\n'
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/title @a subtitle [{"text":"服务器将在30秒后关闭以进行冷备份","color":"red","bold":true}]\n'
sleep 20s
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/save-all\n'
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/tellraw @a [{"text":"[Server酱] ","color":"dark_purple","bold":true},{"text":"服务器将在 ","color":"gold","bold":false},{"text":"10秒","color":"red","bold":true},{"text":" 后关闭以进行全局冷备份","color":"gold","bold":false}]\n'
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/tellraw @a [{"text":"[Server酱] ","color":"dark_purple","bold":true},{"text":"备份过程大约需要10~15分钟, 请耐心等待.","color":"gold","bold":false}]\n'
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/title @a title [{"text":"!注    意!","color":"red","bold":true}]\n'
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/title @a subtitle [{"text":"服务器将在10秒后关闭以进行冷备份","color":"red","bold":true}]\n'
sleep 5s
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/tellraw @a [{"text":"[Server酱] ","color":"dark_purple","bold":true},{"text":"服务器将在 ","color":"gold","bold":false},{"text":"5秒","color":"red","bold":true},{"text":" 后关闭以进行全局冷备份","color":"gold","bold":false}]\n'
sleep 5s
sudo -u norl screen -x -S "mcs3" -p 0 -X stuff $'/stop\n'

sleep 1m
systemctl stop mcs

sleep 1m
sudo -u norl /usr/local/bin/7za a ./cold/$(date -d "today" +"%Y%m%d-%H%M%S")-s3-cold.7z @bl3.txt -mx=7 -mmt

sleep 1m
systemctl restart mcs
# sleep 1m
