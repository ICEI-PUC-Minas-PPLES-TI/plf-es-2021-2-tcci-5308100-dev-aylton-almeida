from unittest.mock import MagicMock, patch
from uuid import uuid4

from src.events.listen.OfferQueue import offer_completed_queue
from src.services.OfferService import OfferService
from tests.utils.models.BaseTest import BaseTest


class OfferQueueTests(BaseTest):

    @patch.object(OfferService, 'handle_offer_complete_event')
    def test_OfferCompletedQueue_when_Default(self, mock_handle_offer_complete_event: MagicMock):
        """Test offer_completed_queue when default behavior"""

        # when
        routing_key = 'commerce.offer.status.completed'
        body = {
            'offer_id': uuid4()
        }
        message_id = 1

        # then
        offer_completed_queue(routing_key, body, message_id)

        # assert
        mock_handle_offer_complete_event.assert_called_once_with(body)
