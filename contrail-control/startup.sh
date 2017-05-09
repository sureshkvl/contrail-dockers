#!/bin/bash

# Start the second process/usr/bin/python /usr/bin/contrail-api --conf_file /etc/contrail/contrail-api.conf 
/usr/bin/contrail-control --conf_file /etc/contrail/contrail-control.conf &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start contrail control process: $status"
  exit $status
fi

/usr/sbin/sshd -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start ssh server: $status"
  exit $status
fi

