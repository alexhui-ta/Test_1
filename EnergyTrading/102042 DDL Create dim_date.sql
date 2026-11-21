
----=====================================================================
----
----=====================================================================
--CREATE OR ALTER VIEW param_holiday 
----FOLDER = '/3_canonical_views/trading/staging' 
--AS 
--    SELECT 
--        b_alg_holiday.holiday AS holiday_date
--        , b_alg_holiday.description AS description
--        , param_holiday_calendar 
--    FROM 
--        b_alg_holiday 
--    WHERE 
--        holidaycalendar = param_holiday_calendar 
--GO
--        --USING PARAMETERS ( param_holiday_calendar : text);
----=====================================================================
----
----=====================================================================
--CREATE OR ALTER VIEW canada_holidays 
----FOLDER = '/3_canonical_views/trading/staging' 
--AS 
--    SELECT 
--        param_holiday.holiday_date AS holiday_date
--        , param_holiday.description AS description 
--    FROM 
--        param_holiday 
--    WHERE 
--        param_holiday_calendar = 'Canada'
--GO
----=====================================================================
----
----=====================================================================
--CREATE OR ALTER VIEW alberta_holidays 
----FOLDER = '/3_canonical_views/trading/staging' 
--AS 
--    SELECT 
--        param_holiday.holiday_date AS holiday_date
--        , param_holiday.description AS description 
--    FROM 
--        param_holiday 
--    WHERE 
--        param_holiday_calendar = 'Alberta'
--GO
----=====================================================================
----
----=====================================================================
--CREATE OR ALTER VIEW dim_date_base 
---- FOLDER = '/3_canonical_views/trading/staging'
---- PRIMARY KEY ( 'date_key' ) 
--AS 
--    SELECT 
--        b_sds_date.datekey AS date_key
--        , b_sds_date.date AS date
--        , b_sds_date.datetextyyyymmdd AS date_text_yyyymmdd
--        , b_sds_date.datetextyyyymd AS date_text_yyyymd
--        , b_sds_date.datetextddmmyear AS date_text_ddmmyear
--        , b_sds_date.datetextdmyear AS date_text_dmyear
--        , b_sds_date.datetextmmmdyyyy AS date_text_mmmdyyyy
--        , b_sds_date.datetextmmmmmmmmmdyyyy AS date_text_mmmmmmmmmdyyyy
--        , b_sds_date.datetextddmmyy AS date_text_ddmmyy
--        , b_sds_date.datetextdmyy AS date_text_dmyy, b_sds_date.daynumberofweek AS day_number_of_week, b_sds_date.daynameofweek AS day_name_of_week
--        , b_sds_date.daynameofweeklong AS day_name_of_week_long, b_sds_date.isweekdayflag AS is_weekday_flag, b_sds_date.isweekendflag AS is_weekend_flag
--        , b_sds_date.daynumberofmonth AS day_number_of_month, b_sds_date.daynumberofyear AS day_number_of_year, b_sds_date.weeknumberofyear AS week_number_of_year
--        , b_sds_date.monthname AS month_name, b_sds_date.monthnamelong AS month_name_long, b_sds_date.monthnumberofyear AS month_number_of_year
--        , b_sds_date.monthsequencenumber AS month_sequence_number, b_sds_date.monthnumberofquarter AS month_number_of_quarter, b_sds_date.quarternumber AS quarter_number
--        , b_sds_date.quartersequencenumber AS quarter_sequence_number, b_sds_date.quartername AS quarter_name, b_sds_date.yearnumber AS year_number
--        , b_sds_date.yearkey AS year_key, b_sds_date.semesternumber AS semester_number, b_sds_date.yearmonthname AS year_month_name
--        , b_sds_date.yearmonthnamelong AS year_month_name_long, b_sds_date.monthkey AS month_key, b_sds_date.priormonthkey AS prior_month_key
--        , b_sds_date.isfirstdayofmonthflag AS is_first_day_of_month_flag, b_sds_date.islastdayofmonthflag AS is_last_day_of_month_flag
--        , b_sds_date.isfirstdayofquarterflag AS is_first_day_of_quarter_flag, b_sds_date.islastdayofquarterflag AS is_last_day_of_quarter_flag
--        , b_sds_date.isfirstdayofyearflag AS is_first_day_of_year_flag, b_sds_date.islastdayofyearflag AS is_last_day_of_year_flag
--        , b_sds_date.offsetindaysfromtodaynumber AS offset_in_days_from_today_number, b_sds_date.offsetinweeksfromtodaynumber AS offset_in_weeks_from_today_number
--        , b_sds_date.offsetinweeksfromtodaytext AS offset_in_weeks_from_today_text, b_sds_date.offsetinmonthsfromtodaynumber AS offset_in_months_from_today_number
--        , b_sds_date.offsetinyearsfromtodaynumber AS offset_in_years_from_today_number
--        , case WHEN (canada_holidays.holiday_date is not null ) THEN true ELSE false END AS is_canada_holiday
--        , case WHEN (alberta_holidays.holiday_date is not null ) THEN true ELSE false END AS is_alberta_holiday
--        , case WHEN (ice_holidays.holiday_date is not null ) THEN true ELSE false END AS is_ice_holiday
--        , case WHEN (nerc_holidays.holiday_date is not null ) THEN true ELSE false END AS is_nerc_holiday
--        , case WHEN (nymex_holidays.holiday_date is not null ) THEN true ELSE false END AS is_nymex_holiday
--        , case WHEN (us_holidays.holiday_date is not null ) THEN true ELSE false END AS is_us_holiday 
--    FROM 
--        (
--            (
--                (
--                    (
--                        (
--                            b_sds_date AS b_sds_date LEFT OUTER JOIN alberta_holidays AS alberta_holidays ON b_sds_date.date = alberta_holidays.holiday_date 
--                        ) 
--                            LEFT OUTER JOIN canada_holidays AS canada_holidays ON b_sds_date.date = canada_holidays.holiday_date 
--                        ) LEFT OUTER JOIN ice_holidays AS ice_holidays ON b_sds_date.date = ice_holidays.holiday_date 
--                    ) LEFT OUTER JOIN nerc_holidays AS nerc_holidays ON b_sds_date.date = nerc_holidays.holiday_date 
--                ) LEFT OUTER JOIN nymex_holidays AS nymex_holidays ON b_sds_date.date = nymex_holidays.holiday_date 
--            ) LEFT OUTER JOIN us_holidays AS us_holidays ON b_sds_date.date = us_holidays.holiday_date  
--    WHERE 
--        (
--            b_sds_date.first_day_of_date_dim = '2005-01-01' 
--            AND b_sds_date.last_day_of_date_dim = '2050-12-31'
--        )
--GO

