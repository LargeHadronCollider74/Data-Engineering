DROP DATABASE IF EXISTS works;
CREATE DATABASE works;
USE works;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  login VARCHAR(100),
  password_hash VARCHAR(100),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone CHAR(11) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  department_id INT UNSIGNED,
  photo_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) on delete cascade,
  FOREIGN KEY (department_id) REFERENCES departments(id) on delete set null
);

DROP TABLE IF EXISTS works;
CREATE TABLE works (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	started_id DATETIME,
	deadline_id DATETIME,
	finished_id DATETIME,
  title VARCHAR(2000),
  `description` VARCHAR(2000),
  owner_user_id INT UNSIGNED,
  closer_user_id INT UNSIGNED,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (owner_user_id) REFERENCES users(id) on delete set null,
  FOREIGN KEY (closer_user_id) REFERENCES users(id) on delete set null
);

DROP TABLE IF EXISTS description_macro;
CREATE TABLE description_macro (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  macro VARCHAR(2000),

  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS works_actions;
CREATE TABLE works_actions (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  work_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED,
  `action` VARCHAR(2000),
  inserted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (work_id) REFERENCES works(id) on delete cascade,
  FOREIGN KEY (user_id) REFERENCES users(id) on delete set null
);

DROP TABLE IF EXISTS confimition_answers;
CREATE TABLE confimition_answers (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name INT UNSIGNED NOT NULL,

  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS work_confimition;
CREATE TABLE work_confimition (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  work_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  answer_id INT UNSIGNED NOT NULL,

  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (work_id) REFERENCES works(id) on delete cascade,
  FOREIGN KEY (user_id) REFERENCES users(id) on delete cascade,
  FOREIGN KEY (answer_id) REFERENCES users(id) on delete cascade
);

DROP TABLE IF EXISTS works_docs;
CREATE TABLE works_docs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  work_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED,
  media_id INT UNSIGNED NOT NULL,
  inserted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (work_id) REFERENCES works(id) on delete cascade,
  -- FOREIGN KEY (media_id) REFERENCES media(id) on delete cascade,
  FOREIGN KEY (user_id) REFERENCES users(id) on delete set null
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  media_type_id INT UNSIGNED,
  filename VARCHAR(255) NOT NULL UNIQUE COMMENT "просто імя файла",
  filebody blob NOT NULL COMMENT "тело файла",
  media json comment "некое краткое описание файла",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (media_type_id) REFERENCES media_types(id) on delete set null
);

ALTER TABLE works_docs ADD CONSTRAINT works_docs_media_id FOREIGN KEY (media_id) REFERENCES media(id) on delete cascade;
ALTER TABLE profiles ADD CONSTRAINT profiles_photo_id FOREIGN KEY (photo_id) REFERENCES media(id) on delete set null;

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO `confimition_answers` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 0, '1986-06-24 05:28:46', '1975-06-29 14:52:11');
INSERT INTO `confimition_answers` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 0, '2010-11-25 23:27:59', '1997-10-22 04:19:15');
INSERT INTO `confimition_answers` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 0, '2016-04-11 23:12:13', '2011-09-22 07:48:37');

INSERT INTO `departments` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'et', '1983-05-07 05:20:11', '2013-09-07 02:44:07');
INSERT INTO `departments` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'ab', '1974-04-20 15:30:56', '1984-11-05 09:29:52');
INSERT INTO `departments` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'odit', '1979-07-12 04:35:35', '2016-06-20 19:20:02');
INSERT INTO `departments` (`id`, `name`, `created_at`, `updated_at`) VALUES (4, 'distinctio', '1974-04-24 14:28:33', '1997-10-27 09:27:14');
INSERT INTO `departments` (`id`, `name`, `created_at`, `updated_at`) VALUES (5, 'est', '1986-10-01 14:24:03', '2003-07-21 02:50:17');

