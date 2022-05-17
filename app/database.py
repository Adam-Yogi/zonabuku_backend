from cmath import log
from app import mysql


class Database:
    def __init__(self) -> None:
        pass

    def connect(self):
        return mysql.connection.cursor()

    def getNew(self):
        cur = self.connect()
        cur.execute("SELECT * FROM products ORDER BY tgl_input DESC LIMIT 10")
        row_headers = [x[0] for x in cur.description]  
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def getDetail(self, id):
        cur = self.connect()
        cur.execute("CALL tampil_detailprodukuser(%s)", [id])
        row_headers = [x[0] for x in cur.description]  
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def getUserAndAddress(self, email):
        cur = self.connect()
        cur.execute("CALL getuserprofile(%s);",[email])
        row_headers = [x[0] for x in cur.description] 
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def getUserFullAddress(self, email):
        cur = self.connect()
        cur.execute('SELECT CONCAT(user_address.alamat," , ", user_address.kota, " , ", user_address.provinsi) AS "alamat" FROM user_address WHERE userEmail=(%s);'
        ,[email])
        row_headers = [x[0] for x in cur.description] 
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def getUser(self, email):
        cur = self.connect()
        cur.execute("SELECT * FROM user WHERE email = %s", [email])
        row_headers = [x[0] for x in cur.description] 
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def newUser(self, email, password, no_telp, first_name, last_name):
        cur = self.connect()
        cur.execute(
            "INSERT INTO user (first_name, last_name, no_telp, email, password) VALUES (%s,%s,%s,%s,%s)",
            (first_name, last_name, no_telp, email, password),
        )
        mysql.connection.commit()
        cur.close()

    def updateUser(self,email, password, no_telp, first_name, last_name):
        cur = self.connect()
        cur.execute(
            "UPDATE user SET first_name = %s, last_name = %s, no_telp= %s, password=%s WHERE email=%s;",
            (first_name, last_name, no_telp, password,email),
        )
        mysql.connection.commit()
        cur.close()

    def updateUserProfilePic(self,email,profile_pic):
        cur = self.connect()
        cur.execute(
            "UPDATE user SET profile_pic= %s WHERE email=%s;",
            (profile_pic,email),
        )
        mysql.connection.commit()
        cur.close()

    def getUserProduct(self,email):
        cur = self.connect()
        cur.execute("CALL tampil_produkListUser(%s);",[email]
        )
        row_headers = [x[0] for x in cur.description]  
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def addProduct(self, email, nama, deskripsi, harga, jumlah,image):
        cur = self.connect()
        cur.execute(
            "CALL addProduct(%s,%s,%s,%s,%s,%s,CURRENT_TIMESTAMP());",
            (email, nama, deskripsi, harga, jumlah, image)
        )
        mysql.connection.commit()
        cur.close()

    def updateProduct(self,productID,current_user_email, namaBuku, desc, harga, jumlah, image):
        cur = self.connect()
        cur.execute(
            "CALL changeProduct(%s,%s,%s,%s,%s,%s,%s);",
            (productID, current_user_email, namaBuku, desc, harga,jumlah, image)
        )
        mysql.connection.commit()
        cur.close()

    def deleteProduct(self,productID):
        cur = self.connect()
        cur.execute(
            "CALL delproduct(%s);",
            [productID]
        )
        mysql.connection.commit()
        cur.close()

    def addToCart(self, email, productID, jumlah):
        cur = self.connect()
        cur.execute(
            "CALL addToCart(%s,%s,%s);",
            (email, productID, jumlah)
        )
        mysql.connection.commit()
        cur.close()

    def addCartItemQuantity(self, email, productID, jumlah):
        cur = self.connect()
        cur.execute(
            "CALL addItemQuantity(%s,%s,%s);",
            (email, productID, jumlah)
        )
        mysql.connection.commit()
        cur.close()

    def getCartItem(self, email):
        cur = self.connect()
        cur.execute(
            "CALL getCartItem(%s);",
            [email]
        )
        row_headers = [x[0] for x in cur.description]  
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def deleteCartItem(self, email, productID, jumlah):
        cur = self.connect()
        cur.execute(
            "CALL delCartItem(%s,%s,%s);",
            (email, productID, jumlah)
        )
        mysql.connection.commit()
        cur.close()

    def getAddress(self, email):
        cur = self.connect()
        cur.execute("SELECT * FROM user_address WHERE userEmail = %s", [email])
        row_headers = [x[0] for x in cur.description] 
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def getKurir(self):
        cur = self.connect()
        cur.execute("SELECT * FROM kurir")
        row_headers = [x[0] for x in cur.description]
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def updateAddress(self, email, alamat, idKota, kota, idProvinsi, provinsi, kodepos):
        cur = self.connect()
        cur.execute(
        "UPDATE user_address SET alamat= %s, idKota= %s, kota= %s, idProvinsi= %s, provinsi= %s, kodepos= %s WHERE userEmail= %s;",
        (alamat, idKota, kota, idProvinsi, provinsi, kodepos, email),
        )

        mysql.connection.commit()
        cur.close()

    def createOrder(self, email, totalHarga, bank, paymentType):
        cur = self.connect()
        cur.execute(
        "INSERT INTO orders (custEmail, totalHarga, bank, paymentType) VALUES (%s,%s,%s,%s);",
        (email, totalHarga, bank, paymentType))
        mysql.connection.commit()
        cur.execute("SELECT LAST_INSERT_ID();")
        row_headers = [x[0] for x in cur.description]
        rv = cur.fetchall()
        cur.close()
        return rv,row_headers

    def sellerOrderCartItem(self,email):
        cur = self.connect()
        cur.execute("CALL showOrder(%s);",[email])
        row_headers = [x[0] for x in cur.description]
        rv = cur.fetchall()
        cur.close()
        return rv,row_headers

    def moveCartToOrder(self, email,orderID,productID,sellerEmail,namaProduk,quantity,alamat,revenue):
        cur = self.connect()

        cur.execute(
        "INSERT INTO order_seller (orderID, productID, sellerEmail, nama_produk,quantity,alamat,revenue) VALUES (%s,%s,%s,%s,%s,%s,%s);",
        (orderID, productID, sellerEmail, namaProduk,quantity,alamat,revenue))
        mysql.connection.commit()

        cur.execute("CALL addOrderDetail(%s,%s);", (email,orderID))
        mysql.connection.commit()
        cur.close()

    def cekCartEmpty(self,email):
        cur = self.connect()
        cur.execute("SELECT * FROM cart WHERE userEmail = %s", [email])
        rv = cur.fetchall()
        cur.close()
        return rv

    def inputOrder(self,id,vanumber,status):
        cur = self.connect()
        cur.execute(
        "UPDATE orders SET vanumber=%s, status=%s WHERE OrderID=%s;",
        (vanumber, status,id)
        )
        mysql.connection.commit()

        cur.execute(
        "UPDATE order_seller SET status=%s WHERE orderID=%s;",
        (status,id)
        )
        mysql.connection.commit()
        cur.close()

    def getOrder(self,email,id):
        cur = self.connect()
        #jika select memakai id, email = 0, dan sebaliknya
        #select memakai email
        if id== 0:
            cur.execute("SELECT * FROM orders WHERE custEmail = %s ORDER BY orderID DESC;", [email])
        #select memakai id
        elif email== 0:
            cur.execute("SELECT * FROM orders WHERE orderID = %s ORDER BY orderID DESC;", [id])
        row_headers = [x[0] for x in cur.description] 
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def getSellerOrders(self,email,value):
        cur = self.connect()
        if value==0:
            cur.execute("SELECT * FROM order_seller WHERE sellerEmail = %s ORDER BY orderID DESC;", [email])
        elif value==1:
            cur.execute("SELECT orderID,nama_produk,quantity,revenue FROM order_seller WHERE sellerEmail = %s ORDER BY orderID DESC;", [email])
        row_headers = [x[0] for x in cur.description] 
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def getSellerOrderDetail(self,orderID):
        cur = self.connect()
        cur.execute("SELECT * FROM order_seller WHERE orderID = %s;", [orderID])
        row_headers = [x[0] for x in cur.description] 
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def updateStatus(self,id,status):
        cur = self.connect()
        cur.execute(
        "UPDATE orders SET status=%s WHERE OrderID=%s",
        (status,id)
        )
        mysql.connection.commit()

        cur.execute(
        "UPDATE order_seller SET status=%s WHERE OrderID=%s",
        (status,id)
        )
        mysql.connection.commit()
        
        cur.close()

    def updateRating(self,productID,rate,totalPembeli,totalRating):
        cur = self.connect()
        cur.execute(
        "UPDATE products SET rating=%s,totalPembeli=%s,totalRating=%s WHERE productID=%s",
        (rate,totalPembeli,totalRating,productID)
        )
        mysql.connection.commit()
        cur.close()
    