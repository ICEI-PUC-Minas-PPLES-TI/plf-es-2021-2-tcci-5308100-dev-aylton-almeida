from marshmallow import Schema, fields


class SupplierBaseSchema(Schema):

    supplier_id = fields.Int()
    phone = fields.Str()
    name = fields.Str()
    legal_id = fields.Str()

    @staticmethod
    def from_offer(offer_supplier: dict):
        """Create a supplier based on an offer supplier
        """

        # TODO: test

        schema = SupplierBaseSchema(unknown='EXCLUDE')

        return schema.load({
            'supplier_id': offer_supplier.get("supplier_id"),
            'phone': offer_supplier.get("phone"),
            'name': offer_supplier.get("name"),
            'legal_id': offer_supplier.get("legal_id"),
        })
