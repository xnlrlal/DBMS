-- 카테고리별, 연도별 매출을 추출하시오.
select category , yyyy , sum(gmv) total_gmv
from gmv_trend g
group by category , yyyy 
;


select category , yyyy , sum(gmv) total_gmv
from gmv_trend g
where category = '컴퓨터 및 주변기기'
group by 1, 2
order by yyyy desc
;


select category , mm , sum(gmv) as gmv
from gmv_trend g
group by 1, 2
;


select category , mm , platform_type , sum(gmv) as gmv 
from gmv_trend g
group by category , mm , platform_type 
;


select sum(gmv) as gmv, min(yyyy), max(yyyy), avg(gmv)  
from gmv_trend g
;


-- 매출(50000000)이 높은 주요 카테고리만 추출하시오.
select category , sum(gmv) as gmv  
from gmv_trend g
group by 1
having sum(gmv) >= 50000000
;


-- 매출(10000000)이 높은 주요 카테고리만 추출하시오. 이중 2020년에 해당하는 것을 추출하시오.
select category , yyyy , sum(gmv) as gmv  
from gmv_trend g 
where yyyy = 2020
group by 1, 2
having 	sum(gmv) >= 10000000
;


select *
from gmv_trend g
order by category , yyyy , mm , platform_type 
;


-- 매출이 높은 순으로 카테고리 정렬하시오.
select category , sum(gmv) as gmv 
from gmv_trend g
group by 1
order by gmv desc 
;


select category , yyyy , sum(gmv) as gmv 
from gmv_trend g
group by 1, 2
order by 1 desc, 3 desc 
;


-----------------------------------------------------------------------

-- 고객 중 결제내역이 있는 고객의 고객정보 및 결제내역을 출력하시오.
-- ANSI 표준 방식의 (INNER)JOIN 
select
	c.customer_id 
,	c.first_name 
,	c.last_name 
,	p.amount 
,	p.payment_date 
from customer c
inner join payment p 
on c.customer_id = p.customer_id
order by p.payment_date 
;


-- 고객 중 customer_id가 2인 고객의 고객정보와 결제내역을 출력하시오.
select
	c.customer_id 
,	c.first_name 
,	c.last_name 
,	p.amount 
,	p.payment_date 
from customer c , payment p 
where c.customer_id = p.customer_id 
and c.customer_id = 2
order by p.payment_date 
;


-- 고객 중 customer_id가 2인 고객의 고객정보와 결제내역을 출력하시오.
-- 해당 결제를 수행한 스탭의 정보까지 출력하시오.
-- staff_id, 스탭의 first_name, last_name
select
	c.customer_id 
,	c.first_name 
,	c.last_name 
,	p.amount 
,	p.payment_date 
,	s.staff_id 
,	s.first_name 
,	s.last_name 
from customer c 
join payment p 
on c.customer_id = p.customer_id 
join staff s 
on p.customer_id = s.staff_id 
where c.customer_id = 2
order by p.payment_date
;


select
	c.customer_id 
,	c.first_name as customer_first_name
,	c.last_name as customer_last_name
,	p.amount 
,	p.payment_date 
,	s.staff_id 
,	s.first_name as staff_first_name
,	s.last_name as staff_last_name
from customer c 
inner join payment p 
on c.customer_id = p.customer_id 
inner join staff s 
on p.staff_id  = s.staff_id 
where c.customer_id = 2
order by p.payment_date
;


select
	c.customer_id 
,	c.first_name 
,	c.last_name 
,	p.amount 
,	p.payment_date 
,	s.staff_id 
,	s.first_name 
,	s.last_name 
from customer c , payment p , staff s 
where c.customer_id = p.customer_id 
and c.customer_id = s.staff_id 
order by p.payment_date 
;

select
	c.customer_id 
,	c.first_name as customer_first_name
,	c.last_name as customer_last_name
,	p.amount 
,	p.payment_date 
,	s.staff_id 
,	s.first_name as staff_first_name
,	s.last_name as staff_last_name
from customer c 
	,payment p 
	,staff s 
where c.customer_id = 2
and c.customer_id = p.customer_id 
and p.staff_id = s.staff_id 
order by p.payment_date
;


---------------------------------------------------------------------
-- FILM 테이블, INVENTORY 테이블
-- 왼쪽 (film)은 다나오고, 오른쪽 (inverntory)는 매칭되는 것만 나오게 되는 것임.
select 
	A.film_id 
,	A.title 
,	B.inventory_id 
from film A
left outer join inventory B 
on (A.film_id = B.film_id)
--where B.inventory_id is null
order by A.title 
;


-- RIGHT OUTER JOIN
-- film 테이블의 내용은 모두 나옴, inventory 테이블의 내용은 매칭되는 것만 나옴.
select 
	b.film_id 
,	b.title 
,	a.inventory_id 
from inventory a
right join film b 
on a.film_id = b.film_id 
--where a.inventory_id is null 
order by b.title 
;
