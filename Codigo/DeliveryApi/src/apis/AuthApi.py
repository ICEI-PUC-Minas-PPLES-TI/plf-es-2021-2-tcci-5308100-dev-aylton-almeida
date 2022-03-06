from werkzeug.exceptions import Forbidden, Unauthorized

from src.classes.Role import Role
from src.utils.JwtUtils import decode_jwt_token


class AuthApi:

    def authorize_request(self, token: str, role: Role = Role.any):
        """Authorize user token

        Args:
            token (str): Bearer Token to authorize user with
            role (Role, optional): Role in which to check for given user token. Defaults to Role.deliverer.

        Returns:
            dict[R: Allowed roles for authenticated user and its user id
        """

        if not token:
            raise Forbidden('No token provided')

        try:
            user_id, found_role = decode_jwt_token(
                token.replace('Bearer ', '')
            )
        except Exception as err:  # pylint: disable=broad-except
            raise Unauthorized(str(err)) from err

        allowed_roles = found_role.get_authorized_roles()

        if role not in allowed_roles:
            raise Unauthorized(
                'User does not have access to this resource')

        return {
            'roles': allowed_roles,
            'user_id': user_id
        }
