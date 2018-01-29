#!/bin/sh
host_name=$(hostname)
ts=$(date +%s)
fans_status=$(hpasmcli -s "show fans" | grep -E '^#' | awk '{print $1,$3}')
echo -e "$fans_status" | while read fan status
do
    if [ "$status" == "Yes" ];then
        status=0
    else
        status=1
    fi
    curl -X POST -d  "[{\"metric\": \"gome_fans_status\", \"endpoint\": \"${host_name}\",\"tags\":\"fan_name=$fan,type=alarm\", \"timestamp\": $ts,\"step\": 60,\"value\": $status,\"counterType\": \"GAUGE\"}]" http://127.0.0.1:1988/v1/push
done
