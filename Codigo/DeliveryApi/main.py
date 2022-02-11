# pylint: disable=no-member
import logging
import os

from dotenv import load_dotenv
from flask import request

from src.app import create_app

load_dotenv()

env_name = os.getenv('FLASK_ENV')
app = create_app(env_name)


@app.before_request
def before_request():
    """Logs requested url before every request"""

    if not request.url.endswith('/ping'):
        app.logger.info('Request: %s %s', request.method, request.url)


if app.config.get('ENV') == 'production':
    gunicorn_logger = logging.getLogger('gunicorn.error')
    app.logger.handlers = gunicorn_logger.handlers
    app.logger.setLevel(gunicorn_logger.level)
