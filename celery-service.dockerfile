FROM python:2

ENV CODE_PATH=/usr/src

ARG dev_path
ARG github_token
ARG service_path

WORKDIR $CODE_PATH/app

COPY $dev_path/entry.sh $CODE_PATH/entry.sh
RUN chmod +x $CODE_PATH/entry.sh

COPY $service_path/requirements.txt ./
RUN sed -i "s@git+ssh:\/\/git@git+https:\/\/$github_token@" requirements.txt
RUN pip install watchdog

RUN pip install --no-cache-dir -r requirements.txt

CMD [ "celery", "worker", "--app", "celery_app", "-l" "info"]
