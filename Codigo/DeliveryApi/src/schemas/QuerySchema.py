

from marshmallow import fields, pre_load
from src.classes.DelimitedCommaListField import DelimitedCommaListField
from src.utils.CaseConverter import to_snake_case

from .CamelCaseSchema import CamelCaseSchema


class OnlySchema(CamelCaseSchema):
    """Select only given fields schema
    """

    only = DelimitedCommaListField(
        required=True, description='Comma separeted list of fields to be selected')


class QuerySchema(OnlySchema):
    """Default schema for get queries
    """

    limit = fields.Int(required=False, description='Limit of items to fetch')
    offset = fields.Int(
        required=False, description="Offset used for data pagination")
    desc = fields.Str(
        required=False, description='Field to descending order by the response')
    asc = fields.Str(
        required=False, description='Field to ascending order by the response')
    ids = DelimitedCommaListField(
        required=False, description='List of ids to fetch group of items')

    @pre_load
    def pre_load_convert(self, data, **_):
        """Converts to camel case so that snake case arg is not ignored
        """
        if not isinstance(data, dict):
            data.data = {to_snake_case(key): to_snake_case(
                val) for key, val in data.data.items()}

        super().pre_load_convert(data, **_)

        return data
