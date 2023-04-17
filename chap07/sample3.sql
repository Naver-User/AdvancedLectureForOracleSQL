-- sample3.sql

-- ------------------------------------------------------
-- 3. DELETE 문
-- ------------------------------------------------------
--  가. 테이블에 저장된 데이터 삭제.
--  나. 한번에 여러 행들을 삭제가능.
--  다. WHERE 절은 *생략가능* (**주의**)
--      생략하면, 지정 테이블의 모든 데이터(행)가 삭제됨.
-- ------------------------------------------------------
-- Basic Syntax1)
--
--  DELETE FROM 테이블명    -- 데이터를 삭제할 테이블 지정
--  [WHERE 조건식];         -- 조건이 참인 행들만 삭제
-- 
-- Basic Syntax2) 테이블의 전체 행들을 삭제
-- 
--  DELETE FROM 테이블명;   -- 이전 문법
--  DELETE 테이블명;        -- 현재 문법
-- ------------------------------------------------------
-- * Please refer to the chapter 07, page N.
-- ------------------------------------------------------
DESC mydept;


BEGIN       -- To start a transaction.

    DELETE FROM mydept
    WHERE deptno = 30;

    -- DELETE FROM mydept;     -- old
    DELETE mydept;          -- current

    -- TCL: Transaction Control Language.
    ROLLBACK;       -- To roll back all changes.
    -- COMMIT;      -- To save all changes permenantly.

END;        -- To end a transaction.


SELECT
    *
FROM
    mydept;


-- ------------------------------------------------------
-- 3-1. 서브쿼리(=부속질의)를 이용한 DELETE 문
-- ------------------------------------------------------
--  가. DELETE 문의 WHERE 절에서, 서브쿼리 사용.
--  나. 서브쿼리의 실행 결과값으로, 테이블의 데이터 삭제가능.
--  다. 이 방법을 사용하면, 기존 테이블에 저장된 데이터를 사용하여,
--      현재 테이블의 특정 데이터 삭제가능.
--  라. 서브쿼리의 실행결과값(=결과셋)의 개수와 타입이, 
--      메인쿼리의 WHERE절에 지정된 조건식의 
--      컬럼의 개수와 타입이 반드시 동일해야 함.
-- ------------------------------------------------------
-- Basic Syntax)
--
--  DELETE FROM 테이블명        -- 데이터를 삭제할 테이블 지정
--  [ WHERE <**Sub-query**> ]; -- 조건이 참인 행들만 삭제
--
-- ------------------------------------------------------
-- Please refer to the chap07, page 33.
-- ------------------------------------------------------
DESC mydept;


BEGIN       -- To start a transaction.

    -- 20번 부서와 동일한 지역에 있는 모든 부서를 삭제하라!!
    SET AUTOCOMMIT OFF;
    SHOW AUTOCOMMIT;

    DELETE FROM mydept
    WHERE loc = (
                    SELECT loc
                    FROM dept
                    WHERE deptno = 20
                );

    ROLLBACK;                
    
    -- 다중컬럼 조건식 지정 (Pairwise 방식)
    SHOW AUTOCOMMIT;

    DELETE FROM mydept
    WHERE (loc, dname) = (
                            SELECT loc, dname
                            FROM dept
                            WHERE deptno = 20
                        );

    ROLLBACK;

END;        -- To end a transaction.


SELECT
    *
FROM
    mydept;


-- 테이블의 모든 데이터(행들)을 절삭(순삭제!)
-- 주의사항: 복구불가한 순삭제
TRUNCATE TABLE myemp_mgr4;      -- DDL

