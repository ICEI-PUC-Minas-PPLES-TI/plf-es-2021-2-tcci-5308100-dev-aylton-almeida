import json
import os
from enum import Enum

import requests
from src.libs.aws.cognito import get_headers
from src.utils.CaseConverter import convert_to_case, to_snake_case


class Role(Enum):
    customer = 0
    leader = 1
    admin = 2
    supplier = 3

    def __str__(self) -> str:
        return str(self.name)


class AuthApi:

    api_url: str
    headers: dict

    def __init__(self):
        self.api_url = os.getenv('SERVICES_BASE_API') + \
            os.getenv('AUTH_API')

    def authorize_request(self, token: str, role: Role = Role.customer):
        """Authorize user token

        Args:
            token (str): Token to authorize user with
            role (Role, optional): Role in which to check for given user token. Defaults to Role.customer.
        """

        auth_response = requests.post(
            self.api_url + '/authorize',
            headers=get_headers(False),
            data=json.dumps({
                'token': token,
                'role': role.name
            })
        )

        auth_response.raise_for_status()

        return convert_to_case(json.loads(auth_response.text), to_snake_case)
