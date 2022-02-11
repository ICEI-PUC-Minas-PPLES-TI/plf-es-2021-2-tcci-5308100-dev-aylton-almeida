from functools import wraps

from flask_apispec import marshal_with
from flask_apispec.annotations import doc
from marshmallow import Schema
from src.utils.CaseConverter import to_snake_case


def marshal_response(schema: Schema, many: bool = False, exclude: list[str] = None):
    """Marsh response with given schema using args only

    Args:
        schema (Schema): Schema to be using during marshalling
        many (bool, optional): If single or many objects. Defaults to False.
    """

    def decorator(f):
        @doc(
            responses={
                '200': {
                    'description': 'Successful operation',
                    'content': {
                        ('Array' if many else 'Object'): {
                            'schema': schema(many=many, exclude=exclude or [])
                        }
                    }
                }
            }
        )
        @wraps(f)
        def decorated_function(*args, **kwargs):
            snake_case_kwargs = {**kwargs}
            if only := snake_case_kwargs.get('only'):
                snake_case_kwargs['only'] = [
                    to_snake_case(field) for field in only]

            only = snake_case_kwargs.get('only')
            valid_schema = schema(
                only=only if isinstance(
                    only, list) and '*' not in only else None,
                many=many,
                exclude=exclude or []
            )

            @marshal_with(valid_schema)
            def marshalled_function():
                return f(*args, **snake_case_kwargs)

            return marshalled_function()
        return decorated_function
    return decorator