--DECLARE @StartDate date = '2005-01-01';
--DECLARE @EndDate   date = '2050-12-31';
USE [RPT_VIEW]
GO
CREATE OR ALTER VIEW [energy_trading].[dim_date]
AS
WITH DateRows AS
(
    SELECT DATEADD(day, gs.value, '2005-01-01') AS [date]
    FROM GENERATE_SERIES
    (
        0,
        DATEDIFF(day, '2005-01-01', '2050-12-31'),
        1
    ) AS gs
    WHERE '2005-01-01' <= '2050-12-31'
)
, Today AS
(
    SELECT CONVERT(date, GETDATE()) AS today
)
, Calendar AS
(
    SELECT
        d.[date],
        t.today,
        DATEADD
        (
            day,
            -((DATEDIFF(day, '19000101', d.[date]) % 7 + 7) % 7),
            d.[date]
        ) AS week_start,
        DATEADD
        (
            day,
            -((DATEDIFF(day, '19000101', t.today) % 7 + 7) % 7),
            t.today
        ) AS today_week_start
    FROM DateRows AS d
    CROSS JOIN Today AS t
)
, canada_holidays AS
(
    SELECT holiday AS holiday_date
    FROM Horizon_ODS.dbo.holiday -- b_alg_holiday
    WHERE holidaycalendar = 'Canada'
)
, alberta_holidays AS
(
    SELECT holiday AS holiday_date
    FROM Horizon_ODS.dbo.holiday -- b_alg_holiday
    WHERE holidaycalendar = 'Alberta'
)
, ice_holidays AS
(
    SELECT holiday AS holiday_date
    FROM Horizon_ODS.dbo.holiday -- b_alg_holiday
    WHERE holidaycalendar = 'ICE'
)
, nerc_holidays AS
(
    SELECT holiday AS holiday_date
    FROM Horizon_ODS.dbo.holiday -- b_alg_holiday
    WHERE holidaycalendar = 'NERC'
)
, nymex_holidays AS
(
    SELECT holiday AS holiday_date
    FROM Horizon_ODS.dbo.holiday -- b_alg_holiday
    WHERE holidaycalendar = 'NYMEX'
)
, us_holidays AS
(
    SELECT holiday AS holiday_date
    FROM Horizon_ODS.dbo.holiday -- b_alg_holiday
    WHERE holidaycalendar = 'US'
)
, base_date AS
(
    SELECT
        CAST(CONVERT(char(8), [date], 112) AS int) AS datekey,
        CAST([date] AS date) AS [date],
        CAST(FORMAT([date], 'yyyy/MM/dd', 'en-US') AS varchar(max)) AS datetextyyyymmdd,
        CAST(FORMAT([date], 'yyyy/M/d', 'en-US') AS varchar(max)) AS datetextyyyymd,
        CAST(FORMAT([date], 'dd/MM/yyyy', 'en-US') AS varchar(max)) AS datetextddmmyear,
        CAST(FORMAT([date], 'd/M/yyyy', 'en-US') AS varchar(max)) AS datetextdmyear,
        CAST(FORMAT([date], 'MMM d, yyyy', 'en-US') AS varchar(max)) AS datetextmmmdyyyy,
        CAST(FORMAT([date], 'MMMM d, yyyy', 'en-US') AS varchar(max)) AS datetextmmmmmmmmmdyyyy,
        CAST(FORMAT([date], 'dd/MM/yy', 'en-US') AS varchar(max)) AS datetextddmmyy,
        CAST(FORMAT([date], 'd/M/yy', 'en-US') AS varchar(max)) AS datetextdmyy,
        CAST(((DATEDIFF(day, '18991231', [date]) % 7 + 7) % 7) + 1 AS int) AS daynumberofweek ,
        CAST(LEFT(FORMAT([date], 'dddd', 'en-US'), 3) AS varchar(max)) AS daynameofweek,
        CAST(FORMAT([date], 'dddd', 'en-US') AS varchar(max)) AS daynameofweeklong,
        CAST(CASE WHEN ((DATEDIFF(day, '19000101', [date]) % 7 + 7) % 7) + 1 <= 5
                THEN 'Y' ELSE 'N' END AS varchar(max)) AS isweekdayflag,
        CAST(CASE WHEN ((DATEDIFF(day, '19000101', [date]) % 7 + 7) % 7) + 1 >= 6
                THEN 'Y' ELSE 'N' END AS varchar(max)) AS isweekendflag,
        CAST(DAY([date]) AS int) AS daynumberofmonth,
        CAST(DATEPART(dayofyear, [date]) AS int) AS daynumberofyear,
        CAST
        (
            (
                DATEDIFF(day,DATEFROMPARTS(YEAR([date]), 1, 1),[date])
                +
                ((DATEDIFF(day,'18991231',DATEFROMPARTS(YEAR([date]), 1, 1)) % 7 + 7) % 7)
            ) / 7 + 1
            AS int
        ) AS weeknumberofyear,
        CAST(DATEPART(WEEK, [date]) AS int) AS weeknumberofyear_1,
        CAST(LEFT(FORMAT([date], 'MMMM', 'en-US'), 3) AS varchar(max)) AS monthname,
        CAST(FORMAT([date], 'MMMM', 'en-US') AS varchar(max)) AS monthnamelong,
        CAST(MONTH([date]) AS int) AS monthnumberofyear,
        CAST(DATEDIFF(month, '17530101', [date]) AS int) AS monthsequencenumber,
        CAST(((MONTH([date]) - 1) % 3) + 1 AS int) AS monthnumberofquarter,
        CAST(DATEPART(quarter, [date]) AS int) AS quarternumber,
        CAST(DATEDIFF(quarter, '17530101', [date]) AS int) AS quartersequencenumber,
        CAST(CONCAT('Q', DATEPART(quarter, [date])) AS varchar(max)) AS quartername,
        CAST(YEAR([date]) AS int) AS yearnumber,
        CAST(YEAR([date]) AS int) AS yearkey,
        CAST(CASE WHEN MONTH([date]) <= 6 THEN 1 ELSE 2 END AS int) AS semesternumber,
        CAST(FORMAT([date], 'yyyy MMM', 'en-US') AS varchar(max)) AS yearmonthname,
        CAST(FORMAT([date], 'yyyy MMMM', 'en-US') AS varchar(max)) AS yearmonthnamelong,
        CAST(YEAR([date]) * 100 + MONTH([date]) AS int) AS monthkey,
        CAST(YEAR(DATEADD(month, -1, [date])) * 100
            + MONTH(DATEADD(month, -1, [date])) AS int) AS priormonthkey,
        CAST(CASE WHEN DAY([date]) = 1 THEN 'Y' ELSE 'N' END AS varchar(max)) AS isfirstdayofmonthflag,
        CAST(CASE WHEN [date] = EOMONTH([date]) THEN 'Y' ELSE 'N' END AS varchar(max)) AS islastdayofmonthflag,
        CAST(CASE WHEN [date] = DATEFROMPARTS(YEAR([date]), ((DATEPART(quarter, [date]) - 1) * 3) + 1, 1)
                THEN 'Y' ELSE 'N' END AS varchar(max)) AS isfirstdayofquarterflag,
        CAST(CASE WHEN [date] = DATEADD(day, -1, DATEADD(quarter, DATEDIFF(quarter, 0, [date]) + 1, 0))
                THEN 'Y' ELSE 'N' END AS varchar(max)) AS islastdayofquarterflag,
        CAST(CASE WHEN [date] = DATEFROMPARTS(YEAR([date]), 1, 1)
                THEN 'Y' ELSE 'N' END AS varchar(max)) AS isfirstdayofyearflag,
        CAST(CASE WHEN [date] = DATEFROMPARTS(YEAR([date]), 12, 31)
                THEN 'Y' ELSE 'N' END AS varchar(max)) AS islastdayofyearflag,
        CAST(DATEDIFF(day, today, [date]) AS int) AS offsetindaysfromtodaynumber,
        CAST(DATEDIFF(day, today_week_start, week_start) / 7 AS int) AS offsetinweeksfromtodaynumber,
        CAST(CASE
                WHEN DATEDIFF(day, today_week_start, week_start) / 7 = 0 THEN 'THIS WEEK'
                WHEN DATEDIFF(day, today_week_start, week_start) / 7 < 0
                    THEN CONCAT('-', ABS(DATEDIFF(day, today_week_start, week_start) / 7), ' W')
                ELSE CONCAT('+', DATEDIFF(day, today_week_start, week_start) / 7, ' W')
            END AS varchar(max)) AS offsetinweeksfromtodaytext,
        CAST(DATEDIFF(month, DATEFROMPARTS(YEAR(today), MONTH(today), 1),
                            DATEFROMPARTS(YEAR([date]), MONTH([date]), 1)) AS int) AS offsetinmonthsfromtodaynumber,
        CAST(YEAR([date]) - YEAR(today) AS int) AS offsetinyearsfromtodaynumber
    FROM Calendar
)
SELECT 
    b_sds_date.*
    , case WHEN (canada_holidays.holiday_date is not null ) THEN 1 ELSE 0 END AS is_canada_holiday
    , case WHEN (alberta_holidays.holiday_date is not null ) THEN 1 ELSE 0 END AS is_alberta_holiday
    , case WHEN (ice_holidays.holiday_date is not null ) THEN 1 ELSE 0 END AS is_ice_holiday
    , case WHEN (nerc_holidays.holiday_date is not null ) THEN 1 ELSE 0 END AS is_nerc_holiday
    , case WHEN (nymex_holidays.holiday_date is not null ) THEN 1 ELSE 0 END AS is_nymex_holiday
    , case WHEN (us_holidays.holiday_date is not null ) THEN 1 ELSE 0 END AS is_us_holiday 
