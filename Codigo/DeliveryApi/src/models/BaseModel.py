from __future__ import annotations

from . import db


class BaseModel:

    session = db.session
    query: any  # ? Added here only for pylint

    def __init__(self, _session=None) -> None:
        self.session = _session or db.session

    def save(self, commit=True):
        """Save model"""

        self.session.add(self)
        self.session.flush()

        if commit:
            self.session.commit()

    def update(self, data: dict, commit=True):
        """Update model with given data

        Args:
            data (dict): Data to update model with
        """

        for key, item in data.items():
            setattr(self, key, item)
        self.session.flush()

        if commit:
            self.session.commit()

    def delete(self, commit=True):
        """Delete model from db"""

        self.session.delete(self)

        if commit:
            self.session.commit()

    @staticmethod
    def commit():
        """Commits current transaction"""

        BaseModel.session.commit()
