CREATE DATABASE hapisdb;

use hapisdb;

DROP TABLE IF EXISTS hapisdb.Requests;
DROP TABLE IF EXISTS hapisdb.Matchings;
DROP TABLE IF EXISTS hapisdb.Forms;
DROP TABLE IF EXISTS hapisdb.Notifications;
DROP TABLE IF EXISTS hapisdb.Users;

-- we create tables
 CREATE TABLE IF NOT EXISTS Users (
        UserID VARCHAR(255)  NOT NULL PRIMARY KEY ,
        UserName VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL ,
        FirstName VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        LastName VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        City VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL ,
        Country VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        AddressLocation VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        PhoneNum VARCHAR(255)  NOT NULL,
        Email VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        ProfileImage VARCHAR(255),
        UNIQUE(UserID),
        UNIQUE(UserName)
       );

        CREATE TABLE IF NOT EXISTS Forms (
        FormID INTEGER AUTO_INCREMENT  NOT NULL PRIMARY KEY ,
        UserID VARCHAR(255)  NOT NULL,
        FormType VARCHAR(255) NOT NULL CHECK (FormType IN ('seeker', 'giver')) ,
        Item VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
        Category VARCHAR(255) NOT NULL CHECK (Category IN ('Clothing', 'Household', 'Books and Media', 'Toys and Games', 'Sports Equipment', 'Baby item', 'Hygiene Products', 'Medical Supplies', 'Pet supplies', 'Food', 'Electronics')) ,
        Dates_available VARCHAR(255) NOT NULL,
        ForWho VARCHAR(255) NOT NULL CHECK (ForWho IN ('self', 'other', '')) ,
        FormStatus VARCHAR(255) NOT NULL CHECK (FormStatus IN ('Completed', 'Not Completed')) ,
        FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
        UNIQUE(FormID)
       );

       CREATE TABLE IF NOT EXISTS Matchings (
        M_ID INTEGER AUTO_INCREMENT  NOT NULL PRIMARY KEY ,
        Seeker_FormID INTEGER NOT NULL,
        Giver_FormID INTEGER NOT NULL,
        Rec1_Status  VARCHAR(255) NOT NULL  CHECK (Rec1_Status IN ('Pending', 'Accepted', 'Rejected')) ,
        Rec2_status VARCHAR(255) NOT NULL CHECK (Rec2_status IN ('Pending', 'Accepted', 'Rejected')) ,
        Rec1_Donation_Status VARCHAR(255) NOT NULL CHECK (Rec1_Donation_Status IN ('Not Started', 'In progress', 'Finished', 'Cancelled')) ,
        Rec2_Donation_Status VARCHAR(255) NOT NULL CHECK (Rec2_Donation_Status IN ('Not Started', 'In progress', 'Finished', 'Cancelled')) ,
        FOREIGN KEY (Seeker_FormID) REFERENCES Forms(FormID) ON DELETE CASCADE,
        FOREIGN KEY (Giver_FormID) REFERENCES Forms(FormID)ON DELETE CASCADE,
        UNIQUE(M_ID)
       );

       CREATE TABLE IF NOT EXISTS Requests (
        R_ID INTEGER AUTO_INCREMENT  NOT NULL PRIMARY KEY ,
        Sender_ID VARCHAR(255) NOT NULL,
        Rec_ID VARCHAR(255) NOT NULL,
        Rec_FormID INTEGER NOT NULL,
        Rec_Status  VARCHAR(255) NOT NULL  CHECK (Rec_Status IN ('Pending', 'Accepted', 'Rejected')) ,
        Rec1_Donation_Status VARCHAR(255) NOT NULL CHECK (Rec1_Donation_Status IN ('Not Started', 'In progress', 'Finished', 'Cancelled')) ,
        Rec2_Donation_Status VARCHAR(255) NOT NULL CHECK (Rec2_Donation_Status IN ('Not Started', 'In progress', 'Finished', 'Cancelled')) ,
        FOREIGN KEY (Rec_FormID) REFERENCES Forms(FormID) ON DELETE CASCADE,
        FOREIGN KEY (Sender_ID) REFERENCES Users(UserID) ON DELETE CASCADE,
        FOREIGN KEY (Rec_ID) REFERENCES Users(UserID) ON DELETE CASCADE,
        UNIQUE(R_ID)
       );

       CREATE TABLE IF NOT EXISTS Notifications (
        N_ID INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY ,
        UserID VARCHAR(255) NOT NULL,
        Message  VARCHAR(255) NOT NULL  ,
        FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
        UNIQUE(N_ID)
       );

