from marshmallow import ValidationError, fields


class DelimitedCommaListField(fields.String):
    def _deserialize(self, value, attr, data, **kwargs):
        try:
            return value.split(",")
        except AttributeError as err:
            raise ValidationError(
                f"{attr} is not a delimited list it has a non string value {value}."
            ) from err
