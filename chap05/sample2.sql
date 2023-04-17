-- sample2.sql


-- ******************************************************
-- SELECT 문의 기본구조와 각 절의 실행순서
-- ******************************************************
--  - Clauses -                 - 실행순서 -
--
-- SELECT clause                        (5)
-- FROM clause                          (1)
-- [ WHERE clause ]                     (2)
-- [ GROUP BY clause ]                  (3)
-- [ HAVING clause ]                    (4)
-- [ ORDER BY clause ]                  (6)
-- ******************************************************


-- ------------------------------------------------------
-- 1. Oracle Join
-- ------------------------------------------------------
--  가. Oracle에서만 사용되는 조인
--  나. 특징: 여러 테이블을 연결하는 조인조건을 WHERE절에 명시
-- ------------------------------------------------------
--  a. Catesian Product (카테시안 프로덕트)
--  b. Equal(= Equi) Join (동등 조인)
--  c. Non-equal(= Non-equi) Join (비동등 조인)
--  d. Self Join (셀프 조인)
--  e. Outer Join (외부 조인)
-- ------------------------------------------------------
-- * Please refer to page 4.
-- ------------------------------------------------------

-- ------------------------------------------------------
-- A. Catesian Product (카테시안 프로덕트)
-- ------------------------------------------------------
-- 두 개 이상의 테이블을 공통컬럼없이 연결하는 조인으로,
-- 모든 조인에서 가장 먼저 발생하는 조인이자 기본이 됨.
--  가. 유효한 데이터로 사용되지 못함.
--  나. 조인조건이 생략된 경우에 발생.
--
-- * 조인결과: 테이블1 x ... x 테이블n 개의 레코드 생성
-- ------------------------------------------------------
-- Basic Syntax)
--  SELECT 테이블1.컬럼 , 테이블2.컬럼
--  FROM 테이블1, 테이블2
-- ------------------------------------------------------
SELECT
    count(*)            -- 107 명
FROM
    employees;


SELECT
    count(*)            -- 27 개
FROM
    departments;


SELECT
    107 * 27            -- 2889
FROM
    dual;    


-- Cartesian Product Operation
SELECT
    -- count(*)        -- 2889 = 107 (employees) x 27 (departments)
    *
FROM
    -- 연결시킬 여러테이블을 아래와 같이 쉼표(,)로 나열하면 됨
    -- 조인조건 없음(***)
    employees,
    departments;


SELECT
    last_name,
    department_name
FROM
    employees,
    departments;


-- ------------------------------------------------------
-- B. Equal(= Equi) Join (동등 조인)
-- ------------------------------------------------------
-- 가. 가장 많이 사용하는 조인
-- 나. 두 테이블에서, 공통으로 존재하는 컬럼의 값이 일치하는 행들을
--     연결하여 데이터를 반환.
--     일치하지 않는 데이터는 제외됨.
-- 다. 대부분, 기본키(PK)를 가진 테이블(Parent, Master)과
--     참조키(FK)를 가진 테이블(Child, Slave)을 조인할 때 사용 (***)
-- ------------------------------------------------------
-- Basic Syntax)
--  SELECT 테이블1.컬럼 , 테이블2.컬럼
--  FROM 테이블1, 테이블2
--  WHERE 테이블1.공통컬럼 = 테이블2.공통컬럼;
-- ------------------------------------------------------
SELECT
    last_name,
    employees.department_id,
    departments.department_id,
    department_name
FROM
    employees,
    departments
WHERE
    -- 동등조인(Equi Join)의 조건 2가지:
    -- (1) 두 테이블이 부모/자식 관계이어야 함
    -- (2) 부모테이블의 PK와 자식테이블의 FK를 동등비교연산자로 조건생성
    --     (*주의*: 이때, 당연히 부모의 PK와 자식의 FK는 그 성질이 동일함)
    -- (3) 공통컬럼이란? 성질이 같은 두 테이블의 컬럼을 의미하는 것으로,
    --         성질이 같다는 의미는 두 컬럼의 의미,도메인,타입이 같음을 의미

    -- 조인조건(동등조인) 기재
    --  (자식테이블의 FK)         (부모테이블의 PK)
    employees.department_id = departments.department_id; -- 조인조건


-- ------------------------------------------------------
-- 공통컬럼 사용시, 컬럼의 모호성 제거
-- ------------------------------------------------------
SELECT
    last_name,
    department_name,
    -- table.common_column : 컬럼의 모호성 제거
    -- department_id,    -- ORA-00918: column ambiguously defined
    departments.department_id   -- OK

    -- 자연조인(Natural Join) == Equi Join + 중복컬럼 제거
