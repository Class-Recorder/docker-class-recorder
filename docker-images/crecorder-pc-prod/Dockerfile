FROM cruizba/crecorder-base

ENV APP_DIR /app

# Firefox
RUN apt-get update && apt-get install firefox -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR $APP_DIR

COPY class-recorder-pc.jar $APP_DIR

ENTRYPOINT [ "java", "-jar", "class-recorder-pc.jar"]