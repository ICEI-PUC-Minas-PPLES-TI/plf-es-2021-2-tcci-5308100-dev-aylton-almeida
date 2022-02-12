import unittest

from tests import app


class BaseTest(unittest.TestCase):

    def setUp(self) -> None:
        self.app = app.test_client()
        self.app_context = app.app_context
        self.app_context().push()
