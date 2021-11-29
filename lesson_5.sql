/*
LONGTEXT вместо JSON т.к. версия срвера 5.6.37
*/

-- SELECT VERSION();

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", -- искуственный ключ
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone CHAR(11) NOT NULL UNIQUE COMMENT "Телефон",
  password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи";  

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",  
  gender CHAR(1) NOT NULL COMMENT "Пол",
  birthday DATE COMMENT "Дата рождения",
  photo_id INT UNSIGNED COMMENT "Ссылка на основную фотографию пользователя",
  `status` VARCHAR(30) COMMENT "Текущий статус",
  city VARCHAR(130) COMMENT "Город проживания",
  country VARCHAR(130) COMMENT "Страна проживания",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT 'Таблица профилей';
ALTER TABLE profiles ADD CONSTRAINT profiles_user_id FOREIGN KEY (user_id) REFERENCES users(id);

CREATE TABLE friendship (
	user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя", 
	friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на друга пользователя", 
    request_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип запроса",
	requested_at DATETIME DEFAULT NOW() COMMENT "Время отправления приглашения дружить",
	confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    PRIMARY KEY (user_id, friend_id)
);

ALTER TABLE friendship ADD CONSTRAINT friendship_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT friendship_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);
-- ALTER TABLE friendship ADD CHECK(initiator_user_id <> target_user_id);

CREATE TABLE friendship_request_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название статуса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Типы запроса на дружбы";

ALTER TABLE friendship ADD CONSTRAINT friendship_request_type_id FOREIGN KEY (request_type_id) REFERENCES friendship_request_types(id); 

CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор сроки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Группы";

CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
  PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ"
) COMMENT "Участники групп, связь между пользователями и группами";

ALTER TABLE communities_users ADD CONSTRAINT communities_users_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE communities_users ADD CONSTRAINT communities_users_community_id_id FOREIGN KEY (community_id) REFERENCES communities(id);

CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
  to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
  body TEXT NOT NULL COMMENT "Текст сообщения",
  is_important BOOLEAN COMMENT "Признак важности",
  is_delivered BOOLEAN COMMENT "Признак доставки",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Сообщения";

ALTER TABLE messages ADD CONSTRAINT messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT messages_to_user_id FOREIGN KEY (to_user_id) REFERENCES users(id);

CREATE TABLE media (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
	filename VARCHAR(255) NOT NULL UNIQUE COMMENT "Путь к файлу",
    media_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип файла" ,
    size INT NOT NULL COMMENT "Размер файла",
	media LONGTEXT,
    created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Медиафайлы";
ALTER TABLE profiles ADD CONSTRAINT profiles_photo_id FOREIGN KEY (photo_id) REFERENCES media(id);

CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы медиафайлов";

ALTER TABLE media ADD CONSTRAINT media_media_type_id FOREIGN KEY (media_type_id) REFERENCES media_types(id);

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'voluptate', '1978-02-11 17:41:09', '2013-09-13 05:44:18');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'esse', '2018-06-30 09:45:02', '1978-03-22 13:43:40');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'explicabo', '2016-09-03 22:17:20', '1974-02-02 05:35:23');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (4, 'non', '1977-05-20 08:57:31', '1998-11-24 05:23:41');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (5, 'omnis', '1993-12-26 14:53:32', '2003-03-30 14:29:26');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (6, 'mollitia', '1999-04-25 06:15:46', '2016-11-17 13:32:58');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (7, 'incidunt', '1976-02-19 03:57:15', '1999-01-10 03:58:14');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (8, 'dicta', '1970-11-27 07:42:20', '1973-05-12 02:40:06');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (9, 'totam', '1987-04-10 04:33:26', '1992-03-04 03:49:27');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (10, 'doloremque', '1998-02-05 02:09:20', '2014-12-11 00:46:16');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (11, 'perferendis', '1985-04-17 14:04:38', '2000-11-19 07:58:26');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (12, 'et', '2002-02-20 06:37:08', '2003-05-17 07:22:39');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (13, 'itaque', '2005-08-13 19:43:30', '1973-06-20 12:44:43');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (14, 'sint', '1985-11-27 11:43:46', '2016-01-19 16:24:18');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (15, 'id', '1976-07-17 22:10:54', '2003-08-22 03:44:59');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (16, 'quos', '1978-03-14 21:20:39', '2004-02-24 14:01:21');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (17, 'aperiam', '1984-05-19 08:36:38', '1979-08-12 18:02:52');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (18, 'voluptatem', '1999-05-15 00:04:14', '1973-05-30 23:28:42');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (19, 'in', '1978-10-13 17:38:20', '1987-08-03 19:37:06');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (20, 'neque', '1989-07-05 04:27:50', '1972-06-30 11:11:23');

INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 1, '2017-11-28 04:18:00');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 21, '1973-03-12 02:10:24');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 41, '2004-02-07 08:57:04');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 61, '1979-01-21 16:03:21');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 81, '2004-10-06 01:33:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 2, '2000-01-29 14:56:18');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 22, '2008-10-05 15:23:16');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 42, '1999-10-14 08:05:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 62, '1978-08-26 19:59:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 82, '2012-11-16 02:42:40');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 3, '1984-06-15 03:21:11');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 23, '1997-05-18 19:36:35');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 43, '1980-06-26 19:39:18');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 63, '1981-04-30 14:39:24');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 83, '2009-03-16 00:04:23');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 4, '1978-10-12 02:22:28');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 24, '2009-01-04 15:42:55');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 44, '2007-08-25 02:20:15');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 64, '1972-12-26 00:24:49');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 84, '1994-02-02 07:29:26');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 5, '1970-02-28 11:37:22');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 25, '2001-01-17 05:06:38');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 45, '1971-05-11 13:03:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 65, '1985-02-03 15:07:12');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 85, '2008-02-18 22:12:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 6, '2009-04-24 14:32:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 26, '1994-06-09 22:34:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 46, '2011-07-27 21:51:34');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 66, '1975-03-17 15:33:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 86, '2013-01-02 20:34:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 7, '2012-09-15 20:33:41');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 27, '2001-10-15 23:33:56');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 47, '1973-01-06 08:39:24');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 67, '2004-01-22 21:29:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 87, '2018-12-04 02:26:00');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 8, '2008-09-27 10:10:10');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 28, '1995-06-28 23:53:31');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 48, '2015-02-27 02:36:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 68, '1972-06-05 07:57:38');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 88, '1979-04-21 02:27:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 9, '1991-10-08 02:08:36');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 29, '1982-11-04 18:47:16');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 49, '2002-09-28 16:32:41');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 69, '1974-08-07 09:50:10');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 89, '2005-12-19 05:33:25');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 10, '1998-08-26 10:57:07');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 30, '1989-01-29 01:33:52');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 50, '2008-01-10 21:07:46');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 70, '1999-06-15 15:32:17');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 90, '1999-05-02 02:36:52');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (11, 11, '1973-07-23 20:54:34');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (11, 31, '1972-04-29 15:11:20');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (11, 51, '1970-11-13 22:31:02');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (11, 71, '2020-02-05 22:53:02');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (11, 91, '1971-11-22 18:30:00');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (12, 12, '1980-03-26 18:57:24');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (12, 32, '2004-08-27 19:57:49');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (12, 52, '1991-12-17 13:37:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (12, 72, '1982-09-09 06:33:11');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (12, 92, '1985-04-18 18:45:11');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (13, 13, '1985-06-06 10:56:37');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (13, 33, '2005-07-26 00:23:37');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (13, 53, '2005-05-14 06:14:03');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (13, 73, '1989-05-21 12:27:25');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (13, 93, '1982-03-23 23:21:41');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (14, 14, '1978-02-15 15:32:29');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (14, 34, '1976-07-12 07:45:05');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (14, 54, '1983-07-23 06:06:18');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (14, 74, '2012-10-03 17:42:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (14, 94, '1970-03-07 14:54:21');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (15, 15, '1988-12-23 13:03:05');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (15, 35, '1986-12-28 13:23:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (15, 55, '1975-09-26 14:40:37');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (15, 75, '2005-06-20 12:36:30');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (15, 95, '1982-10-24 20:41:36');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (16, 16, '1985-09-01 07:25:34');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (16, 36, '1993-03-25 20:37:31');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (16, 56, '1978-06-02 23:04:47');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (16, 76, '1990-02-01 00:43:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (16, 96, '1990-03-20 15:43:21');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (17, 17, '2005-02-21 18:26:54');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (17, 37, '1987-06-19 10:03:46');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (17, 57, '1974-04-15 02:56:16');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (17, 77, '2007-12-26 18:20:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (17, 97, '1982-03-25 03:30:44');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (18, 18, '1989-05-02 18:02:23');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (18, 38, '1983-05-18 07:47:19');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (18, 58, '2018-03-19 11:34:55');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (18, 78, '1973-05-11 07:57:10');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (18, 98, '1986-01-19 03:51:31');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (19, 19, '2010-03-03 06:17:21');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (19, 39, '1998-08-20 19:05:22');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (19, 59, '1975-10-15 05:33:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (19, 79, '1997-06-02 10:50:00');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (19, 99, '1979-02-15 11:38:59');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (20, 20, '1981-11-26 01:30:19');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (20, 40, '2000-09-01 03:37:05');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (20, 60, '2001-01-09 22:51:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (20, 80, '1970-12-17 06:32:00');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (20, 100, '2009-01-23 20:40:28');

INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (1, 1, 1, '1981-08-06 23:27:36', '1981-10-20 11:15:20', '2001-05-24 20:36:01', '1983-12-04 06:25:22');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (2, 2, 2, '2020-09-28 19:14:31', '1973-01-04 10:10:52', '2016-06-02 00:01:32', '2015-07-13 22:13:48');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (3, 3, 3, '1976-07-27 17:41:27', '2018-12-31 05:59:05', '1982-06-30 20:20:03', '1972-01-21 05:10:30');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (4, 4, 4, '2014-07-07 10:13:23', '1989-05-12 08:48:39', '1977-03-28 22:16:35', '1995-04-03 05:52:03');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (5, 5, 1, '1991-08-10 10:03:48', '1985-08-22 04:51:40', '1994-02-09 04:33:29', '1988-04-21 17:43:45');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (6, 6, 2, '2016-03-16 09:29:47', '2008-06-03 04:48:48', '2019-10-13 15:20:19', '1983-12-08 14:21:35');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (7, 7, 3, '2007-02-24 07:52:17', '2005-08-27 21:32:09', '1979-01-16 19:47:12', '1992-05-07 17:03:19');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (8, 8, 4, '2020-08-30 19:10:03', '1976-07-11 15:29:27', '2007-07-07 23:52:52', '2012-08-04 00:41:53');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (9, 9, 1, '1987-02-17 12:35:42', '1987-10-06 02:28:25', '2007-11-10 13:32:47', '1975-09-30 17:34:35');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (10, 10, 2, '1987-05-15 07:58:49', '1999-02-08 21:04:29', '1987-09-21 20:44:43', '2012-07-11 03:23:03');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (11, 11, 3, '1985-02-15 10:16:33', '1985-10-20 18:53:56', '1972-05-10 07:31:29', '1987-09-17 03:06:01');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (12, 12, 4, '2017-01-23 20:00:05', '2005-07-14 18:14:38', '1983-01-06 14:03:56', '1990-09-23 01:54:45');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (13, 13, 1, '2002-12-11 18:44:06', '1973-09-19 18:06:31', '2018-12-04 12:36:14', '1979-05-31 01:28:09');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (14, 14, 2, '1991-05-26 00:42:05', '2007-03-03 01:22:50', '1984-12-27 12:26:25', '1997-09-04 06:48:32');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (15, 15, 3, '1994-01-21 10:04:47', '2002-12-19 13:19:48', '2014-12-19 14:35:10', '1974-04-18 03:21:27');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (16, 16, 4, '1975-12-28 18:40:44', '2007-02-24 22:45:26', '1989-03-28 00:17:48', '2007-12-25 10:22:28');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (17, 17, 1, '1998-11-16 01:20:03', '1991-12-11 16:34:09', '1977-05-26 17:32:30', '2021-02-13 21:42:58');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (18, 18, 2, '1984-05-14 20:34:35', '1974-11-13 17:45:36', '2012-03-16 09:43:17', '2000-07-24 16:20:29');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (19, 19, 3, '2000-01-25 23:03:58', '2007-08-09 03:54:23', '2019-10-30 18:16:09', '2017-08-01 04:27:12');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (20, 20, 4, '1987-09-08 06:19:28', '1985-03-02 04:07:46', '2006-09-17 04:06:32', '2008-06-25 11:34:43');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (21, 21, 1, '2000-10-04 22:25:45', '2007-04-04 08:42:51', '1994-07-31 19:50:29', '1977-06-23 15:49:42');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (22, 22, 2, '2000-11-22 10:35:54', '2002-08-25 07:23:12', '1991-08-23 19:50:10', '1998-11-04 14:41:10');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (23, 23, 3, '1971-09-01 09:20:12', '2008-03-06 14:08:49', '1986-07-16 05:34:28', '1993-02-21 23:05:33');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (24, 24, 4, '1990-07-17 01:06:21', '1979-09-15 10:24:46', '2009-05-10 15:35:25', '2012-09-30 19:18:12');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (25, 25, 1, '2021-06-26 13:09:09', '2004-05-21 07:02:28', '1991-04-04 12:45:42', '2007-07-24 20:56:01');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (26, 26, 2, '2013-01-03 04:43:10', '1993-05-24 18:21:55', '1992-06-28 00:46:33', '2001-07-04 18:43:26');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (27, 27, 3, '2014-07-10 14:07:16', '1981-11-10 06:45:13', '2010-10-26 16:25:22', '1973-03-19 00:26:47');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (28, 28, 4, '1982-04-26 13:47:18', '2018-02-24 01:32:25', '1990-08-14 04:41:18', '1993-12-20 13:41:06');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (29, 29, 1, '1990-02-21 19:03:14', '1980-03-24 17:10:34', '1972-07-25 08:10:34', '2003-08-17 07:19:10');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (30, 30, 2, '1983-10-25 00:03:40', '2015-06-18 08:09:06', '1998-11-12 15:23:21', '2018-10-31 11:08:15');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (31, 31, 3, '2011-11-19 06:58:54', '1987-05-29 01:27:44', '1972-07-20 17:39:56', '1987-12-04 20:02:40');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (32, 32, 4, '2000-11-14 15:49:35', '1988-06-04 17:57:18', '1980-05-13 20:15:14', '1979-01-10 08:42:14');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (33, 33, 1, '1977-12-21 07:00:07', '2017-02-04 04:07:21', '1970-04-03 16:25:19', '2017-01-06 21:52:50');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (34, 34, 2, '2012-03-20 04:14:17', '1973-01-09 09:21:12', '1986-10-16 12:40:57', '1982-09-05 04:04:23');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (35, 35, 3, '1970-12-24 14:05:09', '2010-07-28 10:29:23', '1994-06-19 05:18:10', '1989-05-04 15:31:58');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (36, 36, 4, '1987-12-13 05:55:45', '1970-07-22 15:51:49', '2001-07-24 22:58:44', '1978-12-26 13:25:29');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (37, 37, 1, '2012-03-17 00:11:02', '2018-01-16 13:54:07', '1976-03-17 21:16:52', '1991-08-28 14:12:43');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (38, 38, 2, '2006-11-03 05:56:25', '1972-03-18 06:27:43', '1989-08-13 11:56:24', '2021-10-05 20:07:51');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (39, 39, 3, '2015-05-06 00:49:00', '1997-12-15 14:34:30', '1981-08-26 06:32:18', '1991-11-23 03:55:38');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (40, 40, 4, '1994-01-11 18:02:57', '1985-06-22 03:22:59', '1982-06-08 12:52:00', '1995-07-24 04:26:59');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (41, 41, 1, '1998-08-04 17:19:02', '1989-11-25 02:48:06', '2019-01-11 09:59:29', '2017-10-07 00:00:17');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (42, 42, 2, '2008-04-04 11:08:32', '1981-07-14 14:23:10', '2002-10-13 15:25:53', '2020-01-27 11:18:25');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (43, 43, 3, '1982-02-05 16:36:42', '2013-04-17 00:25:25', '2012-07-16 00:55:31', '1973-04-26 12:55:56');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (44, 44, 4, '1993-03-22 18:14:03', '2011-12-04 22:58:30', '1985-12-13 05:21:09', '2007-11-24 09:05:57');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (45, 45, 1, '2006-05-07 06:47:52', '1999-08-24 17:38:27', '2007-03-30 21:04:44', '2000-06-30 17:55:26');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (46, 46, 2, '2016-02-24 03:59:06', '2012-04-29 11:20:53', '1999-05-14 08:08:51', '1989-12-18 15:10:36');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (47, 47, 3, '1977-11-22 20:15:19', '1980-05-23 21:55:01', '1988-04-17 16:20:42', '2003-09-02 01:55:45');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (48, 48, 4, '1977-03-31 17:00:28', '2015-09-01 06:43:21', '1978-12-21 13:57:13', '1982-04-04 07:34:47');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (49, 49, 1, '2000-05-31 16:59:02', '1992-02-01 22:41:27', '2000-01-29 05:09:08', '1992-08-14 18:14:09');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (50, 50, 2, '1984-05-30 05:59:30', '1998-07-16 21:42:24', '1994-05-08 15:03:41', '2010-02-04 02:40:52');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (51, 51, 3, '1971-05-11 21:21:47', '1989-11-16 05:16:12', '2011-06-18 14:33:37', '1977-10-05 16:30:24');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (52, 52, 4, '1984-08-13 15:04:39', '2006-03-27 21:47:13', '2006-05-15 02:58:50', '2018-07-04 23:50:54');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (53, 53, 1, '2017-03-29 22:45:57', '2003-08-28 23:50:53', '1986-04-19 00:59:12', '1987-06-22 02:14:30');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (54, 54, 2, '2011-03-09 19:13:33', '1991-10-29 09:12:04', '1983-02-03 18:33:44', '2021-03-26 08:16:34');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (55, 55, 3, '1971-06-05 20:46:16', '2010-10-26 22:05:17', '1971-05-21 02:12:07', '1990-09-30 19:52:25');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (56, 56, 4, '1987-12-04 01:27:55', '2011-10-20 21:15:30', '1979-10-02 23:48:04', '1982-08-06 00:19:51');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (57, 57, 1, '2017-11-24 19:33:11', '1987-02-22 08:32:40', '2014-08-12 14:30:10', '1972-12-15 10:23:15');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (58, 58, 2, '2008-10-20 21:51:37', '2014-05-19 09:02:05', '2012-06-01 05:27:24', '2011-08-16 20:01:39');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (59, 59, 3, '1999-12-23 11:52:27', '1999-10-03 07:23:54', '1996-09-11 16:10:38', '2018-01-03 19:58:54');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (60, 60, 4, '2016-06-21 05:35:54', '2017-03-04 01:11:54', '1984-09-25 10:18:29', '1991-02-26 00:59:04');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (61, 61, 1, '1976-05-11 21:46:54', '1970-05-25 18:12:42', '2017-12-18 23:47:14', '2016-03-21 10:15:43');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (62, 62, 2, '1991-10-02 01:11:38', '1994-05-17 22:28:15', '2003-04-14 09:43:02', '1983-02-14 09:32:50');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (63, 63, 3, '1971-02-04 01:16:54', '2012-09-26 01:17:45', '1999-01-16 16:54:37', '2000-02-24 03:27:05');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (64, 64, 4, '1996-09-10 03:11:29', '2011-01-06 04:05:15', '1975-07-01 19:16:27', '1997-01-26 17:00:58');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (65, 65, 1, '1990-01-02 03:05:07', '1981-07-08 19:48:54', '1998-04-25 14:18:55', '1979-09-14 13:30:39');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (66, 66, 2, '2020-09-18 04:26:07', '2014-01-30 11:40:29', '1988-10-03 23:00:38', '1989-09-28 22:01:25');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (67, 67, 3, '1997-12-30 17:40:44', '1992-11-12 11:43:51', '1974-03-23 03:21:10', '2008-04-03 18:43:49');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (68, 68, 4, '1975-06-21 07:51:16', '1984-05-22 06:20:16', '1990-04-21 19:01:23', '2018-01-01 02:18:31');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (69, 69, 1, '1999-01-18 09:22:20', '1973-04-19 09:18:43', '2014-01-04 11:11:40', '2004-04-30 10:23:11');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (70, 70, 2, '2021-08-10 01:42:46', '2005-02-15 08:38:43', '1974-12-23 09:12:36', '1974-07-02 06:31:16');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (71, 71, 3, '1979-04-15 02:07:56', '1998-11-09 09:17:55', '1970-06-08 13:40:24', '1988-01-20 06:42:52');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (72, 72, 4, '1998-03-15 13:55:02', '1988-02-04 15:40:34', '2012-04-18 12:17:44', '2013-03-01 22:40:06');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (73, 73, 1, '2016-07-18 22:05:14', '1991-12-25 13:15:49', '1972-08-28 00:42:29', '1988-12-02 06:34:29');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (74, 74, 2, '2014-05-17 10:39:38', '1971-10-15 22:34:50', '2007-12-13 16:06:04', '2011-03-16 17:17:19');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (75, 75, 3, '2019-01-14 11:30:18', '2019-08-11 19:11:24', '1999-11-01 09:50:44', '1981-01-27 15:22:57');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (76, 76, 4, '1990-10-13 14:16:54', '2007-04-27 18:07:52', '1971-02-27 00:22:31', '2008-05-27 01:35:35');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (77, 77, 1, '2018-07-13 15:31:28', '1971-04-02 02:40:29', '1992-08-07 08:45:39', '1978-10-01 02:40:16');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (78, 78, 2, '2020-01-25 21:05:06', '2000-04-16 23:02:25', '1998-06-29 02:45:13', '2012-02-24 02:51:57');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (79, 79, 3, '1996-04-16 11:55:05', '1983-07-09 21:50:17', '1996-11-27 13:26:59', '1975-08-31 06:12:34');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (80, 80, 4, '1991-09-07 09:39:35', '1982-08-22 07:27:12', '1985-01-17 18:33:27', '1976-08-16 17:32:17');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (81, 81, 1, '2019-09-06 09:21:05', '2007-12-29 22:12:08', '2004-11-07 13:10:36', '2000-11-10 23:53:40');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (82, 82, 2, '2002-01-21 01:28:39', '2004-09-12 19:56:16', '1985-05-12 12:36:32', '1997-09-27 02:43:48');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (83, 83, 3, '2017-03-29 01:46:28', '2001-10-06 12:42:24', '1976-11-06 06:40:03', '1971-10-23 08:38:39');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (84, 84, 4, '1975-06-11 20:33:09', '1998-10-05 19:56:06', '1982-11-27 03:20:29', '1978-12-21 01:44:48');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (85, 85, 1, '2014-01-27 18:51:37', '1981-02-20 14:15:36', '1996-02-24 12:51:27', '1990-09-27 01:18:36');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (86, 86, 2, '1985-01-25 17:26:29', '1995-12-06 07:59:10', '1978-11-09 07:25:58', '1971-12-17 21:15:37');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (87, 87, 3, '2002-04-26 19:43:19', '1997-10-06 13:31:57', '1980-01-17 09:51:35', '2001-08-06 22:07:43');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (88, 88, 4, '1973-11-04 21:08:45', '1976-11-24 22:19:29', '2006-08-27 20:58:10', '1971-05-04 09:57:03');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (89, 89, 1, '2013-10-28 13:20:07', '1997-12-23 01:50:01', '1997-11-10 06:33:48', '1975-02-03 22:06:11');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (90, 90, 2, '1989-01-01 04:06:08', '1984-03-13 05:09:42', '1990-07-02 16:28:28', '2013-12-26 13:50:10');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (91, 91, 3, '2009-04-07 02:43:26', '1976-02-28 04:09:33', '1998-10-01 03:55:23', '2019-04-16 01:13:33');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (92, 92, 4, '1995-01-01 19:30:54', '1975-01-09 21:18:52', '1972-03-13 19:18:37', '1997-09-27 16:47:14');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (93, 93, 1, '2016-07-07 21:17:50', '1991-06-23 21:54:42', '2021-10-06 23:39:57', '2009-06-27 17:17:22');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (94, 94, 2, '1973-11-22 06:20:01', '2001-06-03 08:09:58', '2012-01-07 18:22:48', '1971-01-16 16:01:00');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (95, 95, 3, '1980-02-12 15:46:37', '1990-12-24 00:26:04', '1973-06-19 21:38:25', '1982-11-17 03:02:05');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (96, 96, 4, '2020-02-01 20:12:38', '1984-10-30 10:45:15', '2021-02-06 18:59:09', '2005-10-18 17:12:22');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (97, 97, 1, '1999-10-15 06:46:53', '2009-04-30 07:05:18', '1987-05-26 13:01:14', '1994-08-05 01:49:04');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (98, 98, 2, '1985-12-24 08:53:42', '1991-06-05 21:03:54', '2017-03-24 11:46:21', '2009-01-28 07:01:27');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (99, 99, 3, '2010-11-08 06:08:22', '1982-04-08 15:42:41', '2015-05-20 09:28:05', '2000-08-13 01:28:59');
INSERT INTO `friendship` (`user_id`, `friend_id`, `request_type_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (100, 100, 4, '1978-06-12 14:06:46', '2015-06-23 23:22:03', '2010-06-14 12:05:19', '2009-12-17 03:19:48');

-- http://filldb.info заполнил как initiator_user_id = target_user_id, увеличиваем target_user_id на 1
update friendship set friend_id = friend_id + 1 where friend_id <> 100;
-- запись где initiator_user_id = 197 удаляем
delete from friendship where friend_id = 100;
-- восстанавливаем условие target_user_id <> target_user_id
ALTER TABLE friendship ADD CHECK(user_id <> friend_id);

INSERT INTO `friendship_request_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'request', '1986-12-23 16:10:51', '1978-08-09 03:30:12');
INSERT INTO `friendship_request_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'approved', '2009-02-12 17:23:59', '2000-06-09 15:00:08');
INSERT INTO `friendship_request_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'declined', '1987-03-09 08:56:21', '1992-08-16 22:20:49');
INSERT INTO `friendship_request_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (4, 'unfrended', '1981-10-31 11:10:43', '1988-09-04 18:04:05');

INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (1, 'ipsa', 1, 5059265, NULL, '2003-04-17 15:08:28', '1996-10-20 20:04:18');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (2, 'libero', 2, 965513, NULL, '2019-09-29 08:09:58', '1992-10-11 03:02:02');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (3, 'voluptas', 3, 877600, NULL, '1971-05-22 00:36:45', '1996-10-08 03:54:57');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (4, 'sed', 4, 7264, NULL, '1988-05-19 03:27:40', '2001-09-02 04:46:19');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (5, 'et', 5, 0, NULL, '1995-05-11 03:05:28', '1976-11-11 15:36:21');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (6, 'accusamus', 1, 6636250, NULL, '1971-05-13 09:48:24', '1971-03-02 22:39:10');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (7, 'facilis', 2, 9129, NULL, '2015-04-07 11:40:11', '1998-10-14 14:56:20');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (8, 'necessitatibus', 3, 5, NULL, '2012-03-18 21:05:25', '2002-09-18 20:37:13');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (9, 'aut', 4, 5096253, NULL, '1975-03-27 03:56:33', '1979-09-02 22:00:40');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (10, 'repellat', 5, 0, NULL, '1991-05-11 20:35:04', '2001-12-05 04:53:23');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (11, 'fugiat', 1, 44607, NULL, '1986-03-09 09:07:11', '2013-03-16 18:44:53');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (12, 'qui', 2, 56603195, NULL, '1989-08-02 07:29:49', '1981-07-11 13:16:27');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (13, 'minima', 3, 8778, NULL, '2000-07-20 04:14:32', '1990-12-13 19:46:08');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (14, 'recusandae', 4, 6719, NULL, '1985-12-28 06:59:17', '1974-07-05 13:37:16');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (15, 'minus', 5, 327866, NULL, '1999-07-19 17:00:09', '2010-11-06 01:40:22');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (16, 'omnis', 1, 0, NULL, '1991-06-01 03:28:25', '2007-03-07 09:22:20');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (17, 'repudiandae', 2, 775128, NULL, '2015-12-13 06:39:38', '1971-11-26 10:29:51');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (18, 'ut', 3, 349041, NULL, '1979-10-24 06:16:54', '2008-02-01 00:43:46');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (19, 'esse', 4, 511, NULL, '1992-01-16 05:07:11', '2009-09-23 20:02:39');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (20, 'eligendi', 5, 2, NULL, '1975-03-16 07:09:11', '2010-06-24 11:29:06');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (21, 'eum', 1, 1491, NULL, '1978-08-26 08:25:38', '1983-08-17 07:29:34');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (22, 'aspernatur', 2, 8084289, NULL, '1992-03-04 00:39:26', '1972-08-18 18:08:01');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (23, 'dolores', 3, 2, NULL, '2021-05-14 18:11:37', '2000-06-20 14:43:12');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (24, 'voluptatem', 4, 798135, NULL, '1977-07-23 19:52:07', '2007-10-01 19:21:57');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (25, 'officia', 5, 42041930, NULL, '1973-04-29 04:15:51', '2012-01-13 00:57:25');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (26, 'veniam', 1, 5313292, NULL, '1995-03-16 05:54:46', '2010-08-28 12:12:33');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (27, 'laudantium', 2, 21, NULL, '1982-04-26 04:35:38', '1996-02-16 07:09:17');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (28, 'in', 3, 115733778, NULL, '1979-06-29 03:57:35', '2005-05-13 18:05:36');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (29, 'commodi', 4, 711, NULL, '1985-11-11 04:59:01', '1974-02-08 12:38:34');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (30, 'ex', 5, 69674, NULL, '2000-02-27 13:07:14', '1989-04-21 15:37:16');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (31, 'maxime', 1, 9656, NULL, '2020-04-07 21:37:28', '1973-02-15 04:35:09');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (32, 'tempora', 2, 47185, NULL, '2012-12-31 02:46:18', '1988-04-23 09:56:06');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (33, 'consequatur', 3, 99442, NULL, '1994-06-23 05:45:52', '1980-06-28 14:36:16');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (34, 'est', 4, 603702411, NULL, '1978-02-17 02:42:42', '2012-01-24 02:38:54');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (35, 'excepturi', 5, 5009842, NULL, '1995-04-03 23:21:42', '2021-02-02 11:49:10');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (36, 'facere', 1, 9, NULL, '1975-12-01 05:10:12', '2017-07-24 18:30:56');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (37, 'sunt', 2, 0, NULL, '1985-10-09 00:43:36', '1974-10-21 10:28:47');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (38, 'deserunt', 3, 56628129, NULL, '1971-01-06 20:50:24', '2016-11-12 23:08:36');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (39, 'aliquam', 4, 189, NULL, '2004-06-20 06:03:08', '2020-07-16 15:24:31');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (40, 'quaerat', 5, 946874, NULL, '2014-03-23 02:47:07', '2011-11-16 05:05:06');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (41, 'nihil', 1, 99, NULL, '1978-06-11 04:17:56', '1973-02-28 17:21:19');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (42, 'illo', 2, 27364, NULL, '1987-08-19 01:25:01', '1986-01-31 02:47:50');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (43, 'rerum', 3, 681, NULL, '2007-06-14 00:14:29', '2015-10-27 03:47:12');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (44, 'quo', 4, 170, NULL, '2002-04-28 01:03:52', '2018-01-28 09:00:22');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (45, 'laborum', 5, 52571, NULL, '2016-10-04 16:35:06', '2001-11-13 13:28:52');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (46, 'quam', 1, 650305, NULL, '2019-01-04 15:33:10', '2015-02-19 06:59:56');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (47, 'corporis', 2, 498, NULL, '1981-05-29 10:26:53', '1991-12-28 17:38:25');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (48, 'consectetur', 3, 3754, NULL, '1986-05-13 06:03:59', '1973-01-29 16:56:48');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (49, 'possimus', 4, 9354504, NULL, '2019-05-28 13:57:53', '2011-06-23 18:52:43');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (50, 'eius', 5, 298981, NULL, '1972-12-25 11:49:44', '1993-12-18 06:07:14');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (51, 'repellendus', 1, 392, NULL, '1979-09-25 07:43:07', '1992-08-18 08:29:36');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (52, 'praesentium', 2, 76648210, NULL, '2008-10-10 18:55:18', '2017-02-01 21:51:05');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (53, 'perferendis', 3, 0, NULL, '2011-09-11 18:27:28', '1971-03-14 16:04:14');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (54, 'explicabo', 4, 0, NULL, '1993-11-26 12:03:56', '2021-06-30 12:34:10');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (55, 'dolor', 5, 4767728, NULL, '1995-03-14 17:28:01', '2011-04-06 05:19:18');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (56, 'totam', 1, 98291737, NULL, '1991-11-20 02:34:51', '2012-03-23 21:44:45');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (57, 'molestiae', 2, 7516201, NULL, '1976-08-15 10:27:06', '2020-07-18 23:36:38');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (58, 'expedita', 3, 850, NULL, '2006-06-08 09:44:51', '1980-01-16 20:17:20');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (59, 'magnam', 4, 5886, NULL, '2009-08-21 18:14:08', '1977-12-09 22:03:08');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (60, 'ratione', 5, 6, NULL, '1973-09-13 05:57:36', '1981-11-10 23:26:57');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (61, 'sit', 1, 7388, NULL, '2003-09-30 15:28:16', '2000-06-23 23:58:12');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (62, 'corrupti', 2, 0, NULL, '1994-10-18 04:35:50', '1970-06-24 19:18:34');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (63, 'a', 3, 321944, NULL, '1975-07-18 11:02:27', '2012-10-04 13:47:15');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (64, 'quia', 4, 362, NULL, '2001-10-16 12:28:18', '1982-08-19 02:58:25');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (65, 'molestias', 5, 0, NULL, '2004-03-31 13:41:51', '1971-12-01 10:26:00');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (66, 'exercitationem', 1, 7, NULL, '1985-05-19 10:28:38', '1977-03-25 11:28:20');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (67, 'culpa', 2, 64, NULL, '2016-05-22 16:41:59', '1984-03-20 03:01:37');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (68, 'saepe', 3, 1, NULL, '1977-05-08 00:48:16', '2016-09-27 17:44:25');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (69, 'officiis', 4, 9982162, NULL, '1991-04-05 07:30:58', '1976-11-24 01:10:59');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (70, 'voluptates', 5, 45334571, NULL, '1981-04-30 02:05:47', '1989-09-10 17:55:30');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (71, 'ab', 1, 5133, NULL, '2000-12-10 09:45:26', '1986-03-06 08:41:27');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (72, 'earum', 2, 4370453, NULL, '2015-07-21 17:48:29', '2009-05-27 15:06:51');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (73, 'reiciendis', 3, 616008, NULL, '2008-09-03 00:42:23', '1971-01-26 04:05:14');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (74, 'cupiditate', 4, 4961, NULL, '1974-05-12 08:26:41', '1996-07-25 12:56:12');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (75, 'non', 5, 40, NULL, '1986-02-13 13:19:58', '2008-10-18 16:15:03');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (76, 'odio', 1, 2622, NULL, '2007-11-15 10:42:33', '1973-12-13 05:59:22');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (77, 'vero', 2, 3696, NULL, '1983-10-07 15:31:39', '1991-01-04 21:39:50');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (78, 'blanditiis', 3, 5003287, NULL, '1997-11-02 13:11:45', '1986-09-24 06:48:32');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (79, 'ea', 4, 693134187, NULL, '2020-11-03 14:37:27', '1995-02-11 00:43:24');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (80, 'dolorem', 5, 2496153, NULL, '2012-04-28 00:57:02', '2019-12-16 01:39:34');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (81, 'delectus', 1, 6624, NULL, '1984-05-27 01:19:55', '1974-05-12 01:41:56');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (82, 'id', 2, 2538, NULL, '1975-05-31 23:15:03', '2009-01-08 23:15:01');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (83, 'ipsum', 3, 0, NULL, '2004-03-05 00:40:30', '2008-03-16 18:34:56');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (84, 'velit', 4, 143732, NULL, '2009-04-04 11:14:32', '1984-01-30 07:02:32');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (85, 'fuga', 5, 35028736, NULL, '1997-09-10 00:24:20', '1997-12-29 20:18:42');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (86, 'dolorum', 1, 29310, NULL, '1975-06-09 12:25:50', '2008-08-11 15:06:44');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (87, 'beatae', 2, 7, NULL, '1976-01-06 15:44:12', '1992-04-10 17:25:43');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (88, 'ducimus', 3, 22423, NULL, '2008-09-26 12:33:48', '2003-10-24 23:14:18');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (89, 'cum', 4, 7, NULL, '1991-07-26 18:53:06', '1998-08-04 19:45:16');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (90, 'harum', 5, 7, NULL, '1986-12-07 08:58:09', '1974-01-02 07:46:16');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (91, 'eveniet', 1, 93858, NULL, '2019-07-19 11:21:04', '1985-04-20 19:26:50');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (92, 'debitis', 2, 923386, NULL, '1977-06-22 10:48:56', '1994-01-05 22:33:38');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (93, 'occaecati', 3, 0, NULL, '2019-10-02 16:15:44', '1991-06-08 13:23:07');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (94, 'alias', 4, 67898, NULL, '1998-02-25 15:03:33', '2009-04-18 14:09:18');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (95, 'placeat', 5, 0, NULL, '1981-04-26 07:59:53', '1984-12-17 20:53:46');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (96, 'nostrum', 1, 769064391, NULL, '1974-10-09 04:22:29', '1977-12-28 05:41:19');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (97, 'quas', 2, 6, NULL, '1985-02-23 05:22:07', '1975-05-05 13:27:10');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (98, 'sequi', 3, 9, NULL, '1988-10-20 04:15:40', '1978-11-16 11:30:58');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (99, 'autem', 4, 0, NULL, '2011-10-10 21:31:54', '1987-08-10 15:39:18');
INSERT INTO `media` (`id`, `filename`, `media_type_id`, `size`, `media`, `created_at`, `updated_at`) VALUES (100, 'nisi', 5, 0, NULL, '2012-04-06 06:02:05', '1998-05-18 07:12:23');

INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'text', '1999-04-04 04:20:27', '2001-04-10 08:28:25');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'jpg', '1991-04-11 10:11:51', '1994-03-10 21:10:30');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'gif', '1983-11-02 19:32:13', '2020-01-10 20:09:54');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (4, 'video', '2007-06-23 15:26:56', '2003-09-09 23:00:49');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (5, 'audio', '2010-11-10 03:13:13', '2014-06-07 17:31:45');

INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (1, 1, 1, 'Libero harum voluptatem voluptatem corrupti occaecati sit. Voluptas ut qui recusandae. Temporibus repudiandae explicabo dignissimos voluptatem ipsa enim fuga.', 0, 0, '2007-09-10 15:51:35', '2020-02-19 18:08:14');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (2, 2, 2, 'Minima necessitatibus ab ut sit eligendi fugiat. Necessitatibus quo quisquam vitae eos sed. Non fuga quis accusantium ratione consequatur ad.', 1, 1, '2018-02-22 15:23:43', '2020-03-26 17:27:01');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (3, 3, 3, 'At ipsa dolor provident voluptatibus labore. Sunt explicabo culpa perspiciatis blanditiis veritatis. Ducimus nostrum sunt animi dolorum facere quos nam. Non est voluptas maxime ut ut aut quis itaque.', 1, 1, '2008-03-28 11:17:36', '1977-04-05 14:08:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (4, 4, 4, 'Doloribus officiis dolore quibusdam cupiditate unde accusamus. Voluptas illum voluptate fugit adipisci velit illo.', 0, 1, '2018-02-12 04:04:40', '1995-10-22 05:50:03');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (5, 5, 5, 'Nihil voluptatem non veniam molestias ea possimus est et. Adipisci suscipit ullam a eligendi pariatur.', 1, 1, '1996-07-23 00:00:47', '2020-03-07 10:00:16');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (6, 6, 6, 'Sequi soluta molestiae fuga aspernatur ea soluta fugit. Explicabo et velit quam error. Eos qui autem doloribus. Labore blanditiis excepturi ullam hic nesciunt.', 0, 1, '1982-06-03 23:34:53', '1994-02-08 09:48:37');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (7, 7, 7, 'Sint vitae facere nam mollitia vel. Blanditiis quae voluptate sunt ut perferendis qui fugiat quidem. Possimus in repellendus explicabo quis voluptatem a quia. Tempora est quisquam iste.', 0, 1, '1984-06-24 17:53:18', '2002-12-11 12:55:24');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (8, 8, 8, 'Cum molestiae dolorem modi repudiandae dolores. Doloribus omnis consectetur reiciendis harum minus. Totam voluptas expedita omnis eligendi.', 1, 0, '1998-11-14 06:54:01', '2010-05-20 09:13:30');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (9, 9, 9, 'Et molestiae est consequatur eum enim in. Quidem qui nulla harum recusandae eaque magnam odio.', 1, 1, '2002-03-10 12:00:27', '2011-03-20 09:35:55');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (10, 10, 10, 'Dolorem aliquid amet maiores non quo ab. Omnis sequi non optio ipsum fugit eos nihil. Aut enim quos est sunt non sit hic.', 1, 1, '1970-10-10 12:46:23', '2015-06-14 17:09:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (11, 11, 11, 'Facilis ullam cupiditate rerum ad sed. Dolores earum non libero ea doloremque maxime sint. Et nostrum est aperiam voluptas. Corrupti dolor reprehenderit aut aspernatur quaerat.', 0, 0, '1997-06-26 12:56:36', '1993-05-30 01:42:53');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (12, 12, 12, 'Perspiciatis distinctio sequi dicta assumenda est nostrum fugit tempora. Non illum quo ut dolores voluptatem modi. Eius sed tempora asperiores tempora qui libero aliquid ratione. Suscipit libero qui accusamus cupiditate laboriosam.', 1, 0, '2002-09-18 21:49:41', '1983-07-05 17:34:02');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (13, 13, 13, 'Aut aperiam maxime magnam harum nisi voluptas. Dolor sed fugiat repellendus molestiae reiciendis numquam dicta. Quia rerum architecto cumque distinctio distinctio ratione. Doloribus earum ut qui.', 0, 0, '1974-02-25 17:44:43', '1987-10-12 12:07:04');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (14, 14, 14, 'Est deleniti nam culpa sit earum. Est est omnis sit accusantium et excepturi autem. Id saepe enim qui veniam.', 1, 0, '1972-01-07 05:23:23', '2005-07-18 15:16:33');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (15, 15, 15, 'Quae nemo aliquam aut quasi rem molestias totam. Magnam maiores eligendi nihil.', 1, 1, '1972-04-20 05:58:26', '2011-01-21 09:51:06');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (16, 16, 16, 'Et est et consequatur. Excepturi ipsa odio autem doloremque aliquid doloremque. Recusandae nobis natus minus rem eius ea.', 1, 0, '1974-05-13 10:57:47', '2011-06-15 03:22:47');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (17, 17, 17, 'Alias aliquid consectetur aut eum accusamus id rerum. Animi placeat aperiam quia sit labore.', 0, 0, '1988-01-08 01:14:05', '2020-06-09 05:10:23');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (18, 18, 18, 'Expedita aut cupiditate eos quam eos nisi est. Eveniet dolorem provident sunt at. Commodi aspernatur neque sunt nihil aut.', 0, 1, '1985-02-16 08:18:41', '1995-01-01 12:00:45');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (19, 19, 19, 'Qui est nesciunt quasi porro. Est quas voluptas quas sed sint. Dolor temporibus ut id laboriosam sit sunt.', 0, 1, '1984-05-22 20:44:25', '2001-12-08 20:07:28');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (20, 20, 20, 'Et reprehenderit voluptate eos vel in. Et fugiat sequi sit dolores sequi voluptate odit corrupti. Vitae et aspernatur autem et molestias autem tempore. Assumenda odio quis eius assumenda illo excepturi debitis qui.', 0, 1, '1970-11-23 21:47:39', '1984-08-25 08:11:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (21, 21, 21, 'Culpa quam at cum aliquam ex non voluptates. In eligendi autem excepturi autem. Dolorem sapiente doloremque incidunt aut ex dolor alias.', 1, 1, '2016-10-18 15:59:30', '1990-07-22 02:43:13');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (22, 22, 22, 'Quibusdam dignissimos explicabo facere nobis. Dolor quo tempore in occaecati nostrum iure. Rerum nemo hic quam. Nihil natus ea veritatis explicabo qui. Non eos molestiae aut deserunt officia in quas.', 1, 1, '1986-08-13 12:46:09', '2015-04-25 23:44:49');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (23, 23, 23, 'Eaque labore qui rerum accusamus molestiae. Esse ea fugiat saepe dolor corrupti. Sed et nihil atque facilis. Recusandae quia ipsum temporibus sit quasi ea.', 0, 0, '2002-05-10 09:02:33', '1985-03-16 06:25:03');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (24, 24, 24, 'Dolorem facere minus quae sunt tempora. Est ex ullam quod. Id ab sed incidunt aut.', 0, 1, '2004-10-07 20:56:31', '1987-11-12 22:16:58');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (25, 25, 25, 'Rerum id cupiditate aliquam nesciunt cum molestiae natus. Ipsam fugit et sed repellat doloribus eos. At consequatur quia accusantium perferendis dicta. Molestiae animi et est praesentium corporis occaecati molestiae alias.', 0, 0, '1982-04-15 17:03:59', '1973-07-18 23:45:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (26, 26, 26, 'Commodi et numquam eos quasi. Sed et minima eligendi qui facere. Eaque et consequuntur fugiat corrupti et.', 0, 0, '2019-03-11 16:16:47', '2009-10-06 17:37:57');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (27, 27, 27, 'Ut sed et quia. Distinctio quasi autem libero et totam ut. Quis harum unde laborum nemo in.', 1, 1, '2007-09-21 16:07:03', '1993-03-10 00:35:55');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (28, 28, 28, 'Officiis non occaecati soluta voluptatibus esse exercitationem excepturi. Aliquid consequatur voluptatum nihil. Ea sapiente ut doloribus voluptatem.', 1, 0, '2009-05-10 06:39:50', '2019-03-09 09:18:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (29, 29, 29, 'Ab doloribus magni dolorum. Commodi cum enim aperiam voluptatem itaque sunt aliquam. Commodi qui necessitatibus distinctio.', 0, 1, '2021-07-28 12:09:29', '2019-03-29 13:06:36');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (30, 30, 30, 'Quasi exercitationem assumenda rem suscipit dicta nisi. Quo rerum pariatur mollitia in id est eveniet. Asperiores aut officia reprehenderit aliquid.', 0, 1, '1993-02-06 15:09:55', '2012-02-23 15:08:34');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (31, 31, 31, 'Eius architecto quis sed qui. Non quas maiores rerum velit sed. Tempora placeat vitae delectus vitae dignissimos. Ut qui in numquam enim corporis sed dignissimos.', 0, 0, '1983-03-03 18:56:01', '1990-01-05 18:45:14');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (32, 32, 32, 'Aut maxime deleniti voluptas et. Consequuntur eum et quia asperiores perferendis in. Quia alias dolorem officia aperiam. Soluta temporibus nulla commodi quia provident consectetur voluptatem.', 0, 1, '1991-01-26 00:02:13', '1986-01-14 12:18:33');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (33, 33, 33, 'Maiores est ut molestiae explicabo aliquid cum facere est. In qui impedit ab sit facere accusamus. Consequatur at molestiae voluptas tempora laudantium ea voluptates. Inventore natus autem molestiae minus.', 1, 1, '2015-08-12 20:03:22', '1992-08-19 05:14:27');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (34, 34, 34, 'Beatae suscipit sapiente velit aut eius. Nihil quos est alias quidem rem error tempora. Vero quaerat ipsam voluptatem.', 1, 0, '2001-11-28 20:25:12', '1983-06-05 22:33:07');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (35, 35, 35, 'Veritatis ipsum omnis consequatur aut et quae. Enim deleniti sunt earum asperiores. Qui deserunt eveniet rem aspernatur molestias voluptatem aliquid fugiat. Nihil nam excepturi officia enim consectetur nesciunt.', 0, 0, '1992-04-17 21:08:32', '1978-10-08 22:31:48');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (36, 36, 36, 'Velit non non ea suscipit. Est vero quibusdam enim laborum repellendus. Numquam ab necessitatibus earum voluptatum consequatur omnis.', 0, 0, '1994-12-13 10:50:10', '1999-05-26 06:13:14');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (37, 37, 37, 'Expedita aspernatur iste eum minus necessitatibus odit. Eveniet cupiditate iusto distinctio provident. Beatae vitae ut illum libero necessitatibus sed enim.', 1, 1, '1970-07-07 06:06:11', '2014-11-01 19:02:59');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (38, 38, 38, 'At voluptatem ut exercitationem repellendus assumenda. Eum natus rerum sit id. Facere animi repellendus tempore ea corrupti. Quidem fugit vel voluptatem odit et voluptas ipsa.', 1, 1, '2005-05-25 08:33:36', '2003-06-29 19:22:07');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (39, 39, 39, 'Ipsum enim velit voluptates dolores officiis. Dolorem iusto voluptatem deleniti asperiores magni non provident saepe. Voluptates dolores vitae dolores qui explicabo atque mollitia cumque.', 0, 1, '2007-03-15 18:04:53', '2005-05-02 20:36:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (40, 40, 40, 'Laudantium eum animi temporibus ullam odit. Sint voluptatem temporibus voluptatibus culpa ullam et. Eligendi dignissimos vel quis et nihil et. Optio dolorum repellat in officiis illo.', 0, 1, '1981-10-12 23:10:37', '1998-01-19 15:26:01');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (41, 41, 41, 'Mollitia aliquam officiis molestiae qui placeat doloribus. Nesciunt quisquam vel voluptatem vel pariatur. Autem odio delectus ea similique consequatur odit.', 1, 1, '2018-11-02 14:15:17', '2018-02-23 11:48:18');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (42, 42, 42, 'Officiis magnam rerum consequatur aut aperiam provident. Quam exercitationem sit et cumque fugit voluptate fuga. Eum incidunt molestias explicabo corporis. Quis voluptatum totam molestias consequatur totam sed.', 1, 1, '1979-04-10 19:21:36', '2003-02-01 03:50:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (43, 43, 43, 'Molestias et numquam totam aspernatur ea aspernatur laudantium. Excepturi quos omnis sit blanditiis voluptatem omnis quae. Ex quibusdam ea voluptatem. Iusto velit sapiente corrupti autem non inventore quas.', 1, 1, '1981-12-16 14:44:50', '2005-03-05 15:55:13');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (44, 44, 44, 'Velit veniam quis non consequatur voluptatem consequuntur dolore. Voluptatum porro sint expedita nihil autem. Ut eaque ea omnis aut distinctio hic neque. Quas reiciendis non recusandae ut.', 0, 1, '1974-05-25 10:26:07', '2020-02-19 00:38:34');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (45, 45, 45, 'Dolores in aut ullam iure voluptas vero. Non sint velit repellat id. Optio necessitatibus sunt est dignissimos.', 0, 1, '2002-08-29 02:18:15', '1986-05-13 14:49:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (46, 46, 46, 'Dicta rerum a sed laudantium repudiandae et. Reprehenderit earum eius ipsum dolorem et et. Sint cumque doloribus voluptatibus aliquam. Distinctio odit officia laudantium velit ut et ut molestiae.', 1, 1, '1982-02-22 13:04:24', '2011-02-10 07:32:54');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (47, 47, 47, 'Dolore accusantium ipsa aperiam a ut rerum quisquam asperiores. Mollitia ab voluptatum autem magni doloremque et. Aut ut commodi illum nisi. Et debitis nobis sit qui deleniti.', 1, 1, '2014-01-04 22:06:22', '1979-08-16 14:05:30');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (48, 48, 48, 'Libero ad deleniti exercitationem blanditiis est nisi. Quia unde in et quae. Recusandae aut in id itaque exercitationem excepturi dolores.', 1, 0, '2009-10-30 20:56:36', '1984-02-05 10:50:19');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (49, 49, 49, 'Inventore quod fuga maiores. Assumenda atque in nulla rerum in voluptatibus. Soluta quasi tempore vel non. Illo fuga sed in quasi earum.', 0, 0, '1999-01-20 20:45:27', '2021-07-06 11:07:45');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (50, 50, 50, 'Quo magnam quaerat aut quaerat eum enim. Ullam odit est provident suscipit est ut. Ducimus consectetur est eligendi quibusdam minus quasi.', 0, 0, '1974-04-27 20:33:15', '1982-07-12 21:24:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (51, 51, 51, 'Distinctio qui laudantium reiciendis nemo porro voluptatem omnis. Quasi ducimus illum accusantium ut voluptatum facere voluptatum. Deserunt sed quasi qui. In aut eaque corporis. Voluptatem magni ratione distinctio distinctio voluptas.', 0, 1, '1997-08-27 21:55:19', '2013-10-01 09:22:52');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (52, 52, 52, 'Est dolorem enim sapiente qui placeat omnis laboriosam. Eum veritatis officiis natus excepturi ducimus soluta. Ad cumque repellat sed voluptatibus. Odio magni dignissimos aut ut aut voluptatibus.', 0, 1, '1986-09-04 03:26:37', '2018-06-01 08:36:24');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (53, 53, 53, 'Qui ea rerum blanditiis magni ut laudantium. Iure expedita quos et dolores. Ipsum repudiandae quis voluptatem non aperiam eos et.', 0, 0, '1981-09-24 19:40:13', '2001-10-05 15:46:10');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (54, 54, 54, 'Hic dicta quia quisquam odio. Enim vero veritatis minima nihil eos. Dolores vel non eius placeat laudantium id.', 0, 0, '1976-11-11 02:45:25', '1975-11-20 08:39:46');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (55, 55, 55, 'Blanditiis consequatur harum aut neque. Sed pariatur aliquid labore quisquam id. Aperiam est perferendis expedita dicta.', 0, 1, '2017-06-20 05:17:04', '2004-05-02 03:14:31');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (56, 56, 56, 'Voluptatem voluptates architecto eos soluta temporibus sunt. Qui labore aut non exercitationem suscipit qui. Qui aut est ut et doloremque odit. Ipsa distinctio laudantium nihil ullam amet aut. Sint in nihil ut velit voluptas cum similique repellat.', 0, 1, '1997-08-01 19:00:01', '1973-07-23 11:40:55');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (57, 57, 57, 'Fugit aut in in nulla. Debitis qui pariatur et aut est porro magni. Ut ut dicta quo perferendis odio. Commodi facere ut minus quo.', 0, 1, '1972-09-09 12:08:58', '2000-03-19 16:57:38');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (58, 58, 58, 'Dolores eum at nostrum in inventore. Voluptatem et similique neque soluta hic. Officiis quaerat ea libero maxime odio.', 1, 1, '1979-08-30 08:40:46', '1996-07-16 11:36:33');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (59, 59, 59, 'Consequatur incidunt aut quia itaque ut accusantium et. Voluptatem molestiae temporibus est quos sapiente dolore labore. Minima voluptatem nam eligendi eos reprehenderit voluptas.', 0, 0, '2004-01-13 13:13:12', '2001-11-16 14:04:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (60, 60, 60, 'Officiis architecto ipsum dolores eos. Odit qui non iusto optio expedita. Odio dolor est quis ad deserunt et laborum. Nesciunt nam et occaecati iusto ex impedit.', 0, 1, '2013-12-22 02:15:02', '1994-10-26 03:08:46');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (61, 61, 61, 'Voluptatem aut quia quaerat fugiat culpa. Maxime vel eos voluptatem. Quia odio et eaque consequatur. Aut earum nemo quaerat omnis et quo.', 1, 0, '1999-01-12 03:47:30', '2011-08-27 09:38:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (62, 62, 62, 'Suscipit provident suscipit numquam dolorem sit aut. Dolor aut ab aut aut. Nisi molestias et sed et nobis.', 0, 1, '2010-01-23 22:21:42', '2011-06-23 20:18:22');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (63, 63, 63, 'Fuga in perferendis rerum et excepturi cum. Dolores totam veritatis quia vero. Aut est id cupiditate. Repellendus labore quia est quia illum molestias.', 0, 1, '1972-12-13 07:07:23', '2020-11-24 23:27:00');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (64, 64, 64, 'Voluptas et aliquam recusandae quia minus qui. Consequatur quo quidem et quia. Pariatur molestiae quas recusandae aut asperiores.', 1, 1, '1993-08-03 13:54:26', '1994-10-27 06:00:04');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (65, 65, 65, 'Ut voluptas odio quod ut ducimus fuga omnis pariatur. Error ut debitis corporis quia enim nostrum. Et vero ducimus facere eos ratione. Quibusdam et atque aut dolor.', 1, 0, '1986-11-02 22:19:45', '1998-08-24 23:20:25');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (66, 66, 66, 'Libero deserunt in quia eos. Illo iusto temporibus magnam qui blanditiis nulla. Minima veniam natus voluptates est. Ratione deleniti tempore itaque aliquam cumque totam et.', 0, 1, '2018-06-04 04:22:49', '2001-05-19 06:10:49');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (67, 67, 67, 'Cupiditate dicta voluptatem iure natus. Nemo praesentium earum cupiditate adipisci voluptas aspernatur voluptatem.', 0, 0, '1994-04-29 23:18:51', '1981-06-30 11:43:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (68, 68, 68, 'Ipsam natus voluptas voluptas ex odio dolores. Aut et qui doloremque sed recusandae. Optio ab aut eum occaecati fuga. Officia necessitatibus voluptate suscipit molestias voluptatem.', 1, 1, '1980-05-11 11:16:20', '1993-01-27 11:00:46');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (69, 69, 69, 'Rem asperiores sed ut dolores. Harum ut eos aspernatur et corporis. Quo aspernatur nesciunt sit. Est qui fuga exercitationem deserunt placeat occaecati totam.', 1, 0, '1978-09-13 05:02:42', '1995-08-28 08:51:36');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (70, 70, 70, 'Voluptatem tempore dolores minima repudiandae consequatur aut. Debitis aut officiis tempore esse eos officiis. Impedit dignissimos tempora omnis rerum quibusdam ut praesentium.', 1, 1, '1996-11-24 09:21:34', '1978-07-10 22:51:24');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (71, 71, 71, 'Ad aperiam saepe soluta unde facere dolore. Qui qui temporibus animi exercitationem alias. Aliquam beatae animi recusandae inventore aut. Tempore et veniam consequuntur quis deserunt est velit.', 1, 1, '1999-08-26 10:30:41', '1999-06-07 23:41:21');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (72, 72, 72, 'Et id quas a aut tempore repellat nulla quasi. Quibusdam rem illum velit nihil. Id minus voluptatem sint laborum et facilis. Dolores officia non corporis veritatis quos quia.', 0, 1, '1971-11-06 20:03:34', '1998-11-13 01:34:47');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (73, 73, 73, 'Iure minima magni delectus beatae omnis. Doloremque magni earum a vel doloribus eligendi. Dolorem aut ea necessitatibus hic in qui similique. Quia aperiam iusto reiciendis omnis et similique iste quasi.', 0, 1, '1990-05-14 15:58:29', '1976-07-29 09:21:04');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (74, 74, 74, 'Sapiente nam consequatur tempora aperiam ea. Fugit voluptas in fugit itaque. Odit cum ut libero quo veritatis illo aliquid.', 0, 1, '1977-07-21 16:43:05', '1983-07-18 04:36:17');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (75, 75, 75, 'Fuga et est voluptatem cupiditate autem et. Corrupti velit eveniet omnis magni voluptatem magni provident. Perspiciatis culpa quod alias esse tenetur. Aut aut eveniet non est. Ratione voluptas dolorem dicta debitis sit.', 0, 0, '1982-03-14 00:56:54', '1977-10-14 16:12:33');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (76, 76, 76, 'Doloremque accusamus id sapiente ut et commodi. Quo placeat amet maiores ipsa. Iure reiciendis ullam facilis est ea ut quo. Ad fugiat in magnam aut omnis consequatur est.', 1, 1, '1994-01-05 13:10:08', '2021-03-08 15:38:09');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (77, 77, 77, 'Vero eum nobis excepturi consequatur quam corrupti sunt. Eveniet nesciunt voluptates impedit minima consectetur dicta. Dolorum voluptates sed nam.', 0, 0, '1995-02-02 17:27:13', '2000-04-24 17:34:17');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (78, 78, 78, 'Fugiat est enim nemo molestiae eum et. Repellat deleniti minima et nam saepe dolores. Perspiciatis quod ipsam tempore. Qui repudiandae corrupti animi ducimus.', 0, 1, '1997-12-22 18:01:14', '1996-12-31 05:59:40');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (79, 79, 79, 'Tempora animi expedita sed tempora culpa necessitatibus. Voluptatem unde repellendus dignissimos ut placeat ut. Dicta provident similique praesentium voluptas aut id nemo beatae.', 1, 0, '2018-06-16 03:22:59', '2015-12-17 19:35:05');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (80, 80, 80, 'Aut quidem at quo amet sit quisquam nihil. Id molestiae et eius esse unde. Natus architecto velit beatae voluptas. Voluptatem consequatur voluptatem ullam dolor est qui.', 0, 1, '1985-01-31 22:58:19', '2020-05-12 10:36:46');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (81, 81, 81, 'Molestias est veritatis tempore. Id dolorem voluptatibus odio laboriosam est non. Eum non facere ut ut quisquam omnis vero vel.', 1, 1, '1974-08-05 15:17:22', '2017-11-16 03:06:03');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (82, 82, 82, 'Illo ut totam accusantium non tempore. Deleniti sed eaque temporibus porro. Debitis occaecati similique pariatur perferendis alias rem laboriosam in. Numquam architecto at aliquam illo sit.', 0, 0, '1979-10-06 08:57:55', '2018-12-13 05:28:35');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (83, 83, 83, 'Excepturi et animi quidem enim odio architecto velit. Numquam earum voluptatibus magnam magnam. Consequatur asperiores sed unde debitis perferendis necessitatibus.', 1, 1, '1998-04-21 13:41:40', '1996-12-11 10:07:11');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (84, 84, 84, 'Ad repellendus laborum qui similique. Dignissimos quas repellendus ipsam sit nam laudantium quis dignissimos. Rerum molestiae nesciunt et autem repellendus. Fuga culpa quod fugiat corrupti sequi voluptatem.', 0, 1, '1999-02-11 04:55:45', '2016-09-19 22:21:49');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (85, 85, 85, 'Ex nostrum officia inventore quia debitis. Harum sed omnis et dicta ut et. Voluptates eveniet possimus ut dicta sit earum. A et facere perferendis voluptate non. Eos est qui illum praesentium possimus officia voluptatem consequatur.', 0, 1, '2003-07-15 23:16:40', '1988-10-31 01:14:15');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (86, 86, 86, 'Nihil tempora corporis eum iusto inventore. Molestias pariatur qui vel soluta minus et. At et reprehenderit placeat non accusantium qui dignissimos.', 1, 0, '2019-08-29 09:22:19', '2005-08-03 18:05:39');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (87, 87, 87, 'Neque totam sapiente cupiditate. Hic deleniti architecto qui consequatur. Placeat et ut dolorum enim reiciendis dolorum voluptates exercitationem.', 1, 1, '1977-11-27 05:48:12', '1993-08-31 20:30:28');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (88, 88, 88, 'Aspernatur adipisci eius dolorem autem similique. Nihil eaque autem quis reprehenderit. Fugiat corrupti ut ducimus qui quos enim eveniet.', 1, 0, '2001-01-09 13:51:00', '2005-12-08 10:38:19');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (89, 89, 89, 'Unde maxime aliquid qui. Vel aut corrupti aliquid ipsam possimus maiores. Alias autem et maxime amet ducimus voluptates.', 1, 1, '2001-09-20 03:52:39', '1990-11-02 20:30:18');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (90, 90, 90, 'A et dolor unde eum. Aut facere laboriosam ratione qui aspernatur quod.', 0, 0, '1981-10-19 15:40:39', '2015-04-06 10:14:54');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (91, 91, 91, 'Quo voluptatem qui non autem. Voluptatibus vel debitis enim et sed perspiciatis repellendus esse. Fuga ea est corporis vitae id. Iste est molestiae eius. Ad aut vero eos architecto rem.', 0, 1, '1988-11-23 03:01:03', '1992-12-07 13:23:33');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (92, 92, 92, 'Quia soluta fuga omnis vel. Ut saepe architecto libero in perferendis perferendis tempora iure. Vitae est quidem eum id.', 0, 1, '2008-07-11 19:22:15', '1974-03-08 06:29:24');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (93, 93, 93, 'Sequi dolor qui perspiciatis optio omnis dolor delectus. Aut natus nostrum dicta dolore nam ut. Ipsum nobis et autem sequi velit recusandae necessitatibus. Vel natus dolor excepturi adipisci. Accusantium adipisci recusandae iste sed qui corrupti sapiente.', 0, 0, '1999-12-15 01:58:08', '2019-03-30 21:27:40');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (94, 94, 94, 'Maxime inventore mollitia et eaque ut. Tenetur et nesciunt accusamus sed est fugiat. At incidunt explicabo veritatis aut autem beatae. Eaque rerum vel quibusdam est non. Necessitatibus dignissimos sint excepturi saepe.', 0, 0, '2004-03-13 00:01:43', '2009-12-28 06:11:24');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (95, 95, 95, 'Officiis enim aut eos aut facere. Ad numquam enim ad quisquam dolores. Dolor dolore accusamus amet.', 1, 0, '1997-08-28 10:20:44', '1981-04-14 08:14:22');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (96, 96, 96, 'Repudiandae tenetur distinctio in rerum dolor. Ut aut eligendi officiis quasi ipsa. Vel ducimus illo in qui voluptatibus occaecati consequatur beatae.', 1, 0, '2020-03-12 08:06:46', '1999-06-28 07:44:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (97, 97, 97, 'Quia eos consequatur quae veritatis similique. Velit modi nesciunt corrupti dignissimos aperiam quidem ipsam. Autem facere cupiditate minima incidunt. Tempora quia explicabo molestias totam tempora.', 1, 0, '2000-05-05 10:38:47', '1980-04-09 07:34:14');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (98, 98, 98, 'Nesciunt et soluta est a omnis aut rerum. Ullam ducimus qui perspiciatis nemo impedit. Voluptatum magni enim alias qui. Non voluptas eos voluptatem non. Commodi et delectus provident exercitationem.', 1, 1, '1982-11-30 02:03:54', '2019-10-19 01:55:03');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (99, 99, 99, 'Dolor aliquam cum qui veniam voluptates. Labore officiis consectetur cumque eligendi natus rerum sint provident. Quis ipsam praesentium est non. Eos possimus nostrum distinctio ut ab exercitationem vero et. Ut laborum hic sed dolorum quidem consequatur quo sit.', 1, 1, '1986-10-27 10:40:47', '2010-10-18 09:08:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (100, 100, 100, 'Quidem rerum magnam aut sit odio in dolorum. Officia alias quae ipsam ut ipsa dolorem. Qui facere aut nisi alias minus eligendi unde.', 0, 1, '2018-01-05 06:18:10', '1994-08-31 16:39:53');

INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (1, 1, '', '2011-09-09', 1, 'Eos officiis magni fuga except', 'Lake Chaya', '4633', '2010-10-11 11:23:14', '1989-12-03 18:14:12');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (2, 2, '', '2001-04-21', 2, 'Qui non explicabo quasi offici', 'Turnerside', '7', '1990-03-14 08:45:01', '2014-05-12 00:51:11');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (3, 3, '', '1990-11-08', 3, 'Consectetur minus voluptatibus', 'New Emmanuelchester', '69889', '1983-10-09 15:29:00', '2014-07-30 10:25:06');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (4, 4, '', '2019-12-19', 4, 'Occaecati minima est omnis qui', 'North Keenan', '5', '2005-09-26 08:28:37', '2016-03-08 14:16:14');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (5, 5, '', '1974-09-06', 5, 'Est et omnis molestiae non fug', 'Bednartown', '829366', '1993-01-30 05:12:43', '1997-09-10 08:06:38');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (6, 6, '', '1993-03-23', 6, 'Adipisci quae labore quia iure', 'Rafaelaport', '34', '1995-11-24 15:05:59', '1998-06-27 17:20:54');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (7, 7, '', '2014-03-16', 7, 'Aspernatur architecto ut est i', 'South Stonetown', '', '1972-11-17 01:44:50', '2006-09-23 00:53:52');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (8, 8, '', '1986-03-20', 8, 'Consequatur culpa et qui minus', 'East Ada', '70', '2004-07-09 02:44:46', '1970-01-18 16:58:35');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (9, 9, '', '2021-06-02', 9, 'Et incidunt sapiente ut odit. ', 'North Cathy', '', '1995-01-10 05:20:47', '1985-08-05 02:19:52');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (10, 10, '', '2009-07-29', 10, 'Qui cum et quo voluptates est ', 'North Amaraburgh', '21773864', '2005-05-03 00:27:00', '1989-04-22 23:16:44');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (11, 11, '', '1988-04-02', 11, 'Inventore velit voluptatem nob', 'New Etha', '95373', '1976-07-09 01:38:13', '1999-10-25 00:51:58');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (12, 12, '', '2004-03-13', 12, 'Corrupti maiores natus nesciun', 'New Careymouth', '70208743', '1982-12-27 15:42:08', '1975-04-06 13:29:13');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (13, 13, '', '1984-06-09', 13, 'Omnis aut doloribus ut tempora', 'Lake Pasquale', '628586225', '1997-02-25 15:09:34', '1999-09-01 21:27:01');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (14, 14, '', '2021-03-24', 14, 'Optio qui distinctio reprehend', 'Port Christmouth', '73', '2008-07-09 15:31:39', '1991-09-11 20:50:31');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (15, 15, '', '1997-05-08', 15, 'Omnis aliquam adipisci aut und', 'Kemmerborough', '383', '1997-07-31 13:23:27', '1973-04-27 08:16:00');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (16, 16, '', '2012-09-20', 16, 'Et labore delectus rem omnis e', 'Lockmanfurt', '406521', '1982-12-02 10:38:04', '2020-03-30 01:14:01');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (17, 17, '', '2017-04-14', 17, 'Quas vero consequuntur laborio', 'Rickyborough', '', '1999-07-03 14:01:46', '1999-11-19 02:13:42');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (18, 18, '', '2009-12-10', 18, 'In blanditiis quasi suscipit v', 'Lake Alejandra', '91423141', '2016-03-26 02:05:41', '2006-11-28 12:56:59');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (19, 19, '', '2002-09-01', 19, 'Sed fugiat nemo cum voluptatem', 'Lake Edisonburgh', '', '1978-05-03 16:42:11', '2000-05-28 13:49:14');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (20, 20, '', '1985-08-31', 20, 'Possimus facilis excepturi deb', 'Gwendolynshire', '931', '1991-07-04 15:06:46', '2013-09-18 08:49:25');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (21, 21, '', '1982-08-11', 21, 'Quo reiciendis atque nihil tem', 'East Terrence', '', '2012-06-28 13:13:05', '2014-01-07 01:12:34');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (22, 22, '', '2003-04-07', 22, 'Accusamus earum facilis quaera', 'Marisolburgh', '384592270', '1971-02-18 10:46:53', '1980-08-14 05:14:23');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (23, 23, '', '2017-07-29', 23, 'Impedit voluptate qui ea dolor', 'Emardland', '399559', '1989-12-14 14:32:31', '2007-09-26 11:43:24');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (24, 24, '', '2007-05-21', 24, 'Aperiam quo rerum occaecati mo', 'Lake Heloiseville', '181114619', '2015-06-11 23:28:05', '1975-11-24 17:46:56');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (25, 25, '', '1985-12-15', 25, 'Cupiditate laudantium unde vel', 'Lake Graciela', '58898', '1971-05-18 19:45:55', '1973-03-23 11:28:27');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (26, 26, '', '2012-05-01', 26, 'Error nostrum voluptatem aliqu', 'Rippinhaven', '5298', '1999-09-10 16:38:34', '1985-12-03 08:12:59');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (27, 27, '', '1978-07-24', 27, 'Vel sint ea rem veritatis amet', 'West Vesta', '', '2009-10-15 17:51:43', '2005-12-22 13:53:22');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (28, 28, '', '1984-04-23', 28, 'Molestias eum quia nisi aut. A', 'South Freddie', '751', '2018-05-15 21:11:27', '2011-05-24 09:49:44');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (29, 29, '', '2016-04-01', 29, 'Qui blanditiis dolore id. At i', 'Brakusborough', '167840858', '1980-03-24 03:20:36', '2004-12-16 01:23:10');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (30, 30, '', '1996-10-13', 30, 'Neque quo molestias porro est ', 'South Robb', '47', '1971-07-03 06:36:36', '2018-11-16 07:50:07');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (31, 31, '', '2010-09-22', 31, 'Accusantium voluptatem rerum d', 'East Aida', '', '2020-12-02 06:11:02', '2013-06-23 22:09:02');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (32, 32, '', '1972-10-12', 32, 'Aperiam officiis eaque saepe. ', 'North Ahmed', '', '2009-12-26 09:41:06', '1988-10-14 13:46:24');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (33, 33, '', '2019-01-16', 33, 'Libero libero iste dignissimos', 'Haneview', '330309289', '2020-11-29 15:50:55', '1971-02-06 21:40:06');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (34, 34, '', '2003-11-27', 34, 'Et natus suscipit eum fugit re', 'New Darianton', '19', '1987-12-09 01:17:06', '1984-11-05 21:31:41');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (35, 35, '', '1993-01-29', 35, 'Omnis blanditiis non est. Est ', 'South Jaylonberg', '5630128', '2007-10-03 23:00:12', '1987-09-17 10:50:27');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (36, 36, '', '2014-05-05', 36, 'Error nihil vel distinctio eos', 'Marvinview', '58225132', '1985-10-04 09:46:27', '2016-06-25 03:16:30');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (37, 37, '', '1987-02-24', 37, 'Et est omnis aut optio eos. Bl', 'Jaclynside', '9', '1983-01-17 03:00:06', '1996-02-16 17:47:45');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (38, 38, '', '2000-01-24', 38, 'Exercitationem explicabo dolor', 'East Moses', '', '1998-04-05 11:33:57', '1985-03-22 22:39:17');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (39, 39, '', '2001-01-11', 39, 'Eum repudiandae dignissimos ev', 'South Helmerhaven', '587889', '1979-07-27 07:03:14', '2006-01-28 12:31:52');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (40, 40, '', '2010-12-03', 40, 'Perferendis quidem a officiis ', 'East Vernonport', '46', '1990-02-11 06:39:18', '2000-03-14 05:52:10');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (41, 41, '', '2013-02-15', 41, 'Dignissimos suscipit nisi natu', 'Leannemouth', '', '1975-04-02 06:25:19', '2020-02-04 18:59:29');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (42, 42, '', '1997-08-25', 42, 'Voluptatem qui blanditiis inci', 'Myrnaborough', '14', '2016-06-04 16:16:45', '2005-10-04 17:02:42');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (43, 43, '', '1980-03-28', 43, 'Cupiditate non recusandae rem ', 'East Lindseyside', '819697440', '1989-09-30 12:01:26', '2014-07-07 14:22:04');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (44, 44, '', '2013-04-01', 44, 'Minus eveniet architecto enim ', 'Kihnchester', '6691', '1984-08-01 05:05:16', '1980-09-24 03:36:09');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (45, 45, '', '1974-12-15', 45, 'Molestiae modi aliquam unde as', 'Hermistonfurt', '92677992', '2007-01-02 13:53:34', '1986-11-12 03:45:22');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (46, 46, '', '2008-03-26', 46, 'Voluptates sapiente non alias ', 'West Linda', '3', '1992-01-28 15:44:08', '2018-08-31 10:36:25');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (47, 47, '', '2005-08-30', 47, 'Autem sit doloremque dolor est', 'Nolanborough', '335264', '1978-06-10 12:29:23', '2002-08-19 02:36:52');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (48, 48, '', '2015-07-11', 48, 'Atque magni quia ipsa dolorum ', 'Kelleytown', '250566', '2021-04-18 01:48:00', '1977-08-26 22:53:59');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (49, 49, '', '2019-09-27', 49, 'Perspiciatis omnis facilis vol', 'Tristinfort', '5', '1980-11-17 06:09:14', '2009-06-01 22:41:09');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (50, 50, '', '1998-04-24', 50, 'Molestiae corporis id aut temp', 'New Genevievestad', '8809495', '1980-04-22 01:12:51', '1982-03-16 22:09:23');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (51, 51, '', '1975-01-14', 51, 'A voluptatem alias quia facere', 'Shanahanmouth', '98458174', '2001-11-27 12:28:53', '2020-03-26 03:54:46');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (52, 52, '', '1973-05-31', 52, 'Recusandae dicta voluptatibus ', 'Erdmanshire', '5', '1992-11-28 03:10:48', '2014-03-14 19:44:37');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (53, 53, '', '1992-08-04', 53, 'Possimus quos incidunt unde co', 'South Clement', '8287', '1989-10-22 12:23:54', '1982-06-05 19:28:27');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (54, 54, '', '1981-10-05', 54, 'Aut nostrum hic mollitia in qu', 'Port Stella', '44471', '2017-06-21 02:28:19', '1986-07-08 17:49:50');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (55, 55, '', '1978-08-05', 55, 'Maxime et et doloribus eaque f', 'Earltown', '', '2007-01-16 23:45:34', '1996-10-18 17:24:44');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (56, 56, '', '2009-05-17', 56, 'Necessitatibus iusto amet volu', 'Flatleyport', '80616', '2021-05-03 08:44:33', '2016-09-07 14:39:27');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (57, 57, '', '2017-05-14', 57, 'Consequatur voluptate exercita', 'Raumouth', '982', '1991-12-05 10:26:35', '1974-06-04 17:50:13');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (58, 58, '', '1983-01-08', 58, 'Et corporis quia dolorum accus', 'North Everette', '532845', '2012-03-17 02:32:11', '1976-02-04 02:30:58');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (59, 59, '', '1988-03-23', 59, 'Pariatur distinctio reprehende', 'East Brannon', '272343', '1983-10-15 18:04:31', '1970-05-01 18:18:03');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (60, 60, '', '2017-01-26', 60, 'Optio eaque recusandae quis re', 'Schowalterport', '48265156', '1994-06-27 22:59:20', '1997-01-24 18:40:28');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (61, 61, '', '2005-05-30', 61, 'Dolores est itaque commodi sed', 'New Chanellemouth', '437872987', '2015-07-07 13:32:41', '2008-02-01 07:23:13');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (62, 62, '', '2007-01-29', 62, 'Voluptatem et distinctio id op', 'Lake Nolafort', '189', '2001-10-15 22:55:50', '1976-09-16 00:51:49');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (63, 63, '', '1991-10-23', 63, 'Debitis facere dolore sit omni', 'Elmomouth', '69678', '2001-05-13 00:41:38', '1986-11-16 02:31:05');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (64, 64, '', '1983-01-05', 64, 'Facilis tempora et cumque veli', 'Bergnaumbury', '557300', '2004-10-25 22:17:23', '1976-06-09 23:45:18');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (65, 65, '', '2016-11-22', 65, 'Error hic at excepturi et ea m', 'East Gregoriomouth', '877874', '1973-01-03 11:25:39', '1989-05-26 20:30:16');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (66, 66, '', '2021-06-11', 66, 'Quasi aut maiores itaque eos a', 'Brekkeberg', '92913', '2014-04-28 01:33:44', '2016-01-30 10:19:27');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (67, 67, '', '1978-08-29', 67, 'Quis aut et enim quia. Dolorem', 'Pfefferfort', '', '2000-01-18 15:07:03', '2019-03-22 07:08:21');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (68, 68, '', '1996-03-30', 68, 'Aut voluptatum numquam velit r', 'North Jaclynfurt', '7234634', '1996-01-14 06:53:02', '1998-10-25 05:21:27');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (69, 69, '', '2003-12-24', 69, 'Debitis totam magni et assumen', 'Tavareston', '1', '1992-04-02 17:40:05', '1977-07-04 12:15:59');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (70, 70, '', '1998-05-12', 70, 'Ex et quo et consequatur sit e', 'New Tarynland', '7', '1990-11-06 05:34:46', '1970-08-28 22:30:53');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (71, 71, '', '1980-10-31', 71, 'Aut est sint sapiente sed qui ', 'East Mckenna', '279283637', '1983-04-18 06:25:52', '1997-06-21 07:57:33');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (72, 72, '', '1991-07-02', 72, 'Labore est blanditiis repellat', 'North Drew', '', '2012-05-20 06:32:38', '1974-01-05 11:59:42');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (73, 73, '', '2011-01-29', 73, 'Consequatur quas explicabo in.', 'Bergstromfurt', '4214363', '1977-08-23 02:22:56', '2016-10-24 13:52:47');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (74, 74, '', '2003-04-29', 74, 'Beatae ea est enim doloremque ', 'Chynaburgh', '5', '1985-10-05 09:18:33', '1971-03-01 11:26:42');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (75, 75, '', '2017-10-09', 75, 'Occaecati mollitia esse dolore', 'Gislasonborough', '8', '2003-12-02 06:54:52', '1984-11-13 09:20:15');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (76, 76, '', '2007-06-01', 76, 'Et repellat repudiandae ea. Ve', 'Perryport', '35', '2017-12-27 04:29:33', '2000-09-22 08:36:38');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (77, 77, '', '2016-06-29', 77, 'Ratione possimus vel distincti', 'Noahville', '90111566', '1972-11-10 15:37:06', '2016-09-11 22:05:54');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (78, 78, '', '1984-05-06', 78, 'Voluptas alias consequatur qua', 'Alekberg', '4560296', '2004-10-08 12:16:17', '1978-06-19 07:19:35');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (79, 79, '', '1979-08-27', 79, 'Molestiae eos aliquam nostrum ', 'Deonteburgh', '398554070', '2012-05-18 03:02:42', '1987-09-23 23:50:16');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (80, 80, '', '2016-05-12', 80, 'Quia voluptatem deserunt archi', 'Brisaborough', '879', '2002-01-13 20:03:02', '1996-11-05 17:22:46');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (81, 81, '', '1988-01-21', 81, 'Tempora enim non alias fugiat ', 'Mauricioshire', '5', '1988-11-06 02:57:20', '1983-06-22 08:00:21');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (82, 82, '', '1976-05-22', 82, 'Laudantium sunt rerum aut aliq', 'Lake Ansley', '3580010', '1983-05-27 03:15:29', '2014-05-11 15:18:51');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (83, 83, '', '1992-12-16', 83, 'Vitae voluptate asperiores quo', 'Lake Shanialand', '6828544', '2003-04-27 06:49:31', '2019-08-09 17:01:31');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (84, 84, '', '1981-01-11', 84, 'Provident perspiciatis numquam', 'West Dorcasport', '589204', '2005-09-08 00:37:07', '2014-03-10 03:30:20');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (85, 85, '', '1981-05-06', 85, 'Unde et repellendus fugiat ani', 'West Georgianafort', '880', '1977-01-15 21:15:34', '2012-06-16 17:02:54');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (86, 86, '', '2002-03-21', 86, 'Laboriosam omnis omnis aut asp', 'Schimmelhaven', '1', '1991-07-12 04:13:34', '1994-08-01 13:12:49');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (87, 87, '', '1994-07-09', 87, 'Ut qui et ut dicta eius. Labor', 'West General', '31814593', '1976-11-18 01:01:32', '1970-09-21 11:46:09');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (88, 88, '', '1993-10-01', 88, 'Consequatur est in velit enim ', 'Ankundingfurt', '729448', '2007-01-30 18:39:34', '2020-09-11 09:17:03');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (89, 89, '', '1981-05-24', 89, 'Eveniet ipsum a ipsa similique', 'South Alvahchester', '', '2001-08-22 23:28:41', '1982-06-17 10:04:30');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (90, 90, '', '1973-06-22', 90, 'Dolore sapiente sit nihil ad p', 'Cletusborough', '381305', '1992-02-05 11:05:26', '1984-09-01 09:53:26');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (91, 91, '', '1999-10-24', 91, 'Sunt dignissimos sint earum ex', 'East Dionview', '', '1994-02-10 04:34:27', '1970-01-12 06:18:28');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (92, 92, '', '1971-02-15', 92, 'Rerum consequatur accusamus so', 'West Baby', '103802', '1999-07-03 09:40:03', '1995-03-25 00:11:12');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (93, 93, '', '1988-01-22', 93, 'Tempore deserunt vel et iure i', 'New Aliza', '822', '1981-06-02 11:37:14', '1994-12-21 18:08:57');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (94, 94, '', '2007-10-11', 94, 'Dolore accusamus similique ver', 'North Camylleborough', '44096347', '2003-11-21 07:57:04', '2008-09-03 00:06:47');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (95, 95, '', '2021-07-09', 95, 'Itaque blanditiis qui possimus', 'South Demetrisfurt', '5', '2011-02-11 05:50:40', '1997-02-12 18:00:38');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (96, 96, '', '1977-11-10', 96, 'Rerum ut et incidunt. Eum non ', 'West Flavieborough', '448', '2012-12-20 17:49:27', '2013-06-22 08:33:32');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (97, 97, '', '1996-08-22', 97, 'Ad temporibus accusamus dolore', 'Lake Stacy', '76370510', '2003-05-14 20:03:49', '1993-09-10 07:02:51');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (98, 98, '', '2001-11-16', 98, 'Aspernatur cum corporis dolore', 'Port Samara', '795953637', '2002-07-08 19:16:23', '2016-09-13 11:02:26');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (99, 99, '', '1995-10-04', 99, 'Sit sunt labore voluptatum ven', 'North Alphonsoberg', '73102844', '2018-11-20 18:36:25', '2004-07-05 04:07:30');
INSERT INTO `profiles` (`id`, `user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (100, 100, '', '1971-10-25', 100, 'Unde rem vero ipsa eos. Facili', 'Cartwrightberg', '810355', '1972-12-01 23:07:36', '2004-12-29 04:55:58');

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (1, 'Heber', 'Miller', 'greenholt.penelope@example.net', '(831)014-86', 'f905638b99ad562f5b8716805ec5d05b4151d86c', '2001-01-21 01:45:30', '1986-03-24 20:45:33');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (2, 'Pink', 'Borer', 'vbraun@example.com', '1-547-560-4', 'c889379ec2871aba502c5388e29e9f3f72882945', '1979-11-16 00:50:20', '1995-09-04 14:06:07');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (3, 'Lenora', 'Wintheiser', 'jast.ben@example.com', '04326318469', 'a3281684358a59187d77e1b14ede48f95aa12b1a', '2020-09-11 16:40:40', '1993-09-06 20:31:49');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (4, 'Clare', 'Little', 'rollin.greenfelder@example.net', '879-409-223', '56e93f4ff3e12fff2f8823ca839167080bda9d92', '1994-03-10 15:36:55', '2012-11-03 12:22:02');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (5, 'Valentina', 'Romaguera', 'jovanny.bosco@example.net', '568-523-501', 'aa8e80c2fa9bc17d70194410b291546150037cb5', '2005-06-17 07:05:09', '2015-03-27 12:25:03');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (6, 'Sid', 'Crona', 'trent33@example.com', '(324)766-41', '5c0a74e6f92185251ff6a85113052eb4ad0c2068', '1975-10-01 11:35:25', '1992-11-13 17:00:03');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (7, 'Melany', 'Legros', 'alexander47@example.net', '(582)153-73', '2d047de06c905af6b87c1367cd88a26f33578198', '1998-01-24 20:12:02', '1996-02-08 22:22:47');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (8, 'Shaun', 'Leannon', 'ondricka.cyril@example.net', '332.943.442', '3f19fd116f207cfc11f3bad45f1c179065c0f671', '2018-02-25 06:04:39', '1999-12-27 15:04:35');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (9, 'Abigale', 'Cronin', 'elise.gerlach@example.net', '878.847.721', '3ec885af23d783ed39b925fc90fb6f67ff758565', '2017-03-23 16:49:30', '2000-08-02 19:09:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (10, 'Brando', 'Schulist', 'maureen.herman@example.org', '981-058-262', '36961db83081167cba19a15e147abd42a4c5b53c', '1994-05-07 00:51:34', '2001-09-11 10:19:50');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (11, 'Leland', 'Walsh', 'gerson19@example.net', '1-753-582-5', '74696cff42ee49f1dce19d95fdbc359aa30efdab', '2015-11-19 03:41:39', '2016-05-24 05:54:55');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (12, 'Rosalinda', 'Armstrong', 'maltenwerth@example.com', '(209)917-66', '8d611586b4f4a96fa8c1a8d6250433230dcce249', '1974-03-18 04:44:27', '1999-08-26 01:27:53');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (13, 'Zoie', 'Cole', 'elenor.greenfelder@example.org', '(016)408-03', '0da9c87f683c56abed7ecd8a225195ff628b9a2e', '1983-06-05 03:04:38', '1992-09-14 11:29:12');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (14, 'Blanca', 'Ankunding', 'qjerde@example.org', '(643)235-04', '558e352ad94bcba6c4d3787a21dd0810177dbb26', '2019-06-05 03:16:08', '2001-07-17 11:42:16');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (15, 'Gretchen', 'Jaskolski', 'tavares.o\'conner@example.net', '1-360-087-4', '8b8f4d274ec9511125a6b150359acc4bd70a255f', '1974-10-01 20:38:39', '2008-01-30 05:30:49');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (16, 'Deontae', 'Rutherford', 'langosh.dallin@example.org', '454-408-111', '7b0e54b606ffbe8365bb97d2c22d433a7b6a7001', '1976-01-19 06:01:42', '1996-09-05 05:58:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (17, 'Benny', 'Haley', 'darian.medhurst@example.net', '838.552.677', '708162d36fd430e81d65903e67b17a7d312bfb26', '2002-11-18 08:18:18', '1984-06-16 16:10:10');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (18, 'Jeremie', 'Gutmann', 'corrine39@example.com', '1-672-872-2', '57c3ed20fc555ac76de70abf0731aaaf19714af8', '2014-12-30 14:14:07', '2016-03-25 16:33:10');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (19, 'Benedict', 'Buckridge', 'mertz.nathan@example.org', '324-522-052', '0d8d5c329682da1ab78db13f22d5e7c2cbc5da0a', '2000-11-27 09:08:24', '1971-10-28 14:55:39');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (20, 'Braeden', 'Hahn', 'vmitchell@example.com', '508.303.140', 'c7fa9b8e49c12fe04f5c5a20ac5c259dda3138cd', '2007-01-16 15:48:04', '2003-02-09 14:34:58');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (21, 'Edythe', 'Jakubowski', 'zkovacek@example.com', '(811)018-58', 'bad65594b526e1ddc776841f22b6e8fc28e55143', '2008-01-24 19:34:33', '1991-12-24 05:28:35');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (22, 'Tyree', 'Runolfsdottir', 'rodriguez.nathan@example.net', '675-036-812', 'abfdc4140073765af17a7992a3ab77f7c057b226', '2019-11-04 19:03:45', '2014-12-20 07:27:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (23, 'Reid', 'Breitenberg', 'cschinner@example.net', '02748255812', '67aa7d3d4f628cadfb6a193c9f17bff3fb9b08c9', '1983-09-21 10:28:29', '1972-08-17 08:43:23');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (24, 'Louie', 'Pouros', 'rlynch@example.org', '904.085.018', '8eb1393e231507f2f9151643ace2c698f883e5aa', '2006-07-30 03:53:12', '1996-01-19 05:22:28');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (25, 'Guido', 'Kuvalis', 'vjacobs@example.net', '379.200.419', 'e9673fdf64c2ca1062741904e05bb03c730d54f4', '1991-12-19 10:21:59', '1976-10-12 06:15:33');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (26, 'Hobart', 'Farrell', 'onie88@example.com', '188-965-441', '85c39f4e9502bfad406a08d30c30e9847037ebc7', '2021-05-10 19:18:13', '2002-01-12 09:38:03');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (27, 'Dino', 'Rutherford', 'heathcote.naomi@example.com', '(503)103-23', '1d6cea2d6efd8da6473e1edfcd6b217299da9c9a', '1978-11-25 16:55:21', '2007-01-05 04:55:25');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (28, 'Griffin', 'Gislason', 'schmidt.clare@example.org', '985.524.336', '463b693b2da8ae3fd56737f0c4b7695942507d0a', '2003-10-10 14:11:49', '2007-09-24 17:27:53');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (29, 'Elmore', 'Paucek', 'dbeer@example.org', '00122622639', '7a14ee63dc03c0f6f78c266786e199c240fe040d', '2021-04-02 21:07:59', '2020-01-27 06:27:40');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (30, 'Keely', 'Johnson', 'ubaldo42@example.org', '04849584824', '96588d5b1982a7845fd6be2459f645d3bc35e21b', '1973-04-13 14:48:50', '1985-05-05 05:13:02');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (31, 'Jasper', 'Borer', 'tdickinson@example.com', '+38(1)80223', '94d846cb38a8fe81efd7395e8d695599effd099a', '2010-05-14 15:51:29', '1977-04-05 00:18:41');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (32, 'Merlin', 'Koepp', 'langworth.maudie@example.com', '1-478-753-9', 'f59c0ecb7bcb2645299ad738d9ac9f5673ea8543', '1972-04-08 07:13:06', '2021-06-26 19:35:45');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (33, 'Chelsea', 'Haag', 'anika.homenick@example.net', '05858648542', '6aed5239622071d6aacbc75f6dca77f07b62ae10', '1974-07-06 07:56:02', '2005-06-21 19:58:44');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (34, 'Shayne', 'Johnson', 'herbert12@example.com', '121.211.846', 'a9d96ee13335748ba5a862274a6d997f4bae4be3', '1997-03-04 03:33:18', '1973-06-23 09:16:12');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (35, 'Vernie', 'Brakus', 'morissette.king@example.net', '1-389-222-6', '6db1f1a95c4d68e61d920a60baaff452190d4545', '2018-01-18 17:51:56', '1979-02-13 07:48:54');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (36, 'Gus', 'Swaniawski', 'bhauck@example.com', '453-869-666', 'ce7411a7a768705206574ab952038956b81553bb', '1974-11-13 23:27:36', '2011-09-26 13:38:48');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (37, 'Vidal', 'Spencer', 'edd86@example.net', '(271)171-57', '47b985f1d100006601f579db68e7ee1ca268ea20', '1981-05-24 11:32:58', '1970-10-05 23:36:38');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (38, 'Susie', 'Kovacek', 'jamar.krajcik@example.org', '1-916-977-7', 'd3750a72b630d7b624cfdfb97e18a7b2cb221225', '2006-08-09 19:09:45', '1998-10-29 18:32:25');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (39, 'Timmothy', 'Trantow', 'timothy.braun@example.net', '641-064-022', '8bf93da7bd9fbc90c785c6fa5d86beee75c241dd', '2013-03-19 02:56:24', '1990-11-24 12:16:41');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (40, 'Chaz', 'King', 'ariel76@example.com', '(249)117-96', 'faacc7814c67af028c1561a87976aaa420e5b62e', '2010-12-05 03:04:57', '1991-05-01 01:51:33');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (41, 'Samara', 'Pfannerstill', 'eliza.armstrong@example.org', '417.426.309', '924ddd3316e89da99bd1b201e363f6124823d304', '2011-06-10 07:24:32', '1984-07-01 02:01:42');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (42, 'Alfonzo', 'Wintheiser', 'schamberger.oma@example.net', '1-510-095-5', '696f7fd29eeedce34d24545a15ae8cff46a39f29', '1979-09-20 04:31:38', '2013-12-01 06:28:35');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (43, 'Zoila', 'Huel', 'hannah.murazik@example.net', '(344)198-92', '5b69130b2c463a9912ec07a9ce5caa6b60bc7f27', '2011-01-15 15:15:19', '1984-02-03 10:53:38');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (44, 'Alvis', 'Ernser', 'borer.hiram@example.net', '(626)377-84', 'b71b060ea6e4c5eca27dffb2688af41b758f6614', '1994-09-02 20:07:04', '1996-07-30 14:35:53');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (45, 'Johnnie', 'Vandervort', 'erick93@example.com', '362-880-556', '651c1b4957a3d24ab83cecb85f41ad7832bacd18', '1979-08-04 12:27:08', '2015-09-30 09:10:56');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (46, 'Deborah', 'Koepp', 'humberto52@example.com', '1-267-724-3', '15a75471cdb83e1945a40155f6a0b7e6504c9008', '2003-02-18 10:33:13', '2016-05-09 09:59:18');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (47, 'Hayden', 'Bode', 'fay.ralph@example.com', '311-099-448', 'c6f48cdfa6717c58d15e3f61f8dc23dc4518bca2', '2000-08-17 17:35:15', '1995-05-06 03:14:49');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (48, 'Clint', 'Beahan', 'wilkinson.keyon@example.org', '217-928-686', '7890b76ad466756406948fd00e641ee260ec1b5b', '2010-12-17 22:15:06', '1977-06-25 05:45:40');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (49, 'Keegan', 'Huels', 'shamill@example.com', '07786781675', 'd269292610c58e7a6135fd537aa671b938159cab', '1984-03-02 05:05:00', '1983-11-21 07:13:13');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (50, 'Gerard', 'Emard', 'will.alexanne@example.com', '964.225.938', '01ef54da15c90c8f73956dabeb2ddc8743fe03c4', '2016-12-28 17:11:19', '1989-03-12 19:54:51');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (51, 'Graham', 'Nienow', 'xbogisich@example.net', '+88(2)14005', '16cec7d045c9f60a2f170a6b5d899b5e4624fb1a', '1972-05-08 11:32:29', '1980-01-01 06:28:26');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (52, 'Garfield', 'Veum', 'summer77@example.com', '+22(9)90191', 'e9fd53bb0a5afbd4df8d0c26adb6b852d628ed4a', '1971-12-25 12:21:26', '1977-08-12 21:11:48');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (53, 'Hildegard', 'Mann', 'asia18@example.net', '04549757634', 'afb247cb5b0cae7afc0f289b8752decd194e4579', '1977-05-18 12:36:19', '1986-12-08 22:30:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (54, 'Ahmed', 'Jakubowski', 'vern.fahey@example.com', '160.823.150', 'a36eb4d3ceb0fe81a9af2d074bdb6438973c32bc', '1990-02-19 16:50:19', '2013-12-20 00:43:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (55, 'Alize', 'Eichmann', 'hhowe@example.net', '418-691-927', '8effe6a5e84526dda54a479886bf5170c7e5db7d', '1984-04-26 12:28:03', '1970-09-21 13:18:44');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (56, 'Ward', 'Bruen', 'cwhite@example.net', '788-973-366', '085ec0e45197bc7c09fecb4f662a501a45398bae', '1985-05-13 05:33:13', '1978-10-06 02:11:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (57, 'Mittie', 'Abshire', 'dolores90@example.com', '1-002-744-6', '7fdd9c171ef87ad40c34ae8b3b33f890fed88494', '1993-12-24 13:00:07', '1977-06-04 00:52:23');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (58, 'Miller', 'Wilderman', 'cmoen@example.com', '383.244.230', '72b4b0e47a2aa685086618abed51ae75f2ca6096', '1990-06-02 10:29:34', '2011-11-02 07:58:31');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (59, 'Ahmed', 'Aufderhar', 'gorczany.neoma@example.net', '(385)214-62', '8ebc6a5a996336080160813f52e742527c32de65', '1970-08-28 08:58:51', '1986-01-10 10:27:19');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (60, 'Dayne', 'VonRueden', 'silas79@example.org', '08525258951', 'a0f9ad4f7e602f0b45564c405772289f33e8a298', '2001-04-29 20:24:38', '1990-11-20 21:37:41');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (61, 'Birdie', 'Paucek', 'lizzie69@example.net', '752-299-681', 'f71aa8ba178bd8f97a05140a0b9dd68bf78f0800', '1983-03-18 08:14:35', '1986-01-02 12:49:03');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (62, 'Maryse', 'Frami', 'mina25@example.net', '1-026-080-9', '7800ab63e13c8ee9e5016762a3151c0072e30989', '2003-05-31 01:17:48', '2006-12-09 04:14:10');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (63, 'Corbin', 'Howe', 'rkulas@example.com', '004.916.980', '8bd49c83cd355ab6662e1ee76afb27414e1eda79', '1992-07-27 19:33:19', '1984-05-20 00:48:22');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (64, 'Jaylen', 'Vandervort', 'sigurd.little@example.org', '1-291-870-7', '78cac41a835f97eb2f01c423ecf32d69f4dc5a42', '2009-06-11 09:32:36', '2011-07-13 10:13:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (65, 'Lola', 'Hilpert', 'samantha26@example.net', '020-356-873', '36f535776bc842d738b6671306c1a832ac150801', '2012-04-09 14:44:17', '1977-01-11 09:38:18');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (66, 'Katrine', 'Williamson', 'esmitham@example.com', '+02(9)56218', '2d9d117846c9bf33b6c22df48fbc7018762e8d14', '1973-04-28 03:33:56', '1988-05-11 17:39:54');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (67, 'Maude', 'Hayes', 'mmcclure@example.org', '09709781764', '66bd096fa944275b377beb7d057be5e8203dd18f', '2007-08-15 10:09:49', '1984-02-15 14:29:23');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (68, 'Ambrose', 'Crooks', 'annabell05@example.org', '+66(4)75703', '60dcde0940aa01c259666bd552ff0381e50a0e6a', '1970-06-10 20:32:54', '2013-09-09 09:48:42');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (69, 'Ignatius', 'Abernathy', 'shanny30@example.com', '(492)267-28', '039d1ad2303eb16e5bcf971cd1e8f5ded8fbd9f6', '1972-03-22 01:59:20', '1992-08-16 02:15:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (70, 'Orland', 'Bartell', 'gusikowski.lelah@example.org', '439-837-654', '5645ff50bdc9df5df08cfdeb52931e634cc641c0', '2006-05-01 13:20:17', '2000-04-24 05:41:58');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (71, 'Corbin', 'Ankunding', 'kdenesik@example.com', '+43(8)21296', 'f7fd5225f25263f4c36d50418a7f7d8f1000e915', '1989-03-24 08:37:10', '2017-08-20 10:07:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (72, 'Leonora', 'Stehr', 'mozelle83@example.org', '885-086-259', '819ad531bc14593784cae6e0988a1e5848e81b5f', '1994-12-14 12:27:52', '2005-06-16 04:21:33');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (73, 'Nicklaus', 'Rodriguez', 'destany.adams@example.com', '583-127-911', 'f6a7d74b442f6171a140e16a1d0f520d38fe5e49', '1992-08-09 17:05:12', '2007-05-27 05:56:34');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (74, 'Camron', 'Gutmann', 'kathleen.treutel@example.com', '01016621908', '2c82cb54d0d78f5409280906d9b53b7d0e0b7534', '1989-08-13 18:55:35', '1970-10-22 13:02:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (75, 'Mose', 'Wolff', 'emard.weldon@example.net', '573.405.274', 'a66afbbd1bcd6ac3871b3c343299d583b301f976', '1988-12-08 22:26:07', '2002-11-08 09:40:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (76, 'Chad', 'Wolf', 'lratke@example.net', '1-319-497-7', '79ad7f3b4a6945c335bff8cdb2114d40e821299a', '2020-03-28 19:20:24', '1985-10-27 09:54:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (77, 'Makayla', 'Bergnaum', 'hirthe.stanford@example.org', '231-862-096', '3d5e4dee69ebd0ef84fa37b39d9fbdb1d99a75bc', '2002-03-20 02:46:24', '1985-08-06 07:05:39');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (78, 'Zelma', 'Kessler', 'fidel.stiedemann@example.org', '+46(5)31878', '8ff94433e8e1202185d32e42ca202dce7500d774', '2008-02-07 11:01:19', '1987-05-25 17:26:40');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (79, 'Marlin', 'Kub', 'antoinette.king@example.org', '1-057-276-2', '2ce93124bc9b82615dcc06fd1cc3f0bb18f28900', '2001-03-07 20:05:29', '2014-12-16 03:25:44');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (80, 'Anita', 'Schoen', 'pouros.rhianna@example.com', '374.116.183', '222a396e82068612fee9cddcc76c7185e29219c2', '1997-03-05 01:23:38', '1970-11-22 20:14:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (81, 'Delphine', 'Kemmer', 'karen01@example.org', '688-866-684', '60bc786fff107c3bccd1c2856ffac2919199f8f4', '1982-03-25 23:16:00', '1991-09-21 23:14:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (82, 'Noemi', 'Dooley', 'samara84@example.org', '02315822970', 'd715aab78e24518499b015ad6c8be6506112238d', '2014-09-01 06:28:42', '1994-08-31 22:17:58');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (83, 'Sonya', 'Weber', 'feest.iva@example.com', '549-745-415', 'dddc3b514b411e8eff88aa05a1aadda7144467da', '2012-04-19 09:42:20', '1997-11-13 03:06:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (84, 'Aidan', 'Gleason', 'veronica31@example.com', '(275)905-65', '654f84160ed524ca7993197164b4dd6ffe6bb193', '2001-08-10 01:48:55', '2003-06-18 19:12:49');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (85, 'Paul', 'Green', 'pbechtelar@example.com', '(148)746-86', '46e8cba48dc59f2e3dcb8c8de86ff9b44e14b6a6', '2009-09-09 15:21:52', '2019-09-19 02:39:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (86, 'Elsa', 'Murphy', 'josefa76@example.org', '134.001.016', 'ff8b22b5fcfaea7e66437caa7aa27a98b8562d54', '2000-05-01 00:24:10', '2014-07-22 07:20:39');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (87, 'Lula', 'Schaefer', 'hannah83@example.net', '(542)470-57', 'e078761c355ec7ef4c213e9c9dfd82df056dc9f7', '1994-08-07 15:47:51', '1987-12-17 00:12:23');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (88, 'Blanca', 'Beer', 'nkeeling@example.net', '029-889-429', 'c9bd4072939b91cc85a3be8a8a0d83a339a265c7', '2019-03-30 16:52:29', '2016-10-15 22:22:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (89, 'Audra', 'Stiedemann', 'craig07@example.com', '(257)267-39', '7b5de69bdeec0ea44443530ed5459801da9e7544', '2006-11-02 14:03:45', '2006-02-04 10:50:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (90, 'Horacio', 'Cole', 'cmertz@example.org', '1-861-704-4', '985129ae6eb0f619695f27016ca3d50a04a6ab4f', '2008-02-06 07:10:50', '1978-01-09 20:49:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (91, 'Andreane', 'Hermiston', 'marquis39@example.com', '912-532-283', 'cd660b29b3dd5370fb24ea44494acf90895632fd', '2011-05-27 00:00:26', '2003-05-18 13:11:43');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (92, 'Jovan', 'Huels', 'neha70@example.net', '1-901-177-3', 'a135bcbd3c1cb31cc20ee2428df523a047dc2376', '1979-01-20 14:18:05', '1987-12-05 00:16:58');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (93, 'Garfield', 'Goodwin', 'iauer@example.org', '771-782-315', '89cf714be7ad7c5fabff7806cf03831901e9836a', '1995-10-28 17:16:29', '1979-03-18 04:40:25');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (94, 'Adriana', 'Welch', 'gerlach.willie@example.com', '402-361-430', '4a6461e86bba037bec00f5204d8f9d8700806709', '2011-08-24 04:24:05', '1989-11-16 14:26:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (95, 'Litzy', 'Heller', 'konopelski.melyna@example.org', '610-766-164', 'f24b367cc6fc8addc0eb88106d4298d47ace3bef', '1986-12-16 16:56:51', '2014-12-11 04:31:52');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (96, 'Shanie', 'Hills', 'lcole@example.net', '882-115-742', '26b50da9b70a2c50ceae7d53ac88e966d2777a0f', '2009-04-12 01:55:18', '2019-03-16 02:46:55');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (97, 'Kaela', 'Hayes', 'dolores.runolfsson@example.com', '+61(4)86622', '509d4926efbfcaa55761b98990c3fec023e78bd2', '1973-11-14 14:13:54', '2011-02-26 16:28:25');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (98, 'Kyler', 'Runolfsdottir', 'homenick.marilou@example.net', '328.857.493', '0a469dbfd85ef9967697c2f957079a683e40142d', '1998-10-07 10:45:49', '2013-03-08 16:05:21');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (99, 'Claud', 'Langworth', 'walker.yolanda@example.org', '965-475-944', '67294c19b3604391f1332ec5072d3b7ea7c227cd', '1998-09-23 06:17:11', '1986-01-06 06:23:14');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`, `updated_at`) VALUES (100, 'Meaghan', 'Bailey', 'eschaden@example.net', '1-180-451-7', 'd104ab6330e3a705cae1cd5f31e074612a27a7dc', '1979-12-02 04:47:42', '1998-03-25 15:38:23');

SET FOREIGN_KEY_CHECKS=1;

-- Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»
-- п.1
-- update users set created_at = null, updated_at = null
-- where (id between 20 and 50);
update users set created_at = null where (id between 20 and 50);
update users set updated_at = null where (id between 30 and 70);

select * from users
where (created_at is null) or (updated_at is null);

select now();

update users set created_at = now() where (created_at is null);
update users set updated_at = now() where (updated_at is null);

-- п.2
alter table users modify created_at VARCHAR(20);
alter table users modify updated_at VARCHAR(20);

desc users;
select * from users;
update users set created_at = '20.10.2017 8:10', updated_at = '20.10.2017 8:10';

select created_at, str_to_date(created_at, '%d.%m.%Y %H:%i') from users;

update users set created_at = str_to_date(created_at, '%d.%m.%Y %H:%i'), updated_at = str_to_date(updated_at, '%d.%m.%Y %H:%i');

alter table users modify created_at DATETIME;
alter table users modify updated_at DATETIME;

-- п.3
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  name VARCHAR(100) NOT NULL,
  value integer
);

INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('aspernatur', 0);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('similique', 31);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('nostrum', 1565);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('eveniet', 1443);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('non', 991);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('ut', 823);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('amet', 567);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('repellat', 201);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('officiis', 510);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('cumque', 49);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('totam', 0);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('non', 119);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('sit', 1567);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('odit', 1194);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('et', 0);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('nobis', 1177);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('non', 925);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('sunt', 970);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('soluta', 0);
INSERT INTO `storehouses_products` (`name`, `value`) VALUES ('dolorem', 1615);

select * from storehouses_products
order by value = 0, value asc;

-- п.4
select monthname(t2.birthday), t1.*, t2.*
from users t1, profiles t2
where (t1.id = t2.user_id)
 and (lower(monthname(birthday)) in ('may', 'august'));

-- п.4
select * from storehouses_products
where (value in (1443, 925, 1615))
order by value = 1615, value = 925, value = 1443;

-- Практическое задание теме «Агрегация данных»
-- п.1
-- select t1.id, t2.birthday, year(now()) - year(t2.birthday) age
-- from users t1, profiles t2
-- where (t1.id = t2.user_id);
select avg(year(now()) - year(t2.birthday)) age_avg
from users t1, profiles t2
where (t1.id = t2.user_id);
-- п.2
-- select t1.id, t2.birthday
-- 	  ,str_to_date(concat(date_format(now(), '%Y'),date_format(t2.birthday, '%m%d')), '%Y%m%d')
-- 	  ,DAYOFWEEK(str_to_date(concat(date_format(now(), '%Y'),date_format(t2.birthday, '%m%d')), '%Y%m%d'))
-- from users t1, profiles t2
-- where (t1.id = t2.user_id);
select DAYOFWEEK(str_to_date(concat(date_format(now(), '%Y'),date_format(t2.birthday, '%m%d')), '%Y%m%d'))
      ,count(*)
from users t1, profiles t2
where (t1.id = t2.user_id)
group by DAYOFWEEK(str_to_date(concat(date_format(now(), '%Y'),date_format(t2.birthday, '%m%d')), '%Y%m%d'));
-- п.3
select exp(sum(log(value))) from storehouses_products;

