from __future__ import annotations

from sqlalchemy.dialects.postgresql import UUID

from . import db
from .BaseModel import BaseModel


class OrderModel(BaseModel, db.Model):

    __tablename__ = 'delivery_orders'

    order_id = db.Column(UUID(as_uuid=True), primary_key=True)
    buyer_name = db.Column(db.String(100), nullable=False)
    delivered = db.Column(db.Boolean, default=False)

    shipping_address_id = db.Column(db.Integer, db.ForeignKey(
        'delivery_addresses.address_id'), nullable=False)
    delivery_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'delivery_deliveries.delivery_id'), nullable=False)

    def __init__(self, data: dict, _session=None) -> None:
        super().__init__(_session=_session)

        self.order_id = data.get('order_id')
        self.buyer_name = data.get('buyer_name')
        self.delivered = data.get('delivered')
        self.shipping_address_id = data.get('shipping_address_id')
        self.delivery_id = data.get('delivery_id')
