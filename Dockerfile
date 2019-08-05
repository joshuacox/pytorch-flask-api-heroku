FROM python:3

WORKDIR /usr/src/app

COPY ./requirements.txt ./
RUN pip install --no-cache-dir -r ./requirements.txt

COPY ./app.json ./
COPY ./app.py ./
COPY ./commons.py ./
COPY ./imagenet_class_index.json ./
COPY ./inference.py ./
COPY ./Procfile ./
COPY ./runtime.txt ./
COPY ./static ./
COPY ./templates ./

RUN useradd flask \
&& chown -R flask. /usr/src/app \
&& mkdir /home/flask && chown -R flask. /home/flask
USER flask
CMD [ "python", "./app.py" ]
