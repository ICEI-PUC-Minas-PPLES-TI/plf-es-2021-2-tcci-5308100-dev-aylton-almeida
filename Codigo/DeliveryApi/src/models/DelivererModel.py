from __future__ import annotations

from sqlalchemy.dialects.postgresql import UUID

from . import db
from .BaseModel import BaseModel


class DelivererModel(BaseModel, db.Model):

    __tablename__ = 'delivery_deliverers'

    deliverer_id = db.Column(db.Integer, primary_key=True)
    phone = db.Column(db.String(20))

    delivery_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey('delivery_deliveries.delivery_id', ondelete="CASCADE"),
    )

    def __init__(self, data: dict, _session=None) -> None:
        super().__init__(_session=_session)

        self.deliverer_id = data.get('deliverer_id')
        self.phone = data.get('phone')
        self.delivery_id = data.get('delivery_id')
