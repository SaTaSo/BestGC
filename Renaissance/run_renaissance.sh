#!/bin/bash

work="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

results_dir=$work/results
graphs_dir=$work/graphs
logs_dir=$work/logs
bin_dir=$work/bin

mkdir $logs_dir &> /dev/null
mkdir $results_dir &> /dev/null
mkdir $graphs_dir &> /dev/null

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
    prefix = $bench-$day
    sufix=$gc
    echo "Starting $sufix"
    $gc_script -jar ./renaissance-gpl-0.11.0.jar $bench --repetitions 10 --no-forced-gc &> $logs_dir/$bench.log
    # Backup Logs "$GC-$max_heap-$min-heap-gc.log"
    echo "Saving logs to $results_dir/$prefix/$sufix ..."
    mkdir -p $results_dir/$prefix/$sufix
    cp $logs_dir/$bench.log $results_dir/$prefix/$sufix
    cp /tmp/jvm.log $results_dir/$prefix/$sufix
    echo "Finished $prefix/$sufix"
    echo
}


for BENCH in akka-uct reactors als chi-square dec-tree gauss-mix logg-regression movie-lens naive-bayes page-rank db-shootout dummy-empty dummy-failing dummy-param dummy-setup-failing dummy-teardown-failing dummy-validation-failing fj-kmeans future-genetic mnemonics par-mnemonics scrabble neo4j-analytics rx-scrabble dotty scala-doku scala-kmeans philosophers scala-etm-bench7 finagle-chirper finagle-http 
do
 runSet $BENCH
done


