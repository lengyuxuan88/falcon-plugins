#!/bin/sh
host_name=`hostname`
name=$(ipmitool -I open sdr list | grep 'Power Supply'| awk '{print $1"_"$2"_"$3,$8}')
#echo $name
ts=`date +%s`
echo -e "$name" | while read power status 
do
    for i in "$status"
    do
        if [ "$i" == "ok" ];then 
            status=0
        else
            status=1
        fi
        curl -X POST -d  "[{\"metric\": \"gome_power_status\", \"endpoint\": \"${host_name}\",\"tags\":\"power=$power,type=alarm\", \"timestamp\": $ts,\"step\": 60,\"value\": $status,\"counterType\": \"GAUGE\"}]" http://127.0.0.1:1988/v1/push
    done
done
