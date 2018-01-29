#!/bin/sh
host_name=$(hostname)
ts=$(date +%s)
cpu_temp=$(ipmitool -I open sdr | grep CPU | awk '{print $1="CPU""_"$2,$4}')
echo -e "$cpu_temp" | while read cpu temp
do
    curl -X POST -d  "[{\"metric\": \"gome_cpu_temp\", \"endpoint\": \"${host_name}\",\"tags\":\"cpu=$cpu,type=alarm\", \"timestamp\": $ts,\"step\": 60,\"value\": $temp,\"counterType\": \"GAUGE\"}]" http://127.0.0.1:1988/v1/push
done
