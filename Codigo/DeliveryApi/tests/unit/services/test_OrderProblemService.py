from unittest.mock import MagicMock, patch
from uuid import uuid4

from src.classes.ProblemType import ProblemType
from src.models.OrderProblemModel import OrderProblemModel
from src.services.OrderProblemService import OrderProblemService
from tests.utils.models.BaseTest import BaseTest


class OrderProblemServiceTests(BaseTest):

    @patch.object(OrderProblemModel, 'save')
    def test_CreateProblem_when_Default(self, mock_save: MagicMock):
        """Test get_one_by_id when default behavior"""

        # when
        payload = {
            'order_id': uuid4(),
            'problem_type': ProblemType.absent_receiver,
            'description': 'test',
            'commit': True
        }

        # then
        response = OrderProblemService.create_problem(**payload)

        # assert
        self.assertEqual(response.order_id, payload['order_id'])
        self.assertEqual(response.type, payload['problem_type'].name)
        self.assertEqual(response.description, payload['description'])
        mock_save.assert_called_once_with(payload['commit'])
