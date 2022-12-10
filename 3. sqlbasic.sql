select first_name 
from customer
;

select 
	first_name
,	last_name 
,	email 
from customer
;

select 
	*
from customer 
;

select 
	first_name  || ' ' || last_name  as first_last_name
,	email 
from customer
;

-------------------------------------------------------------------------
select *
from gmv_trend
;

select *
from gmv_trend
limit 10
;

-- 특정 컬럼 추출하기 
select category as 카테고리, yyyy 년도, mm 월
from gmv_trend
;

-- 중복값 없이 특정 컬럼 추출하기 
select distinct category
from gmv_trend 
;

select distinct category , yyyy
from gmv_trend 
;

-- 앨리어스 사용
select 	A.customer_id as cust_id
,		A.first_name || ' ' || A.last_name  as "full name"
,		A.email as 이메일
from customer as A
;

-- 조건이 하나일 때, 숫자열
-- 특정 연도의 매출 탐색하기
select *
from gmv_trend
where  yyyy = 2021
;

-- 2019년부터 이후의 매출 탐색하기
select *
from gmv_trend
where  yyyy >= 2019
;

-- between ~ and 
select *
from gmv_trend gt 
where  yyyy between 2018 and 2020
;

select *
from gmv_trend gt 
where  yyyy != 2021
;

-- 조건이 하나일 때, 문자열
select *
from gmv_trend gt 
where category = '컴퓨터 및 주변기기'
;

select *
from gmv_trend gt 
where category != '컴퓨터 및 주변기기'
;

-- amount 컬럼의 값 11.00보다 큰행을 추출하시오.
-- id, amount, date 

select 	a.payment_id 
, 		a.amount 
, 		a.payment_date 
from payment as a
where a.amount  > 11.00
;

-- amount 컬럼의 값이 0.99 보다 작은 행을 추출하시오.
-- id, amount, date 
select	a.payment_id 
,		a.amount 
,		a.payment_date 
from payment as a
where a.amount < 0.99
;

-- 조건이 여러 개일 때
-- and 조건
select *
from gmv_trend gt 
where category = '컴퓨터 및 주변기기'
and yyyy = 2021
;

-- or 조건
select *
from gmv_trend gt 
where gmv > 1000000 or gmv < 10000
;

-- and, or 조건 혼용
select *
from gmv_trend gt 
where (gmv > 1500000 or gmv < 10000) and yyyy = 2021
;

-- first_name이 'Tiffany'이고 last_name이 'Jordan'인 행을 추출하시오
select *
from customer c 
where c.first_name = 'Tiffany'
and c.last_name = 'Jordan'
;

-- first_name이 'Michael'이거나 last_name이 'Lee'인 행을 추출하시오
select *
from customer c 
where c.first_name  = 'Michael'
or c.last_name  = 'Lee'
;

-- first_name이 'Tiffany'아니고 last_name이 'Jordan'아닌 행을 추출하시오
select c.first_name || ' ' || c.last_name as "full name"
from customer c 
where c.first_name <> 'Tiffany'
and c.last_name <> 'Jordan'
; 

-- amount가 10부터 11사이에 있는 행을 모두 리턴하시오.
-- cu_id, pa_id, amount
select 	p.customer_id
,		p.customer_id 
,		p.amount 
from payment p 
where p.amount between 10 and 11
;

-- amount가 10부터 11사이에 있지 않은 행을 모두 리턴하시오.
select 	p.customer_id
,		p.customer_id 
,		p.amount 
from payment p 
where p.amount not between 10 and 11
;

-- 2007-02-14 21:21:59.996
-- payment_date가 2007년 2월 14일의 모든 행을 리턴하시오.
select 	p.customer_id 
, 		p.payment_id
, 		p.amount
, 		p.payment_date  
from payment p 
where p.payment_date between '2007-02-14 00:00:00.00000'
and '2007-02-14 23:59:59.9'
order by p.payment_date  
;

-- 매출이 낮은 순으로 정렬 추출하시오.
select *
from gmv_trend gt 
order by gmv 
;

-- 매출이 높은 순으로 정렬 추출하시오.
select *
from gmv_trend gt 
order by gmv desc
;

-- first_name 컬럼의 값을 기준으로 오름차순(내림차순) 정렬하시오.
select 
	c.customer_id 
,	c.first_name 
,	c.last_name 
from customer c 
order by c.first_name desc  
;

-- first_name 컬럼의 값을 기준으로 내림차순 정렬함,
-- 그 상태에서 last_name 컬럼의 값을 기준으로 오름차순 정렬함.
select 
	c.customer_id 
,	c.first_name 
,	c.last_name 
from customer c 
order by c.first_name desc, c.last_name asc
;

select 
	c.customer_id 
,	c.first_name 
,	length(c.last_name) as length_last_name
,	c.last_name 
from customer c 
order by length_last_name desc 
;

select 
	c.customer_id 
,	c.first_name 
,	length(c.last_name) as length_last_name
,	c.last_name 
from customer c 
order by 3 desc 
;

----------
drop table if exists tb_sort_test;
create table tb_sort_test
(
	num int
);

insert into tb_sort_test values (1);
insert into tb_sort_test values (2);
insert into tb_sort_test values (3);
insert into tb_sort_test values (null);

-- null이 무조건 맨 위로 올라오게 됨
select *
from tb_sort_test tst
order by num nulls first 
;

-- null이 무조건 맨 아래로 내려가게 됨
select *
from tb_sort_test tst
order by num nulls last 
;

select *
from tb_sort_test tst
order by num desc nulls last 
;

