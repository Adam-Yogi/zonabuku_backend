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
        cur.execute("SELECT * FROM products WHERE productID = %s", (id))
        row_headers = [x[0] for x in cur.description]  
        rv = cur.fetchall()
        cur.close()
        return rv, row_headers

    def getUser(self, email):
        cur = self.connect()
        cur.execute("SELECT * FROM user WHERE email = '%s'" % (email))
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