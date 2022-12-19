drop table if exists tb_film_grade;
create table tb_film_grade
(
	film_grade_no int primary key 
,	title_nm varchar not null
,	release_year smallint 
,	grade_rnk int
);

insert into tb_film_grade values (1, '늑대사냥', 2022, 1);
insert into tb_film_grade values (2, '공조2: 인터내셔날', 2022, 2);
insert into tb_film_grade values (3, '아바타 리마스터링', 2022, 3);


select * from tb_film_grade;

drop table if exists tb_film_attendance;
create table tb_film_attendance
(
	film_grade_no varchar not null
,	title_nm varchar not null
,	release_year smallint 
,	attendance_rank int
);

insert into tb_film_attendance values (1, '아바타 리마스터링', 2022, 1);
insert into tb_film_attendance values (2, '헌트', 2022, 2);
insert into tb_film_attendance values (3, '늑대사냥', 2022, 3);

commit;

select a.title_nm, release_year from tb_film_grade a;
select a.title_nm, release_year from tb_film_attendance a;


-- 중복된 행을 하나씩만 보여주고 있음 
-- 중복된 행의 중복을 제거하고 유일한 값(행)만 보여줌
select a.title_nm, release_year from tb_film_grade a
union
select a.title_nm, release_year from tb_film_attendance a
;

-- 중복된 행도 모두 보여줌
select a.title_nm, release_year from tb_film_grade a
union all
select a.title_nm, release_year from tb_film_attendance a
;


select a.title_nm as "타이틀명", release_year as "출시연도" from tb_film_grade a
union all
select a.title_nm, release_year from tb_film_attendance a
order by 타이틀명
;

--오류
select a.title_nm as "타이틀명", release_year as "출시연도" from tb_film_grade a
union all
select a.title_nm, release_year from tb_film_attendance a
order by a.title_nm
;


----------INTERSECT----------
drop table if exists tb_film_grade;
create table tb_film_grade
(
	film_grade_no int primary key 
,	title_nm varchar not null
,	release_year smallint 
,	grade_rnk int
);

insert into tb_film_grade values (1, '늑대사냥', 2022, 1);
insert into tb_film_grade values (2, '공조2: 인터내셔날', 2022, 2);
insert into tb_film_grade values (3, '아바타 리마스터링', 2022, 3);


select * from tb_film_grade;
select * from tb_film_attendance;

drop table if exists tb_film_attendance;
create table tb_film_attendance
(
	film_grade_no varchar not null
,	title_nm varchar not null
,	release_year smallint 
,	attendance_rank int
);

insert into tb_film_attendance values (1, '아바타 리마스터링', 2022, 1);
insert into tb_film_attendance values (2, '헌트', 2022, 2);
insert into tb_film_attendance values (3, '늑대사냥', 2022, 3);

commit;

select a.title_nm as "타이틀명", release_year as "출시연도" from tb_film_grade a
intersect
select a.title_nm, release_year from tb_film_attendance a
order by 타이틀명 desc 
;

-- intersect 연산과 inner join의 결과집합은 동일
select a.title_nm , a.release_year 
from tb_film_grade a
inner join tb_film_attendance b 
on (a.title_nm = b.title_nm
	and a.release_year = b.release_year)
order by a.title_nm desc
;


----------EXCEPT----------
drop table if exists tb_film_grade;
create table tb_film_grade
(
	film_grade_no int primary key 
,	title_nm varchar not null
,	release_year smallint 
,	grade_rnk int
);

insert into tb_film_grade values (1, '늑대사냥', 2022, 1);
insert into tb_film_grade values (2, '공조2: 인터내셔날', 2022, 2);
insert into tb_film_grade values (3, '아바타 리마스터링', 2022, 3);

drop table if exists tb_film_attendance;
create table tb_film_attendance
(
	film_grade_no varchar not null
,	title_nm varchar not null
,	release_year smallint 
,	attendance_rank int
);

insert into tb_film_attendance values (1, '아바타 리마스터링', 2022, 1);
insert into tb_film_attendance values (2, '헌트', 2022, 2);
insert into tb_film_attendance values (3, '늑대사냥', 2022, 3);

commit;

select * from tb_film_grade;
select * from tb_film_attendance;

-- 위의 것 빼기 아래 것
select a.title_nm, release_year from tb_film_grade a
except
select a.title_nm, release_year from tb_film_attendance a
;

select a.title_nm, release_year from tb_film_attendance a
except
select a.title_nm, release_year from tb_film_grade a
;

select a.title_nm, release_year from tb_film_attendance a
union all
select a.title_nm, release_year from tb_film_attendance a
except
select a.title_nm, release_year from tb_film_grade a
;

