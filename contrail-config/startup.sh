#!/bin/bash

/usr/share/zookeeper/bin/zkServer.sh start
rabbitmq-server &
# Start the first process

/usr/sbin/rabbitmqctl add_user stackrabbit stackqueue
/usr/sbin/rabbitmqctl set_permissions -p / stackrabbit ".*" ".*" ".*"


/usr/bin/ifmap-server &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start ifmap-server process: $status"
  exit $status
fi

# Start the second process/usr/bin/python /usr/bin/contrail-api --conf_file /etc/contrail/contrail-api.conf 
/usr/bin/python /usr/bin/contrail-api --conf_file /etc/contrail/contrail-api.conf &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start contrail api process: $status"
  exit $status
fi


/usr/bin/python /usr/bin/contrail-discovery --conf_file /etc/contrail/contrail-discovery.conf &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start contrail discovery process: $status"
  exit $status
fi

/usr/bin/python /usr/bin/contrail-schema --conf_file /etc/contrail/contrail-schema.conf &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start contrail schema process: $status"
  exit $status
fi

/usr/bin/python /usr/bin/contrail-svc-monitor --conf_file /etc/contrail/contrail-svc-monitor.conf &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start contrail svc monitor process: $status"
  exit $status
fi

/usr/sbin/sshd -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start ssh server: $status"
  exit $status
fi

#starting zookeeper
#/usr/share/zookeeper/bin/zkServer.sh start


#starting rabbitmq-server
#rabbitmq-server &

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container will exit with an error
# if it detects that either of the processes has exited.
# while /bin/true; do
#  PROCESS_1_STATUS=$(ps aux |grep -q my_first_process)
#  PROCESS_2_STATUS=$(ps aux |grep -q my_second_process)
#  if [ $PROCESS_1_STATUS || $PROCESS_2_STATUS ]; then
#    echo "One of the processes has already exited."
#    exit -1
#  fi
#  sleep 60
#done

