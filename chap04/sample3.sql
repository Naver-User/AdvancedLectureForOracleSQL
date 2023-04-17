-- sample3.sql


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
-- 4. GROUP BY clause
-- ------------------------------------------------------
-- (Basic syntax)
--   SELECT
--      [단순컬럼1, ]
--      ..
--      [단순컬럼n, ]
--
--      [표현식1, ]
--      ..
--      [표현식n, ]
--
--      그룹함수1,
--      그룹함수2,
--      ...
--      그룹함수n
--   FROM table
--   [ GROUP BY { 단순컬럼1, .., 단순컬럼n | 표현식1, .., 표현식n } ]
--   [ HAVING 조건식 ]
--   [ ORDER BY caluse ];
-- ------------------------------------------------------
-- *주의할 점1: 
--   GROUP BY뒤에, Column alias or index 사용불가!!!
-- *주의할 점2:
--   GROUP BY뒤에 명시된 컬럼은, 
--   SELECT절에 그룹함수와 함께 사용가능!!
-- *주의할 점3:
--   ORDER BY절의 다중정렬과 비슷하게, 다중그룹핑 가능
-- *주의할 점4:
--   WHERE 절을 사용하여, 그룹핑하기 전에, 행을 제외시킬 수 있다!!
--   (1차 필터링 - 행을 필터링)
-- *주의할 점5:
--   HAVING 절을 사용하여, 그룹핑한 후에, 행(X)이 아니라, 그룹(OK)을 
--   제외시킬 수 있다!! (2차 필터링 - 그룹을 필터링)
-- *주의할 점6:
--   WHERE 절에는 그룹함수를 사용할 수 없다!!
-- *주의할 점7:
--   GROUP BY 절은 NULL 그룹도 생성함!!
-- ------------------------------------------------------
-- *** Chapter04 Page 10 참고할 것
-- ------------------------------------------------------

SELECT
    DISTINCT department_id       -- NULL 포함
FROM
    employees
WHERE
    department_id IS NOT NULL;

-- 부서별 GROUP BY ( AVG 함수 )
SELECT
    department_id   AS 부서번호,        -- 그룹생성 단순컬럼
    avg(salary)     AS 평균월급         -- 각 그룹마다 적용될 그룹함수
FROM
    employees
GROUP BY
    department_id  -- NULL도 그룹으로 생성 (*주의*)
ORDER BY
    1 ASC;


-- 부서별 GROUP BY ( MAX 함수 )
SELECT
    department_id   AS 부서번호,       -- 그룹생성 단순컬럼
    min(salary)     AS 최소월급,       -- 각 그룹마다 적용될 그룹함수1
    max(salary)     AS 최대월급        -- 각 그룹마다 적용될 그룹함수2
FROM
    employees
GROUP BY
    department_id            -- OK
    -- 1                        -- X : SELECT 절의 순서가 더 느림
    -- 부서번호                 -- X : SELECT 절의 순서가 더 느림
ORDER BY
    -- 부서번호 ASC;        -- OK
    department_id ASC;      -- OK


-- 다중컬럼 GROUP BY
SELECT
    to_char( hire_date , 'YYYY' )   AS 년,      -- 다중그룹생성 표현식1
    to_char( hire_date , 'MM')      AS 월 ,     -- 다중그룹생성 표현식2
    sum(salary)                                 -- 각 그룹마다 적용될 그룹함수
FROM
    employees
GROUP BY
    -- 다중 표현식(1..N)
    to_char( hire_date , 'YYYY'),               -- 다중그룹생성 표현식1
    to_char( hire_date , 'MM')                  -- 다중그룹생성 표현식2
ORDER BY
    년 ASC;
