# Linux 监控平台 

Grafana + Prometheus + NodeExporter

## 一. 下载&解压

1. Grafana
   
   https://grafana.com/grafana/download

   ```shell
   wget https://dl.grafana.com/enterprise/release/grafana-enterprise-9.1.2.linux-amd64.tar.gz
   tar -zxvf grafana-enterprise-9.1.2.linux-amd64.tar.gz
   ```

2. Prometheus

   https://prometheus.io/download/

   ```shell
   wget https://github.com/prometheus/prometheus/releases/download/v2.38.0/prometheus-2.38.0.linux-amd64.tar.gz
   tar -zxvf prometheus-2.38.0.linux-amd64.tar.gz
   ```

3. NodeExporter

   https://github.com/prometheus/node_exporter

   https://github.com/prometheus/node_exporter/releases

   ```shell
   wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0-rc.0/node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
   tar -zxvf node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
   ```

## 二. 修改 Prometheus 配置

修改 prometheus.yml

```yaml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9090"]
      
  # 以下为新增配置
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
      
```

## 三. 运行

`sh monitor.sh (start|stop)`

```shell
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
```

## 四. 查看运行情况

1. NodeExplorer

   http://localhost:9100/metrics

2. Prometheus

   http://localhost:9090/

3. Grafana

   http://localhost:3000/

## 五. Grafana 调整

1. DataSource 添加 Prometheus

2. 添加 仪表盘

   https://grafana.com/grafana/dashboards/
   
   https://grafana.com/grafana/dashboards/8919-1-node-exporter-for-prometheus-dashboard-cn-0413-consulmanager/

