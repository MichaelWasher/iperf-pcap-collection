#!/bin/bash
set -x


# Collect the PCAP and output to the host
FILE_NAME="${HOSTNAME}_$(date +"%Y_%m_%d_%I_%M_%p").pcap"
DIR_PATH="/pcaps/"
FILE_PATH="$DIR_PATH$FILE_NAME"
echo "Writing PCAP to $FILE_PATH"
mkdir -p $DIR_PATH

echo "Collecting PCAP..."
tcpdump -i any -w $FILE_PATH "port 30995"