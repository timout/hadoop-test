FROM ubuntu:16.04
 
ENV HADOOP_HOME /opt/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
 
RUN \
  apt-get update && apt-get install -y \
  ssh rsync vim curl \
  build-essential cmake \
  libxml2 libxml2-dev \
  libprotobuf-dev protobuf-compiler \
  libkrb5-dev libcurl4-openssl-dev uuid-dev \
  libgsasl7 libgsasl7-dev libboost-dev \
  libssl-dev \
  openjdk-8-jdk && \
  curl -sL https://deb.nodesource.com/setup_8.x | bash && apt-get install -y nodejs

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
RUN chmod 755 /start-hadoop.sh
 
EXPOSE 9000 50010 50020 50070 50090 50075
 
CMD bash start-hadoop-all.sh
