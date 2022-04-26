import midtransclient
from audioop import cross
from cmath import log
from itertools import groupby
import requests
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
    data, row_headers = db.getUserAndAddress(current_user_email)
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
        # sorting berdasarkan email
        cart_item.sort(key=lambda x: x["userEmail"])
        # tambahkan total harga di tiap data
        for item in cart_item:
            total_harga = item["harga"] * item["quantity"]
            item["totalHarga"] = total_harga

        cartAll = []

        for key, value in groupby(cart_item, key=itemgetter("userEmail")):
            data, row_headers = db.getUserAndAddress(key)
            address = toJsonFormat(data, row_headers)
            checkoutItem = {
                "email": key,
                "namaPenjual": address[0]["nama"],
                "alamat": address[0]["alamat"],
                "idKota": address[0]["idKota"],
                "kota": address[0]["kota"],
                "idprovinsi": address[0]["idProvinsi"],
                "provinsi": address[0]["provinsi"],
                "produk": [],
            }

            print(key)
            for k in value:
                checkoutItem["produk"].append(k)
            cartAll.append(checkoutItem)
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

@cross_origin
@app.route("/ongkir", methods=["GET"])
def ongkir():
    destination = request.args.get("destination", None)
    origin = request.args.get("origin", None)
    courier = request.args.get("courier", None)
    weight = request.args.get("weight", None)
    api_key = request.headers["key"]
    print(destination, origin, courier, weight, api_key)
    headers = {"Content-Type": "application/x-www-form-urlencoded", "key": api_key}
    data = {
        "origin": origin,
        "destination": destination,
        "courier": courier,
        "weight": weight,
    }

    res = requests.post("https://api.rajaongkir.com/starter/cost", headers=headers, data=data)
    ongkir = res.json()
    print(ongkir)

    return jsonify(ongkir)

@cross_origin
@app.route("/buatorder", methods=["POST", "GET"])
@jwt_required()
def buatorder():

    # TODO : PERTAMA, Terima data dari frontend => nama bank, totalHarga
    # TODO : masukkin kedua data tersebut ke tabel order, setelah itu kita perlu
    # data order id, nama bank, sama total harga buat request ke midtrans
    # TODO :  pilih param sesuai nama bank, 'bri' maka param nya pilih yang bri ('bri','mandiri','bca','permata','bni')
    # TODO : request ke midtrans pake method charge param, dengan param nya yg sudah dipilih tadi
    # data response akan seperti ini

    # USE CASE : BNI
    # USE CASE : BNI -> user bayar pake va_number, jadi simpen aja va_numbernya
    # virtual_account = response["va_numbers"][0]['va_number']
    contoh_response_bni = {
        "currency": "IDR",
        "fraud_status": "accept",
        "gross_amount": "44000.00",
        "merchant_id": "G914563348",
        "order_id": "order-109",
        "payment_type": "bank_transfer",
        "status_code": "201",
        "status_message": "Success, Bank Transfer transaction is created",
        "transaction_id": "d2592167-f317-4102-8ffa-99e0ec95e6c5",
        "transaction_status": "pending",
        "transaction_time": "2022-04-26 07:56:49",
        "va_numbers": [{"bank": "bni", "va_number": "9886334840985088"}],
    }

    # USE CASE : BRI
    # USE CASE : BRI -> user bayar pake va_number, jadi simpen aja va_numbernya
    # virtual_account = response["va_numbers"][0]['va_number']
    contoh_response_bri = {
        "currency": "IDR",
        "fraud_status": "accept",
        "gross_amount": "44000.00",
        "merchant_id": "G914563348",
        "order_id": "order-109",
        "payment_type": "bank_transfer",
        "status_code": "201",
        "status_message": "Success, Bank Transfer transaction is created",
        "transaction_id": "decbbda7-7b94-46b8-b892-3aa738113c88",
        "transaction_status": "pending",
        "transaction_time": "2022-04-26 08:28:01",
        "va_numbers": [{"bank": "bri", "va_number": "633489584538092100"}],
    }
    # USE CASE : BCA
    # virtual_account = response["va_numbers"][0]['va_number']
    contoh_response_bca = {
        "currency": "IDR",
        "fraud_status": "accept",
        "gross_amount": "44000.00",
        "merchant_id": "G914563348",
        "order_id": "order-109",
        "payment_type": "bank_transfer",
        "status_code": "201",
        "status_message": "Success, Bank Transfer transaction is created",
        "transaction_id": "798d936b-2715-4460-b051-aa98768e48bd",
        "transaction_status": "pending",
        "transaction_time": "2022-04-26 08:43:23",
        "va_numbers": [{"bank": "bca", "va_number": "63348989640"}],
    }
    
    # TODO : masukkin Virtual acc number ke tabel order

    # OVERVIEW
    # -- terima data nama bank dan total harga dari frontend
    # -- charge ke api midtrans dan dapetin VA/virtual account number
    # -- simpen data tersebut ke tabel order (order_id, user email, bank_payment, total_harga, virtual_account)
    # -- buat route untuk ngambil data dari tabel order berdasarkan email user

    # ----------<start daftar param>----------------------

    bca = {
        "payment_type": "bank_transfer",
        "transaction_details": {"order_id": '33', "gross_amount": 12000},
        "bank_transfer": {"bank": "bca"},
    }

    bni = {
        "payment_type": "bank_transfer",
        "transaction_details": {"order_id": '22', "gross_amount": 12000},
        "bank_transfer": {"bank": "bni"},
    }

    bri = {
        "payment_type": "bank_transfer",
        "transaction_details": {"order_id": '22', "gross_amount": 12000},
        "bank_transfer": {"bank": "bri"},
    }

    # -----------<end daftar param>-------------------

    param = {}
    current_user_email = get_jwt_identity()
    bank = request.json.get('bank', None)
    totalHarga = request.json.get('totalharga', None)

    data, row_headers = db.createOrder(current_user_email,totalHarga,bank,"bank")
    OrderID = toJsonFormat(data, row_headers)
    id=OrderID[0]['LAST_INSERT_ID()']

    if bank == "bri":

        param = {
        "payment_type": "bank_transfer",
        "transaction_details": {"order_id": id, "gross_amount": totalHarga},
        "bank_transfer": {"bank": "bri"},}

    elif bank == "bni":

        param = {
        "payment_type": "bank_transfer",
        "transaction_details": {"order_id": id, "gross_amount": totalHarga},
        "bank_transfer": {"bank": "bni"},}

    elif bank == "bca":

        param = {
        "payment_type": "bank_transfer",
        "transaction_details": {"order_id": id, "gross_amount": totalHarga},
        "bank_transfer": {"bank": "bca"},}

    else:
        return jsonify({"msg": "error, unknown bank name"})

    chargeResponse = core_api.charge(param)
    vanumber=chargeResponse['va_numbers'][0]['va_number']
    status=chargeResponse['transaction_status']
    db.inputOrder(id,vanumber,status)

    return jsonify(chargeResponse)


