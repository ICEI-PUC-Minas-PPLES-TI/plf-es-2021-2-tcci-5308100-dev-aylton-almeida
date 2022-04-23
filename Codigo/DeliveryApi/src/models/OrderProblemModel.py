from __future__ import annotations

from sqlalchemy.dialects.postgresql import UUID

from . import db
from .BaseModel import BaseModel


class OrderProblemModel(BaseModel, db.Model):

    __tablename__ = 'delivery_order_problems'

    order_problem_id = db.Column(db.Integer, primary_key=True)
    type = db.Column(db.String(30), nullable=False)
    description = db.Column(db.String(1000), default='', nullable=False)

    order_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey('delivery_orders.order_id', ondelete='CASCADE'),
        nullable=False,
    )

    def __init__(self, data: dict, _session=None) -> None:
        super().__init__(_session=_session)

        self.order_problem_id = data.get('order_problem_id')
        self.type = data.get('type')
        self.description = data.get('description')
        self.order_id = data.get('order_id')
