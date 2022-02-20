from marshmallow import Schema, fields


class AddressBaseSchema(Schema):

    address_id = fields.Int()
    city_name = fields.Str()
    country_state = fields.Str()
    street_name = fields.Str()
    street_number = fields.Str()
    unit_number = fields.Str()
    postal_code = fields.Str()
    neighborhood_name = fields.Str()
    lat = fields.Number()
    lng = fields.Number()

    @staticmethod
    def from_offer_order_address(offer_order_address: dict):
        """Create an address based on an offer order shipping address data"""

        # TODO: test

        schema = AddressBaseSchema(unknown='EXCLUDE')

        # Remove old address id if any
        offer_order_address.pop('address_id', None)

        return schema.load({
            **offer_order_address
        })