-- IN 연산자 
select *
from gmv_trend gt 
where category in ('컴퓨터 및 주변기기', '생활용품')
;

select *
from gmv_trend gt 
where category not in ('컴퓨터 및 주변기기', '생활용품')
;

-- customer_id가 1혹은 2인 행을 모두 리턴하시오.
select 
	r.customer_id 
,	r.rental_id 
,	r.return_date 
from rental r 
where r.customer_id in (1, 2)
order by r.return_date 
;

select 
	r.customer_id 
,	r.rental_id 
,	r.return_date 
from rental r 
where r.customer_id in (1, 2)
order by r.return_date 
;

-- IN 연산자와 OR연산은 결과집합이 동일함
select 
	r.customer_id 
,	r.rental_id 
,	r.return_date 
from rental r 
where r.customer_id = 1
or r.customer_id = 2
order by r.return_date 
;

-- customer id가 1혹은 2가 아닌 모든 행을 모두 리턴하시오.
select 
	r.customer_id 
,	r.rental_id 
,	r.return_date 
from rental r 
where r.customer_id not in (1, 2)
order by r.return_date desc
;

select 
	r.customer_id 
,	r.rental_id 
,	r.return_date 
from rental r 
where r.customer_id <> 1
and r.customer_id <> 2
-- and r.return_date is not null
order by r.return_date desc 
;

-- film_id 기준으로 정렬한 후 정렬된 집합 중에서 5건만 출력 
select 
	f.film_id 
,	f.title 
,	f.release_year 
from film f 
order by f.film_id 
limit 5
;

-- film_id 기준으로 정렬한 후 정렬된 집합 중에서 2건만 출력
-- 출력하는 시작 행은 4번째 행부터 2건만 출력함
-- offset 3: 0,1,2,3 즉 4번째 행을 의미함 (0부터 시작)
select 
	f.film_id 
,	f.title 
,	f.release_year 
from film f 
order by f.film_id 
limit 2 offset 3
;

-- rental_date 컬럼을 기준으로 내림차순 정렬한 후 정렬된 집합 중에서
-- 10건만 출력하시오. (가장 최근에 렌트한 10건을 조회)
select *
from rental r 
order by r.rental_date desc 
limit 10
;

select 
	f.film_id 
,	f.title 
,	f.release_year 
from film f 
order by f.film_id 
fetch first 5 row 
only
;

select 
	f.film_id 
,	f.title 
,	f.release_year 
from film f 
order by f.film_id 
offset 3 rows
fetch first 2 row 
only 
;

---
select *
from gmv_trend gt 
where gt.category like '%패션%'
;

select *
from gmv_trend gt 
where gt.category not like '%패션%'
;

-- first_name이 "Jen"으로 시작하는 모든 행을 리턴하시오.
-- cu_id, first_nm, last_nm
select 
	c.customer_id
,	c.first_name 
,	c.last_name 
from customer c 
where c.first_name like 'Jen%'
;

-- Jen + 3자리 즉 총 6자리만 있으면 리턴함.
select 
	c.customer_id
,	c.first_name 
,	c.last_name 
from customer c 
where c.first_name like 'Jen___'
;

-- 총 6자리 이상인 모든 행 리턴함.
select 
	c.customer_id
,	c.first_name 
,	c.last_name 
from customer c 
where c.first_name like 'Jen___%'
;

-- NULL 비교
drop table if exists tb_contact;
create table tb_contact 
(
	contact_no serial primary key
,	first_nm varchar(50) not null
,	last_nm varchar(50) not null
,	email_adres varchar(255) not null
,	phone_number varchar(15)
);

insert into tb_contact (first_nm, last_nm, email_adres, phone_number)
values ('순신', '이', 'sslee@gmail.com', '010-2345-1212');
insert into tb_contact (first_nm, last_nm, email_adres, phone_number)
values ('방원', '이', 'bwlee@gmail.com', null);
select *
from tb_contact tc ;

-- PHONE_NUMBER 컬럼의 값이 NULL인 행을 리턴하시오.
select 
	tc.contact_no 
,	tc.first_nm 
,	tc.last_nm 
,	tc.phone_number 
from tb_contact tc 
where tc.phone_number is null
;

-- PHONE_NUMBER 컬럼의 값이 NULL이 아닌 행을 리턴하시오.
select 
	tc.contact_no 
,	tc.first_nm 
,	tc.last_nm 
,	tc.phone_number 
from tb_contact tc 
where tc.phone_number is not null
;

-- CASE문
-- 길이(LENGTH)가 50분 이하면 SHORT으로 함
-- 길이가 50분 초과하고 120분 보다 작거나 같으면 MEDIUM으로 함
-- 길이가 120분을 초과하면 LONG으로 함
select 
	f.title 
,	f.length 
,	case when length > 0 and length <= 50 then 'SHORT'
		 when length > 50 and length <= 120 then 'MEDIUM'
		 when length > 120 then 'LONG'
	end duration 
from film f 
order by f.title 
;

-- 길이가 50분 이하면 1로 함 
-- 길이가 50분 초과하고 120분 보다 작거나 같으면 2로 함
-- 길이가 120분을 초과하면 3으로 함
-- DESC로 정렬
select 
	f.title 
,	f.length 
,	case when length > 0 and length <= 50 then 'SHORT'
		 when length > 50 and length <= 120 then 'MEDIUM'
		 when length > 120 then 'LONG'
	end duration 
from film f 
order by case when length > 0 and length <= 50 then 1
			  when length > 50 and length <= 120 then 2
		 	  when length > 120 then 3
		 end desc, f.length desc
;



























