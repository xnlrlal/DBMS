drop table if exists data_type_test;

create table data_type_test
(
	a_boolean boolean 
	, b_char char(10)
	, c_varchar varchar(10)
	, d_text text
	, e_int int
	, f_smallint smallint
	, g_float float
	, h_numeric numeric(15, 2)
);

insert into data_type_test values 
(
	true
	, 'ABCDE'
	, 'ABCDE'
	, 'TEXT'
	, 1000
	, 10
	, 10.12345
	, 10.25
);

select * from data_type_test;

-- ACCOUNT
drop table if exists account;

create table account
(
	user_id serial primary key
	, username varchar(50) unique not null 
	, password varchar(50) not null
	, email varchar(355) unique not null
	, created_on timestamp not null
	, last_login timestamp
);

drop table if exists role;
create table if not exists role
(
	role_id serial primary key
	, role_name varchar(255) unique not null
);

drop table if exists account_role;
create table account_role
(
	user_id integer not null
	, role_id integer not null
	, grant_date timestamp without time zone
	, primary key (user_id, role_id)
	, constraint account_role_role_id_fkey foreign key (role_id)
	  references role (role_id) match simple on update no action on delete no action 
	, constraint account_role_user_id_fkey foreign key (user_id)
	  references account (user_id) match simple on update no action on delete no action
);

insert into account values (1, '이순신', '0111', 'sslee@gmail.com', current_timestamp, null);
commit;

select * from account;

insert into role values (1, 'DBA');
commit;

select * from role;

insert into account_role values (1, 1, current_timestamp);
 
select * 
from account_role;

-- "account_role_user_id_fkey" 참조키(foreign key) 제약 조건을 위배, (user_id)=(2) 키가 "account" 테이블에 없습니다.
insert into account_role 
values (2, 1, current_timestamp);
-- "account_role_role_id_fkey" 참조키(foreign key) 제약 조건을 위배, (role_id)=(2) 키가 "role" 테이블에 없습니다.
insert into account_role 
values (1, 2, current_timestamp);
-- 중복된 키 값이 "account_role_pkey" 고유 제약 조건을 위반
insert into account_role 
values (1, 1, current_timestamp);
-- 참조키(foreign key) 제약 조건 - "account_role" 테이블 - 을 위반
update account set user_id = 2 
where user_id = 1;
-- 참조키(foreign key) 제약 조건 - "account_role" 테이블 - 을 위반
delete from account 
where user_id = 1;

select 
	a.film_id 
	, a.title 
	, a.release_year 
	, a.length 
	, a.rating 
from film a
	, film_category b
where a.film_id  = b.film_id 
and b.category_id = 1
;

create table if not exists action_film as 
select 
	a.film_id 
	, a.title 
	, a.release_year 
	, a.length 
	, a.rating 
from film a
	, film_category b
where a.film_id  = b.film_id 
and b.category_id = 1
;

select * from action_film;

-- 테이블 구조 변경 
create table links (
	link_id serial primary key
	, title varchar(500) not null
	, url varchar(1024) not null unique
);

select * from links;

-- active 컬럼 추가
alter table links add column active boolean;
-- active 컬럼 삭제 
alter table links drop column active;
-- title 컬럼을 link_title 컬럼으로 변경 
alter table links rename column title to link_title;
-- target 컬럼 추가 
alter table links add column target varchar(10);
-- target 컬럼의 default 값을 "_blank"로 설정 
alter table links alter column target set default '_blank';

insert into links (link_title, url)
values ('Postgresql', 'https://www.tutorialspoint.com/postgresql/index.htm');
commit;

select * from links;

-- 한 번 만들어진 테이블이라고 하더라도 테이블 이름 변경 가능함 
create table vendors(
	id serial primary key
	, name varchar not null
);

select * from vendors;

-- suppliers로 변경 
alter table vendors rename to suppliers;

select * from suppliers;

-- supplier_groups 테이블 생성 
create table supplier_groups (
	id serial primary key
	, name varchar not null
);

-- suppliers 테이블에 컬럼 추가 후 fk 생성 
alter table suppliers add column group_id int not null;
alter table suppliers add foreign key (group_id)
references supplier_groups (id);

-- 뷰 생성 
-- 뷰는 실체하는 데이터가 아닌 보기전용
drop view supplier_data;
create view supplier_data as
select 
	s.id 
	, s."name" 
	, g."name" "group_name" 
	from 
		suppliers s, supplier_groups g
	where 
		g.id = s.group_id 
;

select * from supplier_data;

-- 참조하고 있는 테이블의 이름 자동으로 변경 반영됨 
alter table supplier_groups rename to groups;

select * from supplier_groups;
select * from groups;

-- dvd 렌탈 시스템의 관리자는 고객별 매출 순위를 알고 싶습니다.
-- 신규 테이블로 고객의 매출 순위를 관리하고 싶습니다.
-- 테이블 이름 customer_rank이고
-- 테이블 구성은 customer, payment를 활용해서 구성합니다.
-- ctas 기법을 이용하여 신규테이블을 생성하고 데이터를 입력하시오.

-- 반납일자가 2005년 5월 29일인 렌탈 내역의 film_id를 조회하시오.
select 
	b.film_id
	, a.return_date 
from rental a , inventory b
where b.inventory_id = a.inventory_id 
and date(a.return_date) = '2005-05-29'
;

