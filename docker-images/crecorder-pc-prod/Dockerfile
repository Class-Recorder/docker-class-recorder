FROM cruizba/crecorder-base

ENV APP_DIR /app

WORKDIR $APP_DIR

COPY class-recorder-pc.jar $APP_DIR

ENTRYPOINT [ "java", "-jar", "class-recorder-pc.jar"]