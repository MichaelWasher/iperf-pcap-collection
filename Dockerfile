FROM quay.io/fedora/fedora:36

RUN yum install -y rsync wget helm && \
    yum -y clean all && rm -rf /var/cache

# Install Kubectl / oc
ARG OC_VER="4.10.9"
RUN wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OC_VER/openshift-client-linux-$OC_VER.tar.gz && \
    tar -xf openshift-client-linux-$OC_VER.tar.gz && \
    mv oc /bin/ && \
    mv kubectl /bin/ && \
    rm openshift-client-linux-$OC_VER.tar.gz

ADD ./ /iperf-pcap-collection

WORKDIR "/iperf-pcap-collection"
ENTRYPOINT ["deploy"]
CMD [""]
