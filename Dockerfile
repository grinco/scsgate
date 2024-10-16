FROM ubuntu:noble

LABEL authors=vadim@grinco.eu 

ENV MQTT_USER="anonymous"
ENV MQTT_PASS=""
ENV MQTT_HOST="localhost"

RUN apt update && apt install -y git

RUN apt-get -y dist-upgrade

RUN mkdir /app/
WORKDIR /app/

# Install development environment
RUN apt install -y libssl-dev build-essential

# Prepare dependencies
RUN git clone https://github.com/papergion/easysocket.git && \
    mv easysocket/MakeHelper /app/
RUN git clone https://github.com/janderholm/paho.mqtt.c.git && \
    cd /app/paho.mqtt.c/ && \
    make && make install

# Build and install scsgate
RUN git clone https://github.com/grinco/raspy_scsgate_cpp 
WORKDIR /app/raspy_scsgate_cpp
RUN sed -i 's/-Werror //g' Makefile && make
RUN mkdir /app/scsgate/
RUN cp -r bin/release/* /app/scsgate/

# Cleanup 
RUN cd /app && rm -rf raspy_scsgate_cpp easysocket paho.mqtt.c MakeHelper
RUN apt remove -y libssl-dev build-essential && apt -y autoremove 

WORKDIR /app/scsgate/
CMD ./scsgate_x -B${MQTT_HOST} -U${MQTT_USER} -P${MQTT_PASS} -v
