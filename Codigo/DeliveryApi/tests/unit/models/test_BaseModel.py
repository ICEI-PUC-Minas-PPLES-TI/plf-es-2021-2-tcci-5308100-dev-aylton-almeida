from unittest.mock import MagicMock
from uuid import uuid4

from src.models.BaseModel import BaseModel
from src.models.DeliveryModel import DeliveryModel
from tests.utils.models.BaseTest import BaseTest


class BaseModelTests(BaseTest):

    _model = None

    def setUp(self) -> None:
        self._model = BaseModel(_session=MagicMock())

        return super().setUp()

    def test_Save_when_Commit(self):
        """Test save when asked to commit transaction"""

        # mock
        mock_add = MagicMock()
        mock_commit = MagicMock()
        mock_flush = MagicMock()
        self._model.session.add = mock_add
        self._model.session.commit = mock_commit
        self._model.session.flush = mock_flush

        # then
        self._model.save()

        # assert
        mock_add.assert_called_once_with(self._model)
        mock_flush.assert_called_once_with()
        mock_commit.assert_called_once_with()

    def test_Save_when_NoCommit(self):
        """Test save when asked to not commit transaction"""

        # mock
        mock_add = MagicMock()
        mock_commit = MagicMock()
        mock_flush = MagicMock()
        self._model.session.add = mock_add
        self._model.session.commit = mock_commit
        self._model.session.flush = mock_flush

        # then
        self._model.save(False)

        # assert
        mock_add.assert_called_once_with(self._model)
        mock_flush.assert_called_once_with()
        mock_commit.assert_not_called()

    def test_Update_when_Commit(self):
        """Test update when asked to commit transaction"""

        # when
        data = {
            'name': 'Test'
        }

        # mock
        mock_commit = MagicMock()
        mock_flush = MagicMock()
        self._model.session.commit = mock_commit
        self._model.session.flush = mock_flush

        # then
        self._model.update(data)

        # assert
        self.assertEqual(self._model.name,  # pylint: disable=no-member
                         data['name'])
        mock_flush.assert_called_once_with()
        mock_commit.assert_called_once_with()

    def test_Update_when_NoCommit(self):
        """Test update when asked not to commit transaction"""

        # when
        data = {
            'name': 'Test'
        }

        # mock
        mock_commit = MagicMock()
        mock_flush = MagicMock()
        self._model.session.commit = mock_commit
        self._model.session.flush = mock_flush

        # then
        self._model.update(data, False)

        # assert
        self.assertEqual(self._model.name,  # pylint: disable=no-member
                         data['name'])
        mock_flush.assert_called_once_with()
        mock_commit.assert_not_called()

    def test_Delete_when_Commit(self):
        """Test update when asked to commit transaction"""

        # mock
        mock_delete = MagicMock()
        mock_commit = MagicMock()
        self._model.session.delete = mock_delete
        self._model.session.commit = mock_commit

        # then
        self._model.delete()

        # assert
        mock_delete.assert_called_once_with(self._model)
        mock_commit.assert_called_once_with()

    def test_Delete_when_NoCommit(self):
        """Test update when asked not to commit transaction"""

        # mock
        mock_delete = MagicMock()
        mock_commit = MagicMock()
        self._model.session.delete = mock_delete
        self._model.session.commit = mock_commit

        # then
        self._model.delete(False)

        # assert
        mock_delete.assert_called_once_with(self._model)
        mock_commit.assert_not_called()

    def test_Commit_when_Default(self):
        """Test commit when default behavior"""

        # mock
        BaseModel.session = MagicMock()

        # then
        BaseModel.commit()

        # assert
        BaseModel.session.commit.assert_called_once_with()

    def test_GetOneFiltered_when_Default(self):
        """Test get_one_filtered when default behavior"""

        # when
        filters = [
            DeliveryModel.delivery_id == uuid4(),
            DeliveryModel.offer_id == uuid4()
        ]

        # mock
        mock_filter = MagicMock()
        mock_first = MagicMock(return_value='found-model')
        mock_filter.return_value.first = mock_first
        BaseModel.query = MagicMock()
        BaseModel.query.filter = mock_filter

        # then
        response = BaseModel.get_one_filtered(filters)

        # assert
        self.assertEqual(response, 'found-model')
        mock_filter.assert_called_once_with(*filters)
        mock_first.assert_called_once_with()
