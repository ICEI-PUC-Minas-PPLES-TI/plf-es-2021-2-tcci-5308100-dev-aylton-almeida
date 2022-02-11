import json
from json.decoder import JSONDecodeError

from flask.globals import current_app
from rabbitmq_pika_flask import RabbitMQ
from src.utils.CaseConverter import (convert_to_case, to_camel_case,
                                     to_snake_case)

rabbit = RabbitMQ()


def body_parser(data: str):
    """Parses received data from RabbitMQ

    Args:
        data (str): Received JSON data

    Returns:
        dict or list: dict or list snaked case parsed data
    """
    try:
        parsed_data = json.loads(data)
        return convert_to_case(parsed_data, to_snake_case)
    except JSONDecodeError:
        current_app.logger.error('Invalid JSON data received')
        return None


def msg_parser(data: any):
    """Parses data to through RabbitMQ

    Args:
        data (any): Data to be parsed

    Returns:
        str: JSON camel case parsed data
    """

    camel_data = convert_to_case(data, to_camel_case)

    return json.dumps(camel_data)
