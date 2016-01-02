#!/bin/bash

docker run -d -p 10.0.0.99:80:9000 -p 10.0.0.99:8001:8001 --hostname=elastic es/haproxy

docker run -m=1g --cap-add=IPC_LOCK --ulimit memlock=-1:-1 -d -p 10.0.0.30:9200:9200 -p 10.0.0.30:9300:9300 --hostname=esmaster1 -v /etc/hosts:/etc/hosts bigdata/elastic --network.publish_host=esmaster1 \
    --network.bind_host=0.0.0.0 \
    --discovery.zen.ping.multicast.enabled=false \
    --discovery.zen.ping.unicast.hosts=esmaster1,esmaster2 \
    --discovery.zen.ping.timeout=5s \
    --discovery.zen.minimum_master_nodes=1 \
    --cluster.name=docker_cluster \
    --http.enabled=false \
    --node.master=true \
    --node.data=false

docker run -m=1g -d --cap-add=IPC_LOCK --ulimit memlock=-1:-1 -p 10.0.0.40:9200:9200 -p 10.0.0.40:9300:9300 --hostname=estmaster2 -v /etc/hosts:/etc/hosts bigdata/elastic --network.publish_host=esmaster2 \
    --network.bind_host=0.0.0.0 \
    --discovery.zen.ping.multicast.enabled=false \
    --discovery.zen.ping.unicast.hosts=esmaster1,esmaster2 \
    --discovery.zen.ping.timeout=5s \
    --discovery.zen.minimum_master_nodes=1 \
    --cluster.name=docker_cluster \
    --http.enabled=false \
    --node.master=true \
    --node.data=false \
    --bootstrap.mlockall=true



docker run -m=1g -d --cap-add=IPC_LOCK --ulimit memlock=-1:-1 -p 10.0.0.10:9200:9200 -p 10.0.0.10:9300:9300 --hostname=esclient1 -v /etc/hosts:/etc/hosts bigdata/elastic --network.publish_host=esclient1 \
    --network.bind_host=0.0.0.0 \
    --discovery.zen.ping.multicast.enabled=false \
    --discovery.zen.ping.unicast.hosts=esmaster1,esmaster2 \
    --discovery.zen.ping.timeout=5s \
    --discovery.zen.minimum_master_nodes=1 \
    --http.port=9200 \
    --cluster.name=docker_cluster \
    --node.master=false \
    --node.data=false \
    --bootstrap.mlockall=true

docker run -m=1g -d --cap-add=IPC_LOCK --ulimit memlock=-1:-1 -p 10.0.0.20:9200:9200 -p 10.0.0.20:9300:9300 --hostname=esclient2 -v /etc/hosts:/etc/hosts bigdata/elastic --network.publish_host=esclient2 \
    --network.bind_host=0.0.0.0 \
    --discovery.zen.ping.multicast.enabled=false \
    --discovery.zen.ping.unicast.hosts=esmaster1,esmaster2 \
    --discovery.zen.ping.timeout=5s \
    --discovery.zen.minimum_master_nodes=1 \
    --http.port=9200 \
    --cluster.name=docker_cluster \
    --node.master=false \
    --node.data=false \
    --bootstrap.mlockall=true

docker run -m=2g -d --cap-add=IPC_LOCK --ulimit memlock=-1:-1 -p 10.0.0.50:9200:9200 -p 10.0.0.50:9300:9300 --hostname=esdata1 -v /etc/hosts:/etc/hosts bigdata/elastic --network.publish_host=esdata1 \
    --network.bind_host=0.0.0.0 \
    --discovery.zen.ping.multicast.enabled=false \
    --discovery.zen.ping.unicast.hosts=esmaster1,esmaster2 \
    --discovery.zen.ping.timeout=5s \
    --discovery.zen.minimum_master_nodes=1 \
    --cluster.name=docker_cluster \
    --http.enabled=false \
    --node.master=false \
    --node.data=true \
    --bootstrap.mlockall=true

docker run -m=2g -d --cap-add=IPC_LOCK --ulimit memlock=-1:-1 -p 10.0.0.60:9200:9200 -p 10.0.0.60:9300:9300 --hostname=esdata2 -v /etc/hosts:/etc/hosts bigdata/elastic --network.publish_host=esdata2 \
    --network.bind_host=0.0.0.0 \
    --discovery.zen.ping.multicast.enabled=false \
    --discovery.zen.ping.unicast.hosts=esmaster1,esmaster2 \
    --discovery.zen.ping.timeout=5s \
    --discovery.zen.minimum_master_nodes=1 \
    --cluster.name=docker_cluster \
    --node.master=false \
    --http.enabled=false \
    --node.data=true \
    --bootstrap.mlockall=true

: '
docker run -d -p 10.0.0.70:9200:9200 -p 10.0.0.70:9300:9300 --hostname=esdata3 -v /etc/hosts:/etc/hosts bigdata/elastic --network.publish_host=esdata3 \
    --network.bind_host=0.0.0.0 \
    --discovery.zen.ping.multicast.enabled=false \
    --discovery.zen.ping.unicast.hosts=esmaster1,esmaster2 \
    --discovery.zen.ping.timeout=5s \
    --discovery.zen.minimum_master_nodes=1 \
    --cluster.name=docker_cluster \
    --node.master=false \
    --http.enabled=false \
    --node.data=true 

docker run -d -p 10.0.0.80:9200:9200 -p 10.0.0.80:9300:9300 --hostname=esdata4 -v /etc/hosts:/etc/hosts bigdata/elastic --network.publish_host=esdata4 \
    --network.bind_host=0.0.0.0 \
    --discovery.zen.ping.multicast.enabled=false \
    --discovery.zen.ping.unicast.hosts=esmaster1,esmaster2 \
    --discovery.zen.ping.timeout=5s \
    --discovery.zen.minimum_master_nodes=1 \
    --cluster.name=docker_cluster \
    --node.master=false \
    --http.enabled=false \
    --node.data=true 
'
