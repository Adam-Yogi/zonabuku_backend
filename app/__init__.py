from flask import Flask
from flask_mysqldb import MySQL
from flask_jwt_extended import JWTManager
import os
from dotenv import load_dotenv
from flask_cors import CORS


app = Flask(__name__)
load_dotenv()
app.config["JWT_SECRET_KEY"] = os.environ.get("JWT_SECRET")
jwt = JWTManager(app)
CORS(app)
mysql = MySQL()

app.config.from_pyfile("../config/database.cfg")
mysql.init_app(app)

from app import routes
