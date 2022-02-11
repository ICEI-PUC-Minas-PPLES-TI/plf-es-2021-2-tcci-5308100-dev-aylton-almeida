import unittest

from tests import app, db


class BaseTest(unittest.TestCase):

    def setUp(self) -> None:
        self.app = app.test_client()
        self.app_context = app.app_context
        self.app_context().push()

        db.drop_all()
        db.create_all()
