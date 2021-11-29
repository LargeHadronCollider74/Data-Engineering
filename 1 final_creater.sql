/*
"Работы"
- работа имеет кратое и детальное описание
- пользователь создающий работу определяет время начала исполнения, конечный срок и при необходимости согласующих (может не быть согласующих)
- все пользователи могут оставлять коментарии по работе, а также добавлять любые файлы

состояния работы
- на согласовании, если добавлены согласующие и есть хоть один, кто не согласовал
- не согласовано, если хотя бы хоть один из согласующих не согласовал (требовать указать причину)
- на исполнении, согласовано всеми или согласующих небыло
- исполнено, закрыто одним из пользователей, заполняем без участия пользователя closer_user_id, finished_at и требуем заполнить conclution
- просрочено согласование, если не согласовоно а started_at истекла
- просрочено исполнение, если согласовоно а deadline_at истекла
- закрыто успешно, завершено без просрочки
- закрыто, но просрочено

при создании работ, мользователь может выбрать детальное описание из зарание подготовленных шаблонов

авторизация пользователя по login и password_hash
*/

DROP DATABASE IF EXISTS works;
CREATE DATABASE works;
USE works;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  inserted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  `table` VARCHAR(100) not null,
  `action` VARCHAR(100) not null,
	row_id INT UNSIGNED NOT NULL,
	row_data VARCHAR(2000) NOT NULL
) engine = ARCHIVE;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  login VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(100),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone CHAR(15) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
create index ind_users_login on users(login);

drop trigger if exists trg_logs_users_insert;
DELIMITER $$
CREATE TRIGGER trg_logs_users_insert after insert ON users FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('users', 'insert', new.id, concat('login: ', new.login));
END$$
DELIMITER ;

drop trigger if exists trg_logs_users_udpate;
DELIMITER $$
CREATE TRIGGER trg_logs_users_udpate after update ON users FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('users', 'update', new.id, concat('login: ', new.login));
END$$
DELIMITER ;

drop trigger if exists trg_logs_users_delete;
DELIMITER $$
CREATE TRIGGER trg_logs_users_delete before delete ON users FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('users', 'delete', id, concat('login: ', login));
END$$
DELIMITER ;

DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

drop trigger if exists trg_logs_departments_insert;
DELIMITER $$
CREATE TRIGGER trg_logs_departments_insert after insert ON departments FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('departments', 'insert', new.id, concat('name: ', new.name));
END$$
DELIMITER ;

drop trigger if exists trg_logs_departments_udpate;
DELIMITER $$
CREATE TRIGGER trg_logs_departments_udpate after update ON departments FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('departments', 'update', new.id, concat('name: ', new.name));
END$$
DELIMITER ;

drop trigger if exists trg_logs_departments_delete;
DELIMITER $$
CREATE TRIGGER trg_logs_departments_delete before delete ON departments FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('departments', 'delete', id, concat('name: ', name));
END$$
DELIMITER ;

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
	started_at DATETIME,
	deadline_at DATETIME,
	finished_at DATETIME,
  title VARCHAR(200),
  `description` VARCHAR(2000),
  owner_user_id INT UNSIGNED,
  closer_user_id INT UNSIGNED,
  conclution VARCHAR(2000),
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (owner_user_id) REFERENCES users(id) on delete set null,
  FOREIGN KEY (closer_user_id) REFERENCES users(id) on delete set null
);

drop trigger if exists trg_logs_works_insert;
DELIMITER $$
CREATE TRIGGER trg_logs_works_insert after insert ON works FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('works', 'insert', new.id, concat('title: ', new.title));
END$$
DELIMITER ;

drop trigger if exists trg_logs_works_udpate;
DELIMITER $$
CREATE TRIGGER trg_logs_works_udpate after update ON works FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('works', 'update', new.id, concat('title: ', new.title));
END$$
DELIMITER ;

drop trigger if exists trg_logs_works_delete;
DELIMITER $$
CREATE TRIGGER trg_logs_works_delete before delete ON works FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('works', 'delete', id, concat('title: ', title));
END$$
DELIMITER ;

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
create index indx_works_actions_work_id on works_actions (work_id);

DROP TABLE IF EXISTS confimition_answers;
CREATE TABLE confimition_answers (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(20) NOT NULL,

  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS work_confimition;
CREATE TABLE work_confimition (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  work_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  answer_id INT UNSIGNED NOT NULL,
  decline_reason VARCHAR(200),

  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (work_id) REFERENCES works(id) on delete cascade,
  FOREIGN KEY (user_id) REFERENCES users(id) on delete cascade,
  FOREIGN KEY (answer_id) REFERENCES confimition_answers(id) on delete cascade
);
create index indx_work_confimition_work_id on work_confimition (work_id);

drop trigger if exists trg_logs_work_confimition_insert;
DELIMITER $$
CREATE TRIGGER trg_logs_work_confimition_insert after insert ON work_confimition FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('work_confimition', 'insert', new.id, concat('work_id: ', new.work_id));
END$$
DELIMITER ;

drop trigger if exists trg_logs_work_confimition_udpate;
DELIMITER $$
CREATE TRIGGER trg_logs_work_confimition_udpate after update ON work_confimition FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('work_confimition', 'update', new.id, concat('work_id: ', new.work_id));
END$$
DELIMITER ;

drop trigger if exists trg_logs_work_confimition_delete;
DELIMITER $$
CREATE TRIGGER trg_logs_work_confimition_delete before delete ON work_confimition FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('work_confimition', 'delete', id, concat('work_id: ', work_id));
END$$
DELIMITER ;

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
  filename VARCHAR(255) NOT NULL UNIQUE COMMENT "оригинальное имя файла, которое загрузил пользователь (путь не полный, толоко имя)",
  filebody blob NOT NULL COMMENT "тело файла",
  media json comment "некое краткое описание свойств файла",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (media_type_id) REFERENCES media_types(id) on delete set null
);

