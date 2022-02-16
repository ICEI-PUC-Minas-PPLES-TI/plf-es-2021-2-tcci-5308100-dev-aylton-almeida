import json
import os

import requests

token_endpoint = os.getenv('COGNITO_TOKEN_ENDPOINT')
client_id = os.getenv('COGNITO_CLIENT_ID')
client_secret = os.getenv('COGNITO_CLIENT_SECRET')
scope = os.getenv('COGNITO_TOKEN_SCOPE')


def get_headers(auth_guard=True):
    """Get request headers, with auth token if needed

    Args:
        auth_guard (bool, optional): If the auth token should be added to the request header. Defaults to True.

    Returns:
        dict: Request header
    """

    headers = {
        'Content-Type': 'application/json'
    }

    if auth_guard:
        body = {
            'grant_type': 'client_credentials',
            'client_id': client_id,
            'client_secret': client_secret,
            'scope': scope
        }

        cognito_response = requests.post(token_endpoint, data=body)
        token_json = json.loads(cognito_response.text)
        token = ' '.join(
            [token_json['token_type'], token_json['access_token']])

        headers['Authorization'] = token

    return headers
