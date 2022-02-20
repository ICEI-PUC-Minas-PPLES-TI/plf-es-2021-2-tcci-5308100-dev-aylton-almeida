from __future__ import annotations

from . import db
from .BaseModel import BaseModel


class SupplierModel(BaseModel, db.Model):

    __tablename__ = 'delivery_suppliers'

    supplier_id = db.Column(db.Integer, primary_key=True, autoincrement=False)
    phone = db.Column(db.String(20), nullable=True)
    name = db.Column(db.String(100),  nullable=False)
    legal_id = db.Column(db.String(30), nullable=True)

    def __init__(self, data: dict, _session=None) -> None:
        super().__init__(_session=_session)

        self.supplier_id = data.get('supplier_id')
        self.phone = data.get('phone')
        self.name = data.get('name')
        self.legal_id = data.get('legal_id')
