from cmath import log
import json
from flask import jsonify, request
from app import app
from app.database import Database
from flask_jwt_extended import create_access_token
from flask_jwt_extended import get_jwt_identity
from flask_jwt_extended import jwt_required
from flask_cors import cross_origin


db = Database()


@cross_origin
@app.route("/")
@app.route("/books")
def home():
    data, row_headers = db.getNew()
    booksData = toJsonFormat(data, row_headers)
    return jsonify(booksData)


@cross_origin
@app.route("/details")
def detail():
    id = request.args.get("id")
    data, row_headers = db.getDetail(id)
    booksData = toJsonFormat(data, row_headers)
    return jsonify(booksData)

@cross_origin
@app.route("/login", methods=["POST"])
def create_token():
    email = request.json.get("email", None)
    password = request.json.get("password", None)
    user, row_headers = db.getUser(email)
    userData = user[0]
    userPassword = userData[5]
    if userData is None:
        return jsonify({"error": "Unauthorized"}), 401
    if not (password == userPassword):
        return jsonify({"error": "Unauthorized"}), 401

    access_token = create_access_token(identity=email)
    return jsonify(access_token=access_token)


@cross_origin
@app.route("/register", methods=["POST"])
def register():
    email = request.json.get("email", None)
    password = request.json.get("password", None)
    no_telp = request.json.get("no_telp", None)
    last_name = request.json.get("last_name", None)
    first_name = request.json.get("first_name", None)
    print(email, password, last_name, first_name, no_telp)
    user, row_headers = db.getUser(email)
    print(user)
    print(len(user))
    if len(user) != 0:
        return jsonify({"error": "user exist"}), 400
    db.newUser(email, password, no_telp, first_name, last_name)
    return jsonify({"msg": "registration success"}), 200


def toJsonFormat(data, row_headers):
    json_data = []
    for result in data:
        json_data.append(dict(zip(row_headers, result)))
    return json_data


@cross_origin
@app.route("/getuser", methods=["GET"])
@jwt_required()
def fetchUser():
    current_user_email = get_jwt_identity()
    data, row_headers = db.getUser(current_user_email)
    user_json = toJsonFormat(data, row_headers)
    return jsonify(user_json)

@cross_origin
@app.route("/updateuser", methods=["PATCH"])
@jwt_required()
def updateUser():
    try:
        current_user_email = get_jwt_identity()
        password = request.json.get("password", None)
        no_telp = request.json.get("no_telp", None)
        last_name = request.json.get("last_name", None)
        first_name = request.json.get("first_name", None)
        db.updateUser(current_user_email,password,no_telp,first_name,last_name)
        return jsonify({'msg':'update succeed'}),200
    except:
        print("gagal")
        return jsonify({'msg':'error while updating'}),400

    
@cross_origin
@app.route("/updateprofilepic", methods=["PATCH"])
@jwt_required()
def updateProfilePic():
    try:
        current_user_email = get_jwt_identity()
        profile_pic=request.json.get('profile_pic',None)
        print(profile_pic,current_user_email)
        db.updateUserProfilePic(current_user_email,profile_pic)
        return jsonify({'msg':'update succeed'}),200
    except:
        return jsonify({'msg':'error while updating'}),400
    
@cross_origin
@app.route("/userproduct")
@jwt_required()
def userProduct():
    try:
        current_user_email = get_jwt_identity()
        data, row_headers = db.getUserProduct(current_user_email)
        booksData = toJsonFormat(data, row_headers)
        return jsonify(booksData),200
    except:
        return jsonify({'msg':'error while fetching userproduct'}),400

#belum jadi
@cross_origin
@app.route("/addproduct", methods=["POST"])
@jwt_required()
def addProduct():
    current_user_email = get_jwt_identity()
    namaBuku = request.json.get("nama", None)
    desc = request.json.get("deskripsi", None)
    harga = request.json.get("harga", None)
    jumlah = request.json.get("jumlah", None)
    image = request.json.get("gambar", None)
    desc = request.json.get("deskripsi", None)
    data, row_headers = db.getUserProduct(current_user_email)
    booksData = toJsonFormat(data, row_headers)
    return jsonify(booksData)

if __name__ == "__main__":
    app.run()

@cross_origin
@app.errorhandler(404)
def page_not_found(error):
    return error
