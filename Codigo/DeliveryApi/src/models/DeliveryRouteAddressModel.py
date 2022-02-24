from __future__ import annotations

from src.models.AddressModel import AddressModel

from . import db
from .BaseModel import BaseModel


class DeliveryRouteAddressModel(BaseModel, db.Model):

    __tablename__ = 'delivery_delivery_route_addresses'

    delivery_route_id = db.Column(db.Integer, db.ForeignKey(
        'delivery_delivery_routes.delivery_route_id'), primary_key=True)
    address_id = db.Column(db.Integer, db.ForeignKey(
        'delivery_addresses.address_id'), primary_key=True)
    position = db.Column(db.Integer, nullable=False)

    address: AddressModel = db.relationship('AddressModel')

    def __init__(self, data: dict, _session=None) -> None:
        super().__init__(_session=_session)

        self.delivery_route_id = data.get('delivery_route_id')
        self.address_id = data.get('address_id')
        self.position = data.get('position')