-- we insert into tables
INSERT INTO Users (UserID, UserName, FirstName, LastName, City, Country, AddressLocation, PhoneNum, Email, ProfileImage)
VALUES
('108471659217411098840','hapis@2023','HAPIS','Lg','Lleida','Spain','Av. de Catalunya 8, Lleida, Spain','728 607 894','liquidgalaxyhapis@gmail.com',''),
('1','Thicand42','Sai','Kosaka','Tokyo','Japan','1-chōme-6 Kyōbashi, Chuo City, Tōkyō-to 104-0031, Japó','22 366095','SaiKosaka@armyspy.com', 'assets/images/db_images/sai.jpg'),
('2','Thrervoich','Motoko','Taihei','Tokyo','Japan','15 Nihonbashikabutochō, Chuo City, Tōkyō-to 103-0026, Japó','24 838673','MotokoTaihei@gustr.com', 'assets/images/db_images/motoko.jpg'),
('3','Hort1949','Ikumi','Kanausuku','Tokyo','Japan','Japó, 〒173-0036 Tōkyō-to, Itabashi City, Mukaihara, 3-chōme−9−4 ヒラカワビル','22 923870','IkumiKanausuku@fleckens.hu', 'assets/images/db_images/Ikumi.jpg'),
('4','Throok','Tomoka','Matsuoka','Tokyo','Japan','4-chōme-7 Toyotamakita, Nerima City, Tōkyō-to 176-0012, Japó','96 439302','TomokaMatsuoka@armyspy.com', 'assets/images/db_images/tomoka.jpg'),
('5','Arefling00','Shoudai','Tanba','Tokyo','Japan','1-chōme-43 Kotakechō, Nerima City, Tōkyō-to 176-0004, Japó','96 741695','ShoudaiTanba@einrot.com', 'assets/images/db_images/shoudai.jpg'),
('6','Faceink1957','Shinji','Matsumura','Tokyo','Japan','4 Chome-2 Shibuya, Shibuya City, Tokyo 150-0002, Japó','23 171931','ShinjiMatsumura@einrot.com', 'assets/images/db_images/shinji.jpg'),
('7','Accutudgeted','Io','Fujikawa','Tokyo','Japan','Japó, 〒135-0051 Tōkyō-to, Koto City, Edagawa, 1-chōme−9−17 都営枝 川一丁目第二アパート１７','26 858315','IoFujikawa@gustr.com', 'assets/images/db_images/lo.jpg'),
('8','Lonsind','Shinga','Hakui','Tokyo','Japan','3-chōme-17-15 Megurohonchō, Meguro City, Tōkyō-to 152-0002, Japó','26 857543','ShingaHakui@teleworm.us', 'assets/images/db_images/shinga.jpg'),
('9','Fivinte','Mariyo','Shimizu','Tokyo','Japan','3-chōme-11 Nishiōi, Shinagawa City, Tōkyō-to 140-0015, Japó','22 299580','MariyoShimizu@einrot.com', ''),
('10','Leng1943','Akihide','Yajima','Tokyo','Japan','Japó, 〒140-0003 Tōkyō-to, Shinagawa City, Yashio, 2-chōme−6−2 日本通運','22 175195','AkihideYajima@fleckens.hu', 'assets/images/db_images/Akihide.jpg'),
('11','Labould','Louise','Boyle','Edinburgh','United Kingdom','143 W Port, Edinburgh, United Kingdom','070 8547 1937','LouiseBoyle@armyspy.com', 'assets/images/db_images/louisa.jpg'),
('12','Acers2002','Lydia','King','Edinburgh','United Kingdom','8 The Loan, South Queensferry, City of Edinburgh, United Kingdom','079 1220 4171','LydiaKing@jourrapide.com', 'assets/images/db_images/lydia.jpg'),
('13','Whoods','Mac','Docherty','Edinburgh','United Kingdom','39 Great Jct St, Edinburgh, United Kingdom','079 5021 1344','MacDocherty@dayrep.com', 'assets/images/db_images/mac.jpg'),
('14','Tookill','Codey','Muir','Edinburgh','United Kingdom','24 Nicolson Square, Edinburgh, United Kingdom','079 7302 9197','CodeyMuir@armyspy.com', 'assets/images/db_images/codey.jpg'),
('15','Thatimbers1981','Melanie','Campbell','Edinburgh','United Kingdom','9 Elm Row, Edinburgh, United Kingdom','078 1548 7929','MelanieCampbell@jourrapide.com', 'assets/images/db_images/melanie.jpg'),
('16','Musigen','Scott','Robertson','Edinburgh','United Kingdom','75 Princes St, Edinburgh, United Kingdom','079 4789 2306','ScottRobertson@armyspy.com', ''),
('17','Thaveling','Katherine','Brown','Edinburgh','United Kingdom','16 Lochside Ave, Edinburgh, United Kingdom','070 5406 8188','KatherineBrown@rhyta.com', 'assets/images/db_images/katherine.jpg'),
('18','Houts1968','Martyna','Murphy','Edinburgh','United Kingdom','25 Greenside Ln, Edinburgh, United Kingdom','077 8349 5290','MartynaMurphy@rhyta.com', 'assets/images/db_images/martyna.jpg'),
('19','Evight','Amelie','Morrison','Edinburgh','United Kingdom','5 Canonmills, Edinburgh, United Kingdom','078 4828 3192','AmelieMorrison@teleworm.us','assets/images/db_images/amelie.jpg'),
('20','Blesteth','Paul','Williamson','Edinburgh','United Kingdom','79 Restalrig Rd S, Edinburgh, United Kingdom','077 5703 5789','PaulWilliamson@dayrep.com','assets/images/db_images/paul.jpg'),
('21','Therry','Lovella','Davis','San Francisco','United States','1434 34th Ave, San Francisco, CA 94122, Estats Units d''Amèrica','8435469546','LovellaRDavis@rhyta.com', 'assets/images/db_images/lovella.jpg'),
('22','Clithapping','Oscar','Hodges','San Francisco','United States','1417 26th Ave, San Francisco, CA 94122, Estats Units d''Amèrica','4439643412','OscarKHodges@teleworm.us', 'assets/images/db_images/oscar.jpg'),
('23','Stowly1990','Joyce','Parmley','San Francisco','United States','1223-1299 24th Ave, San Francisco, CA 94122, Estats Units d''Amèrica','4126614737','JoyceRParmley@jourrapide.com', 'assets/images/db_images/joyce.jpg'),
('24','Stoped','David','Hall','San Francisco','United States','1212 10th Ave, San Francisco, CA 94122, Estats Units d''Amèrica','2087737216','DavidKHall@gustr.com', 'assets/images/db_images/david.jpg'),
('25','Funition','Gretchen','Ward','San Francisco','United States','3230-3290 Fulton St, San Francisco, CA 94118, Estats Units d''Amèrica','8086936767','GretchenTWard@jourrapide.com', ''),
('26','Rometh','Lisa','Craft','San Francisco','United States','1427 Cabrillo St, San Francisco, CA 94118, Estats Units d''Amèrica','6513360810','LisaDCraft@cuvox.de', 'assets/images/db_images/lisa.jpg'),
('27','Toorse','James','Bailey','San Francisco','United States','666 22nd Ave, San Francisco, CA 94121, Estats Units d''Amèrica','6105868582','JamesJBailey@dayrep.com', 'assets/images/db_images/james.jpg'),
('28','Muchy1989','Alice','Taylor','San Francisco','United States','701-765 28th Ave, San Francisco, CA 94121, Estats Units d''Amèrica','8325586914','AliceETaylor@gustr.com','assets/images/db_images/alice.jpg'),
('29','Arager','Gregory','Lykins','San Francisco','United States','3750 Balboa St, San Francisco, CA 94121, Estats Units d''Amèrica','6099988023','GregoryTLykins@fleckens.hu', 'assets/images/db_images/gregory.jpg'),
('30','Phome1935','Nicole','Campbell','San Francisco','United States','San Francisco, Califòrnia 94121, Estats Units','7149242357','NicoleSCampbell@superrito.com', ''),
('31','Babiless','Damaso','Figueroa','Lleida','Spain','Av. Alcalde Porqueras 3, Lleida, Spain','721 914 872','DamasoFigueroaCarreon@dayrep.com', 'assets/images/db_images/damaso.jpg'),
('32','Cartheindfar','Sabelia','Velez','Lleida','Spain','Av. de Catalunya 4, Lleida, Spain','726 607 893','SabeliaVelezOlvera@jourrapide.com', 'assets/images/db_images/Sabelia.jpg'),
('33','Histrely','Fabrizio','Orozco','Lleida','Spain','Av. Alcalde Porqueras 13, Lleida, Spain','613 414 268','FabrizioOrozcoMontenegro@fleckens.hu', 'assets/images/db_images/Fabrizio.jpg'),
('34','Imsed1982','Florio','Ferrer','Lleida','Spain','Av. Estudi General 6, Lleida, Spain','754 286 708','FlorioFerrerSerna@superrito.com', 'assets/images/db_images/Florio.jpg'),
('35','Facke1946','Hermione','Solerzano','Lleida','Spain','Av. Prat de la Riba 23, Lleida, Spain','737 816 654','HermioneSolorzanoMontano@rhyta.com', 'assets/images/db_images/Hermione.jpg'),
('36','Incents','Galeno','Blanco','Lleida','Spain','Av. Catalunya 10, Lleida, Spain','672 949 462','GalenoBlancoSalinas@jourrapide.com', 'assets/images/db_images/Galeno.jpg'),
('37','Weataid','Zenon','Porras','Lleida','Spain','Plaça dels Pagesos 25, Lleida, Spain','623 647 881','ZenonPorrasBustos@superrito.com', 'assets/images/db_images/Zenon.jpg'),
('38','Aruld1959','Ulises','Cotto','Lleida','Spain','Av. de les Garrigues 14, Lleida, Spain','754 079 743','UlisesCottoPineda@rhyta.com', 'assets/images/db_images/Ulises.jpg'),
('39','Surew1973','Jesusa','Salgado','Lleida','Spain','Av. de Balàfia 15, Lleida, Spain','789 660 443','JesusaSalgadoNunez@fleckens.hu', 'assets/images/db_images/Jesusa.jpg'),
('40','Whiond','Martiniana','Najera','Lleida','Spain','Baró de Maials 20, Lleida, Spain','619 582 314','MartinianaNajeraBrito@armyspy.com', 'assets/images/db_images/Martiniana.jpg'),
('41','NourAli00','Nour','Ali','Cairo','Egypt','5 El Zohour St., MOHANDESEEN, Cairo, Egypt','1002671922','NourAli@example.com', 'assets/images/db_images/Nour.jpg'),
('42','AHatem21','Ahmed','Hatem','Cairo','Egypt','197 26th July St., Agouza, Cairo, Egypt','1009176299','AhmedHatem@blbla.com', 'assets/images/db_images/ahmed.jpg'),
('43','Fatom2','Fatma','Hassan','Cairo','Egypt','3 Hassan Sadek St., off Mirghany, Cairo, Egypt','1201878817','FatmaHassan@blaa.com', ''),
('44','Saraaah00','Sarah','Mahmoud','Cairo','Egypt','18 Tawfik Shams St., off Fatma Roushdy St., Cairo, Egypt','1118922277','SaraaMah@lala.com', 'assets/images/db_images/sarah.jpg'),
('45','Marioom1211','Mariam','Ali','Cairo','Egypt','43 Kasr El-Nile St., Down Town, Cairo, Egypt','1009876662','MariamAliNader@laaa.com', 'assets/images/db_images/mariam.jpg'),
('46','Ayaa1200','Aya','AbdelAziz','Cairo','Egypt','72 Misr and Sudan St., HADAYEK EL KOBBA, Cairo, Egypt','1001112222','AyaaA0200@anywhere.com', ''),
('47','OmarAhmed090','Omar','Ahmed','Cairo','Egypt','10 Messaha Sq., 2nd floor , Cairo, Egypt','1001928333','Omar090@anything.com', 'assets/images/db_images/omar.jpg'),
('48','Mark21','Mark','Hany','Cairo','Egypt','130, 26th July St. , Zamalek, Cairo, Egypt','1009872811','MarkHanyyy123@nothing.com', 'assets/images/db_images/mark.jpg'),
('49','AyaHassan345','Aya','Hassan','Cairo','Egypt','101 Abdel Moniem Riad St., Agouza, Cairo, Egypt','1212228374','AyaaH4@example.com', ''),
('50','Joe02','Youssef','Ahmed','Cairo','Egypt','307 El-Harm St., Pyramids, Cairo, Egypt','1213383744','JoeAhme22@anything.com', 'assets/images/db_images/youssef.jpg');