FROM
    employees,
    departments
WHERE
    -- Equi Join
    employees.department_id = departments.department_id;    -- 조인조건


SELECT
    last_name,
    department_name,
    -- 공통컬럼 사용시, 소속테이블명 기재로 모호성 제거
    employees.department_id  
FROM
    employees,
    departments
WHERE
    employees.department_id = departments.department_id;


-- ------------------------------------------------------
-- 테이블에 별칭 사용
-- ------------------------------------------------------
-- 가. SELECT 절에서, 컬럼 별칭(Column Alias)을 사용했듯이,
--     FROM 절에서도, 테이블 별칭(Table Alias)을 사용가능하다.
-- 나. 테이블명이 길거나, 식별이 힘든 경우에 유용하다.
-- 다. (*주의*) 테이블 별칭을 지정한 경우에는, 반드시 이 별칭을
--     사용하여, 컬럼을 참조해야 한다.
--     만일, 테이블 별칭을 사용하지 않고, 테이블명으로 컬럼을
--     참조하면, 테이블명을 별칭(Alias)으로 인식하기 때문에,
--     오류 발생.
-- ------------------------------------------------------
-- Basic Syntax)
--      SELECT alias1.컬럼 , alias2.컬럼
--      FROM 테이블1 alias1, 테이블2 alias2
--      WHERE alias1.공통컬럼 = alias2.공통컬럼;
-- ------------------------------------------------------

-- 테이블 별칭(alias) 사용
SELECT
    emp.last_name,              -- 성
    dept.department_name,       -- 부서명
    -- ORA-00904: "EMPLOYEES"."DEPARTMENT_ID": invalid identifier
    -- employees.department_id     -- 부서번호 : XX
    emp.department_id     -- 부서번호 : XX
FROM
    -- 한번 테이블에 별칭(Alias)을 부여하면, DQL문장을 구성하는
    -- 모든 절에서 테이블명이 나올 필요가 있는 곳에는 모두, 테이블 별칭을
    -- 사용해야 함(***)
    employees emp,          -- emp : 테이블 별칭(alias)
    departments dept        -- dept: 테이블 별칭(alias)
WHERE
    emp.department_id = dept.department_id;


-- 테이블 별칭(alias) 사용시 주의할 점
-- ORA-00904: "EMPLOYEES"."DEPARTMENT_ID": invalid identifier
SELECT
    e.last_name,
    d.department_name,
    e.department_id
FROM
    employees e,          -- emp : 테이블 별칭(alias)
    departments d         -- dept: 테이블 별칭(alias)
WHERE
    -- 테이블별칭을 사용하지 않으면 어떻게 될까?
    e.department_id = d.department_id; -- 조인조건


-- ------------------------------------------------------
-- Check조건(1차 필터링을 수행하는 조건) 추가
-- ------------------------------------------------------
-- 가. Oracle 조인에서는, WHERE절에 AND / OR 연산자를 사용하여
--     조인조건에 Check조건을 추가할 수 있다.
-- 나. 이로인해, WHERE의 어떤 조건이 조인조건이고, 어떤 조건이
--     Check조건인지, 쉽게 파악이 안되어, 가독성이 떨어짐
-- 다. (*주의*) 따라서, 조인조건을 우선 명시하고, 나중에 Check조건
--     을 명시하는 방법으로, 가독성을 향상시켜야 한다.(현업의 약속)
-- 라. 결과: 조인조건의 결과 중에서, Check조건으로 1차 필터링된 결과
--           를 반환
-- ------------------------------------------------------
SELECT
    e.last_name,
    e.salary,
    d.department_name
FROM
    employees e,
    departments d
WHERE
    -- 동등조인(Equi Join) 수행
    e.department_id = d.department_id  -- 동등 조인조건
    AND e.last_name = 'Whalen';        -- Check 조건


SELECT
    d.department_name AS 부서명,
    count(e.employee_id) AS 인원수
FROM
    employees e,
    departments d
WHERE
    e.department_id = d.department_id           -- 조인조건
    AND to_char( hire_date , 'YYYY') <= 2005    -- Check조건
GROUP BY
    d.department_name;


-- ------------------------------------------------------
-- C. Non-equal(= Non-equi) Join (비동등 조인)
-- ------------------------------------------------------
-- 가. WHERE절에 조인조건을 지정할 때, 동등비교연산자(=) 이외의,
--     비교 연산자(>,<,>=,<=,!=)를 사용하는 조인
-- ------------------------------------------------------
-- * Please refer to the chapter 05, page 13.
-- ------------------------------------------------------
-- DDL
DROP TABLE job_grades PURGE;    -- 테이블 삭제

