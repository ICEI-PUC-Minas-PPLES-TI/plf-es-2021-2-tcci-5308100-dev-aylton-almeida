from src.jobs.Scheduler import scheduler
from src.services.DeliveryService import DeliveryService


@scheduler.task(
    'cron',
    id='run_send_report',
    hour='20',
    max_instances=1
)
def run_send_reports():
    """Runs the send_report job everyday at 20 PM"""

    # TODO: test
    with scheduler.app.app_context():
        DeliveryService.send_report()
