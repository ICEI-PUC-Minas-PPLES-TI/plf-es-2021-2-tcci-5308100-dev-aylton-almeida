from werkzeug.exceptions import Forbidden

from src.classes.Role import Role
from src.utils.JwtUtils import decode_jwt_token


class AuthApi:

    def authorize_request(self, token: str, role: Role = Role.deliverer):
        """Authorize user token

        Args:
            token (str): Bearer Token to authorize user with
            role (Role, optional): Role in which to check for given user token. Defaults to Role.deliverer.

        Returns:
            dict[R: Allowed roles for authenticated user and its user id
        """

        # TODO: test

        try:
            if not token:
                raise Forbidden('No token provided')

            user_id, found_role = decode_jwt_token(
                token.replace('Bearer ', '')
            )

            allowed_roles = found_role.get_authorized_roles()

            if role not in allowed_roles:
                raise Forbidden('User does not have access to this resource')

            return {
                'roles': [allowed_roles],
                'user_id': user_id
            }
        except Exception as e:  # pylint: disable=broad-except
            raise Forbidden(str(e)) from e
