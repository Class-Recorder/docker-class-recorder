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

####### Jdk 8
RUN apt-get update \ 
    && apt-get install -y openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH
ENV APP_DIR /app