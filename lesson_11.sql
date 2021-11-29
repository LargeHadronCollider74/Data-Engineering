DROP DATABASE IF EXISTS prd;
CREATE DATABASE prd;
USE prd;

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

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  -- id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  inserted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  `table` VARCHAR(100) not null,
	row_id INT UNSIGNED NOT NULL,
	row_name VARCHAR(200) NOT NULL
) engine = ARCHIVE;

drop trigger if exists trg_logs_users;
DELIMITER $$
CREATE TRIGGER trg_logs_users after insert ON users FOR EACH ROW
BEGIN
  insert into logs (`table`, row_id, row_name) values ('users', new.id, new.name);
END$$
DELIMITER ;

drop trigger if exists trg_logs_catalog;
DELIMITER $$
CREATE TRIGGER trg_logs_catalog after insert ON catalog FOR EACH ROW
BEGIN
  insert into logs (`table`, row_id, row_name) values ('catalog', new.id, new.name);
END$$
DELIMITER ;

drop trigger if exists trg_logs_products;
DELIMITER $$
CREATE TRIGGER trg_logs_products after insert ON products FOR EACH ROW
BEGIN
  insert into logs (`table`, row_id, row_name) values ('products', new.id, new.name);
END$$
DELIMITER ;

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

-- 1
select * from logs;

-- 2
select ceil(rand() * 5);
select substr(md5(rand()), 1, ceil(rand() * 5) + 3);

DROP procedure IF EXISTS users_table_filler;
DELIMITER $$
CREATE procedure users_table_filler (count integer, batch integer)
BEGIN
  declare username varchar(100);
  declare i integer default 0;

  start transaction;
  while (i < count) do
    set username = substr(md5(rand()), 1, ceil(rand() * 5) + 3);
     if not exists(select * from users where (username = name)) then
      insert into users (name) value (username);
      set i = i + 1;
      if (0 = (i % batch)) then
        commit;
        start transaction;
      end if;
     end if;
  end while;
  commit;
END$$
DELIMITER ;

create index ind_users_name on users(name);

select count(*) from logs;
select count(*) from users;
call users_table_filler(1000000, 10000);
