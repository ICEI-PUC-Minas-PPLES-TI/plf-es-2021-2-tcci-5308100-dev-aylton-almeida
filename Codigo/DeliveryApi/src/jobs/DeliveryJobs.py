from flask import current_app

from src.jobs.Scheduler import scheduler
from src.services.DeliveryService import DeliveryService


@scheduler.task(
    'cron',
    id='run_send_report',
    hour="20",
    max_instances=1
)
def run_send_reports():
    """Runs the send_report job everyday at 20 PM"""

    with scheduler.app.app_context():
        current_app.logger.info('Starting deliveries report job...')

        DeliveryService.send_report()

        current_app.logger.info('Deliveries report job finished')
