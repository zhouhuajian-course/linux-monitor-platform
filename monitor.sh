#!/bin/bash
case $1 in
    start)
        # 5秒后启动监控平台
        for i in `seq 5 -1 1`
        do
            echo "${i}秒后启动监控平台"
            sleep 1
        done

        ./node_exporter-1.4.0-rc.0.linux-amd64/node_exporter &
        ./prometheus-2.38.0.linux-amd64/prometheus --config.file=./prometheus-2.38.0.linux-amd64/prometheus.yml &
        ./grafana-9.1.2/bin/grafana-server -homepath ./grafana-9.1.2 -config ./grafana-9.1.2/conf/defaults.ini & ./grafana-9.1.2/bin/grafana-server -homepath ./grafana-9.1.2 -config ./grafana-9.1.2/conf/defaults.ini &
        ;;
    stop)
         # 5秒后停止监控平台
         for i in `seq 5 -1 1`
         do
             echo "${i}秒后停止监控平台"
             sleep 1
         done

         kill -9 `lsof -ti:9090` `lsof -ti:9100` `lsof -ti:3000`
        ;;
    *)
        echo "Usage: sh monitor.sh (start|stop)"
        ;;
esac