----------count() 
-- payment 테이블의 건수를 조회하시오
select count(*) as cnt
from payment a
;

select count(*) as cnt
from customer a
;


drop table if exists tb_count_test;
create table tb_count_test
(
	count_test_no int primary key 
,	count_test_nm varchar(50) not null
);

commit;

select count(*) as cnt
from tb_count_test 
;


-- payment 테이블에서 customer_id 별 건수를 구하시오.
select a.customer_id , count(a.customer_id) as id_cnt
from payment a
group by a.customer_id
;

select *
from payment a
where a.customer_id = 184
;

select a.customer_id , count(a.customer_id) as id_cnt
from payment a
group by a.customer_id
order by id_cnt desc 
limit 1
;

select 
	a.customer_id 
,	b.first_name 
,	b.last_name 
,	b.first_name || ' ' || b.last_name as full_name
,	count(a.customer_id) as id_cnt
from payment a, customer b
where a.customer_id = b.customer_id 
group by a.customer_id , b.first_name , b.last_name , full_name
order by id_cnt desc 
limit 1
;

select 
	a.customer_id 
,	max(b.first_name) as last_name
,	max(b.last_name) as first_name
,	count(a.customer_id) as id_cnt
from payment a, customer b
where a.customer_id = b.customer_id 
group by a.customer_id
order by id_cnt desc 
limit 1
;

select 
	a.customer_id 
,	min(b.first_name) as last_name
,	min(b.last_name) as first_name
,	count(a.customer_id) as id_cnt
from payment a, customer b
where a.customer_id = b.customer_id 
group by a.customer_id
order by id_cnt desc 
limit 1
;

-- amount 값 중 유일한 값만을 출력하시오.
select distinct a.amount as amount 
from payment a
order by amount 
;

select count(distinct a.amount) as amount_cnt
from payment a
;

select distinct a.amount as amount , count(a.amount) as cnt
from payment a
group by amount
order by amount 
;

-- payment 테이블에서 customer_id 별 amount 컬럼의 유일값을 개수를 출력하시오.
select distinct a.amount 
from payment a
where a.customer_id = 1
;

select a.customer_id , count(distinct a.amount) as amount_cnt
from payment a
group by a.customer_id 
;

-- amount 컬럼의 유일값의 개수가 11 이상인 행들을 출력하시오.
select a.customer_id , count(distinct a.amount) as amount_cnt
from payment a
group by a.customer_id 
having count(distinct a.amount) >= 11
order by amount_cnt
;


---------- max(), min()
-- payment 테이블에서 최대 amount값과 최소 amount 값을 구하시오.
select 
	max(a.amount) as max_amount
,	min(a.amount) as min_amount
from payment a
;

-- payment 테이블에서 customer_id별 최대 amount값과 최소 amount값을 구하시오.
select 
	a.customer_id 
,	max(a.amount) as max_amount
,	min(a.amount) as min_amount
from payment a
group by a.customer_id 
order by customer_id 
;

-- 위 결과 중 최대 amount값이 11.0보다 큰 집합을 출력하시오.
select 
	a.customer_id 
,	max(a.amount) as max_amount
,	min(a.amount) as min_amount
from payment a
group by a.customer_id 
having max(a.amount) > 11.0
order by customer_id 
;


drop table if exists tb_max_min_test;
create table tb_max_min_test
(
	max_min_test_no char(6) primary key
,	max_amount numeric(15, 2)
,	min_amount numeric(15, 2)
);

commit;

insert into tb_max_min_test values ('100001', 100.52, 11.49);
commit;

select * from tb_max_min_test;

select a.max_min_test_no 
from tb_max_min_test a
where a.max_min_test_no = '100111'
;

select max(a.max_min_test_no) as max_min_test_no
from tb_max_min_test a
where a.max_min_test_no = '100111'
;

select coalesce (max(a.max_min_test_no), '없음') as max_min_test_no
from tb_max_min_test a
where a.max_min_test_no = '100111'
;

----------AVG(), SUM()
-- payment 테이블에서 amount의 평균값과 amount의 합계값을 구하시오.
-- 단, 소수점 이하 2자리까지 출력하시오.
select 
	round(avg(a.amount), 2) as amount_avg
,	round(sum(a.amount), 2) as amount_sum
from payment a
;

-- payment 테이블에서 customer_id 별 amount의 평균값과 amount의 합계값을 구하시오.
-- amount 합계값을 기준으로 내림차순 정렬하시오.
select 
	a.customer_id 
