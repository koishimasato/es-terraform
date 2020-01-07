FROM docker.elastic.co/elasticsearch/elasticsearch-oss:6.7.1
RUN bin/elasticsearch-plugin install analysis-kuromoji
RUN bin/elasticsearch-plugin install -b repository-s3
RUN bin/elasticsearch-plugin install -b http://es-learn-to-rank.labs.o19s.com/ltr-1.1.1-es6.7.1.zip

