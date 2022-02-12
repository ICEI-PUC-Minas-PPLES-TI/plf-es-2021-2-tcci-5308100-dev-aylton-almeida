from dotenv import load_dotenv

from src.app import PATH, create_app

load_dotenv()

app = create_app('testing')
base_path = PATH