select 
	i.film_id 
	, rental.return_date 
from  inventory i, rental
where exists (
	select 1
	from rental a 
	where i.inventory_id = a.inventory_id 
	and rental.inventory_id = a.inventory_id 
	and date(a.return_date) = '2005-05-29'
 
);

select b.film_id 
from rental a
inner join inventory b 
on (a.inventory_id = b.inventory_id)
where a.return_date
between '2005-05-29 00:00:00.000'
and '2005-05-29 23:59:59.999'
;

-- film 테이블에서 반납일자가 2005년 5월 29일인 렌탈 내역의 film_id를 조회하여 film정보를 출력하시오.
-- film_id, title <== 조회된 film_id 기준으로 film 테이블을 조회하여 film정보를 출력함
select film_id , title
from film
where exists (
	select b.film_id 
	from rental a
	inner join inventory b 
	on (a.inventory_id = b.inventory_id)
	where a.return_date
	between '2005-05-29 00:00:00.000'
	and '2005-05-29 23:59:59.999'
	and b.film_id = film.film_id 
);

select c.film_id ,c.title 
from film c
where c.film_id in (
	select b.film_id 
	from rental a
	inner join inventory b 
	on (a.inventory_id = b.inventory_id)
	where a.return_date
	between '2005-05-29 00:00:00.000'
	and '2005-05-29 23:59:59.999'
);

-- amount가 9.00을 초과하고 payment_date가 
-- 2007년 2월 15일부터 2007년 2월 19일 사이에
-- 결제내역이 존재하는 고객의 이름을 출력하시오.
-- customer_id, first_name, last_name 
select distinct a.customer_id
	, a.first_name 
	, a.last_name 
from customer a
join payment b
on a.customer_id = b.customer_id 
where b.amount > 9.00
and b.payment_date 
between '2007-02-15 00:00:00.000'
and '2007-02-19 23:59:59.999'
order by a.first_name 
;

select c.customer_id 
	, c.first_name 
	, c.last_name 
from customer c 
where exists (
	select 1
	from payment p 
	where c.customer_id = p.customer_id 
	and p.amount > 9.00
	and p.payment_date 
	between '2007-02-15 00:00:00.000'
	and '2007-02-19 23:59:59.999'
)
order by c.first_name 
;

-- amount가 9.00을 초과하고 payment_date가 
-- 2007년 2월 15일부터 2007년 2월 19일 사이에
-- 결제내역이 존재하지 않는 고객의 이름을 출력하시오.
-- customer_id, first_name, last_name 
select distinct c.customer_id 
	, c.first_name 
	, c.last_name 
from customer c 
where not exists (
	select 1
	from payment p 
	where c.customer_id = p.customer_id 
	and p.amount > 9.00
	and p.payment_date 
	between '2007-02-15 00:00:00.000'
	and '2007-02-19 23:59:59.999'
)
order by c.first_name 
;

-- payment 테이블 조회하여 amount가 9.00을 초과하고
-- payment_date가 2007년 2월 15일부터 2007년 2월 19일 사이에
-- 결제내역이 존재하는 고객의 이름을 출력하시오.
-- customer_id, first_name, last_name, amount, payment_date 
-- -----------
select a.customer_id , a.first_name , a.last_name 
	, b.amount , b.payment_date 
from customer a 
	, (
		select p.customer_id, p.amount , p.payment_date
		from payment p 
		where p.amount > 9.00
		and p.payment_date 
		between '2007-02-15 00:00:00.000'
		and '2007-02-19 23:59:59.999'	
	) b
where a.customer_id = b.customer_id
;
------------------------------------------------------------(t)
select p.customer_id , p.amount , p.payment_date 
from payment p
where p.amount > 9.00 
and p.payment_date between '2007-02-15 00:00:00.000'
and '2007-02-19 23:59:59.999'
;

select a.customer_id
	, a.first_name
	, a.last_name
	, b.amount
	, b.payment_date
from
(
	select p.customer_id , p.amount , p.payment_date 
	from payment p
	where p.amount > 9.00 
	and p.payment_date between '2007-02-15 00:00:00.000'
	and '2007-02-19 23:59:59.999'
) b
, customer a 
where a.customer_id = b.customer_id
order by a.customer_id
;

-- payment 테이블 조회하여 amount가 9.00을 초과하고
-- payment_date가 2007년 2월 15일부터 2007년 2월 19일 사이에 있는 
-- 고객 및 그 결제내역을 조회하시오.
-- customer_id, first_name, last_name, amount, payment_date, staff_nm, rental_duration
-- -----------
select a.customer_id
	, a.first_name
	, a.last_name
	, b.amount
	, b.payment_date
	, (
		select s.first_name || ' ' || s.last_name 
		from staff s 
		where s.staff_id = b.staff_id
	  	) as staff_nm 
	, (
		select r.rental_date || '~' || r.return_date 
		from rental r 
		where r.rental_id = b.rental_id
		) as rental_duration
from
(
	select p.customer_id , p.amount , p.payment_date , p.staff_id , p.rental_id
	from payment p
	where p.amount > 9.00 
	and p.payment_date between '2007-02-15 00:00:00.000'
	and '2007-02-19 23:59:59.999'
) b
, customer a 
where a.customer_id = b.customer_id
order by a.customer_id
;













































