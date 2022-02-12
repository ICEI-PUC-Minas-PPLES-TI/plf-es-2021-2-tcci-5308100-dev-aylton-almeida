from __future__ import annotations

from uuid import uuid4

from sqlalchemy.dialects.postgresql import UUID

from src.classes.DeliveryStatus import DeliveryStatus
from src.utils.GenerateSecretCode import generate_secret_code

from . import db
from .BaseModel import BaseModel


def _generate_delivery_access_code(_) -> str:
    """Generates a random access code for a delivery."""
    # TODO: test

    # Generate code with 6 digits and check if available in db
    is_valid = False
    while not is_valid:
        code = generate_secret_code(6)

        is_valid = not DeliveryModel.get_one_filtered([
            DeliveryModel.access_code == code,
        ])

    return code


class DeliveryModel(BaseModel, db.Model):

    __tablename__ = 'delivery_deliveries'

    delivery_id = db.Column(
        UUID(as_uuid=True), primary_key=True, default=uuid4)
    offer_id = db.Column(UUID(as_uuid=True), nullable=True)
    status = db.Column(
        db.String(30), default=str(DeliveryStatus.created), nullable=False)
    access_code = db.Column(
        db.String(6), default=_generate_delivery_access_code, nullable=False)
    report_sent = db.Column(db.Boolean, default=False)
    start_time = db.Column(db.DateTime)
    end_time = db.Column(db.DateTime)

    supplier_id = db.Column(db.Integer, db.ForeignKey(
        'delivery_suppliers.supplier_id'))

    def __init__(self, data: dict, _session=None) -> None:
        super().__init__(_session=_session)

        self.delivery_id = data.get('delivery_id')
        self.offer_id = data.get('offer_id')
        self.status = data.get('status')
        self.access_code = data.get('access_code')
        self.report_sent = data.get('report_sent')
        self.start_time = data.get('start_time')
        self.end_time = data.get('end_time')