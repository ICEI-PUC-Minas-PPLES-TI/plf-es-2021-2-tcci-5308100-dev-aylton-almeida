from __future__ import annotations

from sqlalchemy.dialects.postgresql import UUID

from . import db
from .BaseModel import BaseModel


class DeliveryRouteModel(BaseModel, db.Model):

    __tablename__ = 'delivery_delivery_routes'

    delivery_route_id = db.Column(db.Integer, primary_key=True)
    estimate_time = db.Column(db.Time, nullable=False)

    delivery_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'delivery_deliveries.delivery_id'))

    def __init__(self, data: dict, _session=None) -> None:
        super().__init__(_session=_session)

        self.delivery_route_id = data.get('delivery_route_id')
        self.estimate_time = data.get('estimate_time')
        self.delivery_id = data.get('delivery_id')