CREATE TABLE  job_grades (
    grade_level   VARCHAR2(3) PRIMARY KEY,    -- 월급여등급
    lowest_sal    NUMBER,                     -- 최소 월급여
    highest_sal   NUMBER                      -- 최대 월급여
);

DESC job_grades;

-- DML
INSERT INTO job_grades VALUES('A', 1000, 2999);
INSERT INTO job_grades VALUES('B', 3000, 5999);
INSERT INTO job_grades VALUES('C', 6000, 9999);
INSERT INTO job_grades VALUES('D', 10000, 14999);
INSERT INTO job_grades VALUES('E', 15000, 24999);
INSERT INTO job_grades VALUES('F', 25000, 40000);

-- TCL
COMMIT;

-- DQL
SELECT * FROM job_grades;


-- 2개의 테이블을 비동등조인(Non-Equi Join) 수행
-- 비동등조인이란? 비교연산자 중에, 같다(=)를 제외한 나머지 비교연산자로
-- 조인을 수행하는 것을 의미
SELECT
    last_name,
    salary,
    grade_level
    -- *
FROM
    employees e,
    job_grades g    -- 등급별 페이밴드 테이블
WHERE
    -- 비동등 조인조건 설정 (범위연산자 사용)
    e.salary BETWEEN g.lowest_sal AND g.highest_sal;
    -- e.salary BETWEEN 1000 AND 3000;


-- 3개의 테이블 조인
SELECT
    last_name,
    salary,
    department_name,
    grade_level
FROM
    employees e,
    departments d,
    job_grades g
WHERE
    e.department_id = d.department_id                       -- Equal Join
    AND e.salary BETWEEN g.lowest_sal AND g.highest_sal;    -- Non-equal Join


-- ------------------------------------------------------
-- D. Self Join (셀프 조인)
-- ------------------------------------------------------
-- 하나의 테이블만 사용하여, 자기자신을 조인할 수도 있는데, 이를
-- Self Join 이라고 한다.
--  가. FROM 절에 같은 테이블을 사용해야 함
--  나. 따라서, 반드시 테이블 별칭을 사용해야 함
--  다. 테이블 하나를, 두 개 이상으로 Self 조인가능
--  라. 하나의 테이블을, 마치 여러 테이블을 사용하는 것처럼,
--      테이블 별칭을 사용하여, 조인하는 방법을 의미
-- ------------------------------------------------------

-- 1) 사원이름과 담당관리자 사원번호를 필요로 하는 경우
SELECT
    last_name,
    job_id, 
    employee_id,        -- 이건 나의 사번
    manager_id          -- 이건 나의 관리자의 사번
FROM
    employees;


-- 2) 사원이름과 담당관리자 이름을 필요로 하는 경우
--    불가능
-- 
--    But, 사원테이블과 사원테이블과 동일한 구조의 담당관리자
--    테이블이 있다고 가정한다면? 
--    : 두 테이블 조인을 통해, 원하는 데이터의 조회가능
--      실제 존재하지 않는 관리자 테이블 생성은, 테이블 별칭(alias)
--      을 사용하여, 가상의 관리자 테이블을 생성하면 됨. (***)
SELECT
    employee_id,    -- 사원번호(사번)
    last_name,      -- 나의 이름
    manager_id      -- 관리자 사번
FROM
    employees e
ORDER BY
    employee_id ASC;


SELECT
    employee_id,
    last_name,
    job_id
FROM
    employees
WHERE
    employee_id = 100;


-- --------------------------------
DROP TABLE manager PURGE;

CREATE TABLE manager        -- 관리자 테이블
AS
    SELECT
        DISTINCT 
            employee_id,    -- 관리자 사번
            last_name       -- 관리자 이름
    FROM
        employees;

-- 대전제!!!! : 관리자도 사원이다!! 
--              그래서 관리자도 사번이 있다!!

SELECT
    e.employee_id AS 직원사번,
    e.last_name AS 사원명,
    e.manager_id AS 관리자사번1,
    m.employee_id AS 관리자사번2,
    m.last_name AS 관리자명
FROM
    employees e,
    employees m
WHERE
    e.manager_id = m.employee_id;    


