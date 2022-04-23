from marshmallow import Schema, post_dump, pre_load
from marshmallow.decorators import post_load

from src.utils.CaseConverter import (convert_to_case, to_camel_case,
                                     to_snake_case)


class CamelCaseSchema(Schema):
    def on_bind_field(self, field_name, field_obj):
        field_obj.data_key = to_camel_case(field_obj.data_key or field_name)

    @pre_load
    def pre_load_convert(self, data, **_):
        """Converts to camel case so that snake case arg is not ignored
        """

        if not isinstance(data, dict):
            data.data = convert_to_case(data.data, to_camel_case)

        return data

    @post_load
    def post_load_convert(self, data, **_):
        """Convert to snake case inside dicts
        """

        return {k: convert_to_case(val, to_snake_case) for k, val in data.items()}

    @post_dump
    def convert_to_camel_case(self, data, **_):
        """Convert dict fields to camel case"""
        return convert_to_case(data,  to_camel_case)
