# alpine is the light-weight version of Linux, highly suitable for running docker imagesmia malkova 1080phoseph
FROM python:3.9-alpine3.13

# Who will maintain the app
LABEL maintainer="ibanking90"  

# This instructs Python to run in UNBUFFERED mode, which is recommended when using Python inside a Docker container. 
# The reason for this is that it does not allow Python to buffer outputs; instead, it prints output directly, 
# avoiding some complications in the docker image when running your Python application.
ENV PYTHONBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
# WORKDIR is where the command will be RUN from
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password\
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

# Switch from root user to django-user
USER django-user