INSERT INTO `description_macro` (`id`, `macro`, `created_at`, `updated_at`) VALUES (1, 'Omnis et velit nesciunt sit sequi in.', '2017-09-22 05:54:15', '2001-12-30 11:16:16');
INSERT INTO `description_macro` (`id`, `macro`, `created_at`, `updated_at`) VALUES (2, 'Rem cum libero reprehenderit.', '2003-02-16 01:08:06', '2011-03-25 13:19:54');
INSERT INTO `description_macro` (`id`, `macro`, `created_at`, `updated_at`) VALUES (3, 'Omnis dolores impedit neque repellat beatae praesentium nam.', '2016-01-31 09:02:49', '1995-05-29 19:16:53');
INSERT INTO `description_macro` (`id`, `macro`, `created_at`, `updated_at`) VALUES (4, 'Tempora rerum numquam quaerat dolore eos vero.', '2014-10-24 15:03:38', '1993-09-07 05:20:24');
INSERT INTO `description_macro` (`id`, `macro`, `created_at`, `updated_at`) VALUES (5, 'Labore quae est et rem sed reprehenderit dignissimos.', '2016-12-18 23:07:11', '1983-03-05 11:59:42');
INSERT INTO `description_macro` (`id`, `macro`, `created_at`, `updated_at`) VALUES (6, 'Molestiae magnam dicta minus quos doloremque cupiditate animi.', '1997-04-15 20:41:30', '2014-02-12 14:16:33');
INSERT INTO `description_macro` (`id`, `macro`, `created_at`, `updated_at`) VALUES (7, 'Soluta eum dolores dolorem omnis deleniti quia.', '2002-07-24 02:55:25', '2014-09-19 20:58:10');
INSERT INTO `description_macro` (`id`, `macro`, `created_at`, `updated_at`) VALUES (8, 'Ea magni dolorem unde enim quos.', '2019-12-28 07:23:51', '1987-04-11 00:09:26');
INSERT INTO `description_macro` (`id`, `macro`, `created_at`, `updated_at`) VALUES (9, 'Et ut repudiandae excepturi omnis vel rerum ut qui.', '2018-06-16 23:38:14', '1975-10-23 10:15:11');
INSERT INTO `description_macro` (`id`, `macro`, `created_at`, `updated_at`) VALUES (10, 'Sunt dicta alias aperiam vel.', '2002-01-09 05:22:56', '1989-05-20 08:11:49');

INSERT INTO `media` (`id`, `media_type_id`, `filename`, `filebody`, `media`, `created_at`, `updated_at`) VALUES (1, 1, 'cumque', 'Occaecati ex magnam iste delectus odio. Et odio saepe ad quis. Nisi nisi exercitationem neque quasi.', NULL, '1992-02-16 15:23:20', '2010-05-14 10:31:07');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `filebody`, `media`, `created_at`, `updated_at`) VALUES (2, 2, 'recusandae', 'Minima amet facere aut corporis. Aperiam autem quo aut nesciunt error ea odio. Velit omnis possimus deleniti enim aut. Nostrum pariatur autem nulla molestiae.', NULL, '2008-09-06 13:09:20', '2011-07-29 15:25:46');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `filebody`, `media`, `created_at`, `updated_at`) VALUES (3, 3, 'dolor', 'Sunt suscipit asperiores sequi. Enim eum sed et necessitatibus voluptate vero molestias. Sit dignissimos sint qui rerum.', NULL, '2015-05-08 21:40:55', '2011-01-30 23:27:07');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `filebody`, `media`, `created_at`, `updated_at`) VALUES (4, 4, 'alias', 'Et est minima quisquam aliquam molestiae facilis. Repellendus voluptatem voluptatem velit expedita quibusdam consequatur. Ab dolorum necessitatibus dolor eligendi. Non sapiente beatae voluptas libero vitae aut.', NULL, '2010-09-15 01:20:47', '1975-05-26 16:14:02');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `filebody`, `media`, `created_at`, `updated_at`) VALUES (5, 5, 'dolorum', 'Quae enim dicta velit sapiente autem autem labore. Voluptas veniam distinctio veritatis itaque. Magni accusantium necessitatibus hic est.', NULL, '1989-10-24 11:04:33', '1985-12-30 06:33:37');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `filebody`, `media`, `created_at`, `updated_at`) VALUES (6, 1, 'iste', 'Quidem autem voluptatem debitis facere fugit et. Voluptatem est soluta placeat voluptatibus sequi omnis quia.', NULL, '1974-03-30 10:09:18', '2020-10-22 23:27:06');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `filebody`, `media`, `created_at`, `updated_at`) VALUES (7, 2, 'asperiores', 'Necessitatibus omnis quod hic. Impedit earum atque dolor fugit fuga.', NULL, '1996-05-09 08:47:26', '1993-11-05 03:09:51');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `filebody`, `media`, `created_at`, `updated_at`) VALUES (8, 3, 'dolorem', 'Magnam sunt et cum ipsum inventore aspernatur. Ex molestiae assumenda asperiores. Harum sapiente dolor aut dignissimos. Ut rem quia ipsam qui occaecati magnam ipsa. Rerum autem nesciunt dolorem sit autem.', NULL, '2002-11-23 22:16:51', '1999-09-29 09:32:52');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `filebody`, `media`, `created_at`, `updated_at`) VALUES (9, 4, 'minus', 'Ut animi nihil labore consequatur vel tenetur. Officia nemo error in voluptatem explicabo ex voluptas tempora. Quod consequatur non necessitatibus inventore vel possimus sint ab.', NULL, '1972-12-06 18:33:36', '1977-12-16 05:34:26');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `filebody`, `media`, `created_at`, `updated_at`) VALUES (10, 5, 'molestiae', 'Cum voluptas dignissimos nihil voluptates consequatur. Natus et ab amet animi sed rerum consectetur cupiditate. Veniam a itaque dolorum odit. Dolorem qui ipsum cupiditate officia provident omnis.', NULL, '1994-04-29 05:40:10', '1977-02-10 05:04:51');

INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'deleniti', '2002-08-09 11:19:18', '1980-11-02 11:25:56');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'asperiores', '1976-12-18 08:01:28', '2014-10-18 02:57:42');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'et', '2015-11-07 09:57:28', '1985-10-02 05:03:23');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (4, 'rerum', '2016-04-11 19:39:01', '1982-11-01 01:25:10');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (5, 'quis', '2015-02-03 07:20:05', '2003-06-24 09:27:21');

INSERT INTO `profiles` (`id`, `user_id`, `department_id`, `photo_id`, `created_at`, `updated_at`) VALUES (1, 1, 1, 1, '1972-01-08 10:57:56', '1995-06-22 07:24:42');
INSERT INTO `profiles` (`id`, `user_id`, `department_id`, `photo_id`, `created_at`, `updated_at`) VALUES (2, 2, 2, 2, '1996-11-24 23:50:22', '1999-04-13 11:01:22');
INSERT INTO `profiles` (`id`, `user_id`, `department_id`, `photo_id`, `created_at`, `updated_at`) VALUES (3, 3, 3, 3, '1972-02-29 15:09:56', '2011-11-04 21:50:47');
INSERT INTO `profiles` (`id`, `user_id`, `department_id`, `photo_id`, `created_at`, `updated_at`) VALUES (4, 4, 4, 4, '1983-07-16 21:23:37', '2003-02-26 11:27:24');
INSERT INTO `profiles` (`id`, `user_id`, `department_id`, `photo_id`, `created_at`, `updated_at`) VALUES (5, 5, 5, 5, '2013-04-17 03:50:26', '2004-03-30 18:16:49');
INSERT INTO `profiles` (`id`, `user_id`, `department_id`, `photo_id`, `created_at`, `updated_at`) VALUES (6, 6, 1, 6, '2011-02-24 22:52:15', '1981-09-15 13:32:39');
INSERT INTO `profiles` (`id`, `user_id`, `department_id`, `photo_id`, `created_at`, `updated_at`) VALUES (7, 7, 2, 7, '1980-12-22 16:12:34', '2015-01-21 11:04:30');
INSERT INTO `profiles` (`id`, `user_id`, `department_id`, `photo_id`, `created_at`, `updated_at`) VALUES (8, 8, 3, 8, '2018-05-14 17:00:01', '2008-02-24 11:49:24');
INSERT INTO `profiles` (`id`, `user_id`, `department_id`, `photo_id`, `created_at`, `updated_at`) VALUES (9, 9, 4, 9, '1982-07-10 18:18:07', '1978-03-25 11:57:48');
INSERT INTO `profiles` (`id`, `user_id`, `department_id`, `photo_id`, `created_at`, `updated_at`) VALUES (10, 10, 5, 10, '2013-05-05 16:23:49', '2004-12-28 13:29:07');

