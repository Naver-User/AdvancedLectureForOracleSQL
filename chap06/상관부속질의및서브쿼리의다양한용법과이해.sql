
-- 각 사원별, 사번/이름/부서번호/부서명을 얻자!!
-- (without join and using subquery)


SELECT
    -- 사번 AS 사원번호,
    -- 이름 AS 사원명,
    -- 부서번호,
    -- 부서명

    부서번호,
    avg(급여) AS 평균급여
FROM (
    SELECT
        employee_id AS 사번,
        last_name AS 이름,
        salary AS 급여,
        department_id AS 부서번호,

        ( -- 상관부속질의: 메인쿼리의 데이터를 받아서 수행되는 서브쿼리
            --  (1) 단독수행불가 (왜? 메인쿼리의 데이터 없이는 수행이 안되기 때문)
            --  (2) SELECT 절이 수행되는 횟수만큼, 똑같이 수행
            --  (3) 메인쿼리와 함께 수행(먼저 수행되지 못함)
            SELECT
                department_name
            FROM 
                departments t2 
            WHERE 
                t2.department_id = t1.department_id
        ) AS 부서명
    FROM
        employees t1
    WHERE
        department_id >= 70        
) e
WHERE
    사번 IN (
        SELECT employee_id
        FROM employees
        WHERE employee_id > 100
    )
GROUP BY
    부서번호
-- HAVING
--     부서번호 IN (
--         SELECT department_id
--         FROM departments
--         WHERE department_id >= 70
--     )
ORDER BY
    부서번호 ASC;    