#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
ver="v0.2"
fhome=/usr/share/norit/


function Init2() 
{
logger "Init"
pushg_start=$(sed -n 1"p" $fhome"sett.conf" | tr -d '\r')
pushg_port=$(sed -n 3"p" $fhome"sett.conf" | tr -d '\r')
}

function logger()
{
local date1=$(date '+ %Y-%m-%d %H:%M:%S')
echo $date1" norit starter: "$1
}


#START
logger " "
logger "start, ver "$ver

cd $fhome"sc/"
perl -pi -e "s/\r\n/\n/" ./setup.sh
chmod +rx ./setup.sh
./setup.sh
cd $fhome

if [ "$pushg_start" == "1" ]; then
	logger "sender start local pushgateway"
	logger "sender pushg_port="$pushg_port
	cp -f $fhome"0.sh" $fhome"start_pg.sh"
	echo "su pushgateway -c '/usr/local/bin/pushgateway --web.listen-address=0.0.0.0:${pushg_port}' -s /bin/bash 1>/dev/null 2>/dev/null &" >> $fhome"start_pg.sh"
	chmod +rx $fhome"start_pg.sh"
	$fhome"start_pg.sh"
fi
sleep 1

find $fhome"conf/" -maxdepth 1 -type f -name '*.config' > $fhome"confs1.txt"
str_col1=$(grep -c '' $fhome"confs1.txt")
logger "str_col1="$str_col1
echo > $fhome"confs2.txt"
for (( i1=1;i1<=$str_col1;i1++)); do
	basename $(echo $(sed -n $i1"p" $fhome"confs1.txt" | tr -d '\r')) >> $fhome"confs2.txt"
	cp -f $fhome"ntracker.sh" $fhome"ntracker_"$i1".sh"
	$fhome"norit.sh" $i1 &
done

cat $fhome"confs2.txt"

while true
do
sleep 10
logger "healthscheck ok"
done
