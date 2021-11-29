DROP function IF EXISTS random_phone;
DELIMITER $$
CREATE function random_phone() RETURNS varchar(15) deterministic
BEGIN
  declare result varchar(15);
  set result = case ceil(rand() * 3) when 1 then '+37517'
                                     when 2 then '+37529'
                                     when 3 then '+37525'
               end;
  set result = concat(result, ceil(rand() * 8999999)+1000000);
  return result;
END$$
DELIMITER ;

DROP function IF EXISTS random_word;
DELIMITER $$
CREATE function random_word(start_from_capital boolean) RETURNS varchar(20) deterministic
BEGIN
  declare i integer default 0;
  declare len integer default ceil(rand() * 5) + 3;
  declare char_source varchar(40) default 'abcdefghijklmnopqrstuvwxyz';
  declare result varchar(20);
  
  set result = '';
  while (i < len) do
    set result = concat(result, substring(char_source, ceil(rand() * length(char_source)), 1));
    set i = i + 1;
  end while;
  
  if (start_from_capital) then
    set result = concat(upper(substring(result, 1, 1)), substring(result, 2));
  end if;

  return result;
END$$
DELIMITER ;

DROP function IF EXISTS random_word_sequence;
DELIMITER $$
CREATE function random_word_sequence(start_from_capital boolean, cnt integer) RETURNS varchar(2000) deterministic
BEGIN
  declare i integer default 0;
  declare result varchar(2000);
  
  set result = '';
  while (i < cnt) do
    if (0 < length(result)) then
      set result = concat(result, ' ');
    end if;
    set result = concat(result, random_word(start_from_capital and (0 = i)));
    set i = i + 1;
  end while;

  return result;
END$$
DELIMITER ;

DROP function IF EXISTS random_date;
DELIMITER $$
CREATE function random_date(_from datetime, _to datetime) RETURNS datetime deterministic
BEGIN
  return from_unixtime(unix_timestamp(_from) + floor(rand() * (unix_timestamp(_to) - unix_timestamp(_from))));
END$$
DELIMITER ;

DROP procedure IF EXISTS users_table_filler;
DELIMITER $$
CREATE procedure users_table_filler(count integer, batch integer)
BEGIN
  declare _login varchar(100);
  declare _phone varchar(15);
  declare created_at datetime;
  declare i integer default 0;

  start transaction;
  while (i < count) do
    set _login = random_word(false);
    set _phone = random_phone();
    set created_at = random_date('2015-10-01', now());

    if (not exists(select null from users where (_login = login))) and
       (not exists(select null from users where (_phone = phone))) then
      insert into users (login, password_hash, first_name, last_name, email, phone, created_at, updated_at)
      value (_login, md5(rand()), random_word(true), random_word(true), concat(_login, '@mysql.by'), _phone, created_at, random_date(created_at, now()));
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

DROP procedure IF EXISTS departments_table_filler;
DELIMITER $$
CREATE procedure departments_table_filler(count integer, batch integer)
BEGIN
  declare _name varchar(100);
  declare i integer default 0;

  start transaction;
  while (i < count) do
    set _name = random_word_sequence(true, ceil(rand() * 3));

    if (not exists(select null from departments where (_name = name))) then
      insert into departments (name) value (_name);
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

DROP procedure IF EXISTS profiles_table_filler;
DELIMITER $$
CREATE procedure profiles_table_filler(batch integer)
BEGIN
  declare _exit boolean default null;
  declare _created_at datetime;
  declare _user_id INT UNSIGNED;
  declare i integer default 0;
  
  declare cur_users cursor for select id from users order by id;  
  declare continue handler for sqlstate '02000' set _exit = true;
  declare continue handler for sqlstate '23000' set _exit = true;

  start transaction;
  open cur_users;  
    lbl: LOOP  
      fetch cur_users into _user_id;
      if (_exit is not null) then
        leave lbl;
      end if;  

      set _created_at = random_date('2015-10-01', now());

      insert into profiles (user_id, department_id, created_at, updated_at)
      value (_user_id, (select id from departments order by rand() limit 1), _created_at, random_date(_created_at, now()));
        
      set i = i + 1;
      if (0 = (i % batch)) then
        commit;
        start transaction;
       end if;
    end loop;
  close cur_users;  
  commit;
END$$
DELIMITER ;

DROP procedure IF EXISTS description_macro_table_filler;
DELIMITER $$
CREATE procedure description_macro_table_filler(count integer, batch integer)
BEGIN
  declare _macro varchar(2000);
  declare i integer default 0;

  start transaction;
  while (i < count) do
    set _macro = random_word_sequence(true, ceil(rand() * 20));

    if (not exists(select null from description_macro where (_macro = macro))) then
      insert into description_macro (macro) value (_macro);
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

DROP procedure IF EXISTS media_table_photo_id_filler;
DELIMITER $$
CREATE procedure media_table_photo_id_filler(batch integer)
BEGIN
  declare _exit boolean default null;
  declare _filename varchar(255);
  declare _created_at datetime;
  declare _media_type_id integer default (select id from media_types where ('image' = name));
  declare _profile_id INT UNSIGNED;
  declare i integer default 0;
  
  declare cur_profiles cursor for select id from profiles;  
  declare continue handler for sqlstate '02000' set _exit = true;
  declare continue handler for sqlstate '23000' set _exit = true;

  start transaction;
  open cur_profiles;  
    lbl: LOOP  
      fetch cur_profiles into _profile_id;
      if (_exit is not null) then
        leave lbl;
      end if;

      set _filename = concat(random_word(false), '.', random_word(false));
      set _created_at = random_date('2015-10-01', now());

      insert into media (media_type_id, filename, filebody, created_at, updated_at)
      value (_media_type_id, _filename, md5(rand()), _created_at, random_date(_created_at, now()));
      update profiles set photo_id = (select last_insert_id()) where (_profile_id = id);

      set i = i + 1;
      if (0 = (i % batch)) then
        commit;
        start transaction;
      end if;
    end loop;
  close cur_profiles;  
  commit;