-- self 조인을 위한 가상 테이블 생성
SELECT
    -- 사원 테이블의 컬럼들
    e.employee_id AS 사원번호,
    e.last_name AS 사원명,
    e.manager_id AS 관리자번호,

    -- 관리자 테이블의 컬럼들
    m.employee_id AS 사원번호,
    m.last_name AS 관리자명
FROM
    employees e,        -- 사원 정보
    employees m         -- 관리자 정보(가상)
WHERE
    e.manager_id = m.employee_id;


-- ------------------------------------------------------
-- E. Outer Join (외부 조인) == Inner Join + 탈락한 행들을 살리자!
-- ------------------------------------------------------
-- INNER조인의 조건에 부합하지 못해, 탈락한 행들을 되살리는 조인
-- Join 조건에 부합하지 않아도, 결과셋에 누락된 데이터를 포함시키
-- 는 방법:
--  (취소) 가. Inner Join (Equal, Non-Equal, Self Join):
--  가. Inner Join (Equi Join => 동등조인, 셀프조인):
--      조인결과는 반드시, 동등조인조건을 만족하는 데이터만 포함하는 조인
--  나. (+) 연산자를 사용한다.
--  다. (+) 연산자는, 조인대상 테이블들 중에서, 한번만 사용가능
--          때문에, Oracle Join 에서는 Full Outer Join 은 지원하지 못함
--  라. (+) 연산자는, 일치하는 데이터가 없는 쪽에 지정
--  마. (+) 연산자의 지정:
--      내부적으로, 한 개 이상의 NULL 가진 행이 생성되고,
--      이렇게 생성된 NULL 행들과 데이터를 가진 테이블들의 행들
--      이 조인하게 되어, 조건이 부합하지 않아도, 결과값에 포함됨
-- ------------------------------------------------------
-- Basic Syntax)
--
--  SELECT 테이블1.컬럼 , 테이블2.컬럼
--  FROM 테이블1 , 테이블2
--  WHERE 테이블1.공통컬럼 = 테이블2.공통컬럼 (+);
-- ------------------------------------------------------
-- * Please refer to the chapter 05, page 19.
-- ------------------------------------------------------
SELECT
    e.employee_id AS 사원번호,
    e.manager_id AS 관리자번호,
    e.last_name AS 사원명,
    m.last_name AS 관리자명
FROM
    -- 지시하는자와 지시받는자의 정보를 획득 => Self Join 필요
    employees e,        -- 사원 정보
    employees m         -- 관리자 정보(가상)
WHERE
    -- 동등조인조건을 생성
--  -- FK(자식) -   -- PK(부모) --
    e.manager_id = m.employee_id   -- 회장님은 탈락!!!
ORDER BY
    e.employee_id;

SELECT
    e.employee_id AS 사원번호,
    e.last_name AS 사원명,
    m.last_name AS 관리자명
FROM
    employees e,        -- 사원 정보
    employees m         -- 관리자 정보(가상)
WHERE
    e.manager_id = m.employee_id (+)     -- OK
    -- e.manager_id (+) = m.employee_id     -- OK
    -- e.manager_id (+) = m.employee_id (+) // XX : Full Outer Join 지원불가
ORDER BY
    e.employee_id;

SELECT count(DISTINCT manager_id)
FROM employees
WHERE manager_id IS NOT NULL;   

SELECT 107-18 FROM dual;

-- ------------------------------------------------------

-- 이 쿼리의 목적은, 
-- 각 사원의 "관리자의 관리자"가 누구인지를 찾아내기위해
-- 셀프조인을 2번 하는 것임.
SELECT
    e.last_name AS 사원명,
    m.last_name AS 관리자명,
    mm.last_name AS "관리자의 관리자명"
FROM
    employees e,
    employees m,
    employees mm
WHERE
    e.manager_id = m.employee_id
    AND m.manager_id = mm.employee_id;

--- 2022.12.21 아래 할 차례임

SELECT
    e.last_name AS 사원명,
    m.last_name AS 관리자명,
    mm.last_name AS "관리자의 관리자명"
FROM
    employees e,
    employees m,
    employees mm
WHERE
    -- 사원 중에서, 관리자가 없는 사원까지 포함
    e.manager_id = m.employee_id (+)
    -- 관리자 중에서, 관리자가 없는 관리자까지 포함
    AND m.manager_id = mm.employee_id (+);

-- =======================================

SELECT
    -- 사원테이블의 컬럼들
    e.employee_id,
    e.last_name,
    e.department_id,

    -- 부서테이블의 컬럼들
    d.department_id,
    d.department_name
FROM
    employees e,
    departments d
WHERE
    e.department_id = d.department_id;  -- 동등조인