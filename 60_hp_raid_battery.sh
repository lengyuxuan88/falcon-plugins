#!/bin/sh
host_name=`hostname`
ts=`date +%s`
raid_batt=`hpssacli ctrl all show status | grep Battery | awk -F '/' '{print $1}'| tr -d " "`
raid_batt_status=`hpssacli ctrl all show status | grep Battery | awk '{print $3}'`
if [ "$raid_batt_status" == "OK" ];then
    raid_batt_status=0
else
    raid_batt_status=1
fi
curl -X POST -d  "[{\"metric\": \"gome_raid_$raid_batt\", \"endpoint\": \"${host_name}\", \"tags\":\"type=alarm\",\"timestamp\": $ts,\"step\": 60,\"value\": $raid_batt_status,\"counterType\": \"GAUGE\"}]" http://127.0.0.1:1988/v1/push
