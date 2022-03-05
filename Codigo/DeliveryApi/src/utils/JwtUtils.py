import os
from datetime import datetime, timezone

import jwt


def create_jwt_token(key: str) -> str:
    """Creates JWT token

    Args:
        key (str): JWT key

    Returns:
        str: JWT token
    """

    # TODO: test

    secret = os.getenv('SECRET_KEY')

    return jwt.encode({'key': key, 'iat': datetime.now(tz=timezone.utc)}, secret, algorithm='HS256')


def decode_jwt_token(token: str):
    """Decore JWT token

    Args:
        jwt (str): JWT token

    Returns:
        str: JWT token key
    """

    # TODO: test

    secret = os.getenv('SECRET_KEY')
    decoded = jwt.decode(token, secret, algorithms='HS256')

    return decoded.get('key')
