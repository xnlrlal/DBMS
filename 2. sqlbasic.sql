create table TB_CONTACT
(
	CONTACT_NO SERIAL primary key 
,	FIRST_NM VARCHAR(50) not null 
,	LAST_NM VARCHAR(50) not null 
,	EMAIL_ADRES VARCHAR(200) not null UNIQUE
);

insert into tb_contact (FIRST_NM, LAST_NM, EMAIL_ADRES)
values ('순신', '이', 'sslee@gmail.com');

insert into tb_contact (FIRST_NM, LAST_NM, EMAIL_ADRES)
values ('방원', '이', 'bwlee@gmail.com');

select * from tb_contact;

-- 테이블 구조 및 데이터 복제 => 제약조건은 복제 반영 안됨.
-- 테이블, 컬럼명, 컬럼 데이터타입, 컬럼값만 복제(반영)
create table tb_contact_bak
	as table tb_contact;
	
select * from tb_contact_bak;

-- 제약조건 추가
alter table tb_contact_bak add primary key(CONTACT_NO);
alter table tb_contact_bak add unique(EMAIL_ADRES);
alter table tb_contact_bak 
	alter column FIRST_NM set not null
, 	alter column LAST_NM set not null
;

insert into tb_contact_bak (CONTACT_NO, FIRST_NM, LAST_NM, EMAIL_ADRES)
values (3, '방간', '이', 'bglee@gmail.com');
insert into tb_contact_bak (CONTACT_NO, FIRST_NM, LAST_NM, EMAIL_ADRES)
values (4, '성계', '이', 'sglee@gmail.com');

-------
drop table if exists TB_USER_ROLE;
drop table if exists TB_USER;
create table tb_user 
(
	USER_NO INT
,	USER_NM VARCHAR(50) not null 
,	BIRTH_DE DATE not null 
,	ADDRS VARCHAR(200) null 
,	primary key (USER_NO)			-- 테이블 생성하면서 USER_NO를 기본키로 지정
);									-- USER_NO 컬럼으로 이루어진 인덱스도 자동으로 생성됨

drop table if exists TB_USER;
create table TB_USER 
(
	USER_NO INT
,	USER_NM VARCHAR(50) not null 
,	BIRTH_DE DATE not null 
,	ADDRS VARCHAR(200) null 
,	constraint PK_TB_USER primary key (USER_NO)	-- 기본키 제약조건의 제약조건명 명명
);

drop table if exists TB_USER;
create table TB_USER 							-- 테이블 생성
(
	USER_NO INT
,	USER_NM VARCHAR(50) not null 
,	BIRTH_DE DATE not null 
,	ADDRS VARCHAR(200) null 
);

alter table tb_user add primary key (USER_NO);	-- 기본키 지정


create table TB_VENDOR 
(
	VENDOR_NM VARCHAR(255)
);

insert into tb_vendor (VENDOR_NM) values ('Apple');
insert into tb_vendor (VENDOR_NM) values ('IBM');
insert into tb_vendor (VENDOR_NM) values ('Samsung');
insert into tb_vendor (VENDOR_NM) values ('LG');
insert into tb_vendor (VENDOR_NM) values ('Microsoft');
insert into tb_vendor (VENDOR_NM) values ('Sony');

select * from tb_vendor;

-- serial 형식으로 기본 키로 지정 
-- 기존에 있는 행(데이터)들에게 자동으로 & 순차적으로 번호를 부여하게 됨 
alter table tb_vendor add column VENDOR_ID SERIAL primary key;
alter table tb_vendor drop constraint tb_vendor_pkey;

------------------------------------------------------------------------------------------

create table TB_CUST
(
	CUST_NO INT
,	CUST_NM VARCHAR(255) not null 
,	primary key (CUST_NO)
);

drop table if exists TB_CONTACT;
create table TB_CONTACT 
(
	CONTACT_NO INT
,	CONTACT_TYP_CD CHAR(6) not null 	-- 'CTC001': 전화번호, 'CTC002': 이메일주소, ...
,	CONTACT_INFO VARCHAR(100)
,	CUST_NO INT
,	primary key (CONTACT_NO)
,	constraint FK_CUST_NO_TB_CUST foreign key (CUST_NO) references TB_CUST(CUST_NO)
	on delete no action 		-- 자식을 가지고 있는 부모테이블의 행을 삭제하려고 하면 삭제 못하게 하는 것 
);

insert into tb_cust (CUST_NO, CUST_NM) values (1, '이순신');
insert into tb_cust (CUST_NO, CUST_NM) values (2, '이방원');

select * from tb_cust;

insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (1, 'CTC001', '010-2314-4356', 1);
insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (2, 'CTC002', 'sslee@gmail.com', 1);

insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (3, 'CTC001', '010-7777-5555', 2);
insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (4, 'CTC002', 'bwlee@gmail.com', 2);

select * from tb_contact;

delete from tb_cust where CUST_NO = 1;

--------------
drop table if exists TB_CUST;
drop table if exists TB_CONTACT;

create table TB_CUST
(
	CUST_NO INT
,	CUST_NM VARCHAR(255) not null 
,	primary key (CUST_NO)
);

create table TB_CONTACT 
(
	CONTACT_NO INT
,	CONTACT_TYP_CD CHAR(6) not null 	-- 'CTC001': 전화번호, 'CTC002': 이메일주소, ...
,	CONTACT_INFO VARCHAR(100)
,	CUST_NO INT
,	primary key (CONTACT_NO)
,	constraint FK_CUST_NO_TB_CUST foreign key (CUST_NO) references TB_CUST(CUST_NO)
	on delete set null  		-- set null 옵션은 자식을 가지고 있는 부모행을 삭제하려고 하면 자식행의 값을 null로 셋팅함 
);

insert into tb_cust (CUST_NO, CUST_NM) values (1, '이순신');
insert into tb_cust (CUST_NO, CUST_NM) values (2, '이방원');

insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (1, 'CTC001', '010-2314-4356', 1);
insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (2, 'CTC002', 'sslee@gmail.com', 1);

insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (3, 'CTC001', '010-7777-5555', 2);
insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (4, 'CTC002', 'bwlee@gmail.com', 2);

delete from tb_cust where CUST_NO = 1;

select * from tb_contact;
select * from tb_cust;

-------------
drop table if exists TB_CONTACT;
drop table if exists TB_CUST;

create table TB_CUST
(
	CUST_NO INT
,	CUST_NM VARCHAR(255) not null 
,	primary key (CUST_NO)
);

create table TB_CONTACT 
(
	CONTACT_NO INT
,	CONTACT_TYP_CD CHAR(6) not null 	-- 'CTC001': 전화번호, 'CTC002': 이메일주소, ...
,	CONTACT_INFO VARCHAR(100)
,	CUST_NO INT
,	primary key (CONTACT_NO)
,	constraint FK_CUST_NO_TB_CUST foreign key (CUST_NO) references TB_CUST(CUST_NO)
	on delete cascade 		-- cascade옵션은 자식을 가지고 있는 부모행을 삭제하려고 하면 자식행도 삭제해 버림 
);

insert into tb_cust (CUST_NO, CUST_NM) values (1, '이순신');
insert into tb_cust (CUST_NO, CUST_NM) values (2, '이방원');

insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (1, 'CTC001', '010-2314-4356', 1);
insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (2, 'CTC002', 'sslee@gmail.com', 1);

insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (3, 'CTC001', '010-7777-5555', 2);
insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (4, 'CTC002', 'bwlee@gmail.com', 2);

delete from tb_cust where CUST_NO = 1;

select * from tb_contact;
select * from tb_cust;

------------
drop table if exists TB_CONTACT;
drop table if exists TB_CUST;

create table TB_CUST
(
	CUST_NO INT
,	CUST_NM VARCHAR(255) not null 
,	primary key (CUST_NO)
);

insert into tb_cust (CUST_NO, CUST_NM) values (1, '이순신');
insert into tb_cust (CUST_NO, CUST_NM) values (2, '이방원');
select * from tb_cust; 

create table TB_CONTACT 
(
	CONTACT_NO INT 
,	CONTACT_TYP_CD CHAR(6) not null 	-- 'CTC001': 전화번호, 'CTC002': 이메일주소, ...
,	CONTACT_INFO VARCHAR(100) 
,	CUST_NO INT 
,	primary key (CONTACT_NO) 
);

insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (1, 'CTC001', '010-2314-4356', 1);
insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (2, 'CTC002', 'sslee@gmail.com', 1);

insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (3, 'CTC001', '010-7777-5555', 2);
insert into tb_contact (CONTACT_NO, CONTACT_TYP_CD, CONTACT_INFO, CUST_NO)
values (4, 'CTC002', 'bwlee@gmail.com', 2);
select * from tb_contact;

-- alter TABLE ~~~ 
alter table TB_CONTACT 
add constraint FK_TB_CONTACT_1 foreign key (CUST_NO) references TB_CUST(CUST_NO)
on delete no action;

alter table TB_CONTACT 
add constraint FK_TB_CONTACT_1 foreign key (CUST_NO) references TB_CUST(CUST_NO)
on delete set null;

alter table TB_CONTACT 
add constraint FK_TB_CONTACT_1 foreign key (CUST_NO) references TB_CUST(CUST_NO)
on delete cascade;

