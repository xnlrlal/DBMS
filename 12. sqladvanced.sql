drop table if exists product_group;
create table product_group
(
	group_id int primary key 
	, group_name varchar(255) not null
);

drop table if exists product;
create table product
(
	product_id serial primary key 
	, product_name varchar(255) not null
	, price decimal(11, 2)
	, group_id int not null 
	, foreign key(group_id) references product_group(group_id)
);

insert into product_group 
values (1, 'SmartPhone')
		, (2, 'Laptop')
		, (3, 'tablet');
	
commit;
select * from product_group;

insert into product (product_name, group_id, price)
values 
	('xiaomi 12S Ultra', 1, 200)
	, ('pixel 6 pro', 1, 400)
	, ('갤럭시 S22 Ultra', 1, 500)
	, ('iPhone 14 Pro', 1, 900)
	, ('YOGA Slim7 Pro', 2, 1200)
	, ('삼성 2022 갤럭시북2 프로', 2, 700)
	, ('LG 울트라PC 15U560 ', 2, 700)
	, ('Apple 2022 맥북 에어', 2, 800)
	, ('레노버 TAB M10 H', 3, 150)
	, ('삼성전자 갤럭시챕 S8', 3, 200)
	, ('Apple 아이패드 10.2', 3, 700);

commit;
select * from product;

-- 집계함수는 집계의 결과만을 출력함 
select count(*)
from product p ;

-- 분석함수는 집계의 결과 및 집합(테이블의 내용)을 함께 출력함.
select a.*
	, count(*) over() as cnt
from 
	product a
order by a.product_id 
;

select a.group_id 
	, count(*) as cnt
from product a
group by a.group_id 
order by a.group_id 
;

select a.*
	, count (*) over(partition by a.group_id) as cnt
from product a
order by a.product_id 
;

-- avg()
select 
	avg(price)
from
	product p ;

-- group by + avg()
-- group_name 컬럼을 기준으로 price 컬럼의 평균값을 구하시오.
select 
	b.group_name 
	, avg(price)
from product a
inner join product_group b 
on (a.group_id = b.group_id)
group by b.group_name 
;

-- 분석함수 사용 
-- 결과 집합을 그대로 출력 + group_name 컬럼을 기준의 평균 출력 
select 
	a.product_name 
	, a.price 
	, b.group_name 
	, avg(price) over (partition by b.group_name) as group_name_avg
from product a
inner join product_group b 
on (a.group_id = b.group_id)
;

select 
	a.product_name 
	, a.price 
	, b.group_name 
	, avg(price) over (partition by b.group_name order by b.group_name) as group_name_avg
from product a
inner join product_group b 
on (a.group_id = b.group_id)
;

-- 누적평균을 구하시오.
select 
	a.product_name 
	, a.price 
	, b.group_name 
	, avg(price) over (partition by b.group_name order by a.price) as cumulative_aggregate_avg
from product a
inner join product_group b 
on (a.group_id = b.group_id)
;


-- row_number()
select 
	a.product_name 
	, b.group_name 
	, a.price 
	, row_number() over (partition by b.group_name order by a.price desc) as "row_number()"
from product a
inner join product_group b 
on (a.group_id = b.group_id)
;


-- rank()
select 
	a.product_name 
	, b.group_name 
	, a.price 
	, rank() over (partition by b.group_name order by a.price) as "rank()"
from product a
inner join product_group b 
on (a.group_id = b.group_id)
;


-- dense_rank()
select 
	a.product_name 
	, b.group_name 
	, a.price 
	, dense_rank() over (partition by b.group_name order by a.price) as "dense_rank()"
from product a
inner join product_group b 
on (a.group_id = b.group_id)
;


-- first_value()
-- 가장 첫번째 나오는 price 값을 출력하시오. (그룹별 가장 비싼것만 출력하시오.)
select 
	a.product_name , b.group_name , a.price 
	, first_value (a.price) over
	(partition by b.group_name order by a.price desc)
	as highest_price_per_group
from product a
inner join product_group b
on a.group_id = b.group_id 
;


-- last_value()
select 
	a.product_name , b.group_name , a.price 
	, last_value (a.price) over
	(partition by b.group_name order by a.price desc
	range between unbounded preceding
	and unbounded following)
	as lowest_price_per_group
from product a
inner join product_group b
on a.group_id = b.group_id 
; 

select 
	a.product_name , b.group_name , a.price 
	, last_value (a.price) over
	(partition by b.group_name order by a.price desc)
	as lowest_price_per_group
from product a
inner join product_group b
on a.group_id = b.group_id 
; 