,	round(avg(a.amount), 2) as amount_avg
,	round(sum(a.amount), 2) as amount_sum
from payment a
group by a.customer_id 
order by amount_sum desc
;

-- amount의 평균값이 5.00 이상인 결과집합을 출력하시오.
-- 단, amount의 합계값을 기준으로 내림차순 정렬하시오.
select 
	a.customer_id 
,	round(avg(a.amount), 2) as amount_avg
,	round(sum(a.amount), 2) as amount_sum
from payment a
group by a.customer_id 
having avg(a.amount) >= 5.00
order by amount_sum desc
;

-- customer_id, first_name, last_name 별 amount의 평균값과 amount의 합계값을 구하시오.
select 
	a.customer_id 
,	max(b.first_name) as first_name
,	max(b.last_name) as last_name 
,	round(avg(a.amount), 2) as amount_avg
,	round(sum(a.amount), 2) as amount_sum
from payment a, customer b
where a.customer_id = b.customer_id 
group by a.customer_id 
having avg(a.amount) >= 5.00
order by amount_sum desc
;


drop table if exists tb_avg_sum_test;
create table tb_avg_sum_test
(
	avg_sum_test_no char(6) primary key
,	avg_amount numeric(15, 2)
,	sum_amount numeric(15, 2)
);
commit;

insert into tb_avg_sum_test values ('100001', 100.00, 10.00);
insert into tb_avg_sum_test values ('100002', 100.00, 20.00);
insert into tb_avg_sum_test values ('100003', 100.00, 30.00);
insert into tb_avg_sum_test values ('100004', null, 40.00);
insert into tb_avg_sum_test values ('100005', 200.00, null);
insert into tb_avg_sum_test values ('100006', null, null);
commit;

select * from tb_avg_sum_test;

-- 평균을 구할 때 전체 합계를 4로 나눔.
-- 즉 null인 행은 평균을 구할 때 대상에 포함되지 않음.
-- 합계를 구할 때도 null인 행은 합계를 구하는 대상에 포함되지 않았음.
select 
	round(avg(a.avg_amount), 2) as avg_amount 
,	round(sum(a.sum_amount), 2) as sum_amount  
from tb_avg_sum_test a
;

-- 연산시 null과의 연산을 하려고 하면 결과는 null이 됨.
select a.avg_amount + a.sum_amount as "avg+sum"
from tb_avg_sum_test a
;

-- 숫자를 문자열로 바꾸기
select a.dt , cast (a.dt as varchar) as yyyymmdd
from online_order a
;

-- 문자열 컬럼에서 일부만 잘라내기
select 
	a.dt 
,	left (cast (a.dt as varchar), 4) as yyyy
,	substring (cast(a.dt as varchar), 5, 2) as mm
,	right (cast (a.dt as varchar), 2) as dd
from online_order a
;

-- yyyy-mm-dd 형식으로 이어서 출력해 보시오.
select 
	a.dt 
,	left (cast (a.dt as varchar), 4) as yyyy
,	substring (cast(a.dt as varchar), 5, 2) as mm
,	right (cast (a.dt as varchar), 2) as dd
,	left (cast (a.dt as varchar), 4) || '-' || 
	substring (cast(a.dt as varchar), 5, 2) || '-' || 
	right (cast (a.dt as varchar), 2) as "||"
,	concat(left (cast (a.dt as varchar), 4), '-'
		 , substring (cast(a.dt as varchar), 5, 2), '-'
		 , right (cast (a.dt as varchar), 2)) as concat
from online_order a
;

-- null 값인 경우 임의의 값으로 바꿔주기
select 
	coalesce (b.gender, 'NA') as gender
,	coalesce (b.age_band, 'NA') as age_band
,	sum(a.gmv)
from online_order a
left join user_info b 
on a.userid = b.userid 
group by 1, 2
order by 1, 2
;

-- 내가 원하는 값으로 컬럼 추가해보기
select distinct case when a.gender = 'M' then '남성'
					 when a.gender = 'F' then '여성'
					 else 'NA'
					 end as gender 
from user_info a
;

-- 연령대 그룹(20대, 30대, 40대)을 만들어 연령대별 매출액을 출력하시오 
select 
	distinct case when a.age_band = '20~24' then '20대'
				  when a.age_band = '25~29' then '20대'
				  when a.age_band = '30~34' then '30대'
				  when a.age_band = '35~39' then '30대'
				  when a.age_band = '40~44' then '40대'
				  else 'NA'
				  end as age_group
,	sum(b.gmv) as gmv
from user_info a, online_order b
where a.userid = b.userid
group by 1
;