INSERT INTO `users` (`id`, `login`, `password_hash`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (1, 'et', 'a1d8900d00f4915c07a56e1a2aa35249dc01962c', 'Elisabeth', 'Treutel', 'nkerluke@example.org', '331.394.741', '1972-01-19 11:41:40', '1991-01-24 21:00:47');
INSERT INTO `users` (`id`, `login`, `password_hash`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (2, 'qui', '52cfa130d6e340ac95577f4d8638c1fa8e45d1a0', 'Marlin', 'Denesik', 'robyn86@example.org', '510-846-984', '1973-10-20 16:56:51', '1988-11-14 02:25:57');
INSERT INTO `users` (`id`, `login`, `password_hash`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (3, 'et', 'fc1e99d72e53514d7d4d65b117f1ec22b75fb71e', 'Glen', 'Roberts', 'terry.auer@example.org', '748-375-693', '2000-12-04 19:58:29', '1998-01-21 23:03:09');
INSERT INTO `users` (`id`, `login`, `password_hash`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (4, 'quaerat', '8c3d03cdb312360dafa6276f10e853752250fcaa', 'Gage', 'Sporer', 'ned.konopelski@example.com', '240.223.763', '1998-03-04 23:05:29', '1984-06-16 11:11:52');
INSERT INTO `users` (`id`, `login`, `password_hash`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (5, 'explicabo', '7ac06d3a9d97898540ec62c750b7d8a88e31c807', 'Buford', 'Hartmann', 'deckow.luigi@example.net', '+68(8)27795', '1993-03-01 02:28:49', '2012-08-30 16:48:51');
INSERT INTO `users` (`id`, `login`, `password_hash`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (6, 'veritatis', 'fd07c0808e38a8e9e8f6f918f72a8c3430c4d1d8', 'Garrick', 'VonRueden', 'lelia90@example.com', '036-518-524', '1981-02-13 23:55:27', '1983-10-21 13:42:33');
INSERT INTO `users` (`id`, `login`, `password_hash`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (7, 'qui', '541ffa67965de44f4a3345aaa730e07d66dea7fb', 'Brenna', 'Berge', 'savion.leffler@example.org', '673.324.254', '1997-01-21 09:45:16', '2014-03-01 04:03:08');
INSERT INTO `users` (`id`, `login`, `password_hash`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (8, 'delectus', '17cea7a6dc77263b8f8efdb42f12b9908b098e01', 'Camden', 'Lind', 'rortiz@example.net', '821.850.580', '2016-06-18 13:14:07', '1983-05-07 15:15:15');
INSERT INTO `users` (`id`, `login`, `password_hash`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (9, 'qui', '0e7927079a0ccd6f485fe24b802f98781b50319c', 'Nikki', 'Pfeffer', 'jessie.brown@example.com', '04054240269', '2006-07-30 01:33:18', '1970-12-11 21:46:06');
INSERT INTO `users` (`id`, `login`, `password_hash`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (10, 'qui', '5c9fb111d89d99ff8a247f72b0e6063e01330c99', 'Raven', 'Blanda', 'fanny.dicki@example.net', '(809)755-41', '1987-07-25 10:43:18', '2008-04-05 05:57:21');

INSERT INTO `work_confimition` (`id`, `work_id`, `user_id`, `answer_id`, `created_at`, `updated_at`) VALUES (1, 1, 1, 1, '1975-11-13 04:10:05', '1982-03-13 09:51:15');
INSERT INTO `work_confimition` (`id`, `work_id`, `user_id`, `answer_id`, `created_at`, `updated_at`) VALUES (2, 2, 2, 2, '2001-01-03 08:01:05', '1972-12-23 19:42:08');
INSERT INTO `work_confimition` (`id`, `work_id`, `user_id`, `answer_id`, `created_at`, `updated_at`) VALUES (3, 3, 3, 3, '2017-04-22 03:03:06', '2007-09-27 15:51:25');
INSERT INTO `work_confimition` (`id`, `work_id`, `user_id`, `answer_id`, `created_at`, `updated_at`) VALUES (4, 4, 4, 1, '1982-12-28 08:06:58', '2017-08-19 08:50:01');
INSERT INTO `work_confimition` (`id`, `work_id`, `user_id`, `answer_id`, `created_at`, `updated_at`) VALUES (5, 5, 5, 2, '1986-03-15 21:40:54', '2008-03-03 21:30:07');
INSERT INTO `work_confimition` (`id`, `work_id`, `user_id`, `answer_id`, `created_at`, `updated_at`) VALUES (6, 6, 6, 3, '1986-03-03 07:04:20', '1974-04-22 20:26:04');
INSERT INTO `work_confimition` (`id`, `work_id`, `user_id`, `answer_id`, `created_at`, `updated_at`) VALUES (7, 7, 7, 1, '1996-06-13 12:36:41', '1973-08-27 22:56:07');
INSERT INTO `work_confimition` (`id`, `work_id`, `user_id`, `answer_id`, `created_at`, `updated_at`) VALUES (8, 8, 8, 2, '1993-06-08 10:05:13', '1981-12-18 05:55:26');
INSERT INTO `work_confimition` (`id`, `work_id`, `user_id`, `answer_id`, `created_at`, `updated_at`) VALUES (9, 9, 9, 3, '1993-06-12 05:19:41', '2012-07-30 14:31:11');
INSERT INTO `work_confimition` (`id`, `work_id`, `user_id`, `answer_id`, `created_at`, `updated_at`) VALUES (10, 10, 10, 1, '2006-09-17 05:15:21', '2002-05-05 21:12:28');

INSERT INTO `works` (`id`, `created_at`, `started_id`, `deadline_id`, `finished_id`, `title`, `description`, `owner_user_id`, `closer_user_id`, `updated_at`) VALUES (1, '2000-03-20 15:15:00', '2004-08-04 23:49:07', '1999-08-16 13:26:05', '2005-07-19 08:27:25', 'Eos sit beatae tempora minima odit sint quisquam esse.', 'Necessitatibus est animi voluptates qui eos animi repellat impedit voluptatem voluptatem illum rem quaerat quod non amet magnam qui modi officia modi facilis voluptatem id voluptatem sunt ut.', 1, 1, '1987-08-30 12:16:21');
INSERT INTO `works` (`id`, `created_at`, `started_id`, `deadline_id`, `finished_id`, `title`, `description`, `owner_user_id`, `closer_user_id`, `updated_at`) VALUES (2, '2008-04-27 22:03:42', '1983-01-21 23:43:15', '1985-12-29 16:17:22', '1982-01-23 11:14:33', 'Quae eaque sed placeat sit consequuntur.', 'Ut tenetur qui mollitia perferendis ipsum et itaque qui quasi molestiae nam sequi in a recusandae rerum optio ducimus tempore qui modi nobis dolorum ut eos temporibus.', 2, 2, '1970-03-02 00:03:56');
INSERT INTO `works` (`id`, `created_at`, `started_id`, `deadline_id`, `finished_id`, `title`, `description`, `owner_user_id`, `closer_user_id`, `updated_at`) VALUES (3, '2000-08-26 03:57:45', '1992-08-14 03:53:30', '1974-08-24 23:21:00', '2000-09-03 01:49:35', 'Est asperiores deleniti amet unde.', 'Asperiores magnam voluptatem qui voluptatem dolores sapiente minus amet aut aperiam ut a et itaque omnis velit rerum suscipit.', 3, 3, '2002-04-27 05:13:14');
INSERT INTO `works` (`id`, `created_at`, `started_id`, `deadline_id`, `finished_id`, `title`, `description`, `owner_user_id`, `closer_user_id`, `updated_at`) VALUES (4, '2001-11-18 15:42:13', '1975-07-02 22:36:34', '1988-05-28 08:02:07', '1995-09-03 02:04:21', 'Quaerat a consequatur repellat corporis veniam voluptate.', 'Consequuntur sed in consequatur quasi sunt numquam voluptatem soluta eaque architecto ratione tempore vel eum et.', 4, 4, '1974-03-17 02:55:41');
INSERT INTO `works` (`id`, `created_at`, `started_id`, `deadline_id`, `finished_id`, `title`, `description`, `owner_user_id`, `closer_user_id`, `updated_at`) VALUES (5, '1971-09-20 00:35:00', '2017-06-07 16:27:52', '1970-06-12 03:01:21', '1984-11-23 17:11:16', 'Harum ad aspernatur placeat debitis quibusdam ipsa et.', 'Sint illo atque voluptatum voluptatem provident est doloremque qui rerum aut ut nisi nihil quisquam et aspernatur.', 5, 5, '1973-06-25 14:24:57');
INSERT INTO `works` (`id`, `created_at`, `started_id`, `deadline_id`, `finished_id`, `title`, `description`, `owner_user_id`, `closer_user_id`, `updated_at`) VALUES (6, '1983-01-10 08:20:50', '1974-03-20 23:29:59', '2004-10-09 18:15:34', '2003-06-27 22:44:01', 'Laudantium aut qui et ut quia possimus a.', 'Qui sit dolores dolor exercitationem perferendis deserunt inventore mollitia laboriosam occaecati quod eligendi error accusantium occaecati sit dolorum et sed enim animi sit blanditiis nulla.', 6, 6, '1970-07-14 09:26:10');
INSERT INTO `works` (`id`, `created_at`, `started_id`, `deadline_id`, `finished_id`, `title`, `description`, `owner_user_id`, `closer_user_id`, `updated_at`) VALUES (7, '2021-08-22 08:16:03', '1992-09-23 10:05:00', '1986-10-28 07:30:26', '1996-05-09 02:43:44', 'Consequatur voluptates consectetur temporibus.', 'Delectus aut similique reprehenderit accusamus eos a reprehenderit laboriosam pariatur et molestias voluptas ullam quidem quia velit consectetur consequatur optio quaerat occaecati voluptatem qui aliquam facere.', 7, 7, '1972-05-03 14:47:59');
INSERT INTO `works` (`id`, `created_at`, `started_id`, `deadline_id`, `finished_id`, `title`, `description`, `owner_user_id`, `closer_user_id`, `updated_at`) VALUES (8, '1986-03-24 21:50:35', '2020-07-09 00:10:56', '2009-01-20 16:24:47', '2011-05-03 21:23:12', 'Quo doloribus et aut officia odit.', 'Quasi numquam est et ut nam dolorem incidunt illum aliquid dolor magni itaque aut consequatur praesentium architecto et.', 8, 8, '2000-01-11 09:55:29');
INSERT INTO `works` (`id`, `created_at`, `started_id`, `deadline_id`, `finished_id`, `title`, `description`, `owner_user_id`, `closer_user_id`, `updated_at`) VALUES (9, '1989-05-02 17:16:19', '1978-03-09 06:00:03', '1977-07-28 02:36:02', '2015-02-02 08:27:52', 'Vitae iusto repellat vero blanditiis dolor omnis aut omnis.', 'Vel quisquam eius occaecati ipsa ipsam totam laborum blanditiis voluptatibus vitae sequi deserunt quam harum eos perspiciatis et repellendus a voluptas autem similique voluptatem quia in impedit aspernatur.', 9, 9, '1974-04-01 14:41:34');
INSERT INTO `works` (`id`, `created_at`, `started_id`, `deadline_id`, `finished_id`, `title`, `description`, `owner_user_id`, `closer_user_id`, `updated_at`) VALUES (10, '1980-12-15 14:35:39', '1972-08-17 05:36:34', '1998-01-16 08:26:12', '1981-10-29 06:28:45', 'Quibusdam unde doloremque et et dolor iusto.', 'Eos rem sed animi ab quaerat corrupti dolorem qui vel rerum quos eveniet doloribus praesentium nihil autem beatae.', 10, 10, '1973-02-10 21:36:00');

INSERT INTO `works_actions` (`id`, `work_id`, `user_id`, `action`, `inserted_at`) VALUES (1, 1, 1, 'Dolor non modi tenetur labore suscipit et.', '1979-03-07 18:29:59');
INSERT INTO `works_actions` (`id`, `work_id`, `user_id`, `action`, `inserted_at`) VALUES (2, 2, 2, 'Corporis maiores ea et enim voluptatem et numquam nesciunt.', '1985-03-12 19:38:09');
INSERT INTO `works_actions` (`id`, `work_id`, `user_id`, `action`, `inserted_at`) VALUES (3, 3, 3, 'Officia consectetur eos quas accusantium autem molestias ut.', '1975-09-03 02:49:45');
INSERT INTO `works_actions` (`id`, `work_id`, `user_id`, `action`, `inserted_at`) VALUES (4, 4, 4, 'Ex est ab dolorem sunt enim nemo quia.', '1995-08-17 02:15:49');
INSERT INTO `works_actions` (`id`, `work_id`, `user_id`, `action`, `inserted_at`) VALUES (5, 5, 5, 'Quo est beatae eaque iure illum in et.', '2016-06-16 14:24:08');
INSERT INTO `works_actions` (`id`, `work_id`, `user_id`, `action`, `inserted_at`) VALUES (6, 6, 6, 'Animi aut optio in aut similique aut id voluptas.', '2013-02-02 09:41:19');
INSERT INTO `works_actions` (`id`, `work_id`, `user_id`, `action`, `inserted_at`) VALUES (7, 7, 7, 'Cumque provident exercitationem harum asperiores quia fuga sapiente nobis.', '1980-11-29 08:42:39');
INSERT INTO `works_actions` (`id`, `work_id`, `user_id`, `action`, `inserted_at`) VALUES (8, 8, 8, 'Quibusdam eligendi voluptatem possimus sit.', '1995-01-21 13:15:02');
INSERT INTO `works_actions` (`id`, `work_id`, `user_id`, `action`, `inserted_at`) VALUES (9, 9, 9, 'Ipsam accusantium labore sint.', '1982-05-01 22:40:09');
INSERT INTO `works_actions` (`id`, `work_id`, `user_id`, `action`, `inserted_at`) VALUES (10, 10, 10, 'Recusandae cupiditate molestias possimus vitae quidem aliquid quo.', '1976-04-30 15:34:54');

INSERT INTO `works_docs` (`id`, `work_id`, `user_id`, `media_id`, `inserted_at`) VALUES (1, 1, 1, 1, '1982-09-30 21:11:20');
INSERT INTO `works_docs` (`id`, `work_id`, `user_id`, `media_id`, `inserted_at`) VALUES (2, 2, 2, 2, '1971-10-21 11:50:32');
INSERT INTO `works_docs` (`id`, `work_id`, `user_id`, `media_id`, `inserted_at`) VALUES (3, 3, 3, 3, '1984-03-17 14:14:48');
INSERT INTO `works_docs` (`id`, `work_id`, `user_id`, `media_id`, `inserted_at`) VALUES (4, 4, 4, 4, '2015-05-28 11:55:09');
INSERT INTO `works_docs` (`id`, `work_id`, `user_id`, `media_id`, `inserted_at`) VALUES (5, 5, 5, 5, '1990-04-06 01:10:48');
INSERT INTO `works_docs` (`id`, `work_id`, `user_id`, `media_id`, `inserted_at`) VALUES (6, 6, 6, 6, '2006-01-13 13:12:51');
INSERT INTO `works_docs` (`id`, `work_id`, `user_id`, `media_id`, `inserted_at`) VALUES (7, 7, 7, 7, '1999-03-07 05:49:00');
INSERT INTO `works_docs` (`id`, `work_id`, `user_id`, `media_id`, `inserted_at`) VALUES (8, 8, 8, 8, '1980-09-24 18:03:42');
INSERT INTO `works_docs` (`id`, `work_id`, `user_id`, `media_id`, `inserted_at`) VALUES (9, 9, 9, 9, '2010-06-10 20:09:42');
INSERT INTO `works_docs` (`id`, `work_id`, `user_id`, `media_id`, `inserted_at`) VALUES (10, 10, 10, 10, '2012-09-19 22:41:30');

SET FOREIGN_KEY_CHECKS=1;



