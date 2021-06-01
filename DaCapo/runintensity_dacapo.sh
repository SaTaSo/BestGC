#!/bin/bash

work="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

results_dir=$work/results
graphs_dir=$work/graphs
logs_dir=$work/logs
bin_dir=$work/bin

mkdir $logs_dir &> /dev/null
mkdir $results_dir &> /dev/null
mkdir $graphs_dir &> /dev/null

tag="Dacapo"
max_heap="4g"


function runSet {
    day=`date +"%d:%m:%y"`
   # time=`date +"%H:%M:%S"`
    bench=$1
    size=$2
    iter=$3
    run $bin_dir/g1-java g1
}
function run {
    gc_script=$1
    gc=$2
 
    prefix=$bench-$day
    sufix=$gc
    echo "start $bench"
    echo "start atop"
    install /dev/null "$bench-atop.txt"
    atop 1 -w ./resultsatop/"$bench-atop.txt" &
    echo "starting recording running threads"
    sh ./logthr.sh $bench &
    echo "Starting $sufix"
    $gc_script -jar ./dacapo-9.12-MR1-bach.jar $bench -n $iter -s $size &> $logs_dir/$bench.log
    ps aux | grep "logthr.sh" | grep -v grep | awk '{print $2}' | xargs kill -9
    pkill atop
    ps aux | grep "atop" | grep -v grep | cut -d" " -f3 | xargs kill -9
    atop -r ./resultsatop/"$bench-atop.txt" | grep " java" >> ./resultsatop/"$bench-cpu".txt
    atop -Dr ./resultsatop/"$bench-atop.txt" | grep " java" >> ./resultsatop/"$bench-IO".txt
    atop -Nr ./resultsatop/"$bench-atop.txt" | grep " java" >> ./resultsatop/"$bench-net".txt
    sleep 60; 
    echo "Saving logs to $results_dir/$prefix/$sufix ..."
}
for BENCH in avrora jython lusearch-fix pmd sunflow xalan #fop h2  luindex
do
    for SIZE in large
    do
       for ITER in 10
       do
         runSet $BENCH $SIZE $ITER
       done
    done
done
for BENCH in h2
do
    for SIZE in large
    do
        for ITER in 10
        do
          runSet $BENCH $SIZE $ITER
        done
    done
done
for BENCH in fop luindex
do
   for SIZE in default
    do
        for ITER in 10
        do
          runSet $BENCH $SIZE $ITER
        done
    done
done