FROM 
    base_date AS b_sds_date 
    LEFT OUTER JOIN alberta_holidays AS alberta_holidays ON b_sds_date.date = alberta_holidays.holiday_date 
    LEFT OUTER JOIN canada_holidays AS canada_holidays ON b_sds_date.date = canada_holidays.holiday_date 
    LEFT OUTER JOIN ice_holidays AS ice_holidays ON b_sds_date.date = ice_holidays.holiday_date 
    LEFT OUTER JOIN nerc_holidays AS nerc_holidays ON b_sds_date.date = nerc_holidays.holiday_date 
    LEFT OUTER JOIN nymex_holidays AS nymex_holidays ON b_sds_date.date = nymex_holidays.holiday_date 
    LEFT OUTER JOIN us_holidays AS us_holidays ON b_sds_date.date = us_holidays.holiday_date  
GO

--===========================================================================
-- This is an example of how DIM_DATE is being used together other allegro
-- tables as called by user "agujral@TRANSALTA.ORG"
--===========================================================================
--Select         
--    trade.trade, trade.tradedate
--    ,         position.positiontype as b_s
--    ,         ngposition.pipeline as market1
--    ,         ngposition.point as comp1,         fee.feemode as market2
--    ,         fee.priceindex as comp2,         position.counterparty,         trade.broker,        mnth.month,        ngquantity2.begtime
--    ,         addday(ngquantity2.endtime, -1) endtime,        ngquantity.timeunit,         trade.currency,         ngquantity.energy as volume
--    ,         fee.pricediff as price  
--from          
--    b_alg_trade trade          
--        left join b_alg_position position on position.trade = trade.trade 
--        left join b_alg_ngposition ngposition on ngposition.position = position.position 
--        left join b_alg_ngquantity ngquantity on ngquantity.posdetail = ngposition.posdetail and ngquantity.quantitystatus = 'TRADE' and ngquantity.position = position.position 
--        left join b_alg_ngquantity ngquantity2 on ngquantity2.posdetail = ngposition.posdetail and ngquantity2.posstatus is true and ngquantity2.position = position.position 
--        left join b_alg_finposition finposition on position.position = finposition.position 
--        left join b_alg_fee fee on fee.dbvalue = position.position and fee.dbcolumn = 'position' and fee.feemethod = 'Commodity Price' 
--        inner join (
--                    select distinct firstdayofmonth(date) as Month from dim_date 
--                    where date >= to_date('yyyy-MM-dd','2025-01-01') order by Month
--                    ) mnth 
--            on mnth.month < ngquantity2.endtime and mnth.month >= firstdayofmonth(ngquantity2.begtime)  
-- where 
--    position.tradebook = 'Gas West Term - 1' 
--    and trade.tradedate >= to_date('yyyy-MM-dd','2026-05-19 00:00:00') 
--    and position.positionmode = 'Physical'  
--    and trade.status <> 'inactive'  
 
