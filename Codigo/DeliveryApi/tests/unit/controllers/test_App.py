from http import HTTPStatus
from tests.utils.decode_response import decode_response
from tests.utils.models.BaseTest import BaseTest

from tests import base_path


class AppTests(BaseTest):

    def test_ping(self):
        response = self.app.get(base_path + '/ping', follow_redirects=True)
        self.assertEqual(response.status_code, HTTPStatus.OK)
        self.assertEqual(decode_response(response.data), 'pong')
