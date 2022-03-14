from apispec import APISpec
from apispec.ext.marshmallow import MarshmallowPlugin
from flask_apispec.extension import FlaskApiSpec

doc_spec = {
    'APISPEC_SPEC': APISpec(
        title='Delivery API',
        version='1.0.0',
        openapi_version="3.0.2",
        info=dict(
            description="Zapt API responsible for deliveries management"),
        plugins=[MarshmallowPlugin()],
        components={
            'securitySchemes': {
                'Bearer': {
                    'type': 'apiKey',
                    'name': 'Authorization',
                    'in': 'header',
                    'scheme': 'bearer',
                    'bearerFormat': 'JWT'
                }
            }
        }
    ),
    'APISPEC_SWAGGER_URL': '/delivery/swagger/',
    'APISPEC_SWAGGER_UI_URL': '/delivery/docs/'
}

docs = FlaskApiSpec()
