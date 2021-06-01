#!/bin/bash

work="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

results_dir=$work/results
graphs_dir=$work/graphs
logs_dir=$work/logs
bin_dir=$work/bin
jmeter_log_dir=$work/jmeterlog

mkdir $logs_dir &> /dev/null
mkdir $results_dir &> /dev/null
mkdir $graphs_dir &> /dev/null
mkdir $jmeter_log_dir &> /dev/null


tag="renaissance"
max_heap="4g"


function runSet {
    day=`date +"%d:%m:%y"`
    time=`date +"%H:%M:%S"`
    bench=$1
   run $bin_dir/cms-java cms
   run $bin_dir/g1-java g1
   run $bin_dir/shenandoah-java shenandoah
   run $bin_dir/zgc-java zgc
}
function run {
    gc_script=$1
    gc=$2

    #prefix=$tag-$max_heap-$bench-$size-$day-$time
    prefix="pet"-$day-$time
    sufix=$gc
    echo "Starting $sufix"
    echo "******************* $gc_script"
   $gc_script -jar ./spring-petclinic-1.5.16.jar &> $logs_dir/"$prefix"-"$gc".log &
   sleep 60
   echo "start time: "-`date +"%H:%M:%S"`
   JVM_ARGS="-Xms4g -Xmx4g" apache-jmeter-5.4/bin/jmeter -n -t petclinic.jmx -l testresults-"$prefix"-"$gc".jtl &> $jmeter_log_dir/"$prefix"-"$gc".log 
   echo "end time: "-`date +"%H:%M:%S"`
   ps aux | grep java | grep -v grep | cut -d" " -f2 | xargs kill -9
   ulimit -n 1000000
   ulimit -c unlimited
    # Backup Logs "$GC-$max_heap-$min-heap-gc.log"
    echo "Saving logs to $results_dir/$prefix/$sufix ..."
    mkdir -p $results_dir/$prefix/$sufix
    cp $logs_dir/$gc.log $results_dir/$prefix/$sufix
    cp /tmp/jvm.log $results_dir/$prefix/$sufix
    echo "Finished $prefix/$sufix"
    echo
}

runSet "pet"
