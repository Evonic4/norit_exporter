#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
ver="v0.1"
fhome=/usr/share/norit/
cd $fhome

function init() 
{
logger "init start"

sec4=$(sed -n 12"p" $fhome"sett.conf" | tr -d '\r')
max_time=$(sed -n 13"p" $fhome"sett.conf" | tr -d '\r')
first5_str=16

logger "init sec4="$sec4
logger "init max_time="$max_time
logger "init first5_str="$first5_str

if [ "$max_time" -ge "$sec4" ]; then
	logger "init ERROR: maximum waiting time for a response from the database >= pause between polls, exit"
	exit 0
fi

str_col3=$(grep -cv "^---" $fhome"sett.conf")
if [ "$str_col3" -gt "$((first5_str+3))" ]; then
	all5=$(((str_col3-first5_str)/5))
	#str_col3=$(grep -cv "^---" "./sett.conf"); echo $str_col3; echo $(((str_col3-11)/5))
else
	all5=0
fi
logger "init all5="$all5	#пятерок всего
if [ "$all5" -eq "0" ]; then
	logger "init ERROR: all5=0, exit"
	exit 0
fi
}


function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" norit: "$1
}


constructor_psql ()
{
logger "constructor_psql start"
rm -f $fhome$i".txt"

echo "#!/bin/bash" > $fhome$i".sh"
echo "export PATH=\"\$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin\"" >> $fhome$i".sh"

echo "PID=\$\$" >> $fhome$i".sh"
echo "echo \$PID > $fhome$i".pid"" >> $fhome$i".sh"

echo "psql \"postgresql://$user:$pass@$hostp/$db\" -c \"\\" >> $fhome$i".sh"
echo "with tbl as ( \\" >> $fhome$i".sh"
echo "  SELECT table_schema,table_name \\" >> $fhome$i".sh"
echo "  FROM information_schema.tables \\" >> $fhome$i".sh"
echo "  WHERE table_name not like 'pg_%' AND table_schema IN ('public') \\" >> $fhome$i".sh"
echo ") \\" >> $fhome$i".sh"
echo "SELECT \\" >> $fhome$i".sh"
echo "  table_schema, \\" >> $fhome$i".sh"
echo "  table_name, \\" >> $fhome$i".sh"
echo "  (xpath('/row/c/text()', \\" >> $fhome$i".sh"
echo "    query_to_xml(format('select count(*) AS c from %I.%I', table_schema, table_name), \\" >> $fhome$i".sh"
echo "    false, \\" >> $fhome$i".sh"
echo "    true, \\" >> $fhome$i".sh"
echo "    '')))[1]::text::int AS rows_n \\" >> $fhome$i".sh"
echo "FROM tbl ORDER BY 3 DESC;\" > "$fhome$i".txt" >> $fhome$i".sh"

echo "rm -f $fhome$i".pid"" >> $fhome$i".sh"

$fhome"setup.sh"
}

next_five ()
{
local mn=0
mn=$((i*6))

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


great_five ()
{
logger "great_five start"
for (( i=0;i<$all5;i++)); do
	logger "great_five -----i="$i"-----"
	next_five;
	constructor_psql;
	$fhome$i".sh" &
	$fhome"ntracker.sh" $i &
done

}

#START
logger " "
logger "start, ver "$ver
su pushgateway -c '/usr/local/bin/pushgateway --web.listen-address=0.0.0.0:9097' -s /bin/bash 1>/dev/null 2>/dev/null &
sleep 5
init;

while true
do
logger "----"
great_five;

sleep $sec4"m"
done
