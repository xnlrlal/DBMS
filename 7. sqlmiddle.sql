drop table if exists tb_accnt;
create table tb_accnt
(
	accnt_no int
,	accnt_nm varchar(100) not null
,	balance_amt numeric(15, 2) not null
,	primary key(accnt_no)
);

select * from tb_accnt;


insert into tb_accnt values (1, '일반계좌', 15000.45);

select *
from tb_accnt
where accnt_no = 1
;


insert into tb_accnt values (2, '비밀계좌', 25000.45);

select *
from tb_accnt
where accnt_no = 2
;

commit;


-- insert 
drop table if exists tb_link;
create table tb_link 
(
	link_no int primary key
,	url varchar(255) not null
,	link_nm varchar(255) not null
,	dscrptn varchar(255) not null
,	last_update_de date
);

commit;


insert into tb_link (link_no, url, link_nm, dscrptn, last_update_de)
values (1, 'www.ezen.co.kr', '이젠아카데미컴퓨터학원', '홈페이지', current_date)
;

commit;
select * from tb_link tl;


insert into tb_link (link_no, url, link_nm, dscrptn, last_update_de)
values (2, 'www.google.com', '구글', '검색사이트', current_date)
returning *;

commit;
select * from tb_link tl;


-- insert문 수행 후 insert한 행에서 link_no 컴럼의 값을 출력하시오.
insert into tb_link (link_no, url, link_nm, dscrptn, last_update_de)
values (3, 'www.daum.net', '다음', '포털사이트', current_date)
returning link_no;

commit;
select * from tb_link;


-- update 
drop table if exists tb_link;
create table tb_link 
(
	link_no int primary key
,	url varchar(255) not null
,	link_nm varchar(255) not null
,	dscrptn varchar(255) not null
,	last_update_de date
);


insert into tb_link (link_no, url, link_nm, dscrptn, last_update_de)
values (1, 'www.ezen.co.kr', '이젠아카데미컴퓨터학원', '홈페이지', current_date)
;
insert into tb_link (link_no, url, link_nm, dscrptn, last_update_de)
values (2, 'www.google.com', '구글', '검색사이트', current_date)
;
insert into tb_link (link_no, url, link_nm, dscrptn, last_update_de)
values (3, 'www.daum.net', '다음', '포털사이트', current_date)
;

update tb_link 
set link_nm = '이젠에이씨씨오케이알'
where link_no = 1
;

commit;

select * from tb_link
where link_no = 1
;

update tb_link 
set link_nm = '구글닷컴'
where link_no = 2
returning *
;

commit;


-- update하면서 update한 행에서 link_no 및 link_nm 컬럼을 출력하시오.
update tb_link 
set link_nm = '다음닷넷'
where link_no = 3
returning link_no, link_nm
;

commit;

select * from tb_link
where link_no = 3
;


---------- update JOIN
drop table if exists tb_prdt_cl;
drop table if exists tb_prdt;

create table tb_prdt_cl
(
	prdt_cl_no int primary key
,	prdt_cl_nm varchar(50)
,	discount_rate numeric(2, 2)
);

insert into tb_prdt_cl values (1, 'Smart Phone', 0.20);
insert into tb_prdt_cl values (2, 'Tablet', 0.25);


create table tb_prdt
(
	prdt_no int primary key
,	prdt_nm varchar(50)
,	prc numeric(15)
,	sale_prc numeric(15)
,	prdt_cl_no int
,	foreign key(prdt_cl_no) references tb_prdt_cl(prdt_cl_no)
);

insert into tb_prdt values (1, '갤럭시 S22 Ultra', 1551000, null, 1);
insert into tb_prdt values (2, '갤럭시 S21 Ultra', 1501000, null, 1);
insert into tb_prdt values (3, '갤럭시 탭 S8 Ultra', 1378300, null, 2);
insert into tb_prdt values (4, '갤럭시 탭 S7 FE', 719400, null, 2);

commit;

select * from tb_prdt_cl;
select * from tb_prdt;


update tb_prdt a 
set sale_prc = a.prc - (a.prc * b.discount_rate)
from tb_prdt_cl b
where a.prdt_cl_no = b.prdt_cl_no
;

commit;

select * from tb_prdt;

--------------------------------------------------------------------delete 
drop table if exists tb_link;
create table tb_link 
(
	link_no int primary key
,	url varchar(255) not null
,	link_nm varchar(255) not null
,	dscrptn varchar(255) not null
,	last_update_de date
);

