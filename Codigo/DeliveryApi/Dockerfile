FROM python:3.9

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

ARG FLASK_ENV='production'
ARG FLASK_APP='main.py'
ARG PORT

ENV FLASK_ENV $FLASK_ENV
ENV FLASK_APP $FLASK_APP
ENV DB_SERVER_URL $DB_SERVER_URL
ENV MQ_EXCHANGE $MQ_EXCHANGE
ENV MQ_URL $MQ_URL
ENV G_CLOUD_API_KEY $G_CLOUD_API_KEY
ENV PORT $PORT

# Run the application
COPY . .
CMD gunicorn -k gevent -t 300 -b :$PORT main:app
