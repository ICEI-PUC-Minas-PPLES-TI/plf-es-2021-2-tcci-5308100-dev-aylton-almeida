from datetime import datetime, timedelta, timezone


def get_current_datetime() -> datetime:
    """Returns current datetime"""

    return datetime.now(tz=timezone(-timedelta(hours=3), name='America/Sao_Paulo'))
