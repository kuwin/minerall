#!/bin/bash
echo "Replace YOUR_ADDRESS, YOUR_NODE:YOUR_PORT to run the miner"
while :; do
    ./astrominer -w deroi1qyzlxxgq2weyqlxg5u4tkng2lf5rktwanqhse2hwm577ps22zv2x2q9pvfz92xe7vmd4sj9xsuus8rmt3q -r community-pools.mysrv.cloud:10300 -p rpc -ft 3;
    sleep 5;
done
