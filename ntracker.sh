#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
fhome=/usr/share/norit/
Z1=$1

function init() 
{
logger "init start"

pushg_ip=$(sed -n 9"p" $fhome"sett.conf" | tr -d '\r')
pushg_port=$(sed -n 10"p" $fhome"sett.conf" | tr -d '\r')
job=$(sed -n 11"p" $fhome"sett.conf" | tr -d '\r')
sec4=$(sed -n 12"p" $fhome"sett.conf" | tr -d '\r')
max_time=$(sed -n 13"p" $fhome"sett.conf" | tr -d '\r')
max_curl_time=$(sed -n 14"p" $fhome"sett.conf" | tr -d '\r')
first5_str=16
logger "init first5_str="$first5_str

if [ "$max_time" -ge "$sec4" ]; then
	logger "init maximum waiting time for a response from the database >= pause between polls !, exit"
	exit 0
fi
max_nop=$(((max_time*60)/10))	#макс кол-во проверок
logger "init max_nop="$max_nop
}


function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" ntracker_"$Z1": "$1
}


zapushgateway ()
{
logger "zapushgateway start"

str_col2=$(grep -cv "^---" $fhome$Z1"3.txt")
logger "init str_col2="$str_col2
for (( i1=1;i1<=$str_col2;i1++)); do
	tschema=$(sed -n $i1"p" $fhome$Z1"3.txt" | awk -F"|" '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	tn=$(sed -n $i1"p" $fhome$Z1"3.txt" | awk -F"|" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	rows_n=$(sed -n $i1"p" $fhome$Z1"3.txt" | awk -F"|" '{print $3}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
	echo "rows_n "$rows_n | curl -m $max_curl_time --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$job"/instance/"$hostp"/db/"$db"/table_schema/"$tschema"/table_name/"$tn
done
}

next_five ()
{
local mn=0
mn=$((Z1*6))

host=$(sed -n $((first5_str+mn))"p" $fhome"sett.conf" | tr -d '\r')
port=$(sed -n $((first5_str+1+mn))"p" $fhome"sett.conf" | tr -d '\r')
hostp=$host":"$port
db=$(sed -n $((first5_str+2+mn))"p" $fhome"sett.conf" | tr -d '\r')
user=$(sed -n $((first5_str+3+mn))"p" $fhome"sett.conf" | tr -d '\r')
pass=$(sed -n $((first5_str+4+mn))"p" $fhome"sett.conf" | tr -d '\r')

logger "next_five host="$host
logger "next_five port="$port
logger "next_five db="$db
logger "next_five user="$user
logger "next_five pass=****"
}


watcher ()
{
logger "watcher start"

if [ -f $fhome$Z1".txt" ]; then
		sed '1,2d' $fhome$Z1".txt" > $fhome$Z1"2.txt"
		str_col1=$(grep -cv "^RRRR---" $fhome$Z1"2.txt")
		logger "watcher str_col1="$str_col1
		if [ "$str_col1" -gt "3" ]; then
			sed $((str_col1-2))',$d' $fhome$Z1"2.txt" > $fhome$Z1"3.txt"
			#str_col1=$(grep -cv "^RRRR---" "./2.txt"); [ "$str_col1" -gt "2" ] && sed $((str_col1-2))',$d' "./2.txt"
			
			next_five;
			zapushgateway;
			mv -f $fhome$Z1".txt" $fhome$Z1".txt.old"
			mv -f $fhome$Z1"2.txt" $fhome$Z1"2.txt.old"
			mv -f $fhome$Z1"3.txt" $fhome$Z1"3.txt.old"
			
			logger "end OK-0"
			exit 0
		else
			logger "watcher str_col1="$str_col1" <3"
			logger "end OK-1"
			exit 1
		fi
else
	logger "watcher no file "$Z1".txt"
fi

}


#START
logger " "
logger "start"
init;

nop=0
while true
do
logger "sleep 10"
sleep 10
logger "---->"
nop=$((nop+1))
watcher;

if [ "$nop" -gt "$max_nop" ]; then
	logger "ERROR: time is over"
	cpid=$(sed -n 1"p" $fhome$Z1".pid" | tr -d '\r')
	killall $Z1".sh"
	kill -9 $cpid
	mv -f $fhome$Z1".pid" $fhome$Z1".pid.old"
	exit 0
fi

done
