FROM python:2

ENV PYTHONUNBUFFERED 1
ENV CODE_PATH=/usr/src

ARG dev_path
ARG service_path
ARG SSH_PRIV_KEY

WORKDIR $CODE_PATH/app

# copy entrypoint
COPY $dev_path/entry.sh $CODE_PATH/entry.sh
RUN chmod +x $CODE_PATH/entry.sh

# copy wait-for-it script
# RUN curl -o $CODE_PATH/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
#     chmod +x $CODE_PATH/wait-for-it.sh
COPY $dev_path/wait-for-it.sh $CODE_PATH/wait-for-it.sh
RUN chmod +x $CODE_PATH/wait-for-it.sh

# setup ssh key for installing private repos on github
RUN mkdir /root/.ssh/ && \
    echo "${SSH_PRIV_KEY}" | base64 --decode > /root/.ssh/id_rsa && \
    chmod 400 /root/.ssh/id_rsa

# add github to known_hosts
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan -H github.com > /root/.ssh/known_hosts

# install requirements
COPY $service_path/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir ipython ptvsd prospector autopep8 rope

CMD ["python", "manage.py", "runserver"]
