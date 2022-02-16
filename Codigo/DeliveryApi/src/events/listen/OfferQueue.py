from flask import current_app
from src.libs.rabbitmq import rabbit


@rabbit.queue(routing_key='*.offer.order.paid')
def offer_order_paid_queue(routing_key: str, body: dict, message_id: str):
    """Offer order paid queues"""

    current_app.logger.info(f'{routing_key} - {body}')
