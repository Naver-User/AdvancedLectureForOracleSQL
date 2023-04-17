-- sample12.sql


-- ------------------------------------------------------
-- 5. 제약조건 추가 (ALTER TABLE 문장)
-- ------------------------------------------------------
-- 가. 기존 테이블에 제약조건 추가
-- 나. PK/FK/UK/CK 제약조건 추가 -> ALTER TABLE ADD 문 사용 (***)
-- 다. NN 제약조건 추가          -> ALTER TABLE MODIFY 문 사용 (***)
-- 라. 기존 테이블에 추가적인 제약조건도 추가 가능
-- ------------------------------------------------------
-- Basic Syntax:
--
--  ALTER TABLE 테이블명
--  ADD [CONSTRAINT 제약조건명] 제약조건타입(컬럼명);
-- ------------------------------------------------------


-- ------------------------------------------------------
-- (1) PRIMARY KEY 제약조건 추가
-- ------------------------------------------------------
-- 제약조건 없는 테이블 생성
CREATE TABLE dept03 (
    deptno  NUMBER(2),
    dname   VARCHAR2(15),
    loc     VARCHAR2(15)
);


DESC dept03;


-- 테이블에 제약조건 추가
ALTER TABLE dept03
ADD CONSTRAINT dept03_deptno_pk PRIMARY KEY(deptno);


-- 기본키 제약조건 추가 확인
SELECT
    table_name,
    constraint_type,
    constraint_name,
    r_constraint_name
FROM
    user_constraints
WHERE
    -- table_name IN ('DEPT03');
    table_name IN ('DEPT');


-- ------------------------------------------------------
-- (2) NOT NULL 제약조건 추가 (CK/PK/FK 제약조건 추가도 동일)
-- ------------------------------------------------------
-- Basic Syntax:
--
--  ALTER TABLE 테이블명
--  MODIFY ( 컬럼명 데이터타입 [CONSTRAINT 제약조건명] NOT NULL );
-- ------------------------------------------------------

DESC dept03;


-- NOT NULL 제약조건 추가
ALTER TABLE dept03
MODIFY ( dname VARCHAR2(15) CONSTRAINT dept03_dname_nn NOT NULL );

ALTER TABLE dept03
MODIFY ( loc CONSTRAINT dept03_loc_nn NOT NULL );   -- OK: 컬럼타입생략

ALTER TABLE dept03
-- 결론: 소괄호를 생략하면 오류가 발생하지만, 소괄호를 살리면 OK
--       Why? Table-Level 지정방식과 동일
MODIFY ( CONSTRAINT dept03_loc_uk UNIQUE(loc) );    -- OK: 컬럼과 컬럼타입생략


-- NOT NULL 제약조건 추가 확인
DESC dept03;


SELECT
    table_name,
    constraint_type,
    constraint_name,
    r_constraint_name
FROM
    user_constraints
WHERE
    table_name IN ('DEPT03');




