from datetime import datetime, timezone


def get_current_datetime() -> datetime:
    """Returns current datetime"""

    return datetime.utcnow().replace(tzinfo=timezone.utc)
