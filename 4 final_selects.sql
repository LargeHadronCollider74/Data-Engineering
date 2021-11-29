-- works
select t1.*
      ,works_last_action(t1.id) last_action
      ,ifnull(t2.doc_count, 0) doc_count
      ,ifnull(t3.confirm_count, 0) confirm_count
      ,work_state(t1.id) work_state
      ,t4.*
      ,t5.*
from works t1
left outer join (select t1.work_id
                       ,count(*) doc_count
                 from works_docs t1
                 group by t1.work_id) t2 on (t1.id = t2.work_id)
left outer join (select t1.work_id
                       ,count(*) confirm_count
                 from work_confimition t1
                 group by t1.work_id) t3 on (t1.id = t3.work_id)
left outer join users t4 on (t1.owner_user_id = t4.id)
left outer join users t5 on (t1.closer_user_id = t5.id);

select * from view_works;


-- user details
select t1.*
      ,t2.*
      ,t3.*
      ,t4.*
      ,t5.*
from users t1
inner join profiles t2 on (t2.user_id = t1.id)
left outer join departments t3 on (t3.id = t2.department_id)
inner join media t4 on (t4.id = t2.photo_id)
inner join media_types t5 on (t5.id = t4.media_type_id);

select * from view_users;

-- confirmitions
select t1.*
      ,t2.*
      ,t3.*
from work_confimition t1
inner join confimition_answers t2 on (t1.answer_id = t2.id)
left outer join users t3 on (t1.user_id = t3.id)
where (t1.work_id in (9,500));

-- actions
select t1.*
      ,t2.*
from works_actions t1
left outer join users t2 on (t1.user_id = t2.id)
where (t1.work_id in (11,500))
order by inserted_at desc;
 
-- docs
select t1.*
      ,t2.*
      ,t3.*
      ,t4.*
from works_docs t1
left outer join users t2 on (t1.user_id = t2.id)
inner join media t3 on (t1.media_id = t3.id)
inner join media_types t4 on (t3.media_type_id = t4.id)
where (t1.work_id in (11,500))
order by inserted_at desc;