INSERT INTO Forms (FormID, UserID, FormType, Item, Category, Dates_available, ForWho, FormStatus)
VALUES
(1, 1, 'seeker', 'T shirt', 'Clothing', '2023-07-15 09:30:00,2023-07-28 14:45:00,2023-07-10 18:20:00', 'other', 'Not Completed'),
(2, 2, 'seeker', 'Pants', 'Clothing', '2023-08-22 11:00:00', 'self', 'Not Completed'),
(3, 4, 'seeker', 'Data structures and Algorithms book', 'Books and Media', '2023-06-07 16:55:00', 'self', 'Not Completed'),
(4, 1, 'seeker', 'Cat food', 'Pet supplies', '2023-09-01 18:00:00', 'self', 'Not Completed'),
(5, 4, 'seeker', 'Andriod Tablet', 'Electronics', '2023-09-12 17:00:00', 'self', 'Not Completed'),
(6, 30, 'seeker', 'Hoodie', 'Clothing', '2023-05-28 06:30:00', 'other', 'Not Completed'),
(7, 32, 'seeker', 'Jacket', 'Clothing', '2023-05-27 01:00:00', 'self', 'Not Completed'),
(8, 33, 'seeker', 'Pants', 'Clothing', '2023-07-18 01:00:00', 'other', 'Not Completed'),
(9, 32, 'seeker', 'vacuum cleaner', 'Household', '2023-08-18 01:00:00', 'other', 'Not Completed'),
(10, 45, 'seeker', 'Jacket', 'Clothing', '2023-05-11 14:00:00', 'other', 'Completed'),
(11, 16, 'seeker', 'Jacket', 'Clothing', '2023-03-15 09:30:00,2023-04-04 14:45:00', 'other', 'Completed'),
(12, 22, 'seeker', 'Harry Potter Books', 'Books and Media', '2023-02-02 14:00:00', 'self', 'Completed'),
(13, 12, 'seeker', 'German A1 books', 'Books and Media', '2023-02-12 16:00:00', 'self', 'Completed'),
(14, 14, 'seeker', 'Facial moisturizer', 'Hygiene Products', '2023-04-15 12:00:00', 'self', 'Not Completed'),
(15, 38, 'seeker', 'Wheelchairs', 'Medical Supplies', '2023-08-01 12:00:00,2023-08-02 14:00:00,2023-08-01 13:00:00', 'self', 'Not Completed'),
(16, 21, 'seeker', 'Walkers', 'Medical Supplies', '2023-09-17 18:00:00', 'other', 'Not Completed'),
(17, 30, 'seeker', 'Food', 'Food', '2023-07-03 08:00:00,2023-07-03 18:00:00', 'other', 'Not Completed'),
(18, 34, 'seeker', 'Hand sanitizer', 'Hygiene Products', '2023-10-09 09:00:00', 'other', 'Not Completed'),
(19, 39, 'seeker', 'Hand sanitizer', 'Hygiene Products', '2023-11-11 11:00:00', 'self', 'Not Completed'),
(20, 33, 'seeker', 'Face cleanser', 'Hygiene Products', '2023-08-07 18:00:00', 'other', 'Not Completed'),
(21, 2, 'seeker', 'Baby monitor', 'Baby item', '2023-08-12 19:00:00,2023-07-18 20:00:00', 'self', 'Not Completed'),
(22, 1, 'seeker', 'Baby bottles', 'Baby item', '2023-08-30 20:00:00', 'self', 'Not Completed'),
(23, 4, 'seeker', 'Baby car seat', 'Baby item', '2023-07-15 17:00:00', 'self', 'Not Completed'),
(24, 20, 'seeker', 'Tennis racket', 'Sports Equipment', '2023-07-10 21:00:00', 'self', 'Not Completed'),
(25, 28, 'seeker', 'Hockey stick', 'Sports Equipment', '2023-07-23 21:00:00', 'self', 'Not Completed'),
(26, 26, 'seeker', 'Skateboard', 'Sports Equipment', '2023-07-28 20:00:00', 'self', 'Not Completed'),
(27, 22, 'seeker', 'Bicycle', 'Sports Equipment', '2023-08-01 21:00:00', 'self', 'Not Completed'),
(28, 14, 'seeker', 'doll house', 'Toys and Games', '2023-09-01 17:00:00', 'other', 'Not Completed'),
(29, 12, 'seeker', 'Toy robots', 'Toys and Games', '2023-12-11 19:00:00', 'other', 'Not Completed'),
(30, 38, 'seeker', 'blankets', 'Household', '2023-05-14 07:20:00', 'other', 'Completed'),
(31, 11, 'seeker', 'Arts and crafts set', 'Toys and Games', '2023-09-09 09:00:00', 'self', 'Not Completed'),
(32, 9, 'seeker', 'Mega Bloks', 'Toys and Games', '2023-08-01 12:00:00', 'other', 'Not Completed'),
(33, 32, 'seeker', 'Science fiction books', 'Books and Media', '2023-08-05 16:00:00', 'self', 'Not Completed'),
(34, 40, 'seeker', 'Fifa Video Games', 'Books and Media', '2023-07-09 14:00:00', 'self', 'Not Completed'),
(35, 41, 'seeker', 'Poetry books', 'Books and Media', '2023-07-07 01:00:00,2023-07-08 19:00:00,2023-07-09 20:00:00', 'self', 'Not Completed'),
(36, 45, 'seeker', 'Anatomy books', 'Books and Media', '2023-08-03 19:00:00', 'self', 'Not Completed'),
(37, 19, 'seeker', 'psychology books', 'Books and Media', '2023-07-10 09:00:00', 'self', 'Not Completed'),
(38, 6, 'seeker', 'pots', 'Household', '2023-08-23 14:00:00', 'self', 'Not Completed'),
(39, 20, 'seeker', 'microwave', 'Household', '2023-08-16 19:00:00,2023-08-19 20:00:00,2023-08-20 20:00:00', 'self', 'Not Completed'),
(40, 39, 'seeker', 'ceiling lights', 'Household', '2023-07-30 20:00:00', 'self', 'Not Completed'),
(41, 1, 'giver', 'Baby stroller', 'Baby item', '2023-04-28 06:30:00', '', 'Completed'),
(42, 40, 'giver', 'Hoodie', 'Clothing', '2023-05-28 06:30:00', '', 'Not Completed'),
(43, 34, 'giver', 'Jacket', 'Clothing', '2023-05-27 01:00:00', '', 'Not Completed'),
(44, 38, 'giver', 'Pants', 'Clothing', '2023-07-18 01:00:00', '', 'Not Completed'),
(45, 37, 'giver', 'vacuum cleaner', 'Household', '2023-08-18 01:00:00', '', 'Not Completed'),
(46, 20, 'giver', 'Jacket', 'Clothing', '2023-03-20 10:30:00,2023-04-04 14:45:00', '', 'Completed'),
(47, 42, 'giver', 'Pants', 'Clothing', '2023-03-21 10:30:00', '', 'Completed'),
(48, 35, 'giver', 'Bicycle', 'Sports Equipment', '2023-04-19 10:00:00', '', 'Completed'),
(49, 39, 'giver', 'Hoodie', 'Clothing', '2023-07-08 13:00:00', '', 'Not Completed'),
(50, 31, 'giver', 'Oxygen concentrators', 'Medical Supplies', '2023-07-15 15:00:00,2023-07-15 19:00:00', '', 'Not Completed'),
(51, 50, 'giver', 'T shirt', 'Clothing', '2023-07-20 14:00:00', '', 'Not Completed'),
(52, 48, 'giver', 'Jacket', 'Clothing', '2023-08-01 19:00:00', '', 'Not Completed'),
(53, 43, 'giver', 'baby onsies (1 year)', 'Baby item', '2023-07-12 18:30:00,2023-07-13 18:30:00', '', 'Not Completed'),
(54, 40, 'giver', 'baby jacket (2-3 years)', 'Baby item', '2023-07-03 17:45:00,2023-07-30 19:00:00', '', 'Not Completed'),
(55, 35, 'giver', 'blankets', 'Household', '2023-05-14 07:20:00', '', 'Completed'),
(56, 26, 'giver', 'Hard Puzzle sets', 'Toys and Games', '2023-09-10 19:00:00', '', 'Not Completed'),
(57, 9, 'giver', 'stuffed animals', 'Toys and Games', '2023-10-10 17:30:00', '', 'Not Completed'),
(58, 16, 'giver', 'dog toys', 'Pet supplies', '2023-11-29 05:00:00', '', 'Not Completed'),
(59, 31, 'giver', 'Pants', 'Clothing', '2023-07-29 15:45:00', '', 'Not Completed'),
(60, 37, 'giver', 'Train game', 'Toys and Games', '2023-07-26 16:50:00', '', 'Not Completed');

