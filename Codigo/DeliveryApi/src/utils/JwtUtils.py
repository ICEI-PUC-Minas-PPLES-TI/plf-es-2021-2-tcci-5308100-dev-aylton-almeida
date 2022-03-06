import os
from datetime import datetime, timezone

import jwt

from src.classes.Role import Role


def create_jwt_token(key: str, role: Role) -> str:
    """Creates JWT token

    Args:
        key (str): JWT key

    Returns:
        str: JWT token
    """

    secret = os.getenv('SECRET_KEY')
    payload = {
        'key': key,
        'iat': datetime.now(tz=timezone.utc),
        'role': str(role)
    }

    return jwt.encode(payload, secret, algorithm='HS256')


def decode_jwt_token(token: str) -> tuple[str, Role]:
    """Decore JWT token

    Args:
        jwt (str): JWT token

    Returns:
        tuple[str, Role]: JWT token key and user role
    """

    secret = os.getenv('SECRET_KEY')
    decoded = jwt.decode(token, secret, algorithms='HS256')

    return decoded.get('key'), Role[decoded.get('role')]
