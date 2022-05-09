from datetime import datetime
from unittest.mock import MagicMock, patch

from slack_sdk import WebClient

from src.jobs.DeliveryJobs import run_send_reports
from src.models.DeliveryModel import DeliveryModel
from src.models.SupplierModel import SupplierModel
from src.utils.CaseConverter import convert_to_case, to_snake_case
from tests.utils.models.BaseIntegrationTest import BaseIntegrationTest
from tests.utils.sample_reader import get_sample


class SendDailyReportTest(BaseIntegrationTest):

    @patch.object(WebClient, 'files_upload')
    @patch('src.services.DeliveryService.get_current_datetime')
    def test_SendDailyReport_when_Default(
        self,
        mock_get_current_datetime: MagicMock,
        mock_files_upload: MagicMock,
    ):
        """test generate optimized route when offer sample 1 was sent.
            It should create a delivery route with it's optimized route.
        """

        # when
        delivery_sample = convert_to_case(
            get_sample('delivery_sample_1'), to_snake_case)
        now = datetime.now()

        # Setup data
        supplier = SupplierModel({
            'supplier_id': delivery_sample.get('supplier_id'),
            'phone': 'valid-phone',
            'name': 'Test Supplier'
        })
        supplier.save()
        delivery = DeliveryModel(delivery_sample)
        delivery.save()

        # mock
        mock_get_current_datetime.return_value = now

        # then
        run_send_reports()

        # assert
        mock_files_upload.assert_called_once()
