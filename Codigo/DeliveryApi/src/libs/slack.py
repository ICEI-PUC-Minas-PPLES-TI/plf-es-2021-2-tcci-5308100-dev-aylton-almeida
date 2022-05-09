import os
from io import BytesIO

from slack_sdk import WebClient

SLACK_TOKEN = os.getenv('SLACK_TOKEN')
DELIVERIES_CHANNEL = os.getenv('DELIVERIES_CHANNEL')


def send_file(file: BytesIO, filename: str, filetype: str):
    """Sends file to slack"""

    web_client = WebClient(token=SLACK_TOKEN)

    return web_client.files_upload(
        channels=DELIVERIES_CHANNEL,
        file=file.getvalue(),
        filename=filename,
        filetype=filetype
    )
