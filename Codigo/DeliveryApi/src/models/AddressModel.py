from __future__ import annotations

from uuid import uuid4

from . import db
from .BaseModel import BaseModel


class AddressModel(BaseModel, db.Model):

    __tablename__ = 'delivery_addresses'

    address_id = db.Column(db.Integer, primary_key=True)
    city_name = db.Column(db.String(40))
    country_state = db.Column(db.String(2))
    street_name = db.Column(db.String(100))
    street_number = db.Column(db.String(50))
    unit_number = db.Column(db.String)
    postal_code = db.Column(db.String(50))
    neighborhood_name = db.Column(db.String(100))
    lat = db.Column(db.Float(10, 8))
    lng = db.Column(db.Float(11, 8))

    def __init__(self, data: dict, _session=None) -> None:
        super().__init__(_session=_session)

        self.address_id = data.get('address_id')
        self.city_name = data.get('city_name')
        self.country_state = data.get('country_state')
        self.street_name = data.get('street_name')
        self.street_number = data.get('street_number')
        self.unit_number = data.get('unit_number')
        self.postal_code = data.get('postal_code')
        self.neighborhood_name = data.get('neighborhood_name')
        self.lat = data.get('lat')
        self.lng = data.get('lng')
