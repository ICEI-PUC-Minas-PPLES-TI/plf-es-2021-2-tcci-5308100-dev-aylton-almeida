from src.utils.CaseConverter import (convert_to_case, to_camel_case,
                                     to_snake_case)
from tests.utils.models.BaseTest import BaseTest


class CaseConverterTests(BaseTest):

    def test_ToSnakeCase_when_Default(self):
        """Test to_snake_case when default"""

        # when
        camel_string = "camelCase"

        # then
        response = to_snake_case(camel_string)

        # assert
        self.assertEqual(response, "camel_case")

    def test_ToCamelCase_when_Default(self):
        """Test to_camel_case when default"""

        # when
        snake_string = "snake_string"

        # then
        response = to_camel_case(snake_string)

        # assert
        self.assertEqual(response, "snakeString")

    def test_ConvertToCase_when_ListWithDict(self):
        """Test convert_to_case when data is list of dicts"""

        # when
        converter = to_snake_case
        data = [
            'camelString',
            {
                'myKey': 'value'
            },
            {
                'myKey2': 'newValue'
            },
        ]

        # then
        response = convert_to_case(data, converter)

        # assert
        self.assertEqual(response, [
            'camelString',
            {
                'my_key': 'value'
            },
            {
                'my_key2': 'newValue'
            },
        ])

    def test_ConvertToCase_when_NotDictOrList(self):
        """Test convert_to_case when data is not list or dict
            It should do nothing
        """

        # when
        converter = to_snake_case
        data = 'myString'

        # then
        response = convert_to_case(data, converter)

        # assert
        self.assertEqual(response, 'myString')
