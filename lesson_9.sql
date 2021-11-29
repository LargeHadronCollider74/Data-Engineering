DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;
USE sample;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
USE shop;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS catalog;
CREATE TABLE catalog (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(130)
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	catalog_id INT UNSIGNED NOT NULL, 
  name VARCHAR(130),
	cnt INT UNSIGNED NOT NULL,
  FOREIGN KEY (catalog_id) REFERENCES catalog(id) on delete cascade
);

DROP TABLE IF EXISTS orderss;
CREATE TABLE orderss (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED, 
	products_id INT UNSIGNED NOT NULL, 
	cnt INT UNSIGNED NOT NULL,
  ordered_at DATETIME,
  user_comment VARCHAR(200),
  FOREIGN KEY (user_id) REFERENCES users(id) on delete set null,
  FOREIGN KEY (products_id) REFERENCES products(id) on delete cascade
);

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO `catalog` (`id`, `name`) VALUES (1, 'iusto');
INSERT INTO `catalog` (`id`, `name`) VALUES (2, 'aut');
INSERT INTO `catalog` (`id`, `name`) VALUES (3, 'sint');
INSERT INTO `catalog` (`id`, `name`) VALUES (4, 'labore');
INSERT INTO `catalog` (`id`, `name`) VALUES (5, 'aut');
INSERT INTO `catalog` (`id`, `name`) VALUES (6, 'quia');
INSERT INTO `catalog` (`id`, `name`) VALUES (7, 'et');
INSERT INTO `catalog` (`id`, `name`) VALUES (8, 'et');
INSERT INTO `catalog` (`id`, `name`) VALUES (9, 'modi');
INSERT INTO `catalog` (`id`, `name`) VALUES (10, 'perspiciatis');

INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (1, 28, 1, 18, '2014-02-16 21:27:19', 'quia');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (2, 41, 2, 5, '2001-08-01 01:51:48', 'animi');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (3, 56, 3, 3, '1986-09-08 17:44:57', 'et');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (4, 21, 4, 6, '2021-02-09 09:19:47', 'magni');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (5, 26, 5, 12, '1971-06-20 14:29:04', 'modi');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (6, 59, 6, 10, '1997-01-22 22:36:03', 'repellendus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (7, 27, 7, 18, '1983-08-13 20:23:53', 'culpa');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (8, 62, 8, 4, '2010-06-15 21:27:49', 'voluptate');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (9, 66, 9, 3, '2005-06-16 09:48:21', 'amet');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (10, 68, 10, 15, '2002-01-17 00:08:10', 'quisquam');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (11, 52, 11, 9, '2001-02-08 23:07:12', 'libero');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (12, 54, 12, 16, '2004-06-24 06:43:23', 'quae');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (13, 29, 13, 19, '2012-10-11 22:40:23', 'reprehenderit');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (14, 62, 14, 19, '2017-02-13 00:45:19', 'id');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (15, 49, 15, 1, '2013-03-19 16:00:44', 'quisquam');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (16, 30, 16, 10, '1977-05-20 01:15:57', 'impedit');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (17, 38, 17, 1, '1985-01-26 17:52:03', 'ut');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (18, 62, 18, 5, '1991-12-09 05:21:53', 'laborum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (19, 50, 19, 14, '2019-03-13 19:17:14', 'temporibus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (20, 28, 20, 10, '1973-07-28 14:17:30', 'nemo');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (21, 32, 21, 9, '1997-04-23 01:20:38', 'pariatur');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (22, 29, 22, 19, '1984-03-17 21:16:00', 'voluptate');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (23, 40, 23, 4, '2017-12-07 10:40:45', 'veritatis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (24, 50, 24, 20, '1982-08-25 09:39:42', 'culpa');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (25, 37, 25, 13, '2011-09-27 21:42:19', 'aut');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (26, 53, 26, 13, '1993-02-15 03:29:44', 'est');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (27, 53, 27, 10, '1995-03-11 11:00:58', 'dolor');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (28, 59, 28, 12, '1987-08-07 23:55:14', 'pariatur');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (29, 52, 29, 13, '1994-10-20 11:56:52', 'sit');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (30, 26, 30, 16, '1984-03-27 04:55:39', 'est');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (31, 46, 31, 7, '1978-06-05 02:53:50', 'consequatur');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (32, 55, 32, 18, '1987-05-17 04:58:54', 'esse');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (33, 37, 33, 11, '1986-06-15 10:25:55', 'enim');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (34, 44, 34, 8, '2005-09-08 15:04:23', 'et');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (35, 39, 35, 9, '2007-05-23 04:07:36', 'rerum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (36, 25, 36, 1, '2003-09-20 11:08:11', 'rerum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (37, 49, 37, 10, '1998-02-11 16:58:13', 'totam');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (38, 35, 38, 7, '1984-02-10 18:08:43', 'autem');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (39, 51, 39, 14, '1993-03-25 19:23:19', 'vel');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (40, 52, 40, 16, '1981-07-27 19:50:57', 'ea');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (41, 30, 41, 8, '2002-01-20 22:41:14', 'consequuntur');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (42, 60, 42, 14, '1992-04-06 11:44:33', 'dolor');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (43, 45, 43, 13, '2004-04-10 23:22:31', 'nulla');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (44, 37, 44, 5, '1998-05-27 23:43:26', 'dolorem');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (45, 21, 45, 12, '1995-07-02 06:37:13', 'numquam');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (46, 67, 46, 15, '2017-03-08 15:34:55', 'a');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (47, 33, 47, 10, '1995-10-23 01:00:32', 'laudantium');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (48, 47, 48, 12, '2002-05-04 15:48:03', 'quaerat');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (49, 69, 49, 7, '1997-11-14 17:39:02', 'eius');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (50, 48, 50, 5, '2018-07-05 22:41:53', 'veritatis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (51, 50, 1, 20, '1992-02-02 17:30:35', 'unde');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (52, 58, 2, 19, '2010-04-28 02:07:05', 'sit');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (53, 57, 3, 11, '2011-03-22 23:01:29', 'cum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (54, 69, 4, 17, '1997-01-06 09:53:38', 'accusantium');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (55, 28, 5, 6, '2021-02-27 09:47:14', 'pariatur');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (56, 64, 6, 11, '1975-12-08 18:47:27', 'tenetur');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (57, 23, 7, 10, '2004-10-20 02:20:27', 'voluptatum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (58, 64, 8, 13, '2015-05-13 11:03:44', 'quaerat');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (59, 69, 9, 16, '1981-07-22 02:29:30', 'totam');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (60, 54, 10, 8, '1991-11-18 22:51:05', 'amet');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (61, 61, 11, 2, '1991-02-26 14:11:12', 'doloribus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (62, 59, 12, 9, '2012-07-04 19:08:29', 'excepturi');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (63, 49, 13, 2, '1976-08-26 00:05:37', 'magni');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (64, 57, 14, 20, '2015-11-18 01:45:24', 'atque');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (65, 26, 15, 15, '1974-12-18 15:29:44', 'autem');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (66, 69, 16, 11, '1995-03-26 03:02:11', 'molestias');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (67, 30, 17, 17, '1983-11-09 01:53:32', 'error');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (68, 57, 18, 19, '2010-08-06 20:30:31', 'deserunt');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (69, 67, 19, 4, '1970-02-07 16:53:32', 'natus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (70, 59, 20, 18, '2013-12-14 01:03:59', 'atque');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (71, 20, 21, 5, '2005-11-06 05:22:08', 'harum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (72, 39, 22, 1, '1989-01-06 00:02:23', 'accusamus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (73, 44, 23, 6, '1994-09-30 00:12:50', 'rerum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (74, 64, 24, 9, '1970-01-21 17:21:31', 'est');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (75, 44, 25, 20, '2008-02-18 00:19:58', 'vel');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (76, 69, 26, 13, '1995-08-13 15:39:51', 'sapiente');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (77, 36, 27, 20, '1987-08-02 23:31:05', 'quis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (78, 41, 28, 10, '2002-06-29 20:58:32', 'qui');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (79, 39, 29, 11, '1979-10-15 14:43:59', 'ea');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (80, 34, 30, 16, '1971-06-25 09:13:39', 'vel');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (81, 35, 31, 7, '2012-02-07 18:34:26', 'pariatur');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (82, 60, 32, 4, '1986-08-04 21:26:20', 'qui');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (83, 55, 33, 10, '1998-09-09 02:48:19', 'eaque');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (84, 41, 34, 17, '2001-07-16 04:25:48', 'ut');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (85, 59, 35, 5, '2010-10-08 20:13:04', 'ab');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (86, 21, 36, 18, '2019-10-22 00:46:35', 'est');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (87, 68, 37, 18, '2011-12-15 03:26:39', 'in');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (88, 48, 38, 17, '1978-03-29 00:16:22', 'sunt');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (89, 57, 39, 9, '1996-04-05 08:30:15', 'est');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (90, 70, 40, 15, '2012-08-26 16:45:54', 'soluta');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (91, 39, 41, 12, '1977-10-15 01:28:08', 'quia');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (92, 55, 42, 14, '2005-05-07 16:13:22', 'aliquid');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (93, 25, 43, 8, '1981-07-31 05:15:11', 'vero');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (94, 57, 44, 15, '2013-11-17 18:01:36', 'in');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (95, 33, 45, 3, '2002-11-24 00:07:43', 'ipsum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (96, 35, 46, 16, '1978-02-06 09:01:22', 'dolores');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (97, 30, 47, 5, '1990-03-08 01:22:30', 'dicta');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (98, 38, 48, 15, '1971-12-18 04:50:35', 'nulla');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (99, 43, 49, 12, '2016-08-14 03:59:32', 'laborum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (100, 67, 50, 1, '2020-10-07 09:45:34', 'iure');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (101, 45, 1, 4, '1982-12-21 02:28:14', 'sint');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (102, 41, 2, 11, '1977-09-18 03:43:36', 'fuga');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (103, 31, 3, 19, '1987-09-13 00:23:00', 'distinctio');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (104, 46, 4, 2, '2018-10-14 19:37:10', 'quo');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (105, 58, 5, 16, '2010-02-28 04:59:52', 'quis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (106, 27, 6, 4, '1975-07-17 00:38:34', 'aperiam');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (107, 57, 7, 20, '1972-07-05 23:35:47', 'odit');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (108, 22, 8, 6, '1985-10-11 21:22:37', 'placeat');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (109, 43, 9, 6, '2012-12-08 03:58:52', 'quis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (110, 54, 10, 17, '1979-06-09 12:08:14', 'eum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (111, 69, 11, 18, '1996-03-18 06:41:28', 'alias');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (112, 30, 12, 13, '2006-04-02 00:19:07', 'minus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (113, 54, 13, 8, '1987-08-17 05:26:22', 'magni');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (114, 25, 14, 2, '2002-01-22 21:23:08', 'quisquam');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (115, 56, 15, 18, '1982-01-08 10:57:21', 'quod');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (116, 45, 16, 9, '1998-12-12 04:01:14', 'a');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (117, 44, 17, 6, '1976-12-14 05:57:46', 'veritatis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (118, 30, 18, 17, '1992-01-23 14:41:26', 'sit');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (119, 54, 19, 9, '1998-06-30 07:11:02', 'nihil');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (120, 53, 20, 11, '1990-10-24 23:51:27', 'sit');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (121, 42, 21, 14, '1970-02-11 19:56:32', 'est');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (122, 56, 22, 9, '1975-09-29 03:11:02', 'vero');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (123, 20, 23, 8, '1991-02-02 19:08:46', 'perspiciatis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (124, 48, 24, 2, '1990-02-06 02:05:06', 'ut');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (125, 52, 25, 13, '1973-04-18 04:16:34', 'non');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (126, 49, 26, 14, '2013-06-08 13:25:49', 'veritatis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (127, 37, 27, 7, '1971-02-28 15:46:31', 'vero');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (128, 50, 28, 19, '1992-12-21 14:34:03', 'repellendus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (129, 37, 29, 16, '2008-03-21 18:28:49', 'excepturi');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (130, 27, 30, 12, '2017-06-03 19:07:48', 'possimus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (131, 52, 31, 9, '2008-07-03 18:14:49', 'in');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (132, 61, 32, 4, '2013-05-15 00:18:25', 'fuga');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (133, 39, 33, 12, '1978-03-06 23:07:46', 'excepturi');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (134, 69, 34, 19, '2004-05-15 23:55:43', 'quas');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (135, 30, 35, 18, '1991-02-25 14:28:31', 'et');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (136, 59, 36, 5, '2018-09-10 07:28:12', 'doloremque');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (137, 67, 37, 8, '2002-10-15 22:02:35', 'debitis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (138, 63, 38, 19, '1972-06-25 16:40:40', 'saepe');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (139, 61, 39, 5, '1987-08-16 08:15:34', 'et');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (140, 55, 40, 18, '1976-07-09 20:52:07', 'corrupti');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (141, 53, 41, 17, '1982-12-29 18:22:18', 'corporis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (142, 70, 42, 18, '2002-04-06 06:32:20', 'non');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (143, 59, 43, 9, '1999-05-31 22:32:44', 'dolore');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (144, 55, 44, 5, '2004-05-22 09:51:45', 'cumque');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (145, 37, 45, 19, '1970-09-23 09:23:06', 'quaerat');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (146, 59, 46, 3, '1973-01-16 14:57:32', 'voluptatem');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (147, 54, 47, 13, '1983-09-14 23:10:26', 'officiis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (148, 60, 48, 9, '2011-07-11 15:24:28', 'ad');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (149, 34, 49, 10, '2005-12-24 09:03:04', 'asperiores');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (150, 45, 50, 3, '2021-06-03 04:11:42', 'porro');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (151, 59, 1, 17, '1998-12-13 18:06:52', 'illum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (152, 62, 2, 2, '1980-04-17 04:27:39', 'quos');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (153, 26, 3, 3, '2013-06-10 05:13:40', 'harum');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (154, 62, 4, 4, '2005-11-29 14:31:34', 'rem');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (155, 44, 5, 5, '2017-04-27 21:21:55', 'quis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (156, 48, 6, 3, '1982-05-18 13:22:05', 'omnis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (157, 35, 7, 11, '1972-01-27 01:53:41', 'nam');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (158, 52, 8, 9, '2015-04-24 21:47:27', 'assumenda');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (159, 27, 9, 14, '2012-11-01 20:37:53', 'omnis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (160, 34, 10, 19, '2002-02-22 18:59:16', 'provident');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (161, 42, 11, 20, '2010-12-16 19:34:17', 'aut');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (162, 22, 12, 16, '1976-09-07 22:07:58', 'aut');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (163, 56, 13, 15, '2009-09-27 04:13:02', 'officia');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (164, 45, 14, 6, '1983-07-17 22:19:30', 'perspiciatis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (165, 70, 15, 9, '2013-07-11 15:25:24', 'veritatis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (166, 39, 16, 2, '1991-12-14 19:17:45', 'ab');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (167, 54, 17, 16, '2018-10-18 14:07:01', 'reiciendis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (168, 44, 18, 2, '2005-10-24 05:30:37', 'et');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (169, 26, 19, 15, '2017-12-24 12:13:41', 'dolor');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (170, 23, 20, 18, '1982-03-18 18:59:42', 'molestiae');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (171, 41, 21, 12, '2006-01-29 09:28:58', 'et');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (172, 36, 22, 10, '2000-10-20 19:46:29', 'in');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (173, 39, 23, 6, '2013-04-23 02:28:15', 'ut');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (174, 57, 24, 18, '1974-10-25 01:08:16', 'ratione');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (175, 56, 25, 17, '1993-02-21 13:01:37', 'numquam');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (176, 27, 26, 17, '2013-07-19 12:58:59', 'dolores');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (177, 33, 27, 19, '2003-12-16 13:03:30', 'dolor');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (178, 38, 28, 20, '1982-09-06 21:15:50', 'tenetur');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (179, 43, 29, 10, '2014-07-05 23:55:06', 'quo');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (180, 50, 30, 18, '1993-08-10 05:24:45', 'et');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (181, 58, 31, 10, '1995-08-18 18:27:58', 'voluptatibus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (182, 61, 32, 5, '1981-04-24 13:41:54', 'voluptatem');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (183, 29, 33, 15, '1983-05-15 21:54:12', 'sit');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (184, 35, 34, 9, '1990-09-21 04:39:31', 'perferendis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (185, 24, 35, 16, '1999-05-12 16:26:42', 'quo');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (186, 69, 36, 4, '1981-12-21 09:24:49', 'minus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (187, 62, 37, 2, '1971-03-19 02:24:02', 'accusamus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (188, 27, 38, 5, '1984-01-29 18:26:32', 'aut');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (189, 60, 39, 17, '2003-09-01 17:10:09', 'commodi');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (190, 53, 40, 20, '1991-11-28 12:23:33', 'qui');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (191, 38, 41, 8, '2019-12-27 08:07:50', 'veritatis');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (192, 26, 42, 6, '1986-11-06 15:10:36', 'est');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (193, 44, 43, 6, '1996-11-07 23:04:04', 'similique');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (194, 22, 44, 3, '1987-07-31 13:31:59', 'temporibus');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (195, 62, 45, 5, '2009-05-20 05:02:18', 'qui');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (196, 44, 46, 5, '2012-04-04 05:06:09', 'et');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (197, 53, 47, 20, '2019-01-25 02:41:13', 'et');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (198, 43, 48, 13, '1979-05-23 16:11:01', 'illo');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (199, 26, 49, 9, '1982-02-05 20:48:57', 'voluptas');
INSERT INTO `orderss` (`id`, `user_id`, `products_id`, `cnt`, `ordered_at`, `user_comment`) VALUES (200, 51, 50, 6, '1991-03-13 00:00:24', 'sit');


INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (1, 1, 'est', 90);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (2, 2, 'maxime', 131);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (3, 3, 'repudiandae', 149);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (4, 4, 'mollitia', 73);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (5, 5, 'sunt', 161);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (6, 6, 'culpa', 178);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (7, 7, 'et', 18);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (8, 8, 'ut', 137);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (9, 9, 'quisquam', 185);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (10, 10, 'debitis', 101);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (11, 1, 'non', 89);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (12, 2, 'voluptatibus', 169);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (13, 3, 'eos', 181);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (14, 4, 'explicabo', 3);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (15, 5, 'atque', 198);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (16, 6, 'ipsum', 157);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (17, 7, 'cupiditate', 3);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (18, 8, 'et', 26);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (19, 9, 'officiis', 112);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (20, 10, 'architecto', 137);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (21, 1, 'nemo', 97);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (22, 2, 'non', 158);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (23, 3, 'laudantium', 185);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (24, 4, 'inventore', 107);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (25, 5, 'natus', 16);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (26, 6, 'dolor', 147);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (27, 7, 'eum', 14);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (28, 8, 'quia', 200);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (29, 9, 'ad', 171);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (30, 10, 'vitae', 69);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (31, 1, 'assumenda', 114);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (32, 2, 'et', 34);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (33, 3, 'quas', 184);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (34, 4, 'velit', 8);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (35, 5, 'ab', 121);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (36, 6, 'sint', 121);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (37, 7, 'sed', 190);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (38, 8, 'et', 176);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (39, 9, 'asperiores', 145);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (40, 10, 'quia', 134);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (41, 1, 'inventore', 5);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (42, 2, 'sapiente', 120);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (43, 3, 'repellat', 159);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (44, 4, 'ab', 175);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (45, 5, 'corporis', 136);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (46, 6, 'quam', 154);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (47, 7, 'voluptas', 90);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (48, 8, 'reiciendis', 159);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (49, 9, 'saepe', 113);
INSERT INTO `products` (`id`, `catalog_id`, `name`, `cnt`) VALUES (50, 10, 'deserunt', 191);

INSERT INTO `users` (`id`, `name`) VALUES (1, 'ab');
INSERT INTO `users` (`id`, `name`) VALUES (2, 'fuga');
INSERT INTO `users` (`id`, `name`) VALUES (3, 'repellat');
INSERT INTO `users` (`id`, `name`) VALUES (4, 'quod');
INSERT INTO `users` (`id`, `name`) VALUES (5, 'consequatur');
INSERT INTO `users` (`id`, `name`) VALUES (6, 'itaque');
INSERT INTO `users` (`id`, `name`) VALUES (7, 'atque');
INSERT INTO `users` (`id`, `name`) VALUES (8, 'corrupti');
INSERT INTO `users` (`id`, `name`) VALUES (9, 'sunt');
INSERT INTO `users` (`id`, `name`) VALUES (10, 'debitis');
INSERT INTO `users` (`id`, `name`) VALUES (11, 'ut');
INSERT INTO `users` (`id`, `name`) VALUES (12, 'illum');
INSERT INTO `users` (`id`, `name`) VALUES (13, 'expedita');
INSERT INTO `users` (`id`, `name`) VALUES (14, 'illum');
INSERT INTO `users` (`id`, `name`) VALUES (15, 'nemo');
INSERT INTO `users` (`id`, `name`) VALUES (16, 'ut');
INSERT INTO `users` (`id`, `name`) VALUES (17, 'voluptate');
INSERT INTO `users` (`id`, `name`) VALUES (18, 'cupiditate');
INSERT INTO `users` (`id`, `name`) VALUES (19, 'mollitia');
INSERT INTO `users` (`id`, `name`) VALUES (20, 'nihil');
INSERT INTO `users` (`id`, `name`) VALUES (21, 'molestias');
INSERT INTO `users` (`id`, `name`) VALUES (22, 'provident');
INSERT INTO `users` (`id`, `name`) VALUES (23, 'itaque');
INSERT INTO `users` (`id`, `name`) VALUES (24, 'dicta');
INSERT INTO `users` (`id`, `name`) VALUES (25, 'in');
INSERT INTO `users` (`id`, `name`) VALUES (26, 'vitae');
INSERT INTO `users` (`id`, `name`) VALUES (27, 'cupiditate');
INSERT INTO `users` (`id`, `name`) VALUES (28, 'et');
INSERT INTO `users` (`id`, `name`) VALUES (29, 'ut');
INSERT INTO `users` (`id`, `name`) VALUES (30, 'explicabo');
INSERT INTO `users` (`id`, `name`) VALUES (31, 'quos');
INSERT INTO `users` (`id`, `name`) VALUES (32, 'totam');
INSERT INTO `users` (`id`, `name`) VALUES (33, 'commodi');
INSERT INTO `users` (`id`, `name`) VALUES (34, 'cumque');
INSERT INTO `users` (`id`, `name`) VALUES (35, 'ut');
INSERT INTO `users` (`id`, `name`) VALUES (36, 'dolorem');
INSERT INTO `users` (`id`, `name`) VALUES (37, 'architecto');
INSERT INTO `users` (`id`, `name`) VALUES (38, 'ut');
INSERT INTO `users` (`id`, `name`) VALUES (39, 'vel');
INSERT INTO `users` (`id`, `name`) VALUES (40, 'doloremque');
INSERT INTO `users` (`id`, `name`) VALUES (41, 'magni');
INSERT INTO `users` (`id`, `name`) VALUES (42, 'voluptas');
INSERT INTO `users` (`id`, `name`) VALUES (43, 'id');
INSERT INTO `users` (`id`, `name`) VALUES (44, 'facere');
INSERT INTO `users` (`id`, `name`) VALUES (45, 'ex');
INSERT INTO `users` (`id`, `name`) VALUES (46, 'incidunt');
INSERT INTO `users` (`id`, `name`) VALUES (47, 'vel');
INSERT INTO `users` (`id`, `name`) VALUES (48, 'voluptatum');
INSERT INTO `users` (`id`, `name`) VALUES (49, 'sapiente');
INSERT INTO `users` (`id`, `name`) VALUES (50, 'perferendis');
INSERT INTO `users` (`id`, `name`) VALUES (51, 'dolorem');
INSERT INTO `users` (`id`, `name`) VALUES (52, 'accusantium');
INSERT INTO `users` (`id`, `name`) VALUES (53, 'dolor');
INSERT INTO `users` (`id`, `name`) VALUES (54, 'voluptates');
INSERT INTO `users` (`id`, `name`) VALUES (55, 'maxime');
INSERT INTO `users` (`id`, `name`) VALUES (56, 'itaque');
INSERT INTO `users` (`id`, `name`) VALUES (57, 'voluptatem');
INSERT INTO `users` (`id`, `name`) VALUES (58, 'repudiandae');
INSERT INTO `users` (`id`, `name`) VALUES (59, 'ex');
INSERT INTO `users` (`id`, `name`) VALUES (60, 'iusto');
INSERT INTO `users` (`id`, `name`) VALUES (61, 'dolore');
INSERT INTO `users` (`id`, `name`) VALUES (62, 'ea');
INSERT INTO `users` (`id`, `name`) VALUES (63, 'unde');
INSERT INTO `users` (`id`, `name`) VALUES (64, 'molestiae');
INSERT INTO `users` (`id`, `name`) VALUES (65, 'a');
INSERT INTO `users` (`id`, `name`) VALUES (66, 'at');
INSERT INTO `users` (`id`, `name`) VALUES (67, 'id');
INSERT INTO `users` (`id`, `name`) VALUES (68, 'et');
INSERT INTO `users` (`id`, `name`) VALUES (69, 'id');
INSERT INTO `users` (`id`, `name`) VALUES (70, 'quas');
INSERT INTO `users` (`id`, `name`) VALUES (71, 'nostrum');
INSERT INTO `users` (`id`, `name`) VALUES (72, 'voluptas');
INSERT INTO `users` (`id`, `name`) VALUES (73, 'dolor');
INSERT INTO `users` (`id`, `name`) VALUES (74, 'aut');
INSERT INTO `users` (`id`, `name`) VALUES (75, 'exercitationem');
INSERT INTO `users` (`id`, `name`) VALUES (76, 'vel');
INSERT INTO `users` (`id`, `name`) VALUES (77, 'velit');
INSERT INTO `users` (`id`, `name`) VALUES (78, 'iusto');
INSERT INTO `users` (`id`, `name`) VALUES (79, 'non');
INSERT INTO `users` (`id`, `name`) VALUES (80, 'eligendi');
INSERT INTO `users` (`id`, `name`) VALUES (81, 'tempore');
INSERT INTO `users` (`id`, `name`) VALUES (82, 'aspernatur');
INSERT INTO `users` (`id`, `name`) VALUES (83, 'velit');
INSERT INTO `users` (`id`, `name`) VALUES (84, 'minima');
INSERT INTO `users` (`id`, `name`) VALUES (85, 'atque');
INSERT INTO `users` (`id`, `name`) VALUES (86, 'corrupti');
INSERT INTO `users` (`id`, `name`) VALUES (87, 'aut');
INSERT INTO `users` (`id`, `name`) VALUES (88, 'quo');
INSERT INTO `users` (`id`, `name`) VALUES (89, 'a');
INSERT INTO `users` (`id`, `name`) VALUES (90, 'corrupti');
INSERT INTO `users` (`id`, `name`) VALUES (91, 'tempora');
INSERT INTO `users` (`id`, `name`) VALUES (92, 'et');
INSERT INTO `users` (`id`, `name`) VALUES (93, 'est');
INSERT INTO `users` (`id`, `name`) VALUES (94, 'vero');
INSERT INTO `users` (`id`, `name`) VALUES (95, 'necessitatibus');
INSERT INTO `users` (`id`, `name`) VALUES (96, 'cum');
INSERT INTO `users` (`id`, `name`) VALUES (97, 'cupiditate');
INSERT INTO `users` (`id`, `name`) VALUES (98, 'voluptatum');
INSERT INTO `users` (`id`, `name`) VALUES (99, 'quod');
INSERT INTO `users` (`id`, `name`) VALUES (100, 'cum');

SET FOREIGN_KEY_CHECKS=1;

-- Практическое задание по теме “Транзакции, переменные, представления”
-- 1
start transaction;

insert into sample.users (id, name)
select id, name
from shop.users
where (1 = id);

delete from shop.users
where (1 = id);

commit;

select * from sample.users;
select * from shop.users
order by id;

-- 2
create view prod_names as
select t2.name catalog_name, t1.name product_name
from products t1, catalog t2
where (t1.catalog_id = t2.id);

select * from prod_names;

-- 3
-- select date(ordered_at) ordered_at
-- from orderss
-- group by date(ordered_at)
-- order by ordered_at;

with recursive dates (date) as (
  select '2018-07-01'
  union all
  select DATE_ADD(dates.date, INTERVAL 1 DAY)
  from dates
  where (dates.date < '2018-10-01')
)
select t1.date, case when (t2.ordered_at is null) then 0 else 1 end
from dates t1
left outer join (select date(ordered_at) ordered_at
                 from orderss
                 group by date(ordered_at)
                 order by ordered_at) t2 on (t1.date = t2.ordered_at);

-- 4
-- select t1.id, t1.ordered_at, t1.`rank`
-- from (select t1.id
--             ,t1.ordered_at
--             ,DENSE_RANK() OVER (ORDER BY t1.ordered_at DESC)  `rank`
--       from orderss t1) t1
-- where (5 >= t1.`rank`);

select count(*) from orderss;

delete from orderss
where (id not in (select t1.id
                  from (select t1.id, DENSE_RANK() OVER (ORDER BY t1.ordered_at DESC)  `rank`
                        from orderss t1) t1
                  where (5 >= t1.`rank`)));

-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
-- 1
DROP FUNCTION IF EXISTS hello;
DELIMITER $$
CREATE FUNCTION hello (`date` datetime) RETURNS varchar(100) deterministic
BEGIN
  SET `date` = case when (`date` is null) then now() else `date` end;
  return case when hour(`date`) between 6 and 11 then 'Доброе утро'
              when hour(`date`) between 12 and 17 then 'Добрый день'
              when hour(`date`) between 18 and 23 then 'Добрый вечер'
              else 'Доброй ночи' end;
END$$
DELIMITER ;

select hello(null);
select hello('2020-10-10 19:20:50');

-- 2
alter table products add column `description` varchar(200);
desc products;

insert into products (catalog_id, name, `description`, cnt) values (8, null, 'asdasdasd', 10);
insert into products (catalog_id, name, `description`, cnt) values (8, 'asdasdasd', null, 10);
insert into products (catalog_id, name, `description`, cnt) values (8, null, null, 10);

select * from products
where (name is null)
   or (`description` is null);

drop trigger if exists trg_products_ins;
DELIMITER $$
CREATE TRIGGER trg_products_ins BEFORE INSERT ON products FOR EACH ROW
BEGIN
  if (new.name is null) and (new.`description` is null) then
    signal sqlstate '45000' set message_text = 'nulls for name and description not allowed';
  end if;
END$$
DELIMITER ;

insert into products (catalog_id, name, `description`, cnt) values (8, null, null, 10);
update products set name = null where (1 = id);
update products set `description` = null where (1 = id);

drop trigger if exists trg_products_upd;
DELIMITER $$
CREATE TRIGGER trg_products_upd BEFORE update ON products FOR EACH ROW
BEGIN
  if (new.name is null) and (new.`description` is null) then
    signal sqlstate '45000' set message_text = 'nulls for name and description not allowed';
  end if;
END$$
DELIMITER ;

update products set name = null where (2 = id);
update products set `description` = null where (2 = id);

-- 3
DROP FUNCTION IF EXISTS fibonacci;
DELIMITER $$
CREATE FUNCTION fibonacci (num integer) RETURNS integer deterministic
BEGIN
  declare result integer default 0;
  declare `prev` integer default 0;
  declare `last` integer;
  declare i integer default 0;
  while (i <= num) do
    if (1 = i) then
      set result = 1;
    else
      set `last` = result;
      set result = result + `prev`;
      set `prev` = `last`;
    end if;
    set i = i + 1;
  end while;
  return result;
END$$
DELIMITER ;

select fibonacci(10);

