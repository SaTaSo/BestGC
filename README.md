# BestGC

You may find the applications and scripts used to evaluate G1, CMS, ZGC, and Shenandoah GC in the paper
 "Selecting a Garbage Collector for Java Applications" in this repository.

The benchmarks and applications used in this study are:
- BufferBench (B2): a benchmark that changes the percentage of read and wirte operations in the heap to examine GCs behavior;
- DaCapo benchmark suite;
- Renaissance benchmark suite; and,
- a Spring Boot based project "PetClinic"

#General information and guidelines to run the scripts for the benchmarks:

To evaluate G1, ZGC, CMS, and Shenandoah, there is a configuration file for each GC in the "bin" directory in each benchmark folder.
The configuration file consists of JAVA_HOME,  JAVA_EXE, and JAVA_OPTS values to run the OpenJDK with the desired GC.
To run the script on your machine, replace the JAVA_HOME and JAVA_EXE with the corresponding directories on your machine. 

To run each benchmark to evaluate performance metrics, simply go to the relevant folder and run the execution file: run_`benchmark name`.sh
The script will create a results folder to put the GC's log files.

To categorize the applications into CPU-intensive or I/O-intensive. There is an execution script runintensity_`benchmark name`.sh
This script also runs logthr.sh to record the number of running threads (this is used to calculate the average CPU utilization by each application).
The script creates a folder resultsatop to put the log files obtained from capturing the output results from the atop command line.
The log files provide the data to calculate disk and CPU consumption by each application.

#DaCapo

To run the DaCapo benchmark you need DaCapo JAR file. You can Download 
the latest version from:
https://sourceforge.net/projects/dacapobench/files/
put the JAR file in DaCapo directory.

#Renaissance

To run the Renaissance you need Renaissance JAR file. Download it from:
https://renaissance.dev/download

Also the source code is available on:
https://github.com/renaissance-benchmarks/renaissance/ 
put the JAR file in the Renaissance directory.

#PetClinic
To run the PetClinic you will need to install Apache JMeter. please Download it from:
https://jmeter.apache.org/download_jmeter.cgi
To test the PetClininc we will use a non-GUI mode of the JMeter using a JMX file. you may find the JMX file
pluss the excel files that contain the input values to call the APIs in PetClinic.

CSV files to test the APIs can be found in csv folder in petClinic directory. Replace `DATA_FILE` file locations 
in the .jmx file that points to the adrees of the CSV folder on your machine.
