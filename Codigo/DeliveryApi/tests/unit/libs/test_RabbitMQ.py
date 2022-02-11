import json

from src.libs.rabbitmq import body_parser, msg_parser
from tests.utils.models.BaseTest import BaseTest


class RabbitMQTests(BaseTest):

    def test_BodyParser_when_JsonValid(self):
        """Test body_parser when passed json is valid"""

        # when
        data = json.dumps({'myKey': 'value'})

        # then
        response = body_parser(data)

        # assert
        self.assertEqual(response, {'my_key': 'value'})

    def test_BodyParser_when_JsonIsInvalid(self):
        """Test body_parser when passed json is invalid"""

        # when
        data = "{err}"

        # then
        response = body_parser(data)

        # assert
        self.assertIsNone(response)

    def test_MsgParser_when_Default(self):
        """Test msg_parser when passed default"""

        # when
        data = {'my_key': 'value'}

        # then
        response = msg_parser(data)

        # assert
        self.assertEqual(response, json.dumps({'myKey': 'value'}))
