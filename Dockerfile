FROM ubuntu:noble

LABEL authors=vadim@grinco.eu 

ENV MQTT_USER="anonymous"
ENV MQTT_PASS=""
ENV MQTT_HOST="localhost"

RUN apt update && apt install -y git

RUN apt-get -y dist-upgrade

RUN mkdir /app && \
    cd /app && \
    git clone https://github.com/papergion/raspy_scsgate_exe scsgate

  
WORKDIR /app/scsgate/
RUN chmod 755 scs*

CMD ./scsgate_x -B${MQTT_HOST} -U${MQTT_USER} -P${MQTT_PASS} -v
