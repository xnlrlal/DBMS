-- 주문 테이블 
select *
from online_order
;

-- 상품 테이블
select *
from item 
;

-- 카테고리 테이블
select *
from category
;

-- 유저 테이블
select *
from user_info
;


-- 상품별 매출액 집계 후, 매출액 높은 순으로 정렬하기 
select itemid, sum(gmv) as gmv 
from online_order a
group by 1
order by 2 desc 
;


-- 상품이름을 상품ID와 나란히 놓아서 상품별 매출액을 출력하시오.
select 
	a.id
,	a.item_name  
,	sum(gmv) as gmv  	
from item a
join online_order b 
on a.id = b.itemid 
group by 1, 2
order by gmv desc 
;


-- 카테고리별 매출액을 출력하시오.
select 
	c.id 
,	c.cate1  
,	sum(gmv) as gmv  	
from item a
join online_order b 
on a.id = b.itemid 
join category c 
on a.category_id = c.id 
group by 1, 2
order by gmv desc 
;


-- 성별 매출액을 출력하시오.
select 
	ui.gender 
,	sum(gmv) as gmv
,	count(distinct ui.userid) as user_cnt
from user_info ui
join online_order oo 
on ui.userid = oo.userid 
group by 1
;


-- 연령별 매출핵을 출력하시오.
select 
	ui.age_band 
,	ui.gender 
,	sum(gmv) as gmv 
,	count(distinct ui.userid) as user_cnt
from user_info ui 
join online_order oo 
on ui.userid  = oo.userid 
group by 1, 2
order by gender , age_band  
;


-- 카테고리별 주요 상품(명)의 매출을 출력하시오.
-- 매출액(거래액) = unitsold * price
select 
	c.cate3 
,	c.cate2 
,	c.cate1 
,	i.item_name 
,	sum(oo.unitsold) as unitsold
,	sum(oo.gmv) as gmv
,	sum(gmv) / sum(unitsold) as price
from category c 
join item i 
on c.id = i.category_id 
join online_order oo 
on i.id = oo.itemid 
group by 1, 2, 3, 4
order by 1, 5 desc
;


-- 남성이 구매하는 아이템(명)과 카테고리(cate1), 매출액을 출력하시오.
select 
	c.cate1 
,	i.item_name
,	ui.gender 
,	sum(gmv) as gmv
,	sum(unitsold) as unitsold
from user_info ui 
join online_order oo 
on ui.userid = oo.userid 
join item i 
on i.id = oo.itemid 
join category c 
on c.id = i.category_id 
where ui.gender = 'M'
group by 1, 2, 3
;


---------------------------------------------------------------------
drop table if exists tb_emp;
create table tb_emp 
(
	emp_no	int primary key
,	emp_nm	varchar(50) not null
,	direct_manager_emp_no int 
,	foreign key(direct_manager_emp_no) references tb_emp(emp_no)
	on delete no action 
);

insert into tb_emp values (1, '김회장', null);
insert into tb_emp values (2, '박사장', 1);
insert into tb_emp values (3, '송전무', 2);
insert into tb_emp values (4, '이상무', 2);
insert into tb_emp values (5, '정이사', 2);
insert into tb_emp values (6, '최부장', 3);
insert into tb_emp values (7, '정차장', 4);
insert into tb_emp values (8, '김과장', 5);
insert into tb_emp values (9, '오대리', 8);
insert into tb_emp values (10, '신사원', 8);

select *
from tb_emp te 
;

-- 모든 직원을 출력하면서 직속상사의 이름을 출력하시오.
select 
	a.emp_no  
,	a.emp_nm 
,	b.emp_nm as direct_manager_emp_nm
from tb_emp a
left outer join tb_emp b
on a.direct_manager_emp_no = b.emp_no 
;


-- 상영시간이 동일한 필름을 출력하시오.
-- title(이름)은 서로 다르지만 상영시간이 동일한 film에 대한 정보를 출력하시오.
-- title, title, length
select 
	a.title 
,	b.title 
,	a.length 
from film a 
join film b 
on (a.length  = b.length and a.title <> b.title) 
;


----------
drop table if exists tb_emp;
drop table if exists tb_dept;
create table tb_dept
(
	dept_no int primary key
,	dept_nm varchar(100)
);

insert into tb_dept values (1, '회장실');
insert into tb_dept values (2, '경영지원본부');
insert into tb_dept values (3, '영업부');
insert into tb_dept values (4, '개발1팀');
insert into tb_dept values (5, '개발2팀');
insert into tb_dept values (6, '4차산업혁명팀');

select * from tb_dept;


-- 아직 부서 배정을 받지 못한 송인턴
drop table if exists tb_emp;
create table tb_emp 
(
	emp_no	int primary key
,	emp_nm	varchar(50) not null
,	dept_no int 
,	foreign key(dept_no) references tb_dept(dept_no)
);

insert into tb_emp values (1, '김회장', 1);
insert into tb_emp values (2, '박사장', 2);
insert into tb_emp values (3, '송전무', 2);
insert into tb_emp values (4, '이상무', 2);
insert into tb_emp values (5, '정이사', 2);
insert into tb_emp values (6, '최부장', 3);
insert into tb_emp values (7, '정차장', 3);
insert into tb_emp values (8, '김과장', 4);
insert into tb_emp values (9, '오대리', 4);
insert into tb_emp values (10, '신사원', 5);
insert into tb_emp values (11, '송인턴', null);

select * from tb_emp;


select 
	A.emp_no 
,	A.emp_nm 
,	A.dept_no 
,	B.dept_no 
,	B.dept_nm 
from tb_emp A
full outer join tb_dept B 
on (A.dept_no = B.dept_no)
;


-- 오른쪽에만 존재하는 행
-- 직원없는 부서 출력
select 
	A.emp_no 
,	A.emp_nm 
,	A.dept_no 
,	B.dept_no 
,	B.dept_nm 
from tb_emp A
full outer join tb_dept B 
on (A.dept_no = B.dept_no)
where A.emp_nm is null
;


-- 왼쪽에만 존재하는 행 
-- 부서없는 직원 출력 
select 
	A.emp_no 
,	A.emp_nm 
,	A.dept_no 
,	B.dept_no 
,	B.dept_nm 
from tb_emp A
full outer join tb_dept B 
on (A.dept_no = B.dept_no)
where B.dept_nm is null
;


----------
drop table if exists T1;
create table T1
(
	col_1 char(1) primary key
);

drop table if exists T2;
create table T2
(
	col_2 int primary key
);

insert into T1 (col_1) values ('A');
insert into T1 (col_1) values ('B');
insert into T1 (col_1) values ('C');
insert into T2 (col_2) values ('1');
insert into T2 (col_2) values ('2');
insert into T2 (col_2) values ('3');

select * from T1;
select * from T2;


select *
from T1 A
cross join T2 B 
order by A.col_1, B.col_2
;

