from flask import current_app

from src.libs.rabbitmq import rabbit
from src.services.OfferService import OfferService


@rabbit.queue(routing_key='*.offer.status.completed')
def offer_completed_queue(routing_key: str, body: dict, message_id: str):
    """Offer order paid queues"""

    # TODO: test

    current_app.logger.info(
        f"OFFER COMPLETED EVENT RECEIVED: {body.get('offer_id')}")

    OfferService.handle_offer_complete_event(body)
