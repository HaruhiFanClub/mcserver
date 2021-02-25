#!/bin/bash
cd $(dirname $0)
while true
do
java -Xmx512M -jar YggdrasilOfficialProxy-2.1.3-proxy.jar
sleep 15s
done
