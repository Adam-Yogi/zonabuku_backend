-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 21, 2022 at 01:31 PM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `addProduct` (IN `in_userEmail` VARCHAR(100), IN `in_nama` VARCHAR(100), IN `in_deskripsi` TEXT, IN `in_harga` DECIMAL(8,2), IN `in_jumlah` INT, IN `in_image_product` VARCHAR(100), IN `in_tgl_input` DATETIME)  BEGIN
INSERT INTO products(userEmail, nama, deskripsi, harga, jumlah, image_product, tgl_input) VALUES (in_userEmail, in_nama, in_deskripsi, in_harga, in_jumlah, in_image_product, in_tgl_input);
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `delproduct` (`productID` INT)  BEGIN
DELETE FROM products
WHERE products.productID = productID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tampil_detailProdukUser` (IN `productID` INT)  BEGIN
SELECT products.productID, products.nama, products.deskripsi, products.harga, products.jumlah, products.image_product, products.tgl_input, CONCAT(user.first_name," ", user.last_name) AS 'owner'
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
  `tgl_input` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`productID`, `userEmail`, `nama`, `deskripsi`, `harga`, `jumlah`, `image_product`, `tgl_input`) VALUES
(1, 'aadam@gmail.com', 'Laskar Pelangi', '\"Bangunan itu nyaris rubuh. Dindingnya miring bersangga sebalok kayu. Atapnya bocor di mana-mana. Tetapi, berpasang-pasang mata mungil menatap penuh harap. Hendak ke mana lagikah mereka harus bersekolah selain tempat itu? Tak peduli seberat apa pun kondisi sekolah itu, sepuluh anak dari keluarga miskin itu tetap bergeming. Di dada mereka, telah menggumpal tekad untuk maju.\" Laskar Pelangi, kisah perjuangan anak-anak untuk mendapatkan ilmu. Diceritakan dengan lucu dan menggelitik, novel ini menjadi novel terlaris di Indonesia. Inspiratif dan layak dimiliki siapa saja yang mencintai pendidikan dan keajaiban masa kanak-kanak.', '70000.00', 3, 'https://i.ibb.co/FDg4rbg/laskarpelangi.jpg', '2022-03-07 17:23:27'),
(2, 'aadam@gmail.com', 'Perahu Kertas', 'Namanya Kugy. Mungil, pengkhayal, dan berantakan. Dari benaknya, mengalir untaian dongeng indah. Keenan belum pernah bertemu manusia seaneh itu ....\r\nNamanya Keenan. Cerdas, artistik, dan penuh kejutan. Dari tangannya, mewujud lukisan-lukisan magis. Kugy belum pernah bertemu manusia seajaib itu ....\r\nDan kini mereka berhadapan di antara hamparan misteri dan rintangan. Akankah dongeng dan lukisan itu bersatu? Akankah hati dan impian mereka bertemu?', '69000.00', 2, 'https://i.ibb.co/M19pvC7/perahukertas.jpg', '2022-03-07 17:37:48'),
(3, 'aadam@gmail.com', 'National Geographic Indonesia Edisi Januari 2022', 'Pagebluk membuat kita bagai menaiki roller coaster: Vaksin baru mendorong optimisme. Namun kesalahan informasi dan kekurangan persediaan, mengganggu imunisasi. Virus pun tetap mengancam. 54 - Perselisihan budaya, politik, tanah, dan lainnya, berkobar di seluruh dunia—termasuk di AS, yang menghadapi serangan terhadap demokrasinya dan terus bergulat degan warisan rasismenya. 68 - Dalam tahun yangpenuh tantangan, terdapat pencapaian yang menggembirakan dalam pelestarian harta alam dan budaya. Upaya-upaya kita mencerminkan harapan serta rasa kemanusiaan kita.', '59000.00', 1, 'https://i.ibb.co/5LfSK7m/nationalgeographicjan22.jpg', '2022-03-07 17:37:48'),
(4, 'doge@gmail.com', 'Bobo Edisi 47 2022', 'by Majalah Bobo', '15000.00', 10, 'https://i.ibb.co/G0Qg7GT/bobo47.jpg', '2022-03-07 17:37:48'),
(5, 'emailSaya', 'Dokter Smurf', 'Gimana jadinya kalau ada Dokter Smurf di desa smurf? Apalagi ada Smurfin yang jadi perawatnya? Kehebohan mendadak terjadi di tengah-tengah warga smurf. Semua smurf sakit dan semua smurf mau dirawat oleh Smurfin yang cantik. Bahkan Papa Smurf yang mengaku sehat pun, ikut terkapar sakit dan harus dirawat. Berhasilkah Dokter Smurf menyembuhkan semua smurf yang sakit?', '38500.00', 5, 'https://i.ibb.co/FWyVqTG/doktersmurf.jpg', '2022-03-07 17:37:48'),
(6, 'doge@gmail.com', 'Diet Ketogenik: Panduan & Resep Sehat', 'Diet golongan darah, diet Food Combining, diet mayo, adalah beberapa program diet yang pernah menjadi tren di Indonesia. Kini diet yang semakin populer adalah diet Ketogenik atau diet Keto. Manfaatnya antara lain dipercaya dapat menurunkan berat badan secara signifikan. Buku ini selain beri panduan untuk memulai diet keto dengan benar juga dilengkapi dengan lebih dari 90 resep sehat dan lezat terdiri dari aneka snack, lauk, minuman, dan dessert yang disusun sedemikian rupa oleh penulis agar para pelaku diet Keto dapat menikmati pengalaman diet yang menyenangkan.', '141900.00', 2, 'https://i.ibb.co/x1JVGkn/dietketogenik.jpg', '2022-03-07 19:16:47'),
(7, 'aadam@gmail.com', 'Assassination Classroom 21', 'Jalan apakah yang ditempuh oleh Nagisa dan teman-temannya setelah lulus SMP? Temukan jawabannya dalam buku terakhir Assassination Classroom yang penuh keharuan ini! Buku ini juga memuat kisah kehidupan pribadi Pak Koro saat menikmati waktunya sebagai orang dewasa. Temukan juga cerita lepas Tokyo Depart War di akhir buku ini!', '21250.00', 1, 'https://i.ibb.co/RTjT8KB/ASSASSINATIONCLASSROOM21.jpg', '2022-03-07 19:16:47'),
(8, 'aadam@gmail.com', 'Pulang', 'Ketika gerakan mahasiswa berkecamuk di Paris, Dimas Suryo, seorang eksil politik Indonesia, bertemu Vivienne Deveraux, mahasiswa yang ikut demonstrasi melawan pemerintahan Prancis. Pada saat yang sama, Dimas menerima kabar dari Jakarta; Hananto Prawiro, sahabatnya, ditangkap tentara dan dinyatakan tewas. Di tengah kesibukan mengelola Restoran Tanah Air di Paris, Dimas bersama tiga kawannya-Nugroho, Tjai, dan Risjaf—terus-menerus dikejar rasa bersalah karena kawan-kawannya di Indonesia dikejar, ditembak, atau menghikang begitu saja dalam perburuan peristiwa 30 September. Apalagi dia tak bisa melupakan Surti Anandari—isteri Hananto—yang bersama ketiga anaknya berbulan-bulan diinterogasi tentara. Jakarta, Mei 1998. Lintang Utara, puteri Dimas dari perkawinan dengan Vivienne Deveraux, akhirnya berhasil memperoleh visa masuk Indonesia untuk merekam pengalaman keluarga korban tragedi 30 September sebagai tugas akhir kuliahnya. Apa yang terkuak oleh Lintang bukan sekedar masa lalu ayahnya dengan Surti Anandari, tetapi juga bagaimana sejarah paling berdarah di negerinya mempunyai kaitan dengan Ayah dan kawan-kawan ayahnya. Bersama Sedara Alam, putera Hananto, Lintang menjadi saksi mata apa yang kemudian menjadi kerusuhan terbesar dalam sejarah Indonesia: kerusuhan Mei 1998 dan jatuhnya Presiden Indonesia yang sudah berkuasa selama 32 tahun. Pulang adalah sebuah drama keluarga, persahabatan, cinta, dan pengkhianatan berlatar belakang tiga peristiwa bersejarah: Indonesia 30 September 1965, Prancis Mei 1968, dan Indonesia Mei 1998.', '102000.00', 1, 'https://i.ibb.co/mNfMcTN/pulang.jpg', '2022-03-07 19:16:47'),
(9, 'exampleEmail@gmail.com', 'The Comfort Book: Buku yang Membuat Kita Nyaman', 'Banyak pelajaran hidup yang paling jelas dan paling menghibur kita pelajari justru pada saat kita berada di titik terendah. Kita baru memikirkan makanan saat kita lapar dan baru memikirkan rakit penyelamat saat kita terlempar ke laut. Buku ini adalah kumpulan penghiburan yang dipelajari di masa-masa sulit—serta saran untuk membuat hari-hari buruk kita menjadi lebih baik. Mengacu pada pepatah, memoar, dan kehidupan inspirasional orang lain, buku yang meditatif ini merayakan keajaiban hidup yang selalu berubah. lnilah buku yang bisa kita baca selagi kita membutuhkan kebijaksanaan seorang teman, kenyamanan sebuah pelukan, atau pengingat bahwa harapan datang dari tempat-tempat yang tidak terduga. Tiada yang lebih kuat daripada harapan kecil yang tak akan menyerah.', '79000.00', 3, 'https://i.ibb.co/QP9c8kQ/thecomfortbook.jpg', '2022-03-07 19:16:47'),
(10, 'exampleEmail@gmail.com', 'Mantappu Jiwa *Buku Latihan Soal', 'Kata orang, selama masih hidup, manusia akan terus menghadapi masalah demi masalah. Dan itulah yang akan kuceritakan dalam buku ini, yaitu bagaimana aku menghadapi setiap persoalan di dalam hidupku. Dimulai dari aku yang lahir dekat dengan hari meletusnya kerusuhan di tahun 1998, bagaimana keluargaku berusaha menyekolahkanku dengan kondisi ekonomi yang terbatas, sampai pada akhirnya aku berhasil mendapatkan beasiswa penuh S1 di Jepang. Manusia tidak akan pernah lepas dari masalah kehidupan, betul. Tapi buku ini tidak hanya berisi cerita sedih dan keluhan ini-itu. Ini adalah catatan perjuanganku sebagai Jerome Polin Sijabat, pelajar Indonesia di Jepang yang iseng memulai petualangan di YouTube lewat channel Nihongo Mantappu. Yuk, naik roller coaster di kehidupanku yang penuh dengan kalkulasi seperti matematika. It may not gonna be super fun, but I promise it would worth the ride.', '86900.00', 10, 'https://i.ibb.co/0J9hCry/mantappujiwa.jpg', '2022-03-07 19:16:47'),
(11, 'doge@gmail.com', 'The Devil All of Time', 'Willard Russel, mantan tentara saksi kekejaman perang, sudah menumpahkan banyak darah tapi tak sanggup menyelamatkan istrinya dari kematian. Carl dan Sandy Henderson, pasangan pembunuh berantai yang setiap musim panas mengincar para korbannya di jalanan. Roy dan Theodore, pengkhotbah keliling yang melarikan diri dan dijadikan buronan. Di dunia mereka yang menggila, sesosok pemuda terjebak di tengahnya, dipaksa untuk mengerti bahwa kebaikan dan kejahatan sesungguhnya memiliki batas yang fana.', '85000.00', 4, 'https://i.ibb.co/sjW9M25/thedevilalloftime.jpg', '2022-03-07 19:16:47'),
(12, 'aadam@gmail.com', 'Laut Bercerita', 'Di sebuah senja, di sebuah rumah susun di Jakarta, mahasiswa bernama Biru Laut disergap empat lelaki tak dikenal. Bersama kawan-kawannya, Daniel Tumbuan, Sunu Dyantoro, Alex Perazon, dia dibawa ke sebuah tempat yang tak dikenal. Berbulan-bulan mereka disekap, diinterogasi, dipukul, ditendang, digantung, dan disetrum agar bersedia menjawab satu pertanyaan penting: siapakah yang berdiri di balik gerakan aktivis dan mahasiswa saat itu.', '100000.00', 6, 'https://i.ibb.co/tLCx9xH/lautbercerita.jpg', '2022-03-20 12:45:08');

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
(2, 'exampleName', 'exampleName', 'exampleUsername', 'exampleEmail@gmail.com', 'exampleUsername', '0123456789', '2022-02-22', NULL, 'offline'),
(3, 'NamaDepan', 'NamaBelakang', 'usernameSaya', 'emailSaya', 'passwordSaya', '9876543210', '2000-04-02', NULL, 'offline'),
(10, 'doge', 'guguk', NULL, 'doge@gmail.com', 'pass', '12345', NULL, 'https://i.ibb.co/C1HH4Wj/doge-gmail-com.jpg', 'offline'),
(11, 'yogi', 'adam', NULL, 'aadam@gmail.com', '1234567', '0891', NULL, 'https://i.ibb.co/C1HH4Wj/doge-gmail-com.jpg', 'offline');

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `addUserAddress` AFTER INSERT ON `user` FOR EACH ROW BEGIN
INSERT INTO user_address(userIDAddress) VALUES (NEW.userID);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_address`
--

CREATE TABLE `user_address` (
  `userIDAddress` int(11) NOT NULL,
  `alamat` varchar(100) DEFAULT NULL,
  `kota` varchar(25) DEFAULT NULL,
  `provinsi` varchar(25) DEFAULT NULL,
  `kodepos` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_address`
--

INSERT INTO `user_address` (`userIDAddress`, `alamat`, `kota`, `provinsi`, `kodepos`) VALUES
(2, 'jl. Nama Jalan', 'namaKota', 'namaProvinsi', '12345'),
(3, NULL, NULL, NULL, NULL),
(10, NULL, NULL, NULL, NULL),
(11, NULL, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

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
  ADD PRIMARY KEY (`userIDAddress`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `productID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`userEmail`) REFERENCES `user` (`email`);

--
-- Constraints for table `user_address`
--
ALTER TABLE `user_address`
  ADD CONSTRAINT `user_address_ibfk_1` FOREIGN KEY (`userIDAddress`) REFERENCES `user` (`userID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
