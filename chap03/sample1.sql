-- sample1.sql


-- ******************************************************
-- SELECT 문의 기본구조와 각 절의 실행순서
-- ******************************************************
--  - Clauses -                 - 실행순서 -
--
-- SELECT clause                    (5)
-- FROM clause                      (1)
-- WHERE clause                     (2)
-- GROUP BY clause                  (3)
-- HAVING clause                    (4)
-- ORDER BY clause                  (6)
-- ******************************************************


-- ------------------------------------------------------
-- 1. 단일(행) (반환)함수
-- ------------------------------------------------------
-- 단일(행) (반환)함수의 구분:
--
--  (1) 문자 (처리)함수 : 문자와 관련된 특별한 조작을 위한 함수
--      a. INITCAP  - 첫글자만 대문자로 변경
--      b. UPPER    - 모든 글자를 대문자로 변경
--      c. LOWER    - 모든 글자를 소문자로 변경
--      d. CONCAT   - 두 문자열 연결
--      e. LENGTH   - 문자열의 길이 반환
--      f. INSTR    - 문자열에서, 특정 문자열의 위치(인덱스) 반환
--      g. SUBSTR   - 문자열에서, 부분문자열(substring) 반환
--      h. REPLACE  - 문자열 치환(replace)
--      i. LPAD     - 문자열 오른쪽 정렬 후, 왼쪽의 빈 공간에 지정문자 채우기(padding)
--      j. RPAD     - 문자열 왼쪽 정렬 후, 오른쪽의 빈 공간에 지정문자 채우기(padding)
--      k. LTRIM    - 문자열의 왼쪽에서, 지정문자 삭제(trim)
--      l. RTRIM    - 문자열의 오른쪽에서, 지정문자 삭제(trim)
--      m. TRIM     - 문자열의 왼쪽/오른쪽/양쪽에서, 지정문자 삭제(trim)
--                    (단, 문자열의 중간은 처리못함)
--  (2) 숫자 (처리)함수 :
--  (3) 날짜 (처리)함수
--  (4) 변환 (처리)함수
--  (5) 일반 (처리)함수
--
--  단일(행) (반환)함수는, 테이블의 행 단위로 처리됨!
-- ------------------------------------------------------

-- ------------------------------------------------------
-- (1) 문자(처리) 함수 - INITCAP
-- ------------------------------------------------------
--     첫글자만 대문자로 변경
-- ------------------------------------------------------
SELECT
   'ORACLE SQL',
   INITCAP('ORACLE SQL')
FROM
   DUAL;

SELECT
   EMAIL,
   INITCAP(EMAIL)
FROM
   EMPLOYEES;

-- ------------------------------------------------------
-- (2) 문자(처리) 함수 - UPPER
-- ------------------------------------------------------
--     모든 글자를 대문자로 변경
-- ------------------------------------------------------
SELECT
   'Oracle Sql',
   UPPER('Oracle Sql')
FROM
   DUAL;

SELECT
   LAST_NAME,
   UPPER(LAST_NAME)
FROM
   EMPLOYEES;

SELECT
   LAST_NAME,
   SALARY
FROM
   EMPLOYEES
 -- *Decommendation*  :
 --        The index with the column cannot be used.
 -- WHERE
 -- upper(last_name) = 'KING';
 -- *Recommendation*  : The index with the column can be used.
WHERE
   LAST_NAME = INITCAP('KING');

-- ------------------------------------------------------
-- (3) 문자(처리) 함수 - LOWER
-- ------------------------------------------------------
--     모든 글자를 소문자로 변경
-- ------------------------------------------------------
SELECT
   'Oracle Sql',
   LOWER('Oracle Sql'),
   LOWER('한글') -- 대소문자 체계가 없는 언어에서는 효과가 없음(initcap, upper도 동일)
FROM
   DUAL;

SELECT
   LAST_NAME,
   LOWER(LAST_NAME)