select 
	a.product_name , b.group_name , a.price 
	, last_value (a.price) over
	(partition by b.group_name order by a.price desc
	range between unbounded preceding
	and current row)
	as lowest_price_per_group
from product a
inner join product_group b
on a.group_id = b.group_id 
; 


-- lag()
select 
	a.product_name 
	, b.group_name 
	, a.price 
	, lag (a.price, 1) over (partition by b.group_name order by a.price) as prev_price
	, a.price - lag (a.price, 1) over (partition by b.group_name order by a.price) as cur_prev_diff
from product a
inner join product_group b
on a.group_id = b.group_id 
;

select 
	a.product_name 
	, b.group_name 
	, a.price 
	, lag (a.price, 2) over (partition by b.group_name order by a.price) as prev_price
	, a.price - lag (a.price, 2) over (partition by b.group_name order by a.price) as cur_prev_diff
from product a
inner join product_group b
on a.group_id = b.group_id 
;


-- lead()
select 
	a.product_name 
	, b.group_name 
	, a.price 
	, lead (a.price, 1) over (partition by b.group_name order by a.price) as next_price
	, a.price - lead (a.price, 1) over (partition by b.group_name order by a.price) as cur_next_diff
from product a
inner join product_group b
on a.group_id = b.group_id 
;

select 
	a.product_name 
	, b.group_name 
	, a.price 
	, lead (a.price, 2) over (partition by b.group_name order by a.price) as next_price
	, a.price - lead (a.price, 2) over (partition by b.group_name order by a.price) as cur_next_diff
from product a
inner join product_group b
on a.group_id = b.group_id 
;


-- rental 테이블을 이용하여 년, 연월, 연월일, 전체 각각의 기준으로 
-- rental_id 기준 렌탈이 일어난 횟수를 출력하시오. 
/*
 * 		y			m			d			count
 *     2005			5			24			  8		(일기준)
 * 	   2005			5			25			 137	
 *  					  
 * 						  ⁝⁝
 * 						  			
 * 	   null		   null		   null			16044	(전체)
 */
-- 년
-- rental_id의 개수를 count함
select 
	to_char(a.rental_date, 'yyyy') as y
	, count(*)
from rental a
group by 1
;

-- 연월
select 
	to_char(a.rental_date, 'yyyymm') as m
	, count(*)
from rental a
group by 1
order by 1
;

-- 연월일
select 
	to_char(a.rental_date, 'yyyymmdd') as d
	, count(*)
from rental a
group by 1
order by 1
;

-- 전체
select count(*)
from rental;

-- rollup()
select 
	to_char(a.rental_date, 'yyyy') as y
	, to_char(a.rental_date, 'mm') as m
	, to_char(a.rental_date, 'dd') as d
	, count(*)
from rental a
group by rollup (to_char(a.rental_date, 'yyyy')
				, to_char(a.rental_date, 'mm')
				, to_char(a.rental_date, 'dd'))
order by 1, 2, 3
;

/**
 * rental과 customer 테이블을 이용하여 
 * 현재까지 가장 많이 rental을 한 고객의 
 * 고객id, 렌탈순위, 누적렌탈횟수, 이름(first_name, last_name)을 출력하시오.
 * 	- row_number()
 */
-- 1) rental 순위를 구한다.
select 
	a.customer_id 
	, row_number () over (order by count(a.rental_id) desc) as rental_rank
	, count(a.rental_id) rental_count
from rental a
group by a.customer_id 
;
-- 2) 가장 많이 rental한 1명의 고객만 구한다.
select 
	a.customer_id 
	, row_number () over (order by count(a.rental_id) desc) as rental_rank
	, count(a.rental_id) rental_count
from rental a
group by a.customer_id 
order by rental_rank
limit 1
;
-- 3) customer 테이블과 조인해서 고객의 이름 등을 출력한다.
select 
	a.customer_id 
	, row_number () over (order by count(a.rental_id) desc) as rental_rank
	, count(a.rental_id) rental_count
	, max(b.first_name || ' ' || b.last_name) as first_last_name
from rental a , customer b 
where a.customer_id = b.customer_id 
group by a.customer_id 
order by rental_rank
limit 1
;

select a.customer_id, a.rental_rank, a.rental_count, b.first_name, b.last_name
from (
	select 
		a.customer_id 
		, row_number () over (order by count(a.rental_id) desc) as rental_rank
		, count(a.rental_id) rental_count
	from rental a
	group by a.customer_id 
	order by rental_rank
	limit 1
) a , customer b 
where a.customer_id = b.customer_id 
;






















