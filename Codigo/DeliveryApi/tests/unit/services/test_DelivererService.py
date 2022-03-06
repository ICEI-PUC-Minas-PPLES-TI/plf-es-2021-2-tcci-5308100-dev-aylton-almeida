from unittest.mock import MagicMock, patch

from src.models.DelivererModel import DelivererModel
from src.services.DelivererService import DelivererService
from tests.utils.models.BaseTest import BaseTest


class DelivererServiceTests(BaseTest):

    @patch.object(DelivererModel, 'save')
    def test_Create_when_ShouldCommit(self, mock_save: MagicMock):
        """Test create when should commit transaction"""

        # when
        deliverer = {
            'deliverer_id': 123
        }
        commit = True

        # then
        response = DelivererService.create(deliverer, commit)

        # assert
        self.assertEqual(response.deliverer_id, deliverer.get('deliverer_id'))
        mock_save.assert_called_once_with(commit)

    @patch.object(DelivererModel, 'save')
    def test_Create_when_ShouldNotCommit(self, mock_save: MagicMock):
        """Test create when should not commit transaction"""

        # when
        deliverer = {
            'deliverer_id': 123
        }
        commit = False

        # then
        response = DelivererService.create(deliverer, commit)

        # assert
        self.assertEqual(response.deliverer_id, deliverer.get('deliverer_id'))
        mock_save.assert_called_once_with(commit)

    @patch.object(DelivererModel, 'get_one_filtered')
    def test_GetOneById_when_Default(self, mock_get_one_filtered: MagicMock):
        """Test get_one_by_id when default behavior"""

        # when
        deliverer_id = 123
        found_deliverer = DelivererModel({})

        # mock
        mock_get_one_filtered.return_value = found_deliverer

        # then
        response = DelivererService.get_one_by_id(deliverer_id)

        # assert
        self.assertEqual(response, found_deliverer)
        self.assertTrue(
            mock_get_one_filtered.call_args_list[0][0][0][0].compare(
                DelivererModel.deliverer_id == deliverer_id
            ),
            'assert filter has deliverer_id == deliverer_id'
        )
