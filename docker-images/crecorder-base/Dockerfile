FROM ubuntu

###### Basic stuff
RUN apt-get update \ 
    && apt-get install -y software-properties-common \
    curl gnupg ant gradle wget build-essential git \
    && rm -rf /var/lib/apt/lists/*

####### Ffmpeg
RUN apt-get update \ 
    && apt-get install -y --no-install-recommends ffmpeg libxrender1 libxtst6 \
	libxi6 pulseaudio socat alsa-utils \
    && rm -rf /var/lib/apt/lists/*

ENV OPENJDK_8_AZUL=https://cdn.azul.com/zulu/bin/zulu8.33.0.1-jdk8.0.192-linux_x64.tar.gz

RUN wget $OPENJDK_8_AZUL -O /tmp/openjdk_8_azul.tar.gz \
    && tar xfvz /tmp/openjdk_8_azul.tar.gz --directory /usr/lib/jvm \
    && rm -f /tmp/oopenjdk_8_azul.tar.gz

ENV JAVA_HOME /usr/lib/jvm/zulu8.33.0.1-jdk8.0.192-linux_x64
ENV PATH $JAVA_HOME/bin:$PATH
ENV APP_DIR /app
