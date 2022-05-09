import os
from io import BytesIO
from unittest.mock import MagicMock, patch

from slack_sdk import WebClient

from src.libs.slack import send_file
from tests.utils.models.BaseTest import BaseTest


class SlackTests(BaseTest):

    @patch.object(WebClient, 'files_upload')
    def test_SendFile_when_Default(self, mock_files_upload: MagicMock):
        """Test send_file when default behavior"""

        # when
        file = BytesIO()
        filename = 'filename'
        filetype = 'filetype'

        # mock
        mock_files_upload.return_value = 'ok'

        # then
        response = send_file(file, filename, filetype)

        # assert
        self.assertEqual(response, 'ok')
        mock_files_upload.assert_called_once_with(
            channels=os.getenv('DELIVERIES_CHANNEL'),
            file=file.getvalue(),
            filename=filename,
            filetype=filetype
        )
