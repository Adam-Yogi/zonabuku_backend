-- MySQL dump 10.13  Distrib 8.0.26, for macos11 (x86_64)
--
-- Host: localhost    Database: zonabuku
-- ------------------------------------------------------
-- Server version	8.0.27

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cartID` int NOT NULL AUTO_INCREMENT,
  `userEmail` varchar(100) DEFAULT NULL,
  `productID` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`cartID`),
  KEY `userEmail` (`userEmail`),
  KEY `productID` (`productID`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`userEmail`) REFERENCES `user` (`email`),
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `products` (`productID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (8,'kura@gmail.com',12,4),(10,'kura@gmail.com',6,1),(11,'kura@gmail.com',11,2),(12,'kura@gmail.com',7,1),(13,'aadam@gmail.com',12,2),(14,'aadam@gmail.com',6,1),(15,'aadam@gmail.com',8,1),(16,'arsya@gmail.com',6,1),(17,'arsya@gmail.com',1,2),(18,'arsya@gmail.com',9,1),(19,'doge@gmail.com',12,1);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kurir`
--

DROP TABLE IF EXISTS `kurir`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kurir` (
  `kurirID` int NOT NULL AUTO_INCREMENT,
  `namaKurir` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`kurirID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kurir`
--

LOCK TABLES `kurir` WRITE;
/*!40000 ALTER TABLE `kurir` DISABLE KEYS */;
/*!40000 ALTER TABLE `kurir` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `productID` int NOT NULL AUTO_INCREMENT,
  `userEmail` varchar(100) DEFAULT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `deskripsi` text,
  `harga` decimal(8,2) DEFAULT '0.00',
  `jumlah` int DEFAULT '0',
  `image_product` varchar(100) DEFAULT NULL,
  `tgl_input` datetime DEFAULT NULL,
  PRIMARY KEY (`productID`),
  KEY `userEmail` (`userEmail`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`userEmail`) REFERENCES `user` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'aadam@gmail.com','Laskar Pelangi','\"Bangunan itu nyaris rubuh. Dindingnya miring bersangga sebalok kayu. Atapnya bocor di mana-mana. Tetapi, berpasang-pasang mata mungil menatap penuh harap. Hendak ke mana lagikah mereka harus bersekolah selain tempat itu? Tak peduli seberat apa pun kondisi sekolah itu, sepuluh anak dari keluarga miskin itu tetap bergeming. Di dada mereka, telah menggumpal tekad untuk maju.\" Laskar Pelangi, kisah perjuangan anak-anak untuk mendapatkan ilmu. Diceritakan dengan lucu dan menggelitik, novel ini menjadi novel terlaris di Indonesia. Inspiratif dan layak dimiliki siapa saja yang mencintai pendidikan dan keajaiban masa kanak-kanak.',70000.00,1,'https://i.ibb.co/FDg4rbg/laskarpelangi.jpg','2022-03-07 17:23:27'),(2,'aadam@gmail.com','Perahu Kertas','Namanya Kugy. Mungil, pengkhayal, dan berantakan. Dari benaknya, mengalir untaian dongeng indah. Keenan belum pernah bertemu manusia seaneh itu ....\r\nNamanya Keenan. Cerdas, artistik, dan penuh kejutan. Dari tangannya, mewujud lukisan-lukisan magis. Kugy belum pernah bertemu manusia seajaib itu ....\r\nDan kini mereka berhadapan di antara hamparan misteri dan rintangan. Akankah dongeng dan lukisan itu bersatu? Akankah hati dan impian mereka bertemu?',69000.00,2,'https://i.ibb.co/M19pvC7/perahukertas.jpg','2022-03-07 17:37:48'),(3,'aadam@gmail.com','National Geographic Indonesia Edisi Januari 2022','Pagebluk membuat kita bagai menaiki roller coaster: Vaksin baru mendorong optimisme. Namun kesalahan informasi dan kekurangan persediaan, mengganggu imunisasi. Virus pun tetap mengancam. 54 - Perselisihan budaya, politik, tanah, dan lainnya, berkobar di seluruh dunia—termasuk di AS, yang menghadapi serangan terhadap demokrasinya dan terus bergulat degan warisan rasismenya. 68 - Dalam tahun yangpenuh tantangan, terdapat pencapaian yang menggembirakan dalam pelestarian harta alam dan budaya. Upaya-upaya kita mencerminkan harapan serta rasa kemanusiaan kita.',59000.00,0,'https://i.ibb.co/5LfSK7m/nationalgeographicjan22.jpg','2022-03-07 17:37:48'),(4,'doge@gmail.com','Bobo Edisi 47 2022','by Majalah Bobo',15000.00,10,'https://i.ibb.co/G0Qg7GT/bobo47.jpg','2022-03-07 17:37:48'),(6,'doge@gmail.com','Diet Ketogenik: Panduan & Resep Sehat','Diet golongan darah, diet Food Combining, diet mayo, adalah beberapa program diet yang pernah menjadi tren di Indonesia. Kini diet yang semakin populer adalah diet Ketogenik atau diet Keto. Manfaatnya antara lain dipercaya dapat menurunkan berat badan secara signifikan. Buku ini selain beri panduan untuk memulai diet keto dengan benar juga dilengkapi dengan lebih dari 90 resep sehat dan lezat terdiri dari aneka snack, lauk, minuman, dan dessert yang disusun sedemikian rupa oleh penulis agar para pelaku diet Keto dapat menikmati pengalaman diet yang menyenangkan.',141900.00,29,'https://i.ibb.co/x1JVGkn/dietketogenik.jpg','2022-03-07 19:16:47'),(7,'aadam@gmail.com','Assassination Classroom 21','Jalan apakah yang ditempuh oleh Nagisa dan teman-temannya setelah lulus SMP? Temukan jawabannya dalam buku terakhir Assassination Classroom yang penuh keharuan ini! Buku ini juga memuat kisah kehidupan pribadi Pak Koro saat menikmati waktunya sebagai orang dewasa. Temukan juga cerita lepas Tokyo Depart War di akhir buku ini!',21250.00,0,'https://i.ibb.co/RTjT8KB/ASSASSINATIONCLASSROOM21.jpg','2022-03-07 19:16:47'),(8,'aadam@gmail.com','Pulang','Ketika gerakan mahasiswa berkecamuk di Paris, Dimas Suryo, seorang eksil politik Indonesia, bertemu Vivienne Deveraux, mahasiswa yang ikut demonstrasi melawan pemerintahan Prancis. Pada saat yang sama, Dimas menerima kabar dari Jakarta; Hananto Prawiro, sahabatnya, ditangkap tentara dan dinyatakan tewas. Di tengah kesibukan mengelola Restoran Tanah Air di Paris, Dimas bersama tiga kawannya-Nugroho, Tjai, dan Risjaf—terus-menerus dikejar rasa bersalah karena kawan-kawannya di Indonesia dikejar, ditembak, atau menghikang begitu saja dalam perburuan peristiwa 30 September. Apalagi dia tak bisa melupakan Surti Anandari—isteri Hananto—yang bersama ketiga anaknya berbulan-bulan diinterogasi tentara. Jakarta, Mei 1998. Lintang Utara, puteri Dimas dari perkawinan dengan Vivienne Deveraux, akhirnya berhasil memperoleh visa masuk Indonesia untuk merekam pengalaman keluarga korban tragedi 30 September sebagai tugas akhir kuliahnya. Apa yang terkuak oleh Lintang bukan sekedar masa lalu ayahnya dengan Surti Anandari, tetapi juga bagaimana sejarah paling berdarah di negerinya mempunyai kaitan dengan Ayah dan kawan-kawan ayahnya. Bersama Sedara Alam, putera Hananto, Lintang menjadi saksi mata apa yang kemudian menjadi kerusuhan terbesar dalam sejarah Indonesia: kerusuhan Mei 1998 dan jatuhnya Presiden Indonesia yang sudah berkuasa selama 32 tahun. Pulang adalah sebuah drama keluarga, persahabatan, cinta, dan pengkhianatan berlatar belakang tiga peristiwa bersejarah: Indonesia 30 September 1965, Prancis Mei 1968, dan Indonesia Mei 1998.',102000.00,0,'https://i.ibb.co/mNfMcTN/pulang.jpg','2022-03-07 19:16:47'),(9,'exampleEmail@gmail.com','The Comfort Book: Buku yang Membuat Kita Nyaman','Banyak pelajaran hidup yang paling jelas dan paling menghibur kita pelajari justru pada saat kita berada di titik terendah. Kita baru memikirkan makanan saat kita lapar dan baru memikirkan rakit penyelamat saat kita terlempar ke laut. Buku ini adalah kumpulan penghiburan yang dipelajari di masa-masa sulit—serta saran untuk membuat hari-hari buruk kita menjadi lebih baik. Mengacu pada pepatah, memoar, dan kehidupan inspirasional orang lain, buku yang meditatif ini merayakan keajaiban hidup yang selalu berubah. lnilah buku yang bisa kita baca selagi kita membutuhkan kebijaksanaan seorang teman, kenyamanan sebuah pelukan, atau pengingat bahwa harapan datang dari tempat-tempat yang tidak terduga. Tiada yang lebih kuat daripada harapan kecil yang tak akan menyerah.',79000.00,9,'https://i.ibb.co/QP9c8kQ/thecomfortbook.jpg','2022-03-07 19:16:47'),(10,'exampleEmail@gmail.com','Mantappu Jiwa *Buku Latihan Soal','Kata orang, selama masih hidup, manusia akan terus menghadapi masalah demi masalah. Dan itulah yang akan kuceritakan dalam buku ini, yaitu bagaimana aku menghadapi setiap persoalan di dalam hidupku. Dimulai dari aku yang lahir dekat dengan hari meletusnya kerusuhan di tahun 1998, bagaimana keluargaku berusaha menyekolahkanku dengan kondisi ekonomi yang terbatas, sampai pada akhirnya aku berhasil mendapatkan beasiswa penuh S1 di Jepang. Manusia tidak akan pernah lepas dari masalah kehidupan, betul. Tapi buku ini tidak hanya berisi cerita sedih dan keluhan ini-itu. Ini adalah catatan perjuanganku sebagai Jerome Polin Sijabat, pelajar Indonesia di Jepang yang iseng memulai petualangan di YouTube lewat channel Nihongo Mantappu. Yuk, naik roller coaster di kehidupanku yang penuh dengan kalkulasi seperti matematika. It may not gonna be super fun, but I promise it would worth the ride.',86900.00,10,'https://i.ibb.co/0J9hCry/mantappujiwa.jpg','2022-03-07 19:16:47'),(11,'doge@gmail.com','The Devil All of Time','Willard Russel, mantan tentara saksi kekejaman perang, sudah menumpahkan banyak darah tapi tak sanggup menyelamatkan istrinya dari kematian. Carl dan Sandy Henderson, pasangan pembunuh berantai yang setiap musim panas mengincar para korbannya di jalanan. Roy dan Theodore, pengkhotbah keliling yang melarikan diri dan dijadikan buronan. Di dunia mereka yang menggila, sesosok pemuda terjebak di tengahnya, dipaksa untuk mengerti bahwa kebaikan dan kejahatan sesungguhnya memiliki batas yang fana.',85000.00,30,'https://i.ibb.co/sjW9M25/thedevilalloftime.jpg','2022-03-07 19:16:47'),(12,'aadam@gmail.com','Laut Bercerita','Di sebuah senja, di sebuah rumah susun di Jakarta, mahasiswa bernama Biru Laut disergap empat lelaki tak dikenal. Bersama kawan-kawannya, Daniel Tumbuan, Sunu Dyantoro, Alex Perazon, dia dibawa ke sebuah tempat yang tak dikenal. Berbulan-bulan mereka disekap, diinterogasi, dipukul, ditendang, digantung, dan disetrum agar bersedia menjawab satu pertanyaan penting: siapakah yang berdiri di balik gerakan aktivis dan mahasiswa saat itu.',100000.00,0,'https://i.ibb.co/tLCx9xH/lautbercerita.jpg','2022-03-20 12:45:08');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `no_telp` varchar(12) DEFAULT NULL,
  `tgl_lahir` date DEFAULT NULL,
  `profile_pic` varchar(50) DEFAULT NULL,
  `status` enum('online','offline') DEFAULT 'offline',
  PRIMARY KEY (`userID`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,NULL,NULL,'admin',NULL,'admin',NULL,NULL,NULL,'offline'),(2,NULL,NULL,'exampleUsername','exampleEmail@gmail.com','password','0123456789','2022-02-22',NULL,'offline'),(3,'NamaDepan','NamaBelakang','usernameSaya','emailSaya','passwordSaya','9876543210','2000-04-02',NULL,'offline'),(10,'doge','guguk',NULL,'doge@gmail.com','pass','12345',NULL,'https://i.ibb.co/C1HH4Wj/doge-gmail-com.jpg','offline'),(11,'yogi','adam',NULL,'aadam@gmail.com','1234567','0891',NULL,'https://i.ibb.co/C1HH4Wj/doge-gmail-com.jpg','offline'),(16,'sarah','pd',NULL,'sarahpuspdew@gmail,com','1234567','007',NULL,NULL,'offline'),(17,'kura','kura',NULL,'kura@gmail.com','kura','1234',NULL,NULL,'offline'),(18,'arsya','putra',NULL,'arsya@gmail.com','arsya','08129694532',NULL,NULL,'offline');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_address`
--

DROP TABLE IF EXISTS `user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_address` (
  `userAddressID` int NOT NULL AUTO_INCREMENT,
  `userEmail` varchar(100) DEFAULT NULL,
  `alamat` varchar(200) DEFAULT NULL,
  `idKota` int DEFAULT NULL,
  `kota` varchar(25) DEFAULT NULL,
  `idProvinsi` int DEFAULT NULL,
  `provinsi` varchar(25) DEFAULT NULL,
  `kodepos` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`userAddressID`),
  KEY `userEmail` (`userEmail`),
  CONSTRAINT `user_address_ibfk_1` FOREIGN KEY (`userEmail`) REFERENCES `user` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_address`
--

LOCK TABLES `user_address` WRITE;
/*!40000 ALTER TABLE `user_address` DISABLE KEYS */;
INSERT INTO `user_address` VALUES (1,'exampleEmail@gmail.com','Jl. Raya Abdullah Safe\'i No.1 / Tebet Utara Dalam No.34, RT.5/RW.1, Tebet Tim., Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820\nkota wisata cibubur',153,'Jakarta Selatan',6,'DKI Jakarta','12820'),(2,'emailSaya',NULL,NULL,NULL,NULL,NULL,NULL),(3,'doge@gmail.com','asia',22,'Bandung',9,'Jawa Barat','5252'),(4,'aadam@gmail.com','Alamatku test',28,'Bangka Barat',2,'Bangka Belitung','423425'),(5,'sarahpuspdew@gmail,com',NULL,NULL,NULL,NULL,NULL,NULL),(6,'kura@gmail.com',NULL,NULL,NULL,NULL,NULL,NULL),(7,'arsya@gmail.com','Ancol',155,'Jakarta Utara',6,'DKI Jakarta','423252');
/*!40000 ALTER TABLE `user_address` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-04-20  1:22:53
