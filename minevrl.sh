#!/bin/sh
#
# Choose nearest stratum:
#       eu.rplant.xyz   /France/
#       asia.rplant.xyz /Singapore/
#       na.rplant.xyz   /Canada/
#
FOLDER=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
while [ 1 ]; do
"$FOLDER"/xmrigvrl -a rx/vrl -o asia.rplant.xyz:7155 -u v1wfuv6a90yranxk7g3cx3oy65lyd8fbcopy7sol2.tminer1
sleep 5
done
