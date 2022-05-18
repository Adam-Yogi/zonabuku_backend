-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 18, 2022 at 03:42 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `zonabuku`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addItemQuantity` (IN `in_userEmail` VARCHAR(100), IN `in_productID` INT, IN `in_addQuantity` INT)  BEGIN
UPDATE cart
SET quantity = quantity + in_addQuantity
WHERE productID = in_productID;
UPDATE products
SET jumlah = jumlah - in_addQuantity
WHERE productID = in_productID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addOrder` (IN `in_userEmail` VARCHAR(100))  BEGIN
INSERT INTO orders(custEmail)
VALUES ((SELECT cart.userEmail FROM cart WHERE cart.userEmail = in_userEmail));
INSERT INTO order_detail(orderID, productID, quantity)
VALUES ((SELECT orders.orderID FROM orders WHERE orders.custEmail = in_userEmail),
        (SELECT cart.productID FROM cart WHERE cart.userEmail = in_userEmail),
        (SELECT cart.quantity FROM cart WHERE cart.userEmail = in_userEmail));
DELETE FROM cart WHERE cart.userEmail = in_userEmail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addOrderDetail` (IN `in_userEmail` VARCHAR(100), IN `orderID` INT)  BEGIN
INSERT INTO order_detail(orderID, productID, quantity)
VALUES ((orderID),
        (SELECT cart.productID FROM cart WHERE cart.userEmail = in_userEmail LIMIT 1),
        (SELECT cart.quantity FROM cart WHERE cart.userEmail = in_userEmail LIMIT 1));
DELETE FROM cart WHERE cart.userEmail = in_userEmail LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addProduct` (IN `in_userEmail` VARCHAR(100), IN `in_nama` VARCHAR(100), IN `in_deskripsi` TEXT, IN `in_harga` DECIMAL(8,2), IN `in_jumlah` INT, IN `in_image_product` VARCHAR(100), IN `in_tgl_input` DATETIME)  BEGIN
INSERT INTO products(userEmail, nama, deskripsi, harga, jumlah, image_product, tgl_input) VALUES (in_userEmail, in_nama, in_deskripsi, in_harga, in_jumlah, in_image_product, in_tgl_input);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addToCart` (IN `in_userEmail` VARCHAR(100), IN `in_productID` INT, IN `in_quantity` INT)  BEGIN
INSERT INTO cart(userEmail, productID, quantity)
VALUES (in_userEmail, in_productID, in_quantity);
UPDATE products
SET jumlah = jumlah - in_quantity
WHERE productID = in_productID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `changeProduct` (IN `p_productID` INT, IN `p_userEmail` VARCHAR(100), IN `p_nama` VARCHAR(100), IN `p_deskripsi` TEXT, IN `p_harga` DECIMAL(8,2), IN `p_jumlah` INT, IN `p_image_product` VARCHAR(100))  BEGIN
UPDATE products SET
    nama = IFNULL(p_nama, nama),
    deskripsi = IFNULL(p_deskripsi, deskripsi),
    harga = IFNULL(p_harga, harga),
    jumlah = IFNULL(p_jumlah, jumlah),
    image_product = IFNULL(p_image_product, image_product)
WHERE productID = p_productID AND userEmail = p_userEmail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delCartItem` (IN `in_userEmail` VARCHAR(100), IN `in_productID` INT, IN `in_quantity` INT)  BEGIN
DELETE FROM cart
WHERE cart.userEmail = in_userEmail && cart.productID = in_productID;
UPDATE products
SET jumlah = jumlah + in_quantity
WHERE productID = in_productID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delproduct` (`productID` INT)  BEGIN
DELETE FROM products
WHERE products.productID = productID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCartItem` (IN `in_userEmail` VARCHAR(100))  BEGIN
SELECT products.productID, products.nama, products.harga, products.image_product, cart.quantity, products.userEmail
FROM products
JOIN cart
ON products.productID = cart.productID
WHERE cart.userEmail = in_userEmail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCartPrice` (IN `in_userEmail` VARCHAR(100))  BEGIN
SELECT SUM(cart.quantity * products.harga) as 'total price'
FROM cart
JOIN products ON products.productID = cart.productID
WHERE cart.userEmail = in_userEmail
GROUP BY cart.userEmail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserProfile` (IN `in_userEmail` VARCHAR(100))  BEGIN
SELECT CONCAT(user.first_name," ", user.last_name) AS 'nama', user.userID, user.email, user.no_telp, user.profile_pic, user_address.alamat, user_address.kota, user_address.idKota, user_address.provinsi, user_address.idProvinsi, user_address.kodepos
FROM user
JOIN user_address ON user.email = user_address.userEmail
WHERE user.email = in_userEmail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `showOrder` (IN `in_userEmail` VARCHAR(100))  BEGIN
SELECT cart.productID, cart.quantity, products.nama, products.userEmail,products.harga
FROM products
JOIN cart
ON products.productID = cart.productID
WHERE cart.userEmail = in_userEmail
LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tampil_detailProdukUser` (IN `productID` INT)  BEGIN
SELECT products.productID, products.nama, products.deskripsi, products.harga, products.jumlah, products.image_product, products.tgl_input,products.rating,products.totalPembeli,products.totalRating,CONCAT(user.first_name," ", user.last_name) AS 'owner'
FROM user
JOIN products
ON user.email = products.userEmail
WHERE products.productID = productID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tampil_produkListUser` (IN `userEmail` VARCHAR(100))  BEGIN
SELECT products.productID, products.nama, products.deskripsi, products.harga, products.jumlah, products.image_product, products.tgl_input
FROM products
INNER JOIN user
ON products.userEmail = user.email
WHERE user.email = userEmail;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cartID` int(11) NOT NULL,
  `userEmail` varchar(100) DEFAULT NULL,
  `productID` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `kurir`
--

CREATE TABLE `kurir` (
  `kurirID` int(11) NOT NULL,
  `namaKurir` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `orderID` int(11) NOT NULL,
  `custEmail` varchar(100) NOT NULL,
  `status` varchar(100) DEFAULT NULL,
  `totalHarga` decimal(10,2) DEFAULT NULL,
  `bank` varchar(100) DEFAULT NULL,
  `vanumber` varchar(100) DEFAULT NULL,
  `paymentType` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`orderID`, `custEmail`, `status`, `totalHarga`, `bank`, `vanumber`, `paymentType`) VALUES
(31, 'kura@gmail.com', 'pending', '166900.00', 'bni', '9884678112770659', 'bank'),
(32, 'kura@gmail.com', 'settlement', '94900.00', 'bca', '46781129955', 'bank'),
(38, 'kura@gmail.com', 'pending', '179000.00', 'bca', '46781402983', 'bank'),
(39, 'kura@gmail.com', 'settlement', '219000.00', 'bca', '46781050961', 'bank'),
(40, 'kura@gmail.com', 'pending', '481000.00', 'bca', '46781798890', 'bank');

-- --------------------------------------------------------

--
-- Table structure for table `order_detail`
--

CREATE TABLE `order_detail` (
  `orderID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order_detail`
--

INSERT INTO `order_detail` (`orderID`, `productID`, `quantity`) VALUES
(31, 4, 1),
(31, 6, 1),
(32, 10, 1),
(38, 2, 1),
(38, 9, 1),
(39, 8, 1),
(39, 11, 1),
(40, 3, 1),
(40, 8, 2),
(40, 11, 1),
(40, 12, 1);

-- --------------------------------------------------------

--
-- Table structure for table `order_seller`
--

CREATE TABLE `order_seller` (
  `orderID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  `sellerEmail` varchar(100) DEFAULT NULL,
  `nama_penerima` varchar(100) DEFAULT NULL,
  `nama_produk` varchar(100) DEFAULT NULL,
  `quantity` int(100) DEFAULT NULL,
  `alamat` varchar(200) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `revenue` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order_seller`
--

INSERT INTO `order_seller` (`orderID`, `productID`, `sellerEmail`, `nama_penerima`, `nama_produk`, `quantity`, `alamat`, `status`, `revenue`) VALUES
(38, 2, 'aadam@gmail.com', NULL, 'Perahu Kertas', NULL, 'rumah kura , jakarta barat , dki jakarta', 'pending', '69000.00'),
(38, 9, 'exampleEmail@gmail.com', NULL, 'The Comfort Book: Buku yang Membuat Kita Nyaman', NULL, 'rumah kura , jakarta barat , dki jakarta', 'pending', '79000.00'),
(39, 8, 'aadam@gmail.com', NULL, 'Pulang', NULL, 'rumah kura , jakarta barat , dki jakarta', 'settlement', '102000.00'),
(39, 11, 'doge@gmail.com', NULL, 'The Devil All of Time', NULL, 'rumah kura , jakarta barat , dki jakarta', 'settlement', '85000.00'),
(40, 3, 'aadam@gmail.com', NULL, 'National Geographic Indonesia Edisi Januari 2022', 1, 'rumah kura , jakarta barat , dki jakarta', 'pending', '59000.00'),
(40, 8, 'aadam@gmail.com', NULL, 'Pulang', 2, 'rumah kura , jakarta barat , dki jakarta', 'pending', '204000.00'),
(40, 11, 'doge@gmail.com', NULL, 'The Devil All of Time', 1, 'rumah kura , jakarta barat , dki jakarta', 'pending', '85000.00'),
(40, 12, 'aadam@gmail.com', NULL, 'Laut Bercerita', 1, 'rumah kura , jakarta barat , dki jakarta', 'pending', '100000.00');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `productID` int(11) NOT NULL,
  `userEmail` varchar(100) DEFAULT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga` decimal(8,2) DEFAULT 0.00,
  `jumlah` int(11) DEFAULT 0,
  `image_product` varchar(100) DEFAULT NULL,
  `tgl_input` datetime DEFAULT NULL,
  `rating` decimal(10,1) NOT NULL,
  `totalPembeli` int(100) NOT NULL,
  `totalRating` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`productID`, `userEmail`, `nama`, `deskripsi`, `harga`, `jumlah`, `image_product`, `tgl_input`, `rating`, `totalPembeli`, `totalRating`) VALUES
