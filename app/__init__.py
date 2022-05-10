from flask import Flask
from flask_mysqldb import MySQL
from flask_jwt_extended import JWTManager
import os
from dotenv import load_dotenv,find_dotenv
from flask_cors import CORS

#pastikan buat .env file di folder app
#isi dengan variabel JWT_SECRET, server_key, dan client_key
app = Flask(__name__)
load_dotenv(find_dotenv())
app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET")

jwt = JWTManager(app)
CORS(app)
mysql = MySQL()

app.config.from_pyfile("../config/database.cfg")
mysql.init_app(app)

from app import routes
