insert into media_types (name) value ('image'), ('word'), ('excel');
select * from media_types;

insert into confimition_answers (name) value ('request'), ('approved'), ('declined');
select * from confimition_answers;

call users_table_filler(200, 1000);
select * from users;

call departments_table_filler(10, 1000);
select * from departments;

call profiles_table_filler(1000);
select * from profiles;

call media_table_photo_id_filler(1000);
select * from media;
select * from profiles;

call description_macro_table_filler(10, 1000);
select * from description_macro;

call works_table_filler(1000, 500);
select * from works;
select * from work_confimition;
select * from works_docs;
select * from works_actions;

select count(*) from logs;

