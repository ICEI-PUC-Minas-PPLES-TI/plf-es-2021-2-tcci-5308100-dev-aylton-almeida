from datetime import time


def seconds_to_time(seconds: int) -> time:
    """Converts seconds to time"""

    return time(seconds // 3600, (seconds % 3600) // 60, seconds % 60)
