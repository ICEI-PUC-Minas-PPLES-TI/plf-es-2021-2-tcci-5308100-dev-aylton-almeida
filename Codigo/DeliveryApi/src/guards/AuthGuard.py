from functools import wraps

from flask import request

from src.apis.gateway import gateway
from src.classes.Role import Role


def auth_guard(roles: list[Role] = None, needs_user_id=False, needs_role: Role = False):
    """Guards the route with user authentication and role

    Args:
        needs_user_id (bool, optional): IF auth user id should be passed to decorated method. Defaults to False.
        roles (list[Role], optional): List of allowed roles. Defaults to Role.deliverer.
    """

    roles = roles or [Role.any]

    def decorator(fn):
        @wraps(fn)
        def decorated_function(*args, **kwargs):
            bearer_token = request.headers.get('Authorization')

            user_roles, uid = gateway.service['auth'].authorize_request(
                bearer_token, roles).values()

            if needs_user_id:
                kwargs['auth_user_id'] = uid
            if needs_role:
                kwargs['roles'] = user_roles

            return fn(*args, **kwargs)
        return decorated_function
    return decorator
