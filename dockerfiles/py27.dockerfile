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

# libraries will be mounted to this folder (watchdog will throw error if directory is not found)
RUN mkdir $CODE_PATH/libraries

# install requirements
COPY $service_path/requirements.txt ./
RUN pip install -r requirements.txt
RUN pip install watchdog ipython ptvsd prospector autopep8 rope pytest

# Copy app to folder
# COPY $service_path .

# copy default endpoint specific user settings overrides into container to specify Python path/
COPY $dev_path/config/settings.vscode.json /root/.vscode-remote/data/Machine/settings.json

# git
COPY $dev_path/config/gitignore /root/.config/git/ignore

# CMD ["python", "manage.py", "runserver"]
# CMD ["celery", "worker", "--app", "celery_app", "-l" "info"]