insert into tb_link (link_no, url, link_nm, dscrptn, last_update_de)
values (1, 'www.ezen.co.kr', '이젠아카데미컴퓨터학원', '홈페이지', current_date)
;
insert into tb_link (link_no, url, link_nm, dscrptn, last_update_de)
values (2, 'www.google.com', '구글', '검색사이트', current_date)
;
insert into tb_link (link_no, url, link_nm, dscrptn, last_update_de)
values (3, 'www.daum.net', '다음', '포털사이트', current_date)
;

commit;
select * from tb_link;


delete 
from tb_link a
where a.link_nm = '이젠아카데미컴퓨터학원';

rollback;
commit;

delete 
from tb_link a
where a.link_nm = '구글'
returning *
;

select * from tb_link;


-- delete한 다음에 delete 된 행의 내용 중 link_no, link_nm 컬럼을 출력하시오.
delete
from tb_link a
where a.link_nm = '다음'
returning a.link_no , a.link_nm 
;

commit;
select * from tb_link;


----------UPSERT 
drop table if exists tb_cust;
create table tb_cust 
(
	cust_no int
,	cust_nm varchar(50) unique 
,	email_adres varchar(200) not null
,	valid_yn char(1) not null
,	constraint pk_tb_cust primary key(cust_no)
);

commit;

insert into tb_cust values (1, '이순신', 'sslee@gamil.com', 'y');
insert into tb_cust values (2, '이방원', 'bwlee@gamil.com', 'y');
commit;

select * from tb_cust;

-- 중복되는 cust_nm 값을 insert 하려고 한다면 아무것도 하지 말라고 하는 것임 
insert into tb_cust (cust_no, cust_nm, email_adres, valid_yn)
values (3, '이순신', 'sslee@gamil.com', 'y')
on conflict (cust_nm)
do nothing
;

commit;

-- 에러는 발생하지 않으면서 아무것도 하지 않았음을 알 수 있음
select * from tb_cust;

-- cust_no에 1은 이미 존재하는 행임 
-- 중복되는 행이 입력되려고 할 때 update set을 함.
insert into tb_cust (cust_no, cust_nm, email_adres, valid_yn)
values (1, '이순신', 'sslee7@gmail.co.kr', 'N')
on conflict (cust_no)
do update set email_adres = excluded .email_adres 
			, valid_yn = excluded .valid_yn 
;

commit;
select  * from tb_cust;

----------GROUP BY

-- customer_id 컬럼의 값 기준으로 group by 함 
-- 해당 컬럼값 기준으로 중복이 제거된 행이 출려됨 
select a.customer_id 
from payment a
group by a.customer_id 
order by a.customer_id 
;

-- customer_id 컬럼별 amount의 합계가 큰 순으로 10건을 출력하시오.
select 
	a.customer_id 
,	sum(a.amount) as amount_sum
from payment a
group by 1
order by 2 desc 
limit 10
;

-- first_name 및 last_name도 같이 출력하시오.
select 
	a.customer_id 
,	b.first_name 
,	b.last_name 
,	sum(a.amount) as amount_sum
from payment a
join customer b 
on a.customer_id = b.customer_id 
group by 1, 2, 3
order by 4 desc 
limit 10
;
-- || 두개 같음
select 
	a.customer_id 
,	b.first_name 
,	b.last_name 
,	sum(a.amount) as amount_sum
from payment a, customer b
where a.customer_id = b.customer_id 
group by a.customer_id, b.first_name, b.last_name 
order by amount_sum desc 
limit 10
;

-- customer_id는 first_name 및 last_name을 결정 지을 수 있는 관계이기 때문에 max() 사용가능함.
select 
	a.customer_id 
,	max(b.first_name) as first_name  
,	max(b.last_name) as last_name 
,	sum(a.amount) as amount_sum
from payment a, customer b
where a.customer_id = b.customer_id 
group by a.customer_id 
order by amount_sum desc 
limit 10
;


---------- HAVING
-- 200이상인 결과집합을 추출하시오.
select 
	a.customer_id 
,	b.first_name 
,	b.last_name 
,	sum(a.amount) as amount_sum
from payment a, customer b
where a.customer_id = b.customer_id 
group by a.customer_id, b.first_name, b.last_name 
having sum(a.amount) >= 200
order by amount_sum desc 
limit 10
;


-- customer_id, first_name, last_name, payment_id의 수(payment_id_cnt)가 40이상인 
-- 결과집합을 출력하시오.
-- 고객 기준 결제횟수가 40번 이상인 고객을 출력하시오.(count())
select 
	a.customer_id 
,	b.first_name 
,	b.last_name 
,	count(a.payment_id) as payment_id_cnt
from payment a, customer b
where a.customer_id = b.customer_id 
group by a.customer_id, b.first_name, b.last_name 
having count(a.payment_id) >= 40
order by payment_id_cnt desc 
;

















