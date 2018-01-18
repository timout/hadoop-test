#!/bin/bash
 
/etc/init.d/ssh start

# altering the core-site configuration
sed s/HOSTNAME/$HOSTNAME/ /opt/hadoop/etc/hadoop/core-site.xml.template > /opt/hadoop/etc/hadoop/core-site.xml

$HADOOP_HOME/bin/hdfs namenode -format
 
$HADOOP_HOME/sbin/start-dfs.sh

# keep container running
tail -f /dev/null