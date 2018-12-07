FROM gcr.io/operations-196514/lego-base:latest as base

ENV CODE_PATH=/app
ENV MISC_PATH=/usr/src

ARG dev_path
ARG service_path
ARG SSH_PRIV_KEY

# Copy entrypoint
COPY $dev_path/entry.sh $MISC_PATH/entry.sh
RUN chmod +x $MISC_PATH/entry.sh

# For cloning private dependencies
RUN mkdir /root/.ssh/ && \
    echo "${SSH_PRIV_KEY}" | base64 --decode > /root/.ssh/id_rsa && \
    chmod 400 /root/.ssh/id_rsa

RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan -H github.com > /root/.ssh/known_hosts

# RUN curl -o $MISC_PATH/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
#     chmod +x $MISC_PATH/wait-for-it.sh
COPY $dev_path/wait-for-it.sh $MISC_PATH/wait-for-it.sh
RUN chmod +x $MISC_PATH/wait-for-it.sh

# Install requirements
COPY $service_path/requirements $CODE_PATH/requirements
WORKDIR /usr/local/lib/python2.7
RUN pip install -r /app/requirements/initial.txt
RUN pip install -r /app/requirements/master.txt

RUN mkdir /var/log/ordergroove/

WORKDIR $CODE_PATH

CMD ["python", "lego/manage.py", "runserver", "0.0.0.0:7001"]
