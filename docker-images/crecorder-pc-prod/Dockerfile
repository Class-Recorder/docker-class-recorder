FROM cruizba/crecorder-base

# Create user
RUN useradd -ms /bin/bash userdocker

ENV APP_DIR home/userdocker/app

RUN chown -R userdocker /home/userdocker

# Change user to userdocker
USER userdocker

WORKDIR $APP_DIR

COPY class-recorder-pc.jar $APP_DIR

ENTRYPOINT [ "java", "-jar", "class-recorder-pc.jar"]