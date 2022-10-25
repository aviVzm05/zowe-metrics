#shell script to download the console messages from mainfame
#!/bin/bash

input="inputDataLogs.txt"
output="outputPromLogs.txt"
helpText="#HELP console_log_start provides the start time of job"
# touch "$output" #creates output file if not present

#function to convert timestamp to unix starting from epoch format
convertDate() {
    local epoch
    epoch=$(date -d "$1" +"%s")
    echo $epoch
}

#function to create prometheus metrics format
createPromLogs() {
    read -a fields <<<"$1"
    logTimeStamp=$(convertDate ${fields[0]})
    identifier=${fields[1]}
    jobName=${fields[2]}
    status=${fields[3]}

#now, we have the data fields, lets format it into prometheus log formats
    dataString="console_log_data{jobname=\"${jobName}\",identifier=\"${identifier}\",status=\"${status}\"} $logTimeStamp"
    echo $dataString >> $output
}

#function to push the logs info to pushgateway
pushToPushGateway() {
    echo "not yet"
}

#read data from file
#Read the file to individual fields and read last line as well. Ideally, this would be in loop and 
#get data from zowe, every 15 seconds in loop and move the data to pushgateway
# data=$(zowe logs list logs --range 15s | grep 'IEF403I \| $HASP373 \| IEF404I \| $HASP393')


while read -r line || [ -n "$line" ]
do
  createPromLogs "$line"
done < "$input"