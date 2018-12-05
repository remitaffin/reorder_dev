FROM python:2

ENV PYTHONUNBUFFERED 1
ENV CODE_PATH=/usr/src

ARG dev_path
ARG github_token
ARG service_path

WORKDIR $CODE_PATH/app

COPY $dev_path/entry.sh $CODE_PATH/entry.sh
RUN chmod +x $CODE_PATH/entry.sh

RUN curl -o $CODE_PATH/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x $CODE_PATH/wait-for-it.sh

COPY $service_path/requirements.txt ./
RUN sed -i "s@git+ssh:\/\/git@git+https:\/\/$github_token@" requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install ipython

CMD [ "python", "manage.py", "runserver"]
