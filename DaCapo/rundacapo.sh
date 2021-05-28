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
    time=`date +"%H:%M:%S"`
    bench=$1
    size=$2
    iter=$3
    run $bin_dir/cms-java cms
    run $bin_dir/g1-java g1
    run $bin_dir/shenandoah-java shenandoah
    run $bin_dir/zgc-java zgc
}
function run {
    gc_script=$1
    gc=$2

    prefix=$tag-$max_heap-$bench-$size-$day-$time
    sufix=$gc
    echo "Starting $sufix"

    $gc_script -jar /home/stavakoli/dacapo-9.12-MR1-bach.jar $bench -n $iter -s $size &> $logs_dir/$bench.log

    # Backup Logs "$GC-$max_heap-$min-heap-gc.log"
    echo "Saving logs to $results_dir/$prefix/$sufix ..."
    mkdir -p $results_dir/$prefix/$sufix
    cp $logs_dir/$bench.log $results_dir/$prefix/$sufix
    cp /tmp/jvm.log $results_dir/$prefix/$sufix
    echo "Finished $prefix/$sufix"
    echo
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


#$bin_dir/g1-java -jar ~/Downloads/aa/dacapo-9.12-MR1-bach.jar tradebeans -n 5 -s huge
