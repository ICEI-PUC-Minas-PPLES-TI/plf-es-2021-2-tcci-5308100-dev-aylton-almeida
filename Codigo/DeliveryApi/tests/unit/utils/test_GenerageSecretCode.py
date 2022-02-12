from src.utils.GenerateSecretCode import generate_secret_code
from tests.utils.models.BaseTest import BaseTest


class GenerateSecretCodeTests(BaseTest):

    def test_GenerateSecretCode_when_Default(self):
        """Test generate_secret_code when default"""

        # then
        code1 = generate_secret_code(6)
        code2 = generate_secret_code(7)
        code3 = generate_secret_code(7)

        # assert
        self.assertEqual(len(code1), 6)
        self.assertEqual(len(code2), 7)
        self.assertEqual(len(code3), 7)
        self.assertNotEqual(code2, code3)
