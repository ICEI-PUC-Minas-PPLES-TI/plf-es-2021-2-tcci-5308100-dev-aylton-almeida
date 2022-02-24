from __future__ import annotations

from src.libs.gcloud.maps import get_lat_lng_from_address

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
    lat = db.Column(db.Numeric)
    lng = db.Column(db.Numeric)

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

        if not (self.lat and self.lng):
            self.set_lat_lng()

    def __repr__(self) -> str:
        return f'''{
            self.street_name
            } {self.street_number} {self.neighborhood_name} {self.city_name} {self.country_state} {self.postal_code}'''

    def set_lat_lng(self):
        """Based on address sets latitude and longitude values"""

        lat_lng = get_lat_lng_from_address(str(self))
        self.lat = lat_lng.get('lat')
        self.lng = lat_lng.get('lng')

    def get_lat_lng(self):
        """Returns tuple containing latitude and longitude"""

        return self.lat, self.lng
