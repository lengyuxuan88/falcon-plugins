#!/bin/sh
host_name=$(hostname)
ts=$(date +%s)
cpu_status=$(ipmitool -I open sdr | grep CPU | awk '{print $1="CPU""_"$2,$8}')
echo -e "$cpu_status" | while read cpu status
do
    if [ "$status" == "ok" ];then
        status=0
    else
        status=1
    fi
    curl -X POST -d  "[{\"metric\": \"gome_cpu_status\", \"endpoint\": \"${host_name}\",\"tags\":\"cpu=$cpu,type=alarm\", \"timestamp\": $ts,\"step\": 60,\"value\": $status,\"counterType\": \"GAUGE\"}]" http://127.0.0.1:1988/v1/push
done
