#!/bin/bash
cd $(dirname $0)
#
while true
do
# java -Xmx512M -javaagent:YggdrasilOfficialProxy.jar -jar waterfall-357.jar
java -Xmx512M -javaagent:authlib-injector.jar=http://127.0.0.1:25551 -jar waterfall.jar
sleep 15s
done
