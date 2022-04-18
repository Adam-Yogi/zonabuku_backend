from cmath import log
from itertools import groupby
import json
from operator import itemgetter
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


@cross_origin
@app.route("/addproduct", methods=["POST"])
@jwt_required()
def addProduct():
    try:
        current_user_email = get_jwt_identity()
        namaBuku = request.json.get("nama", None)
        desc = request.json.get("deskripsi", None)
        harga = request.json.get("harga", None)
        jumlah = request.json.get("jumlah", None)
        image = request.json.get("image_product", None)

        db.addProduct(current_user_email, namaBuku, desc, harga, jumlah, image)
        return jsonify({"msg": "insert product success"}), 200
    except:
        return jsonify({'msg':'error while adding product'}),400

@cross_origin
@app.route("/updateproduct", methods=["PATCH"])
@jwt_required()
def updateProduct():
    try:
        current_user_email = get_jwt_identity()
        productID = request.json.get("id", None)
        namaBuku = request.json.get("nama", None)
        desc = request.json.get("deskripsi", None)
        harga = request.json.get("harga", None)
        jumlah = request.json.get("jumlah", None)
        image = request.json.get("image_product", None)

        db.updateProduct(productID,current_user_email, namaBuku, desc, harga, jumlah, image)
    
        return jsonify({"msg": "update product success"}), 200
    except:
        return jsonify({'msg':'error while updating product'}),400

@cross_origin
@app.route("/deleteproduct", methods=["DELETE"])
@jwt_required()
def deleteProduct():
    try:
        productID = request.json.get("id")

        db.deleteProduct(productID)
        response = jsonify({"msg": "delete product success"}), 200
        return response
    except:
        return jsonify({'msg':'error while deleting product'}),400

@cross_origin
@app.route("/addCartItem", methods=["POST"])
@jwt_required()
def addCartItem():
    try:
        current_user_email = get_jwt_identity()
        productID = request.json.get("id", None)
        jumlah = request.json.get("jumlah", None)

        data, row_headers = db.getCartItem(current_user_email)
        booksData = toJsonFormat(data, row_headers)

        if any(d['productID']==productID for d in booksData):
            db.addCartItemQuantity(current_user_email, productID, jumlah)
        else:
            db.addToCart(current_user_email, productID, jumlah)
        
        return jsonify({"msg": "add to cart success"}), 200
    except:
        return jsonify({'msg':'error while adding product'}),400

@cross_origin
@app.route("/getCartItem", methods=["GET"])
@jwt_required()
def getCartItem():
    try:
        current_user_email = get_jwt_identity()
        data, row_headers = db.getCartItem(current_user_email)
        cart_item = toJsonFormat(data, row_headers)
        total_harga = 0
        total_quantity = 0
        header_name = ["data", "totalHarga", "totalQuantity"]
        for item in cart_item:
            total_harga += item["harga"] * item["quantity"]
            total_quantity += item["quantity"]
        data_list = [cart_item, total_harga, total_quantity]
        # bikin dictionary dari dua list header_name:data_list
        res = {header_name[i]: data_list[i] for i in range(len(data_list))}

        return jsonify(res), 200
    except:
        return jsonify({"msg": "error while getting cart item"}), 400

@cross_origin
@app.route("/delCartItem", methods=["DELETE"])
@jwt_required()
def delCartItem():
    try:
        current_user_email = get_jwt_identity()
        productID = request.json.get("id", None)
        jumlah = request.json.get("jumlah", None)

        db.deleteCartItem(current_user_email,productID,jumlah)
        response = jsonify({"msg": "delete cart item success"}), 200
        return response
    except:
        return jsonify({'msg':'error while deleting cart item'}),400

@cross_origin
@app.route("/checkout", methods=["GET"])
@jwt_required()
def checkout():
    try:
        current_user_email = get_jwt_identity()
        data, row_headers = db.getCartItem(current_user_email)
        cart_item = toJsonFormat(data, row_headers)
        total_harga = 0
        #sorting berdasarkan email
        cart_item.sort(key=lambda x:x["userEmail"])
        #tambahkan total harga di tiap data
        for item in cart_item:
            total_harga = item["harga"] * item["quantity"]
            item["totalHarga"] = total_harga
        
        cartAll = []
        #Buat list of list. Dalam list ada dictionary. Dictionary pertama isi data address. 
        #Dictionary selanjutnya berisi data buku yang dari penjual dengan email yang sama 
        for key, value in groupby(cart_item, key=itemgetter('userEmail')):
            data, row_headers = db.getAddress(current_user_email)
            address = toJsonFormat(data, row_headers)
            addressData =  {"email":key,"alamat":address[0]["alamat"],"idKota":address[0]["idKota"],
                            "kota":address[0]["kota"],"idprovinsi":address[0]["idProvinsi"],"provinsi":address[0]["provinsi"]}
            cartGrouped = []
            cartGrouped.append(addressData)
            print(key)
            for k in value:
                cartGrouped.append(k)
            cartAll.append(cartGrouped)
        
        return jsonify(cartAll)
    except:
        return jsonify({"msg": "error while getting cart item"}), 400

@cross_origin
@app.route('/kurir', methods=["GET"])
def getKurir():
    try:
        kurir, row_headers = db.getKurir()
        kurir_data = toJsonFormat(kurir, row_headers)
        return jsonify(kurir_data)
    except:
        return jsonify({'code':'400', 'msg':'error to getting kurir data'})

@cross_origin
@app.route('/updateaddress', methods=['PATCH'])
@jwt_required()
def updateAddress():
    try:
        current_user_email = get_jwt_identity()
        alamat = request.json.get('alamat', None)
        idKota = request.json.get('idKota', None)
        kota = request.json.get('kota', None)
        idProvinsi = request.json.get('idProvinsi', None)
        provinsi = request.json.get('provinsi', None)
        kodepos = request.json.get('kodepos', None)
        db.updateAddress(current_user_email, alamat, idKota, kota, idProvinsi, provinsi, kodepos)
        return jsonify({'msg':'update address succeed'}), 200
    except:
        return jsonify({'msg':'error while updating'}), 400

if __name__ == "__main__":
    app.run()

@cross_origin
@app.errorhandler(404)
def page_not_found(error):
    return error

