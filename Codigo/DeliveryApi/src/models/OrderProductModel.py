from __future__ import annotations

from sqlalchemy.dialects.postgresql import UUID

from . import db
from .BaseModel import BaseModel


class OrderProductModel(BaseModel, db.Model):

    __tablename__ = 'delivery_order_products'

    order_product_id = db.Column(db.Integer, primary_key=True)
    product_sku = db.Column(db.Integer, nullable=False)
    name = db.Column(db.String(500), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)

    order_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'delivery_orders.order_id'), nullable=False)

    def __init__(self, data: dict, _session=None) -> None:
        super().__init__(_session=_session)

        self.order_product_id = data.get('order_product_id')
        self.product_sku = data.get('product_sku')
        self.name = data.get('name')
        self.quantity = data.get('quantity')
        self.order_id = data.get('order_id')