FROM
   EMPLOYEES;

-- ------------------------------------------------------
-- (4) 문자(처리) 함수 - CONCAT
-- ------------------------------------------------------
--     두 문자열 연결(Concatenation)
-- ------------------------------------------------------
-- SELECT
--    -- || (Concatenation Operator) == concat function
--    'Oracle' || 'Sql',
--    concat('Oracle', 'Sql')

SELECT
 -- || (Concatenation Operator) == concat function
   'Oracle' || 'Sql' || 'third',
   CONCAT( CONCAT('Oracle',
   'Sql'),
   'third')
FROM
   DUAL;

SELECT
 -- || (Concatenation Operator) == concat function
   LAST_NAME || SALARY,
   CONCAT(LAST_NAME,
   SALARY)
FROM
   EMPLOYEES;

SELECT
 -- || (Concatenation Operator) == concat function
   LAST_NAME || HIRE_DATE,
   CONCAT(LAST_NAME,
   HIRE_DATE)
FROM
   EMPLOYEES;

-- ------------------------------------------------------
-- (5) 문자(처리) 함수 - LENGTH
-- ------------------------------------------------------
--     문자열의 길이 반환
-- ------------------------------------------------------
--  A. LENGTH   returns Characters
--  B. LENGTHB  returns Bytes
-- ------------------------------------------------------
SELECT
   'Oracle',
   LENGTH('Oracle'),
   LENGTHB('Oracle'),
   LENGTH('한글'),
   LENGTHB('한글')
FROM
   DUAL;

SELECT
   LAST_NAME,
   LENGTH(LAST_NAME)
FROM
   EMPLOYEES;

-- '한글' 문자열을 유니코드(Unicode)로 표현하면, '\D55C\AE00' 임.
SELECT
   '한글',
   LENGTH('한글')  AS LENGTH,
   LENGTHB('한글') AS LENGTHB
FROM
   DUAL;

SELECT
   UNISTR('\D55C\AE00'),
   LENGTH( UNISTR('\D55C\AE00') )  AS LENGTH,
   LENGTHB( UNISTR('\D55C\AE00') ) AS LENGTHB
FROM
   DUAL;

-- ------------------------------------------------------
-- (6) 문자(처리) 함수 - INSTR
-- ------------------------------------------------------
--     문자열에서, 특정 문자열의 (시작)위치(시작 인덱스) 반환
-- ------------------------------------------------------
-- 주의) Oracle 의 인덱스 번호는 1부터 시작함!!!
-- ------------------------------------------------------
SELECT
   INSTR('MILLER',
   'L',
   1,
   2), -- 1: offset, 2: occurence
   INSTR('MILLER',
   'X',
   1,
   2) -- 1: offset, 2: occurence
FROM
   DUAL;

-- ------------------------------------------------------
-- (7) 문자(처리) 함수 - SUBSTR
-- ------------------------------------------------------
--     문자열에서, 부분문자열(substring) 반환
-- ------------------------------------------------------
-- 주의) Oracle 의 인덱스 번호는 1부터 시작함!!!
-- ------------------------------------------------------
SELECT
 -- substr('123456-1234567', 1, 6)
 -- substr('123456-1234567', 8)
   SUBSTR('123456-1234567',
   1,
   7) || '*******' AS 주민등록번호
FROM
   DUAL;

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY/MM/DD - HH24:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR';

SELECT
   HIRE_DATE
FROM
   EMPLOYEES;

-- In the Oracle SQL*Developer (RR/MM/DD)
SELECT
   HIRE_DATE AS 입사일,
   SUBSTR(HIRE_DATE, 1, 2)        AS 입사년도
FROM
   EMPLOYEES;

-- In the Visual Source Code  (DD-MON-RR)
SELECT
   HIRE_DATE,
   TO_CHAR(HIRE_DATE)                    AS 입사일1,
   TO_CHAR(HIRE_DATE, 'RR/MM/DD')        AS 일사일2,
   TO_CHAR(HIRE_DATE, 'yyyy/MM/dd - hh24:mi:ss')        AS 일사일3,
   SUBSTR( TO_CHAR(HIRE_DATE), 8, 2 )    AS 입사년도
