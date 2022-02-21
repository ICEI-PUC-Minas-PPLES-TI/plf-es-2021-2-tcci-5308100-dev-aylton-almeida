from unittest.mock import MagicMock, patch
from uuid import UUID, uuid4

from src.models.DeliveryModel import DeliveryModel
from src.schemas.DeliveryBaseSchema import DeliveryBaseSchema
from src.services.DeliveryService import DeliveryService
from src.services.OfferService import OfferService
from tests.utils.models.BaseTest import BaseTest


class OfferServiceTests(BaseTest):

    @patch.object(DeliveryBaseSchema, 'from_offer')
    @patch.object(DeliveryService, 'get_one_by_offer_id')
    @patch.object(DeliveryService, 'create_optimized_delivery')
    def test_HandleOfferCompleteEvent_when_DeliveryNotCreated(
        self,
        mock_create_optimized_delivery: MagicMock,
        mock_get_one_by_offer_id: MagicMock,
        mock_from_offer: MagicMock
    ):
        """Test handle_offer_complete_event when delivery was not already created"""

        # when
        offer = {
            'offer_id': str(uuid4())
        }
        parsed_offer = {
            'offer_id': UUID(offer.get('offer_id'))
        }

        # mock
        mock_get_one_by_offer_id.return_value = None
        mock_from_offer.return_value = parsed_offer

        # then
        OfferService.handle_offer_complete_event(offer)

        # assert
        mock_get_one_by_offer_id.assert_called_once_with(
            parsed_offer.get('offer_id'))
        mock_create_optimized_delivery.assert_called_once_with(parsed_offer)

    @patch.object(DeliveryBaseSchema, 'from_offer')
    @patch.object(DeliveryService, 'get_one_by_offer_id')
    @patch.object(DeliveryService, 'create_optimized_delivery')
    def test_HandleOfferCompleteEvent_when_DeliveryAlreadyCreated(
        self,
        mock_create_optimized_delivery: MagicMock,
        mock_get_one_by_offer_id: MagicMock,
        mock_from_offer: MagicMock
    ):
        """Test handle_offer_complete_event when delivery was already created"""

        # when
        offer = {
            'offer_id': str(uuid4())
        }
        parsed_offer = {
            'offer_id': UUID(offer.get('offer_id'))
        }

        # mock
        mock_get_one_by_offer_id.return_value = DeliveryModel({})
        mock_from_offer.return_value = parsed_offer

        # then
        OfferService.handle_offer_complete_event(offer)

        # assert
        mock_get_one_by_offer_id.assert_called_once_with(
            parsed_offer.get('offer_id'))
        mock_create_optimized_delivery.assert_not_called()
