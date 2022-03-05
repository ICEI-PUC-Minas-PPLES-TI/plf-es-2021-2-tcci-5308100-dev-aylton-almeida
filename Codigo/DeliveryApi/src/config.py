import os


class Development():
    FLASK_ENV = os.getenv('FLASK_ENV')
    DEBUG = True
    TESTING = False
    SQLALCHEMY_DATABASE_URI = os.getenv('DB_SERVER_URL')
    SQLALCHEMY_ECHO = False
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    MQ_EXCHANGE = os.getenv('MQ_EXCHANGE')
    MQ_URL = os.getenv('MQ_URL')
    SECRET_KEY = os.getenv('SECRET_KEY')


class Testing(Development):
    DEBUG = False
    TESTING = True
    WTF_CSRF_ENABLED = False


class Production(Development):
    DEBUG = False


app_config = {
    'development': Development,
    'production': Production,
    'testing': Testing
}
