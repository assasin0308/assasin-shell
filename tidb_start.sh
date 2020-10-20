#! /usr/bin/bash
# 启动PD server
/usr/local/tidb-v4.0.7-linux-amd64/bin/pd-server  --data-dir=/usr/local/tidb-v4.0.7-linux-amd64/pd  \ 
-metrics-addr="127.0.0.1:9090" --log-file=/usr/local/tidb-v4.0.7-linux-amd64/pd.log &
# 启动TiKV server
/usr/local/tidb-v4.0.7-linux-amd64/bin/tikv-server --pd="0.0.0.0:2379" --data-dir=/usr/local/tidb-v4.0.7-linux-amd64/tikv  \ 
--log-file=/usr/local/tidb-v4.0.7-linux-amd64/tikv.log &
# 启动TiDB server
/usr/local/tidb-v4.0.7-linux-amd64/bin/tidb-server --store=tikv --path="0.0.0.0:2379" \ 
--log-file=/usr/local/tidb-v4.0.7-linux-amd64/tidb.log &
