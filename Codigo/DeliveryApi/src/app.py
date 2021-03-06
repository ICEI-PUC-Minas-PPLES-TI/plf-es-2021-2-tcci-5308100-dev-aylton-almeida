import warnings

from flask import Flask
from flask_cors import CORS
from flask_restful import Api

from src.controllers.AuthController import (AuthorizeResource,
                                            DelivererAuthResource,
                                            SupplierAuthCodeResource,
                                            SupplierAuthResource)
from src.controllers.DeliveryController import (DeliveryListResource,
                                                DeliveryOrderResource,
                                                DeliveryResource,
                                                VerifyDeliveryResource)
from src.controllers.TestsController import IntegrationTestResource
from src.events.listen import *
from src.jobs import *
from src.jobs.Scheduler import scheduler
from src.models import *

from .config import app_config
from .docs import doc_spec, docs
from .libs.rabbitmq import body_parser, msg_parser, rabbit
from .models import db
from .utils.CustomResponse import custom_response

PATH = "/delivery"


def create_app(env_name):
    """Creates new Flask App instance

    Args:
        env_name (development, production, testing): One of the given env names to be used for configuring the app

    Returns:
        Flask: Flask app instance
    """

    # Filter multiple schemas warning
    warnings.filterwarnings(
        "ignore",
        message="Multiple schemas resolved to the name "
    )

    # app initialization
    app = Flask(__name__)
    # uncomment to add routes
    api = Api(app)
    CORS(app)

    app.config.from_object(app_config[env_name])
    app.config.update(doc_spec)

    # add routes
    api.add_resource(VerifyDeliveryResource,
                     f'{PATH}/deliveries/verify/<string:code>')
    api.add_resource(DeliveryListResource,  f'{PATH}/deliveries')
    api.add_resource(DeliveryOrderResource,
                     f'{PATH}/deliveries/deliver-order')
    api.add_resource(DeliveryResource,
                     f'{PATH}/deliveries/<string:delivery_id>')

    api.add_resource(AuthorizeResource, f'{PATH}/auth')
    api.add_resource(DelivererAuthResource, f'{PATH}/auth/deliverers')
    api.add_resource(SupplierAuthResource, f'{PATH}/auth/suppliers')
    api.add_resource(SupplierAuthCodeResource,
                     f'{PATH}/auth/suppliers/verify-code')

    api.add_resource(IntegrationTestResource, f'{PATH}/integration-setup')

    # init docs
    docs.init_app(app)

    docs.register(VerifyDeliveryResource)
    docs.register(DeliveryListResource)
    docs.register(DeliveryOrderResource)
    docs.register(DeliveryResource)

    docs.register(AuthorizeResource)
    docs.register(DelivererAuthResource)
    docs.register(SupplierAuthResource)
    docs.register(SupplierAuthCodeResource)

    # db initialization
    db.init_app(app)

    # init rabbitmq
    rabbit.init_app(
        app,
        'delivery',
        body_parser=body_parser,
        msg_parser=msg_parser,
        development=app.config.get('ENV') != 'production'
    )

    # scheduler initialization
    scheduler.init_app(app)
    scheduler.start()

    @app.route(PATH+'/ping', methods=['GET'])
    def _():
        result = 'pong'
        return custom_response(result, 200)

    return app