INSERT INTO Matchings (M_ID, Seeker_FormID, Giver_FormID, Rec1_Status, Rec2_status, Rec1_Donation_Status, Rec2_Donation_Status)
VALUES
(1, 9, 45, 'Pending', 'Pending', 'Not Started', 'Not Started'),
(2, 8, 44, 'Pending', 'Accepted', 'Not Started', 'Not Started'),
(3, 7, 43, 'Accepted', 'Accepted', 'In progress', 'In progress'),
(4, 11, 46, 'Accepted', 'Accepted', 'Finished', 'Finished'),
(5, 6, 42, 'Accepted', 'Accepted', 'In progress', 'In progress'),
(6, 30, 55, 'Accepted', 'Accepted', 'Finished', 'Finished');

INSERT INTO Requests (R_ID, Sender_ID, Rec_ID, Rec_FormID, Rec_Status, Rec1_Donation_Status, Rec2_Donation_Status)
VALUES
(1, '8', '1', 4, 'Pending', 'Not Started', 'Not Started'),
(2, '7', '4', 3, 'Accepted', 'In progress', 'In progress'),
(3, '10', '1', 41, 'Accepted', 'Finished', 'Finished'),
(4, '49', '45', 10, 'Accepted', 'Finished', 'Finished'),
(5, '44', '42', 47, 'Accepted', 'Finished', 'Finished'),
(6, '31', '39', 49, 'Accepted', 'In progress', 'In progress'),
(7, '31', '35', 48, 'Accepted', 'Finished', 'Finished'),
(8, '16', '14', 14, 'Accepted', 'Cancelled', 'Cancelled'),
(9, '24', '22', 12, 'Accepted', 'Finished', 'Finished'),
(10, '14', '12', 13, 'Accepted', 'Finished', 'Finished');


-- we commit -> COMMIT


COMMIT;
