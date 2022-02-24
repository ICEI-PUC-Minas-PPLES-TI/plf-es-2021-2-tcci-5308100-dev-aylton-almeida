from datetime import time

from src.utils.TimeUtils import seconds_to_time
from tests.utils.models.BaseTest import BaseTest


class TimeUtilsTests(BaseTest):

    def test_SecondsToTime_when_HoursAndMinutes(self):
        """Test seconds to time when seconds converts to hours and minutes"""

        # when
        seconds = 7654

        # then
        response = seconds_to_time(seconds)

        # assert
        self.assertEqual(time(2, 7, 34), response)

    def test_SecondsToTime_when_OnlyMinutes(self):
        """Test seconds to time when seconds converts to only minutes"""

        # when
        seconds = 2400

        # then
        response = seconds_to_time(seconds)

        # assert
        self.assertEqual(time(0, 40), response)
