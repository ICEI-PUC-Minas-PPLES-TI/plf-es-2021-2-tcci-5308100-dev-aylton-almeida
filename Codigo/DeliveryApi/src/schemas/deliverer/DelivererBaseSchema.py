from marshmallow import Schema, fields


class DelivererBaseSchema(Schema):

    deliverer_id = fields.Int()
    phone = fields.Str()
    delivery_id = fields.UUID()
