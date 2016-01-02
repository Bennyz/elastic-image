FROM centos

RUN yum install -y wget && wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.1.1/elasticsearch-2.1.1.rpm \
                        && yum install -y elasticsearch-2.1.1.rpm \
                        && yum install -y java-1.8.0-openjdk

ENV ELASTIC_HOME /usr/share/elasticsearch
ENV PATH $PATH:$ELASTIC_HOME/bin
ADD config/elasticsearch.yml $ELASTIC_HOME/config/
ADD config/logging.yml $ELASTIC_HOME/config/
RUN chown elasticsearch -R $ELASTIC_HOME
CMD ["sysctl","-w","vm.max_map_count=262144"]
CMD ["ulimit","-l","unlimited"]
COPY limits.conf /etc/security/

USER elasticsearch
ENV ES_HEAP_SIZE 128m
ENTRYPOINT ["elasticsearch"]

EXPOSE 9200 9300
