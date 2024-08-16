#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
fhome=/usr/share/norit/
config_num=$1
fPID=$fhome"pids/ntracker_"$config_num".txt"


function init()
{
logger "init config_num="$config_num

pushg_ip=$(sed -n 2"p" $fhome"sett.conf" | tr -d '\r')
pushg_port=$(sed -n 3"p" $fhome"sett.conf" | tr -d '\r')
job=$(sed -n 4"p" $fhome"sett.conf" | tr -d '\r')

config_name=$(sed -n $config_num"p" $fhome"confs2.txt" | tr -d '\r')
script=$(sed -n 1"p" $fhome"conf/"$config_name | tr -d '\r')
max_time_wdb=$(sed -n 3"p" $fhome"conf/"$config_name | tr -d '\r')
max_time_wpg=$(sed -n 4"p" $fhome"conf/"$config_name | tr -d '\r')
stolbc_all=$(sed -n 5"p" $fhome"conf/"$config_name | tr -d '\r')
inst=$(sed -n 6"p" $fhome"conf/"$config_name | tr -d '\r')
logger "init config_name="$config_name
logger "init script="$script

echo $stolbc_all | tr " " "\n" > $fhome"stolbc_"$config_num".txt"
str_col3=$(grep -c '' $fhome"stolbc_"$config_num".txt")
logger "init stolbc str_col3="$str_col3
cat $fhome"stolbc_"$config_num".txt"

[ "$str_col3" -gt "5" ] &&  logger "init stolbc ERROR str_col3>5" && exit 0
[ "$str_col3" -eq "0" ] &&  logger "init stolbc ERROR str_col3=0" && exit 0
}


function logger()
{
local date1=$(date '+ %Y-%m-%d %H:%M:%S')
echo $date1" ntracker_"$script": "$1
}

zanull ()
{
[ "$p1" == "" ] && p1="null"
[ "$p2" == "" ] && p2="null"
[ "$p3" == "" ] && p3="null"
[ "$p4" == "" ] && p4="null"
[ "$p5" == "" ] && p5="null"
}


stolbc ()
{
#for x in $(echo $(echo $stolbc_all | tr -d '\r') | tr " " "\n")

if [ "$str_col3" -eq "1" ]; then
	p1=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	count=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	zanull;
	echo "norit "$count | curl -m $max_time_wpg --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$job"/instance/"$inst"/"$(sed -n "1p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p1
fi
if [ "$str_col3" -eq "2" ]; then
	p1=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	p2=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	count=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $3}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	zanull;
	echo "norit "$count | curl -m $max_time_wpg --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$job"/instance/"$inst"/"$(sed -n "1p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p1"/"$(sed -n "2p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p2
fi
if [ "$str_col3" -eq "3" ]; then
	p1=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	p2=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	p3=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $3}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	count=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $4}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	zanull;
	echo "norit "$count | curl -m $max_time_wpg --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$job"/instance/"$inst"/"$(sed -n "1p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p1"/"$(sed -n "2p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p2"/"$(sed -n "3p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p3
fi
if [ "$str_col3" -eq "4" ]; then
	p1=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	p2=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	p3=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $3}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	p4=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $4}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	count=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $5}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	zanull;
	echo "norit "$count | curl -m $max_time_wpg --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$job"/instance/"$inst"/"$(sed -n "1p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p1"/"$(sed -n "2p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p2"/"$(sed -n "3p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p3"/"$(sed -n "4p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p4
fi
if [ "$str_col3" -eq "5" ]; then
	p1=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	p2=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	p3=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $3}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	p4=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $4}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	p5=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $5}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	count=$(sed -n $i1"p" $fhome"otv/"$config_num"_3.txt" | awk -F"|" '{print $6}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	zanull;
	echo "norit "$count | curl -m $max_time_wpg --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$job"/instance/"$inst"/"$(sed -n "1p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p1"/"$(sed -n "2p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p2"/"$(sed -n "3p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p3"/"$(sed -n "4p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p4"/"$(sed -n "5p" $fhome"stolbc_"$config_num".txt" | tr -d '\r')"/"$p5
fi
}


zapushgateway ()
{
logger "zapushgateway"
str_col2=$(grep -c '' $fhome"otv/"$config_num"_3.txt")
logger "init str_col2="$str_col2

for (( i1=1;i1<=$str_col2;i1++)); do
	stolbc;
done
}


watcher ()
{
logger "watcher start"

if [ -f $fhome"otv/"$config_num".txt" ]; then
		sed '1,2d' $fhome"otv/"$config_num".txt" > $fhome"otv/"$config_num"_2.txt"
		str_col1=$(grep -c '' $fhome"otv/"$config_num"_2.txt")
		logger "watcher str_col1="$str_col1
		if [ "$str_col1" -gt "3" ]; then
			sed $((str_col1-2))',$d' $fhome"otv/"$config_num"_2.txt" > $fhome"otv/"$config_num"_3.txt"
			
			zapushgateway;
			mv -f $fhome"otv/"$config_num".txt" $fhome"otv/"$config_num".txt.old"
			mv -f $fhome"otv/"$config_num"_2.txt" $fhome"otv/"$config_num"_2.txt.old"
			mv -f $fhome"otv/"$config_num"_3.txt" $fhome"otv/"$config_num"_3.txt.old"
			
			logger "watcher end OK-0"
		else
			logger "watcher str_col1="$str_col1" <3"
		fi
else
	logger "watcher no file "$config_num".txt"
fi
}



#START
PID=$$
echo $PID > $fPID

logger " "
logger "start"
init;

#while true
#do
sleep $max_time_wdb
watcher;

logger "OK time is over"
cpid=$(sed -n 1"p" $fPID | tr -d '\r')
#killall $Z1".sh"
kill -9 $cpid
#done

rm -f $fPID
