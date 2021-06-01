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
    run $bin_dir/g1-java g1
}
function run {
    gc_script=$1
    gc=$2

    prefix=$bench-$day
    sufix=$gc
    echo "start atop"
    install /dev/null "$bench-atop.txt"
    atop 1 -w ./resultsatop/"$bench-atop.txt" &
    echo "starting logload.sh"
    sh ./logload.sh $bench &
    echo "Starting $sufix"
    $gc_script -jar ./renaissance-gpl-0.11.0.jar $bench --repetitions 10 --no-forced-gc &> $logs_dir/$bench.log
    ps aux | grep "logload" | grep -v grep | cut -d" " -f3 | xargs kill -9
    pkill atop
    ps aux | grep "atop" | grep -v grep | cut -d" " -f3 | xargs kill -9
    atop -r ./resultsatop/"$bench-atop.txt" | grep " java" >> ./resultsatop/"$bench-cpu".txt
    atop -Dr ./resultsatop/"$bench-atop.txt" | grep " java" >> ./resultsatop/"$bench-IO".txt
    atop -Nr ./resultsatop/"$bench-atop.txt" | grep " java" >> ./resultsatop/"$bench-net".txt
    sleep 60; 
    echo "Saving logs to $results_dir/$prefix/$sufix ..."
}


for BENCH in akka-uct reactors akka-uct als chi-square db-shootout  dec-tree gauss-mix  movie-lens naive-bayes page-rank fj-kmeans future-genetic mnemonics par-mnemonics scrabble neo4j-analytics rx-scrabble dotty scala-doku scala-kmeans philosophers  finagle-chirper
do
 runSet $BENCH
done
