from unittest.mock import MagicMock, patch

from src.jobs.DeliveryJobs import run_send_reports
from src.services.DeliveryService import DeliveryService
from tests.utils.models.BaseTest import BaseTest


class DeliveryJobsTests(BaseTest):

    @patch.object(DeliveryService, 'send_report')
    def test_RunSendReports_when_Default(self, mock_send_report: MagicMock):
        """Test run_send_reports when default behavior"""

        # then
        run_send_reports()

        # assert
        mock_send_report.assert_called_once_with()