FROM
   EMPLOYEES;

SELECT
   '900303-1234567',
   SUBSTR('900303-1234567', 8)
FROM
   DUAL;

-- 그런데, offset index를 음수를 사용할 수 있다면????ㅠ
SELECT
   '900303-1234567',
   SUBSTR('900303-1234567', -7)
FROM
   DUAL;

-- ------------------------------------------------------
-- (8) 문자(처리) 함수 - REPLACE
-- ------------------------------------------------------
--     문자열 치환(replace)
-- ------------------------------------------------------
SELECT
   REPLACE('JACK and JUE', 'J', 'BL')
FROM
   DUAL;

-- ------------------------------------------------------
-- (9) 문자(처리) 함수 - LPAD
-- ------------------------------------------------------
--      문자열 오른쪽 정렬 후,
--      왼쪽의 빈 공간에 지정문자 채우기(padding)
-- ------------------------------------------------------
SELECT
   LPAD('MILLER', 10, '*')
FROM
   DUAL;

-- ------------------------------------------------------
-- (10) 문자(처리) 함수 - RPAD
-- ------------------------------------------------------
--      문자열 왼쪽 정렬 후,
--      오른쪽의 빈 공간에 지정문자 채우기(padding)
-- ------------------------------------------------------
SELECT
   RPAD('MILLER', 10, '*')
FROM
   DUAL;

SELECT
   SUBSTR('900303-1234567', 1, 8) || '******' AS 주민번호
FROM
   DUAL;

SELECT
   RPAD( SUBSTR('900303-1234567', 1, 8), 14, '*' ) AS 주민번호
FROM
   DUAL;

-- ------------------------------------------------------
-- (11) 문자(처리) 함수 - LTRIM
-- ------------------------------------------------------
--    문자열의 왼쪽에서, 지정문자 삭제(trim)
-- ------------------------------------------------------
SELECT
   LTRIM('MMMIMLLER', 'M')
FROM
   DUAL;

SELECT
   LTRIM(' MILLER '),
   LENGTH( LTRIM(' MILLER ') )
FROM
   DUAL;

-- ------------------------------------------------------
-- (12) 문자(처리) 함수 - RTRIM
-- ------------------------------------------------------
--    문자열의 오른쪽에서, 지정문자 삭제(trim)
-- ------------------------------------------------------
SELECT
   RTRIM('MILLRER', 'R')
FROM
   DUAL;

SELECT
   RTRIM(' MILLER '),
   LENGTH( RTRIM(' MILLER ') )
FROM
   DUAL;

-- ------------------------------------------------------
-- (13) 문자(처리) 함수 - TRIM
-- ------------------------------------------------------
--    문자열의 왼쪽/오른쪽/양쪽에서, 지정문자 삭제(trim)
--    (단, 문자열의 중간은 처리못함)
-- ------------------------------------------------------
-- 문법)
--    TRIM( LEADING 'str' FROM 컬럼명|표현식 )
--    TRIM( TRAILING 'str' FROM 컬럼명|표현식 )
--    TRIM( BOTH 'str' FROM 컬럼명|표현식 )
--    TRIM( 'str' FROM 컬럼명|표현식 )     -- BOTH (default)
-- ------------------------------------------------------
SELECT
   TRIM( '0' FROM '0001234567000' ) -- default: BOTH (양쪽에서 제거)
FROM
   DUAL;

SELECT
   TRIM( LEADING '0' FROM '0001234567000' ) -- 문자열 왼쪽에서 제거
FROM
   DUAL;

SELECT
   TRIM( TRAILING '0' FROM '0001234567000' ) -- 문자열 오른쪽에서 제거
FROM
   DUAL;