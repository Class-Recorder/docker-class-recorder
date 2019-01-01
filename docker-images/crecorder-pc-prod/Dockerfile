FROM cruizba/crecorder-base

# Create user
RUN useradd -ms /bin/bash userdocker

ENV APP_DIR /app

RUN chown -R userdocker /home/userdocker  \
    && mkdir /app \
    && chown -R userdocker /app

# Change user to userdocker
USER userdocker

WORKDIR $APP_DIR

COPY class-recorder-pc.jar $APP_DIR

ENTRYPOINT [ "java", "-jar", "class-recorder-pc.jar"]