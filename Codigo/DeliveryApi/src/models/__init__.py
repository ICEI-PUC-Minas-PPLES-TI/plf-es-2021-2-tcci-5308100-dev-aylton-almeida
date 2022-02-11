from os.path import dirname as _dirname

from dotenv import load_dotenv as _load_dotenv
from flask_sqlalchemy import SQLAlchemy as _SQLAlchemy
from src.utils.ModuleAll import get_module_all as _get_module_all

_load_dotenv()

db = _SQLAlchemy()


__all__ = _get_module_all(_dirname(__file__), '*Model.py')