--------------
drop table if exists TB_EMP;
create table TB_EMP
(
	EMP_NO SERIAL primary key 
,	FIRST_NM VARCHAR(50)
,	LAST_NM VARCHAR(50)
,	BIRTH_DE DATE check (BIRTH_DE > '1900-01-01')
,	JOIN_DE DATE check (JOIN_DE > BIRTH_DE)
,	SAL_AMT numeric check (SAL_AMT > 0)
);

-- 오류
insert into TB_EMP (FIRST_NM, LAST_NM, BIRTH_DE, JOIN_DE, SAL_AMT)
values ('순신', '이', '1994-07-12', '1883-01-02', -100000);

insert into TB_EMP (FIRST_NM, LAST_NM, BIRTH_DE, JOIN_DE, SAL_AMT)
values ('순신', '이', '1994-07-12', '2009-01-02', 50000000);

select * from TB_EMP;

-- 테이블 생성 (체크 제약조건 없음)
drop table if exists TB_EMP;
create table TB_EMP
(
	EMP_NO SERIAL primary key 
,	FIRST_NM VARCHAR(50)
,	LAST_NM VARCHAR(50)
,	BIRTH_DE DATE  
,	JOIN_DE DATE  
,	SAL_AMT numeric  
);

insert into TB_EMP (FIRST_NM, LAST_NM, BIRTH_DE, JOIN_DE, SAL_AMT)
values ('순신', '이', '1994-07-12', '1883-01-02', -100000);

alter table TB_EMP 
add constraint TB_EMP_SAL_AMT_CHECK check(SAL_AMT > 0);

truncate table TB_EMP;

------------
drop table if exists TB_PERSON;

create table TB_PERSON
(
	PERSON_NO SERIAL primary key 
,	FIRST_NM VARCHAR(50)
,	LAST_NM VARCHAR(50)
,	EMAIL_ADRES VARCHAR(50) unique 
);

insert into TB_PERSON (FIRST_NM, LAST_NM, EMAIL_ADRES)
values ('순신', '이', 'sslee@gmail.com');

select * from tb_person;

-- 오류
insert into TB_PERSON (FIRST_NM, LAST_NM, EMAIL_ADRES)
values ('순신', '이', 'sslee@gmail.com');
----------
drop table if exists TB_PERSON;
create table TB_PERSON
(
	PERSON_NO SERIAL primary key 
,	FIRST_NM VARCHAR(50)
,	LAST_NM VARCHAR(50)
,	EMAIL_ADRES VARCHAR(50) 
,	unique(FIRST_NM, LAST_NM, EMAIL_ADRES) 		-- 값의 조합은 각각의 행이 모두 유일한 값이어야 함.
);

insert into TB_PERSON (FIRST_NM, LAST_NM, EMAIL_ADRES)
values ('순신', '이', 'sslee@gmail.com');
select * from tb_person;

insert into TB_PERSON (FIRST_NM, LAST_NM, EMAIL_ADRES)
values ('방원', '이', 'sslee@gmail.com');

----------
drop table if exists TB_PERSON;
create table TB_PERSON
(
	PERSON_NO SERIAL primary key 
,	FIRST_NM VARCHAR(50)
,	LAST_NM VARCHAR(50)
,	EMAIL_ADRES VARCHAR(50) 
);

-- 유니크 인덱스 생성 
create unique index IDX_TB_PERSON_01 on TB_PERSON (FIRST_NM, LAST_NM, EMAIL_ADRES);

-- 유니크 제약조건을 걸어줌
alter table TB_PERSON 
add constraint CONSTRAINT_TB_PERSON_01 
unique using index IDX_TB_PERSON_01;

----------
drop table if exists TB_PERSON;

create table TB_PERSON 
(
	PERSON_NO SERIAL primary key 
,	FIRST_NM VARCHAR(50) null 
,	LAST_NM VARCHAR(50) null 
,	EMAIL_ADRES VARCHAR(150) not null 
);

-- 오류
insert into TB_PERSON (FIRST_NM, LAST_NM, EMAIL_ADRES)
values ('순신', '이', NULL);

insert into TB_PERSON (FIRST_NM, LAST_NM, EMAIL_ADRES)
values ('순신', '이', 'sslee@gmail.com');
select * from tb_person;

alter table TB_PERSON alter column FIRST_NM set not null;
alter table TB_PERSON alter column LAST_NM set not null;

-- 오류
insert into TB_PERSON (FIRST_NM, LAST_NM, EMAIL_ADRES)
values (NULL, NULL, 'null@gmail.com');

insert into TB_PERSON (FIRST_NM, LAST_NM, EMAIL_ADRES)
values ('방원', '이', 'bwlee@gmail.com');

select * from TB_PERSON where  FIRST_NM = '방원';