END$$
DELIMITER ;

DROP procedure IF EXISTS work_confimition_table_filler;
DELIMITER $$
CREATE procedure work_confimition_table_filler(_work_id integer unsigned, _owner_user_id integer unsigned, _created_at datetime)
BEGIN
  declare __created_at datetime;
  declare _confirm_user_id integer unsigned;
  declare _answer_id integer unsigned;
  declare _decline_answer_id integer unsigned default (select id from confimition_answers where ('declined' = name));
  declare _decline_reason varchar(2000);
  declare i integer default 0;
  declare _count integer default floor(rand()*6);

  while (i < _count) do
    set _confirm_user_id = (select id from users where (id <> _owner_user_id) and (id not in (select user_id from work_confimition where (_work_id = work_id))) order by rand() limit 1);
    set _answer_id = (select id from confimition_answers order by rand() limit 1);
    set __created_at = random_date(_created_at, now());
    if (_decline_answer_id = _answer_id) then
      set _decline_reason = random_word_sequence(true, 5);
    else
      set _decline_reason = null;
    end if;
    insert into work_confimition (work_id, user_id, answer_id, decline_reason, created_at, updated_at)
    value (_work_id, _confirm_user_id, _answer_id, _decline_reason, __created_at, random_date(__created_at, now()));
    set i = i + 1;
  end while;
END$$
DELIMITER ;

DROP procedure IF EXISTS works_actions_table_filler;
DELIMITER $$
CREATE procedure works_actions_table_filler(_work_id integer unsigned, _created_at datetime)
BEGIN
  declare i integer default 0;
  declare _count integer default floor(rand()*10);

  while (i < _count) do
    insert into works_actions (work_id, user_id, `action`, inserted_at)
    value (_work_id,  (select id from users order by rand() limit 1), random_word_sequence(true, 5), random_date(_created_at, now()));
    set i = i + 1;
  end while;
END$$
DELIMITER ;

DROP function IF EXISTS media_table_random_insert;
DELIMITER $$
CREATE function media_table_random_insert(_user_id integer unsigned, _created_at datetime) returns integer unsigned deterministic
BEGIN
  declare _filename varchar(255);
  declare __created_at datetime;
  declare i integer default 0;

  set _filename = concat(random_word(true), '.', random_word(true));
  set __created_at = random_date(_created_at, now());

  insert into media (media_type_id, filename, filebody, created_at, updated_at)
  value ((SELECT id FROM media_types ORDER BY RAND() LIMIT 1), _filename, md5(rand()), __created_at, random_date(__created_at, now()));
  
  return (select last_insert_id());
END$$
DELIMITER ;

DROP procedure IF EXISTS works_docs_table_filler;
DELIMITER $$
CREATE procedure works_docs_table_filler(_work_id integer unsigned, _created_at datetime)
BEGIN
  declare i integer default 0;
  declare _media_id integer unsigned;
  declare _user_id integer unsigned;
  declare _count integer default floor(rand()*10);

  while (i < _count) do
    set _user_id = (select id from users order by rand() limit 1);
    set _media_id = media_table_random_insert(_user_id, _created_at);
    insert into works_docs (work_id, user_id, media_id, inserted_at)
    value (_work_id, _user_id, _media_id, random_date(_created_at, now()));
    set i = i + 1;
  end while;
END$$
DELIMITER ;

DROP procedure IF EXISTS works_table_filler;
DELIMITER $$
CREATE procedure works_table_filler(count integer, batch integer)
BEGIN
  declare _created_at datetime;
  declare _started_at datetime;
  declare _deadline_at datetime;
  declare _finished_at datetime;
  declare _owner_user_id integer unsigned;
  declare _closer_user_id integer unsigned;
  declare _conclution varchar(2000);
  declare i integer default 0;
  declare _work_id integer unsigned;

  start transaction;
  while (i < count) do
    set _created_at = random_date('2015-10-01', now());
    set _started_at = random_date(_created_at, now());
    set _deadline_at = random_date(_started_at, now());
    set _owner_user_id = (SELECT id FROM users ORDER BY RAND() LIMIT 1);
    if (1 = round(rand())) then
      set _closer_user_id = (SELECT id FROM users where (id <> _owner_user_id) ORDER BY RAND() LIMIT 1);
      set _conclution = random_word_sequence(true, 20);
      set _finished_at = random_date(_created_at, now());
    else
      set _closer_user_id = null;
      set _conclution = null;
      set _finished_at = null;
    end if;

    insert into works (created_at, started_at, deadline_at, finished_at, title, `description`, owner_user_id, closer_user_id, conclution, updated_at)
    value (_created_at, _started_at, _deadline_at, _finished_at, random_word_sequence(true, 3), random_word_sequence(true, 20),
           _owner_user_id, _closer_user_id, _conclution, random_date(_created_at, now()));
           
    set _work_id = (select last_insert_id());
    
    call work_confimition_table_filler(_work_id, _owner_user_id, _created_at);
    call works_actions_table_filler(_work_id, _created_at);
    call works_docs_table_filler(_work_id, _created_at);
    
    set i = i + 1;
    if (0 = (i % batch)) then
      commit;
      start transaction;
     end if;
  end while;
  commit;
END$$
DELIMITER ;

