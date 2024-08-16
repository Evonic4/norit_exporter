#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
ver="v0.2"
fhome=/usr/share/norit/
fPID=$fhome"pids/norit_pid.txt"
cd $fhome
config_num=$1


function init() 
{
logger "init config_num="$config_num
config_name=$(sed -n $config_num"p" $fhome"confs2.txt" | tr -d '\r')
script=$(sed -n 1"p" $fhome"conf/"$config_name | tr -d '\r')
sec4=$(sed -n 2"p" $fhome"conf/"$config_name | tr -d '\r')
max_time_wdb=$(sed -n 3"p" $fhome"conf/"$config_name | tr -d '\r')
max_time_wpg=$(sed -n 4"p" $fhome"conf/"$config_name | tr -d '\r')
stolbc_all=$(sed -n 5"p" $fhome"conf/"$config_name | tr -d '\r')
logger "init config_name="$config_name
}


function logger()
{
local date1=$(date '+ %Y-%m-%d %H:%M:%S')
echo $date1" norit_"$config_num": "$1
}


great_five ()
{
logger "start script "$script
$fhome"sc/"$script $config_num &
$fhome"ntracker_"$config_num".sh" $config_num &
}

#START
PID=$$
echo $PID > $fPID

logger " "
logger "start, ver "$ver
sleep 1
init;


while true
do
great_five;
sleep $sec4
done


rm -f $fPID
