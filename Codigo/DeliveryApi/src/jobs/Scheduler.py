import os

from apscheduler.schedulers.gevent import GeventScheduler
from flask_apscheduler import APScheduler


class Scheduler(APScheduler):

    def __init__(self, scheduler_instance=None, app=None):
        super().__init__(scheduler=scheduler_instance, app=app)

    def start(self, paused=False):

        # Start scheduler only if not in debug mode
        if self.app is not None and\
                self.app.config.get('FLASK_ENV') == 'production' or os.getenv('WERKZEUG_RUN_MAIN') == 'true':

            super().start(paused=paused)
            for job in self.get_jobs():
                self.app.logger.info(f'Starting Job {job.name}')


scheduler = Scheduler(
    GeventScheduler() if os.getenv('FLASK_ENV') == 'production' else None
)