contoh_response_status = {
    "currency": "IDR",
    "fraud_status": "accept",
    "gross_amount": "44000.00",
    "merchant_id": "G914563348",
    "order_id": "order-109",
    "payment_amounts": [],
    "payment_type": "bank_transfer",
    "settlement_time": "2022-04-26 15:53:52",
    "signature_key": "ff48367ac96dee4b8ab27dbe35e105c5699d6b4a42d34e18c00ed1c51bfabf1390c4ca57202c30e51a2782f9c54ea29b81ca453322a30b934616cd3018c167be",
    "status_code": "200",
    "status_message": "Success, transaction is found",
    "transaction_id": "ad9590ae-5679-4ab5-ba12-4366f63f52f7",
    "transaction_status": "settlement",
    "transaction_time": "2022-04-26 15:53:00",
    "va_numbers": [{"bank": "bca", "va_number": "63348587314"}],
}

@cross_origin
@app.route("/Order", methods=["GET"])
@jwt_required()
def Order():
    current_user_email = get_jwt_identity()
    data, row_headers=db.getOrder(current_user_email)
    orders = toJsonFormat(data, row_headers)
    return jsonify(orders)

@cross_origin
@app.route("/cekstatuspembayaran", methods=["POST","GET","PATCH"])
def cekPaymentStatus():
    #Authorization di cek dulu sesuai password midtrans

    orderID = request.json.get('orderID', None)
    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Basic U0ItTWlkLXNlcnZlci1XYzliVURvN0x2dk54YnY1Z1ZXejQyZ3U6",
    }

    link=("https://api.sandbox.midtrans.com/v2/%s/status" % orderID)
    res = requests.get(link, headers=headers)
    ongkir = res.json()
    status=ongkir['transaction_status']
    db.updateStatus(orderID,status)
    

if __name__ == "__main__":
    app.run()

@cross_origin
@app.errorhandler(404)
def page_not_found(error):
    return error

core_api = midtransclient.CoreApi(
    is_production=False,
    server_key="SB-Mid-server-Wc9bUDo7LvvNxbv5gVWz42gu",
    client_key="SB-Mid-client-ckck2z4FgZHRe2NT"
)