-- union  
 
-- Select         
--    trade.trade, trade.tradedate, position.swaptype as b_s,         
--    case when position.swaptype  = 'SELL' THEN payfee.feemode else Recfee.Feemode end as Market1,        
--    case when position.swaptype  = 'SELL' THEN payfee.priceindex else Recfee.priceindex end as comp1,        
--    case when position.swaptype  = 'SELL' THEN recfee.feemode else payfee.Feemode end as Market2,        
--    case when position.swaptype  = 'SELL' THEN recfee.priceindex else payfee.priceindex end as comp2,        
--    case when trade.ta_exchangecleared then finposition.exchbroker else position.counterparty  end as counterparty,         
--    trade.broker,mnth.month,          
--    CAST(mnth.Month AS TIMESTAMP WITHOUT TIME ZONE) begtime, 
--    CAST(MIN(mnth.Month_Enddate, addday(trade.endtime, -1)) AS TIMESTAMP WITHOUT TIME ZONE) endtime,finposition.timeunit, 
--    trade.currency, finposition.quantity as volume, payfee.pricediff+recfee.pricediff as price           
-- from          
--    b_alg_trade trade          
--        left join b_alg_position position on position.trade = trade.trade 
--        left join b_alg_finposition finposition on position.position = finposition.position 
--        left join b_alg_fee payfee on payfee.dbvalue = position.position and payfee.dbcolumn = 'position' and payfee.paystatus = 'PAY' and payfee.feemethod = 'Commodity Price' 
--        left join b_alg_fee recfee on recfee.dbvalue = position.position and recfee.dbcolumn = 'position' and recfee.paystatus = 'REC' and recfee.feemethod = 'Commodity Price' 
--        inner join (
--                    select distinct firstdayofmonth(date) as Month,LASTDAYOFMONTH(date) as Month_Enddate 
--                    from dim_date 
--                    where date >= to_date('yyyy-MM-dd','2025-01-01') order by Month
--                    ) mnth on mnth.month < trade.endtime and mnth.month >= firstdayofmonth(trade.begtime)   
-- where 
--    position.tradebook like 'Gas West Term - 1' and trade.tradedate >= to_date('yyyy-MM-dd','2026-05-19 00:00:00')  
--    and trade.status <> 'inactive' 
--    and position.positionmode = 'Financial' 
--    and position.positiontype = 'Swap'  
--order by tradedate context ('i18n' = 'ca_mst_mdt' )