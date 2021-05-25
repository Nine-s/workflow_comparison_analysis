#!/bin/bash

display_usage() { 
    echo "This script monitors the IO of a process of interest. It must be run with super-user privileges"
    echo "The first argument is mendatory the command to run the process to be monitored"
    echo "The second argument is the constrain to use to filter the lofg. By default it will keep the log elements concerning files with special extensions (fastq, fasta, etc). These are defined in the file display_io.py" 
    echo "The second argument can also be: pid or keyword."
    echo "The third argument is optional. Use it to give the keyword of interest if the keyword option has been chosen"
	} 

if [[ ( $1 == "--help") || ($1 == "-h") ]]; then 
    display_usage
    exit 0
fi 

# if less than two arguments supplied, display usage 
if [  $# -le 0 ] 
then 
    echo "Error: A command to run the process of interest must be provided"
    display_usage
    exit 0
fi 

# parameters
COMMAND="$1"

if [  $# -le 1 ] 
then 
    MODE="ok"
else
    MODE="$2"
fi 

echo "Command to run process of interest: $COMMAND"

# run system tap to monitor
stap iotime.stp > log.txt &
pid_stap=$!

sleep 3  #to be sure to have enough log

# run command of interest
$COMMAND &
pid=$!

echo "pid command: $pid"

# when command is done, kill stap
wait $pid
kill $pid_stap

if [ $MODE == "word" ]; then
    KEYWORD="$3"
    python display_io.py -l log.txt -k $KEYWORD

elif [ $MODE == "pid" ]; then
    python display_io.py -l log.txt -pid "$pid"

else
    python display_io.py -l log.txt
fi  