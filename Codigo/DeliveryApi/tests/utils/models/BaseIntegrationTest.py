import unittest

from flask import Flask
from flask.ctx import AppContext
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy_utils import create_database, database_exists

from src.models import __all__, db
from tests import app


class BaseIntegrationTest(unittest.TestCase):

    app: Flask
    app_context: AppContext
    db: SQLAlchemy

    def setUp(self) -> None:
        self.app = app.test_client()
        self.app_context = app.app_context
        self.app_context().push()

        self._setUpDB()

    def _setUpDB(self):
        """Sets up database, creating it and its tables"""

        self.db = db
        if not database_exists(self.db.engine.url):
            create_database(self.db.engine.url)
        self.db.drop_all()
        self.db.create_all()
        self.db.session.commit()
