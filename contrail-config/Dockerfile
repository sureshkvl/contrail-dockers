FROM ubuntu:trusty
WORKDIR /app
# Copy the current directory contents into the container at /app
COPY python-contrail_1.1master~a8117f1_amd64.deb /app/
COPY contrail-config_1.1master~a8117f1_amd64.deb /app/
COPY contrail-config-openstack_1.1master~a8117f1_amd64.deb /app/
COPY ifmap-server_0.3.2-1contrail3_all.deb /app/

RUN apt-get update && apt-get install -y software-properties-common python-software-properties
# setting the apt-get repo
RUN add-apt-repository ppa:opencontrail/ppa && apt-get update

# Installing prereq
RUN apt-get install -y python-geventhttpclient \
     python-bitarray python-bottle python-kazoo \
     python-kombu python-pycassa python-consistent-hash \
     python-netaddr python-psutil python-lxml python-ncclient \
     python-netifaces python-stevedore python-xmltodict \
     python-jsonpickle python-keystoneclient python-neutron \
     python-novaclient default-jre-headless supervisor \
     default-jre-headless libcommons-codec-java \
     libhttpcore-java liblog4j1.2-java openssh-server \
     rabbitmq-server zookeeperd

# ifmap server requires this folder
RUN mkdir /etc/contrail
# installing the contrail packages
RUN dpkg -i ifmap-server_0.3.2-1contrail3_all.deb
RUN dpkg -i python-contrail_1.1master~a8117f1_amd64.deb
RUN dpkg -i contrail-config_1.1master~a8117f1_amd64.deb
RUN dpkg -i contrail-config-openstack_1.1master~a8117f1_amd64.deb

#copy the config files
COPY contrail-api.conf /etc/contrail/
COPY contrail-schema.conf  /etc/contrail/
COPY contrail-svc-monitor.conf /etc/contrail/
COPY contrail-discovery.conf /etc/contrail/
#setting up the ssh server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

#SSH port
EXPOSE 22
# DISCOVERY PORT
EXPOSE 5998
# API SERVER
EXPOSE 8082
# ZOOKEEPER
EXPOSE 2181
# RABBITMQ
EXPOSE 5672
# IFMAP
EXPOSE 8443

COPY startup.sh startup.sh
CMD ["/bin/bash", "startup.sh"]



#CMD ["/usr/sbin/sshd", "-D"]
#CMD  "/bin/sh /usr/bin/ifmap-server &"
#CMD "/usr/bin/python /usr/bin/contrail-api --conf_file /etc/contrail/contrail-api.conf &"
#CMD  ["/usr/bin/ifmap-server", "&"]
#CMD ["/usr/bin/python", "/usr/bin/contrail-api", "--conf_file /etc/contrail/contrail-api.conf", "&"]
