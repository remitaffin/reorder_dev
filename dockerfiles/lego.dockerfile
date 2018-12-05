FROM gcr.io/operations-196514/lego-base:latest as base

ENV CODE_PATH=/app/

ARG dev_path
ARG SERVICE_PATH
ARG SSH_PRIV_KEY

# Copy entrypoint
COPY $dev_path/entry.sh $CODE_PATH/entry.sh
RUN chmod +x $CODE_PATH/entry.sh

# For cloning private dependencies
RUN mkdir /root/.ssh/ && \
    echo "${SSH_PRIV_KEY}" | base64 --decode > /root/.ssh/id_rsa && \
    chmod 400 /root/.ssh/id_rsa

RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan -H github.com > /root/.ssh/known_hosts

RUN curl -o $CODE_PATH/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x $CODE_PATH/wait-for-it.sh

# Install requirements
COPY $SERVICE_PATH/requirements $CODE_PATH/requirements
WORKDIR /usr/local/lib/python2.7
RUN pip install -r /app/requirements/initial.txt
RUN pip install -r /app/requirements/master.txt

RUN mkdir /var/log/ordergroove/

WORKDIR /app

CMD ["python", "lego/manage.py", "runserver", "0.0.0.0:7001"]