(1, 'aadam@gmail.com', 'Laskar Pelangi', '\"Bangunan itu nyaris rubuh. Dindingnya miring bersangga sebalok kayu. Atapnya bocor di mana-mana. Tetapi, berpasang-pasang mata mungil menatap penuh harap. Hendak ke mana lagikah mereka harus bersekolah selain tempat itu? Tak peduli seberat apa pun kondisi sekolah itu, sepuluh anak dari keluarga miskin itu tetap bergeming. Di dada mereka, telah menggumpal tekad untuk maju.\" Laskar Pelangi, kisah perjuangan anak-anak untuk mendapatkan ilmu. Diceritakan dengan lucu dan menggelitik, novel ini menjadi novel terlaris di Indonesia. Inspiratif dan layak dimiliki siapa saja yang mencintai pendidikan dan keajaiban masa kanak-kanak.', '70000.00', 21, 'https://i.ibb.co/FDg4rbg/laskarpelangi.jpg', '2022-03-07 17:23:27', '4.5', 2, 9),
(2, 'aadam@gmail.com', 'Perahu Kertas', 'Namanya Kugy. Mungil, pengkhayal, dan berantakan. Dari benaknya, mengalir untaian dongeng indah. Keenan belum pernah bertemu manusia seaneh itu ....\r\nNamanya Keenan. Cerdas, artistik, dan penuh kejutan. Dari tangannya, mewujud lukisan-lukisan magis. Kugy belum pernah bertemu manusia seajaib itu ....\r\nDan kini mereka berhadapan di antara hamparan misteri dan rintangan. Akankah dongeng dan lukisan itu bersatu? Akankah hati dan impian mereka bertemu?', '69000.00', 5, 'https://i.ibb.co/M19pvC7/perahukertas.jpg', '2022-03-07 17:37:48', '0.0', 0, 0),
(3, 'aadam@gmail.com', 'National Geographic Indonesia Edisi Januari 2022', 'Pagebluk membuat kita bagai menaiki roller coaster: Vaksin baru mendorong optimisme. Namun kesalahan informasi dan kekurangan persediaan, mengganggu imunisasi. Virus pun tetap mengancam. 54 - Perselisihan budaya, politik, tanah, dan lainnya, berkobar di seluruh dunia—termasuk di AS, yang menghadapi serangan terhadap demokrasinya dan terus bergulat degan warisan rasismenya. 68 - Dalam tahun yangpenuh tantangan, terdapat pencapaian yang menggembirakan dalam pelestarian harta alam dan budaya. Upaya-upaya kita mencerminkan harapan serta rasa kemanusiaan kita.', '59000.00', 3, 'https://i.ibb.co/5LfSK7m/nationalgeographicjan22.jpg', '2022-03-07 17:37:48', '0.0', 0, 0),
(4, 'doge@gmail.com', 'Bobo Edisi 47 2022', 'by Majalah Bobo', '15000.00', 4, 'https://i.ibb.co/G0Qg7GT/bobo47.jpg', '2022-03-07 17:37:48', '0.0', 0, 0),
(5, 'emailSaya', 'Dokter Smurf', 'Gimana jadinya kalau ada Dokter Smurf di desa smurf? Apalagi ada Smurfin yang jadi perawatnya? Kehebohan mendadak terjadi di tengah-tengah warga smurf. Semua smurf sakit dan semua smurf mau dirawat oleh Smurfin yang cantik. Bahkan Papa Smurf yang mengaku sehat pun, ikut terkapar sakit dan harus dirawat. Berhasilkah Dokter Smurf menyembuhkan semua smurf yang sakit?', '38500.00', 22, 'https://i.ibb.co/FWyVqTG/doktersmurf.jpg', '2022-03-07 17:37:48', '0.0', 0, 0),
(6, 'doge@gmail.com', 'Diet Ketogenik: Panduan & Resep Sehat', 'Diet golongan darah, diet Food Combining, diet mayo, adalah beberapa program diet yang pernah menjadi tren di Indonesia. Kini diet yang semakin populer adalah diet Ketogenik atau diet Keto. Manfaatnya antara lain dipercaya dapat menurunkan berat badan secara signifikan. Buku ini selain beri panduan untuk memulai diet keto dengan benar juga dilengkapi dengan lebih dari 90 resep sehat dan lezat terdiri dari aneka snack, lauk, minuman, dan dessert yang disusun sedemikian rupa oleh penulis agar para pelaku diet Keto dapat menikmati pengalaman diet yang menyenangkan.', '141900.00', 4, 'https://i.ibb.co/x1JVGkn/dietketogenik.jpg', '2022-03-07 19:16:47', '0.0', 0, 0),
(7, 'aadam@gmail.com', 'Assassination Classroom 21', 'Jalan apakah yang ditempuh oleh Nagisa dan teman-temannya setelah lulus SMP? Temukan jawabannya dalam buku terakhir Assassination Classroom yang penuh keharuan ini! Buku ini juga memuat kisah kehidupan pribadi Pak Koro saat menikmati waktunya sebagai orang dewasa. Temukan juga cerita lepas Tokyo Depart War di akhir buku ini!', '21250.00', 4, 'https://i.ibb.co/RTjT8KB/ASSASSINATIONCLASSROOM21.jpg', '2022-03-07 19:16:47', '0.0', 0, 0),
(8, 'aadam@gmail.com', 'Pulang', 'Ketika gerakan mahasiswa berkecamuk di Paris, Dimas Suryo, seorang eksil politik Indonesia, bertemu Vivienne Deveraux, mahasiswa yang ikut demonstrasi melawan pemerintahan Prancis. Pada saat yang sama, Dimas menerima kabar dari Jakarta; Hananto Prawiro, sahabatnya, ditangkap tentara dan dinyatakan tewas. Di tengah kesibukan mengelola Restoran Tanah Air di Paris, Dimas bersama tiga kawannya-Nugroho, Tjai, dan Risjaf—terus-menerus dikejar rasa bersalah karena kawan-kawannya di Indonesia dikejar, ditembak, atau menghikang begitu saja dalam perburuan peristiwa 30 September. Apalagi dia tak bisa melupakan Surti Anandari—isteri Hananto—yang bersama ketiga anaknya berbulan-bulan diinterogasi tentara. Jakarta, Mei 1998. Lintang Utara, puteri Dimas dari perkawinan dengan Vivienne Deveraux, akhirnya berhasil memperoleh visa masuk Indonesia untuk merekam pengalaman keluarga korban tragedi 30 September sebagai tugas akhir kuliahnya. Apa yang terkuak oleh Lintang bukan sekedar masa lalu ayahnya dengan Surti Anandari, tetapi juga bagaimana sejarah paling berdarah di negerinya mempunyai kaitan dengan Ayah dan kawan-kawan ayahnya. Bersama Sedara Alam, putera Hananto, Lintang menjadi saksi mata apa yang kemudian menjadi kerusuhan terbesar dalam sejarah Indonesia: kerusuhan Mei 1998 dan jatuhnya Presiden Indonesia yang sudah berkuasa selama 32 tahun. Pulang adalah sebuah drama keluarga, persahabatan, cinta, dan pengkhianatan berlatar belakang tiga peristiwa bersejarah: Indonesia 30 September 1965, Prancis Mei 1968, dan Indonesia Mei 1998.', '102000.00', 4, 'https://i.ibb.co/mNfMcTN/pulang.jpg', '2022-03-07 19:16:47', '0.0', 0, 0),
(9, 'exampleEmail@gmail.com', 'The Comfort Book: Buku yang Membuat Kita Nyaman', 'Banyak pelajaran hidup yang paling jelas dan paling menghibur kita pelajari justru pada saat kita berada di titik terendah. Kita baru memikirkan makanan saat kita lapar dan baru memikirkan rakit penyelamat saat kita terlempar ke laut. Buku ini adalah kumpulan penghiburan yang dipelajari di masa-masa sulit—serta saran untuk membuat hari-hari buruk kita menjadi lebih baik. Mengacu pada pepatah, memoar, dan kehidupan inspirasional orang lain, buku yang meditatif ini merayakan keajaiban hidup yang selalu berubah. lnilah buku yang bisa kita baca selagi kita membutuhkan kebijaksanaan seorang teman, kenyamanan sebuah pelukan, atau pengingat bahwa harapan datang dari tempat-tempat yang tidak terduga. Tiada yang lebih kuat daripada harapan kecil yang tak akan menyerah.', '79000.00', 4, 'https://i.ibb.co/QP9c8kQ/thecomfortbook.jpg', '2022-03-07 19:16:47', '0.0', 0, 0),
(10, 'exampleEmail@gmail.com', 'Mantappu Jiwa *Buku Latihan Soal', 'Kata orang, selama masih hidup, manusia akan terus menghadapi masalah demi masalah. Dan itulah yang akan kuceritakan dalam buku ini, yaitu bagaimana aku menghadapi setiap persoalan di dalam hidupku. Dimulai dari aku yang lahir dekat dengan hari meletusnya kerusuhan di tahun 1998, bagaimana keluargaku berusaha menyekolahkanku dengan kondisi ekonomi yang terbatas, sampai pada akhirnya aku berhasil mendapatkan beasiswa penuh S1 di Jepang. Manusia tidak akan pernah lepas dari masalah kehidupan, betul. Tapi buku ini tidak hanya berisi cerita sedih dan keluhan ini-itu. Ini adalah catatan perjuanganku sebagai Jerome Polin Sijabat, pelajar Indonesia di Jepang yang iseng memulai petualangan di YouTube lewat channel Nihongo Mantappu. Yuk, naik roller coaster di kehidupanku yang penuh dengan kalkulasi seperti matematika. It may not gonna be super fun, but I promise it would worth the ride.', '86900.00', 4, 'https://i.ibb.co/0J9hCry/mantappujiwa.jpg', '2022-03-07 19:16:47', '0.0', 0, 0),
(11, 'doge@gmail.com', 'The Devil All of Time', 'Willard Russel, mantan tentara saksi kekejaman perang, sudah menumpahkan banyak darah tapi tak sanggup menyelamatkan istrinya dari kematian. Carl dan Sandy Henderson, pasangan pembunuh berantai yang setiap musim panas mengincar para korbannya di jalanan. Roy dan Theodore, pengkhotbah keliling yang melarikan diri dan dijadikan buronan. Di dunia mereka yang menggila, sesosok pemuda terjebak di tengahnya, dipaksa untuk mengerti bahwa kebaikan dan kejahatan sesungguhnya memiliki batas yang fana.', '85000.00', 2, 'https://i.ibb.co/sjW9M25/thedevilalloftime.jpg', '2022-03-07 19:16:47', '0.0', 0, 0),
(12, 'aadam@gmail.com', 'Laut Bercerita', 'Di sebuah senja, di sebuah rumah susun di Jakarta, mahasiswa bernama Biru Laut disergap empat lelaki tak dikenal. Bersama kawan-kawannya, Daniel Tumbuan, Sunu Dyantoro, Alex Perazon, dia dibawa ke sebuah tempat yang tak dikenal. Berbulan-bulan mereka disekap, diinterogasi, dipukul, ditendang, digantung, dan disetrum agar bersedia menjawab satu pertanyaan penting: siapakah yang berdiri di balik gerakan aktivis dan mahasiswa saat itu.', '100000.00', 2, 'https://i.ibb.co/tLCx9xH/lautbercerita.jpg', '2022-03-20 12:45:08', '0.0', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `userID` int(11) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `no_telp` varchar(12) DEFAULT NULL,
  `tgl_lahir` date DEFAULT NULL,
  `profile_pic` varchar(50) DEFAULT NULL,
  `status` enum('online','offline') DEFAULT 'offline'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userID`, `first_name`, `last_name`, `username`, `email`, `password`, `no_telp`, `tgl_lahir`, `profile_pic`, `status`) VALUES
(1, NULL, NULL, 'admin', NULL, 'admin', NULL, NULL, NULL, 'offline'),
(2, 'Ereh', 'Yegeh', 'exampleUsername', 'exampleEmail@gmail.com', 'exampleUsername', '0123456789', '2022-02-22', NULL, 'offline'),
(3, 'NamaDepan', 'NamaBelakang', 'usernameSaya', 'emailSaya', 'passwordSaya', '9876543210', '2000-04-02', NULL, 'offline'),
(10, 'doge', 'guguk', NULL, 'doge@gmail.com', 'pass', '12345', NULL, 'https://i.ibb.co/C1HH4Wj/doge-gmail-com.jpg', 'offline'),
(11, 'yogi', 'adam', NULL, 'aadam@gmail.com', '1234567', '0891', NULL, 'https://i.ibb.co/C1HH4Wj/doge-gmail-com.jpg', 'offline'),
(16, 'sarah', 'pd', NULL, 'sarahpuspdew@gmail,com', '1234567', '007', NULL, NULL, 'offline'),
(17, 'kura', 'kura', NULL, 'kura@gmail.com', 'kura', '1234', NULL, NULL, 'offline');

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `addUserAddress` AFTER INSERT ON `user` FOR EACH ROW BEGIN
       INSERT INTO user_address (userEmail) VALUES (new.email);
   END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_address`
--

CREATE TABLE `user_address` (
  `userAddressID` int(11) NOT NULL,
  `userEmail` varchar(100) DEFAULT NULL,
  `alamat` varchar(200) DEFAULT NULL,
  `idKota` int(11) DEFAULT NULL,
  `kota` varchar(25) DEFAULT NULL,
  `idProvinsi` int(11) DEFAULT NULL,
  `provinsi` varchar(25) DEFAULT NULL,
  `kodepos` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_address`
--

INSERT INTO `user_address` (`userAddressID`, `userEmail`, `alamat`, `idKota`, `kota`, `idProvinsi`, `provinsi`, `kodepos`) VALUES
(1, 'exampleEmail@gmail.com', 'jl purwokerto', 153, 'Jakarta Selatan', 6, 'DKI Jakarta', '12820'),
(2, 'emailSaya', NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'doge@gmail.com', 'dog town', 22, 'Bandung', 9, 'Jawa Barat', '5252'),
(4, 'aadam@gmail.com', 'rumah', 28, 'bangka barat', 2, 'bangka belitung', '423425'),
(5, 'sarahpuspdew@gmail,com', NULL, NULL, NULL, NULL, NULL, NULL),
(6, 'kura@gmail.com', 'rumah kura', 151, 'jakarta barat', 6, 'dki jakarta', '16968');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cartID`),
  ADD KEY `userEmail` (`userEmail`),
  ADD KEY `productID` (`productID`);

--
-- Indexes for table `kurir`
--
ALTER TABLE `kurir`
  ADD PRIMARY KEY (`kurirID`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`orderID`),
  ADD KEY `custEmail` (`custEmail`);

--
-- Indexes for table `order_detail`
--
ALTER TABLE `order_detail`
  ADD PRIMARY KEY (`orderID`,`productID`),
  ADD KEY `productID` (`productID`);

--
-- Indexes for table `order_seller`
--
ALTER TABLE `order_seller`
  ADD PRIMARY KEY (`orderID`,`productID`),
  ADD KEY `productID` (`productID`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`productID`),
  ADD KEY `userEmail` (`userEmail`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_address`
--
ALTER TABLE `user_address`
  ADD PRIMARY KEY (`userAddressID`),
  ADD KEY `userEmail` (`userEmail`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `cartID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `kurir`
--
ALTER TABLE `kurir`
  MODIFY `kurirID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `orderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `productID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `user_address`
--
ALTER TABLE `user_address`
  MODIFY `userAddressID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`userEmail`) REFERENCES `user` (`email`),
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `products` (`productID`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`custEmail`) REFERENCES `user` (`email`);

--
-- Constraints for table `order_detail`
--
ALTER TABLE `order_detail`
  ADD CONSTRAINT `order_detail_ibfk_1` FOREIGN KEY (`productID`) REFERENCES `products` (`productID`);

--
-- Constraints for table `order_seller`
--
ALTER TABLE `order_seller`
  ADD CONSTRAINT `order_seller_ibfk_1` FOREIGN KEY (`productID`) REFERENCES `products` (`productID`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`userEmail`) REFERENCES `user` (`email`);

--
-- Constraints for table `user_address`
--
ALTER TABLE `user_address`
  ADD CONSTRAINT `user_address_ibfk_1` FOREIGN KEY (`userEmail`) REFERENCES `user` (`email`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
