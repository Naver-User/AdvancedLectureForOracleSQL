-- 현재 연결세션의 날짜와 시간포맷을 변경하고 싶다

-- ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';         -- Oracle SQL*Developer
-- ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR';        -- Visual Source Code

ALTER SESSION SET nls_date_format = 'yyyy/MM/dd - hh24:mi:ss';

SELECT
    sysdate,
    sysdate + 9,            -- 일수를 더함
    sysdate + 9/24,         -- 24시간으로 나눈 값이, 시간으로 더해짐
    sysdate + 9/24/60,      -- 24시간/60분으로 나눈 값이, 분으로 더해짐
    sysdate + 9/24/60/60,   -- 24시간/60분/60초으로 나눈 값이, 초으로 더해짐
    systimestamp,

    current_date,           -- 현재 Timezone (ASIA/SEOUL)에 맞는 Local Date
    current_timestamp       -- 현재  ""                          Local Timestamp
FROM
    dual;