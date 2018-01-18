FROM ubuntu:16.04
 
ENV HADOOP_HOME /opt/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
 
RUN \
  apt-get update && apt-get install -y \
  ssh \
  rsync \
  vim \
  openjdk-8-jdk

RUN \
  wget http://apache.mirrors.tds.net/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz && \
  tar -xzf hadoop-2.8.1.tar.gz && \
  mv hadoop-2.8.1 $HADOOP_HOME && \
  echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc

RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys
 
ADD config/*xml $HADOOP_HOME/etc/hadoop/
ADD template/*template $HADOOP_HOME/etc/hadoop/
ADD config/ssh_config /root/.ssh/config
ADD start-hadoop.sh start-hadoop.sh
 
EXPOSE 9000
 
CMD bash start-hadoop.sh