DROP TABLE IF EXISTS works_docs;
CREATE TABLE works_docs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  work_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED,
  media_id INT UNSIGNED NOT NULL,
  inserted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (work_id) REFERENCES works(id) on delete cascade,
  FOREIGN KEY (media_id) REFERENCES media(id) on delete cascade,
  FOREIGN KEY (user_id) REFERENCES users(id) on delete set null
);
create index indx_works_docs_work_id on works_docs (work_id);

drop trigger if exists trg_logs_media_insert;
DELIMITER $$
CREATE TRIGGER trg_logs_media_insert after insert ON media FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('media', 'insert', new.id, concat('file: ', new.filename));
END$$
DELIMITER ;

drop trigger if exists trg_logs_media_udpate;
DELIMITER $$
CREATE TRIGGER trg_logs_media_udpate after update ON media FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('media', 'update', new.id, concat('file: ', new.filename));
END$$
DELIMITER ;

drop trigger if exists trg_logs_media_delete;
DELIMITER $$
CREATE TRIGGER trg_logs_media_delete before delete ON media FOR EACH ROW
BEGIN
  insert into logs (`table`, `action`, row_id, row_data) values ('media', 'delete', id, concat('file: ', filename));
END$$
DELIMITER ;

ALTER TABLE works_docs ADD CONSTRAINT works_docs_media_id FOREIGN KEY (media_id) REFERENCES media(id) on delete cascade;
ALTER TABLE profiles ADD CONSTRAINT profiles_photo_id FOREIGN KEY (photo_id) REFERENCES media(id) on delete set null;

DROP function IF EXISTS works_last_action;
DELIMITER $$
CREATE function works_last_action(_work_id integer unsigned) returns varchar(2000) deterministic
BEGIN
  return (select `action` from works_actions where (_work_id = work_id) order by inserted_at desc limit 1);
END$$
DELIMITER ;

DROP function IF EXISTS work_state;
DELIMITER $$
CREATE function work_state(_work_id integer unsigned) returns varchar(200) deterministic
BEGIN
  declare _is_confirmition boolean default false;
  declare _is_declined boolean default false;
  declare _is_finished boolean default false;
  declare _is_expired boolean default false;

  set _is_confirmition = (select case when 0 < count(*) then true else false end from work_confimition where (_work_id = work_id) and (answer_id in (1)));
  set _is_declined = (select case when 0 < count(*) then true else false end from work_confimition where (_work_id = work_id) and (answer_id in (3)));
  if ((not _is_confirmition) and (not _is_declined)) then
    set _is_finished = (select case when finished_at is not null then true else false end from works where (_work_id = id));
  end if;
  if (_is_confirmition) then
    set _is_expired = (select case when now() > started_at then true else false end from works where (_work_id = id));
  else
    if (_is_finished) then
      set _is_expired = (select case when finished_at > deadline_at then true else false end from works where (_work_id = id));
    else
      set _is_expired = (select case when now() > deadline_at then true else false end from works where (_work_id = id));
    end if;
  end if;
  return case when _is_declined then 'declined'
              when _is_confirmition and not _is_expired then 'confirmition'
              when _is_confirmition and _is_expired then 'confirmition expired'
              when _is_finished and not _is_expired then 'finished'
              when _is_finished and _is_expired then 'finished, but expired'
              when not _is_confirmition and not _is_expired then 'in proggress'
              when not _is_confirmition and _is_expired then 'in proggress, but expired' end;
END$$
DELIMITER ;

create view view_users as
select t1.id
      ,t1.login
      ,t1.first_name
      ,t1.last_name
      ,t1.email
      ,t1.phone
      ,t2.department_id
      ,t3.name department_name
      ,t2.photo_id
      ,t5.name photo_type
      ,t4.filename photo_filename
      ,t4.filebody photo_filebody
      ,t4.media photo_media
from users t1
inner join profiles t2 on (t2.user_id = t1.id)
left outer join departments t3 on (t3.id = t2.department_id)
inner join media t4 on (t4.id = t2.photo_id)
inner join media_types t5 on (t5.id = t4.media_type_id);

create view view_works as
select t1.id
      ,work_state(t1.id) work_state
      ,t1.created_at
      ,t1.started_at
      ,t1.deadline_at
      ,t1.finished_at
      ,t1.title
      ,t1.`description`
      ,t1.owner_user_id
      ,t2.department_id owner_department_id
      ,t2.department_name owner_department_name
      ,concat(t2.first_name, ' ',  t2.last_name) owner_user_name
      ,t1.closer_user_id
      ,t3.department_id close_department_id
      ,t3.department_name close_department_name
      ,concat(t3.first_name, ' ',  t3.last_name) close_user_name
      ,works_last_action(t1.id) last_action
      ,ifnull(t4.doc_count, 0) doc_count
from works t1
left outer join view_users t2 on (t1.owner_user_id = t2.id)
left outer join view_users t3 on (t1.closer_user_id = t3.id)
left outer join (select t1.work_id
                       ,count(*) doc_count
                 from works_docs t1
                 group by t1.work_id) t4 on (t1.id = t4.work_id);
