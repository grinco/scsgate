FROM ubuntu:noble

LABEL authors=vadim@grinco.eu 

ENV MQTT_USER="anonymous"
ENV MQTT_PASS=""
ENV MQTT_HOST="localhost"

RUN apt update && apt install -y git

RUN apt-get -y dist-upgrade

RUN mkdir /app/
WORKDIR /app/

#RUN mkdir /app && \
#    cd /app && \
#    git clone https://github.com/papergion/raspy_scsgate_exe scsgate

RUN apt install -y libssl-dev build-essential

RUN git clone https://github.com/papergion/easysocket.git && \
    mv easysocket/MakeHelper /app/

RUN git clone https://github.com/janderholm/paho.mqtt.c.git && \
    cd /app/paho.mqtt.c/ && \
    make && make install

RUN git clone https://github.com/grinco/raspy_scsgate_cpp 

WORKDIR /app/raspy_scsgate_cpp
RUN sed -i 's/-Werror //g' Makefile && make
RUN mkdir /app/scsgate/
RUN cp -r bin/release/* /app/scsgate/

WORKDIR /app/scsgate/
CMD ./scsgate_x -B${MQTT_HOST} -U${MQTT_USER} -P${MQTT_PASS} -v
