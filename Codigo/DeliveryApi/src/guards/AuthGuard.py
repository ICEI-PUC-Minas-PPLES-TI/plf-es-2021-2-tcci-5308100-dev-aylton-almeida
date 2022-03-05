from functools import wraps

from flask import request

from src.apis.AuthApi import Role
from src.apis.gateway import gateway


def auth_guard(role: Role = Role.deliverer, needs_user_id=False, needs_role: Role = False):
    """Guards the route with user authentication and role

    Args:
        needs_user_id (bool, optional): [description]. Defaults to False.
        role (Role, optional): [description]. Defaults to Role.deliverer.
    """
    def decorator(fn):
        @wraps(fn)
        def decorated_function(*args, **kwargs):
            bearer_token = request.headers.get('Authorization')

            roles, uid = gateway.service['auth'].authorize_request(
                bearer_token, role).values()

            if needs_user_id:
                kwargs['auth_user_id'] = uid
            if needs_role:
                kwargs['roles'] = [Role[role] for role in roles]

            return fn(*args, **kwargs)
        return decorated_function
    return decorator
