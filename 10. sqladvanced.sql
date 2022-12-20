-- film 테이블에서 길이가 가장 긴 film을 추출하시오.

-- 185가 길이가 가장 긴 값임을 알 수 있음.
select max(a.length) as max_length 
from film a
;

-- 길이가 185인 영화의 정보를 조회 
select 
	a.film_id 
,	a.title 
,	a.description 
,	a.release_year 
,	a.length 
from film a
where a.length = 185
order by a.title 
;

-- 서브쿼리 (비교연산자 =)
select 
	a.film_id 
,	a.title 
,	a.description 
,	a.release_year 
,	a.length 
from film a
where a.length = (
	select max(a.length) as max_length 
	from film a
)
order by a.title 
;

-- 영화들의 평균길이가 115.27보다 길이가 크거나 같은(이상) 영화들의 리스트를 출력하시오.
select round(avg(a.length), 2) as avg_length
from film a
;

select 
	a.film_id 
,	a.title 
,	a.description 
,	a.release_year 
,	a.length 
from film a
where a.length >= (
	select round(avg(a.length), 2) as avg_length
	from film a
)
order by a.title 
;


/*
 *  서브쿼리
 * 	 - sql문 내에서 메인쿼리가 아니 하위에 존재하는 쿼리를 말함.
 * 	 - 서브쿼리를 활용함으로써 다양한 결과를 도출할 수 있음.
 */

-- RENTAL_RATE 평균
select avg(a.rental_rate) as avg_rental_rate
from film a
;

-- reantal_rate의 평균보다 큰 rental_rate 집합을 구하시오.
select 
	a.film_id 
,	a.title 
,	a.rental_rate 
from film a
where a.rental_rate > 2.98
;

-- 중첩 서브쿼리의 활용
select 
	a.film_id 
,	a.title 
,	a.rental_rate 
from film a
where a.rental_rate > ( 		-- 중첩 서브쿼리의 시작
	select avg(a.rental_rate) as avg_rental_rate
	from film a
);								-- 중첩 서브쿼리의 종료

-- 인라인 뷰의 활용 
-- rental_rate가 평균보다 큰 집합의 영화정보를 추출하시오.
select 
	a.film_id 
,	a.title 
,	a.rental_rate 
from film a 
	, (												-- 인라인 뷰의 시작 
		select
			avg(rental_rate) as avg_rental_rate
		from film
	  ) b 											-- 인라인 뷰의 종료 
where a.rental_rate > b.avg_rental_rate				
;

-- 스칼라 서브쿼리 활용
select 
	a.film_id
	, a.title
	, a.rental_rate
from 
(											-- 인라인 뷰의 시작 
	select
		b.film_id 
		, b.title
		, b.rental_rate
		, (									-- 스칼라 서브쿼리의 시작 
			select avg(c.rental_rate) 
			from film c
		  ) as avg_rental_rate				-- 스칼라 서브쿼리의 종료 
	from film b
) a											-- 인라인 뷰의 종료 
where a.rental_rate > a.avg_rental_rate
;

-- 영화분류별 상영시간이 가장 긴 영화의 제목 및 상영시간을 추출하시오.
select b.category_id
	, a.title 
	, max(a.length)
from film a
	, film_category b
where a.film_id = b.film_id 
group by b.category_id , a.title
;

select film_id, title , length 
from film
where length >= any 
(
	select max(a.length)
	from film a
		, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
);

-- 영화분류별 상영시간이 가장 긴 영화의 상영시간과 동일한 시간을 갖는 영화의 제목 및 상영시간을 추출하시오.
-- 영화분류별 상영시간이 가장 긴 상영시간을 구하시오.
select film_id, title , length 
from film
where length = any 
(
	select max(a.length)
	from film a
		, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
);

-- '=any'는 'in'과 동일함
select film_id, title , length 
from film
where length in 
(
	select max(a.length)
	from film a
		, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
);

-- 영화분류별 상영시간이 가장 긴 영화의 모든 상영시간보다 크거나 같아야만 조건 성립함.
-- 영화분류별 상영시간이 가장 긴 상영시간을 구함 
select film_id, title , length 
from film 
where length >= all 
(
	select max(a.length)
	from film a
		, film_category b
	where a.film_id = b.film_id 
	group by b.category_id
);


-----------
select max(a.length)
from film a
	, film_category b
where a.film_id = b.film_id 
group by b.category_id 
;

select a.title , a.length 
from film a
where length >= any
(
	select max(a.length)
	from film a
		, film_category b
	where a.film_id = b.film_id 
	group by b.category_id 
);

-- 등급기준 평균값들보다 상영시간이 긴 영화정보 추출하시오.
select rating, round(avg(length), 2)
from film
group by rating 
;


select film_id 
	, title 
	, length 
from film 
where length > all 
(
	select round(avg(length), 2)
	from film
	group by rating 
)
order by length 
;

-- EXISTS
-- 고객 중에서 11달러 초과한 지불내역이 있는 고객을 추출하시오.
select 
	c.first_name 
	, c.last_name 
	, c.customer_id 
from customer c 
where exists (
				select 1
				from payment p 
				where p.customer_id = c.customer_id
				and p.amount > 11
			)
order by first_name , last_name 
;

-- 고객 중에서 11달러 초과한 적이 없는 지불내역이 있는 고객을 추출하시오.
select 
	c.first_name 
	, c.last_name 
	, c.customer_id 
from customer c
where not exists (
				select 1
				from payment p 
				where p.customer_id = c.customer_id
				and p.amount > 11
			)
order by first_name , last_name 
;

-- 재고가 없는 영화를 추출하시오.(except 연산)
select film_id , title 
from film
except
select distinct a.film_id 
				, b.title 
from inventory a
inner join film b
on b.film_id = a.film_id 
order by title 
;

-- except 연산을 사용하지 않고 같은 결과를 도출하시오.
select 
	film_id 
	, title 
from film 
where not exists
(
	select 1
	from inventory 
	where inventory.film_id = film.film_id 
)
order by title 
;

select 
	film_id 
	, title 
from film a
where not exists
(
	select 1
	from inventory b, film c
	where a.film_id = b.film_id 
	and a.film_id = c.film_id 
)
order by title 
;

-- 결과 다름
select 
	film_id 
	, title 
from film 
where not exists
(
	select 1
	from inventory a, film b
	where a.film_id = b.film_id 
)
order by title 
;











































