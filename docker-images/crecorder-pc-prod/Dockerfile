FROM cruizba/crecorder-base

# Create user
RUN useradd -ms /bin/bash userdocker

RUN mkdir -p home/userdocker/app

ENV APP_DIR home/userdocker/app

RUN chown -R userdocker /home/userdocker

COPY class-recorder-pc.jar $APP_DIR

# Change user to userdocker
USER userdocker

WORKDIR $APP_DIR

ENTRYPOINT [ "java", "-jar", "class-recorder-pc.jar"]