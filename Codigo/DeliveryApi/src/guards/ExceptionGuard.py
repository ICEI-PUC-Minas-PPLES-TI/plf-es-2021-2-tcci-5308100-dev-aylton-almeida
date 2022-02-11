import json
from contextlib import suppress
from functools import wraps
from http import HTTPStatus

from flask.globals import current_app
from requests import HTTPError
from sqlalchemy.exc import InvalidRequestError
from src.utils.CustomResponse import custom_response
from werkzeug.exceptions import \
    UnprocessableEntity  # pylint: disable=wrong-import-order


def exception_guard(fn):
    """Controllers exception guard"""
    @wraps(fn)
    def decorated_function(*args, **kwargs):
        try:
            return fn(*args, **kwargs)
        except HTTPError as e:
            response = e.response

            # check if it's already json or not
            text = response.text
            with suppress(ValueError):
                res = json.loads(text)
                text = res

            return custom_response(text, response.status_code)
        except UnprocessableEntity as e:
            code = e.code
            message = getattr(e, 'exc').messages

            return custom_response(message, code)
        except InvalidRequestError as e:
            error = HTTPStatus.BAD_REQUEST
            message = e.args[0]

            return custom_response(message, error)
        except Exception as e:  # pylint: disable=broad-except
            error_code = getattr(e, "code", '500')

            if not isinstance(error_code, int) and \
                    (error_code is None or not error_code.isnumeric()
                        or int(error_code) in [item.value for item in HTTPStatus]):
                error_code = 500

            current_app.logger.exception("Service exception: %s", e)
            res = {
                "class": str(e.__class__),
                "error_code": error_code,
                "error": str(e),
            }
            if hasattr(e, 'message'):
                res['message'] = getattr(e, 'message')
            return custom_response(res, error_code)
    decorated_function.__name__ = fn.__name__
    return decorated_function
