/*
Summary of all the Denodo / Allegro tables / views being used by DMSLookup endpoints

b_alg_broker    	    b_alg_dbconstraint 	    b_alg_powerpoint 
b_alg_company	        b_alg_dbconstraint 	    b_alg_powerregion 
b_alg_contract 	        b_alg_dbconstraint 	    b_alg_priceindex 
b_alg_contractparty 	b_alg_feetype	        b_alg_pricetype 
b_alg_contractposition 	b_alg_gridschedule  	b_alg_product 
b_alg_contracttype 	    b_alg_holiday 	        b_alg_ta_acctstrategy
b_alg_controlarea 	    b_alg_icecounterparty 	b_alg_ta_strategy 
b_alg_counterparty 	    b_alg_icehub 	        b_alg_timezone 
b_alg_creditparty 	    b_alg_icemarket 	    b_alg_tradebook 
b_alg_currency 	        b_alg_icemarkettype 	b_alg_transervclass
                        b_alg_iceproduct    	b_alg_transervtype
                        b_alg_icetrader	        b_dms_trade_type 
                        b_alg_location          b_dms_user_profile
                         	                    dms_allegro_trader_profile 
*/
--=======================================================================================
USE [RPT_VIEW]
GO
CREATE OR ALTER VIEW [energy_trading].[di018_accountingstrategy] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide accounting strategy lookups for DMS'  
AS 
    SELECT 
        b_alg_ta_acctstrategy.ta_acctstrategy AS accountingstrategy 
    FROM 
        -- b_alg_ta_acctstrategy
        Horizon_ODS.dbo.ta_acctstrategy AS b_alg_ta_acctstrategy;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_accountingtreatment] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide accounting treatment lookups for DMS'   
AS 
    --SELECT 
    --    string AS accountingtreatment 
    --FROM 
    --    FLATTEN di018_accountingtreatmentlist AS v ( v.dbexpr);
    -- Denodo VQL doesn't have STRING_SPLIT to easily flatten concatenated 
    -- string delimited by comma into multiple row
    -- but we can do it in SQL server. That is why we don't need
    -- the intermidate view "di018_accountingtreatmentlist" like Denodo needs to
    SELECT 
        Trim(s.value) AS accountingtreatment 
    FROM 
        Horizon_ODS.dbo.dbconstraint b_alg_dbconstraint
            CROSS APPLY STRING_SPLIT(b_alg_dbconstraint.dbexpr, ',') s
    WHERE 
        b_alg_dbconstraint.dbconstraint = 'ta_accountingtreatment';
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_accountingtreatmentlist] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to get the list of accounting treatments that are available'   
AS 
    SELECT 
        --split(', ', b_alg_dbconstraint.dbexpr) AS dbexpr 
        b_alg_dbconstraint.dbexpr
    FROM 
        -- b_alg_dbconstraint
        Horizon_ODS.dbo.dbconstraint AS b_alg_dbconstraint 
    WHERE 
        dbconstraint = 'ta_accountingtreatment';
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_bookstrategy] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide book strategy lookups for DMS'   
AS 
    SELECT 
        b_alg_ta_strategy.strategy AS bookstrategy 
    FROM 
        -- b_alg_ta_strategy
        Horizon_ODS.dbo.ta_strategy AS b_alg_ta_strategy 
    WHERE 
        status = 'ACTIVE' 
    GROUP BY 
        b_alg_ta_strategy.strategy;
GO;
--=====================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_broker] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide broker lookups for DMS'  
AS 
    SELECT 
        b_alg_broker.broker AS broker 
    FROM 
        -- b_alg_broker
        Horizon_ODS.dbo.broker AS b_alg_broker
    WHERE 
        status = 'ACTIVE' 
    GROUP BY 
        b_alg_broker.broker;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_company] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide company lookups for DMS'   
AS 
    SELECT 
        b_alg_company.company AS company 
    FROM 
        -- b_alg_company
        Horizon_ODS.dbo.company AS b_alg_company;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_counterparty] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide counterparty lookups for DMS'   
AS 
    SELECT 
        counterparty AS counterparty 
    FROM 
        [energy_trading].[di018_counterpartycontract] 
    GROUP BY 
        counterparty;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_counterpartycontract] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide counterparty contract lookups for DMS'   
AS 
    SELECT 
        b_alg_contract.description AS description
        , b_alg_contractparty.counterparty AS counterparty
        , b_alg_contract.contract AS contract
        , max(b_alg_contracttype.contracttype) AS contracttype
        , b_alg_contractposition.tradetype AS tradetype 
    FROM 
        Horizon_ODS.dbo.contracttype AS b_alg_contracttype 
            INNER JOIN 
                (Horizon_ODS.dbo.contractposition AS b_alg_contractposition 
                    INNER JOIN 
                        (Horizon_ODS.dbo.counterparty AS b_alg_counterparty 
                            INNER JOIN 
                                (Horizon_ODS.dbo.contractparty AS b_alg_contractparty 
                                    INNER JOIN 
                                        Horizon_ODS.dbo.contract AS b_alg_contract 
                                            ON b_alg_contractparty.contract = b_alg_contract.contract ) 
                                        ON b_alg_counterparty.counterparty = b_alg_contractparty.counterparty ) 
                                    ON b_alg_contractposition.contract = b_alg_contract.contract ) 
                                ON b_alg_contracttype.contracttype = b_alg_contract.contracttype  
    WHERE 
        (
            b_alg_contractposition.producttype in ('Power', 'Transmission') 
            AND b_alg_counterparty.counterpartyclass in ('Trading', 'Internal', 'FCM', 'Retail', 'ERCOT Fees') 
            AND b_alg_contractposition.tradetype in ('Power Physical', 'Fee', 'Power Physical BO Bookout', 'Power Transmission', 'Power UC Physical') 
            AND b_alg_counterparty.status = 'ACTIVE' 
            AND b_alg_contract.status = 'ACTIVE' 
            AND (
                    b_alg_contractparty.endtime is null  
                    OR 
                    b_alg_contractparty.endtime > CAST(GETDATE() AS DATE)  --now()
                )
        ) 
    GROUP BY b_alg_contractparty.counterparty, b_alg_contract.description, b_alg_contract.contract, b_alg_contractposition.tradetype;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_controlarea] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide control area lookups for DMS'   
AS 
    SELECT 
        b_alg_controlarea.controlarea AS controlarea
        , max(b_alg_controlarea.timezone) AS timezone
        , b_alg_controlarea.powerregion AS powerregion 
    FROM 
        (    
            SELECT
                b_alg_powerregion.powerregion AS powerregion, b_alg_powerregion.description AS description 
            FROM 
                -- b_alg_powerregion
                Horizon_ODS.DBO.powerregion AS b_alg_powerregion 
            WHERE 
                description like '%west%'
        ) AS di018_powerregion 
            INNER JOIN
                Horizon_ODS.DBO.controlarea AS b_alg_controlarea 
                    ON di018_powerregion.powerregion = b_alg_controlarea.powerregion  
    WHERE 
        b_alg_controlarea.status = 'Active' 
    GROUP BY 
        b_alg_controlarea.controlarea, b_alg_controlarea.powerregion;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_credittenor] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide credit tenor lookups for DMS'   
AS 
    SELECT 
        b_alg_creditparty.creditparty AS counterparty
        , b_alg_creditparty.ta_tenor_buy AS buytenor
        , b_alg_creditparty.ta_tenor_sell AS selltenor 
    FROM 
        Horizon_ODS.DBO.creditparty AS b_alg_creditparty 
            LEFT OUTER JOIN             
            (
                SELECT 
                    b_alg_company.company AS company 
                FROM 
                    Horizon_ODS.dbo.company AS b_alg_company
            ) AS di018_company 
                ON b_alg_creditparty.creditparty = di018_company.company  
    WHERE 
        di018_company.company is null ;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_currency] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide currency lookups for DMS'   
AS 
    SELECT 
        b_alg_currency.currency AS currency 
    FROM 
        Horizon_ODS.DBO.currency AS b_alg_currency 
    WHERE 
        currency like '%D';
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_feemethod] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide fee method lookups for DMS'   
AS 
    --SELECT 
    --    string AS feemethod 
    --FROM 
    --    FLATTEN di018_feemethodlist AS v ( v.dbexpr);

    SELECT 
        Trim(s.value) AS feemethod 
    FROM 
        Horizon_ODS.dbo.dbconstraint b_alg_dbconstraint
            CROSS APPLY STRING_SPLIT(b_alg_dbconstraint.dbexpr, ',') s
    WHERE 
        b_alg_dbconstraint.dbconstraint = 'feemethod'    
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_feemethodlist] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to get the list of power services that are available'   
AS 
    SELECT 
        -- split(',', b_alg_dbconstraint.dbexpr) AS dbexpr 
        b_alg_dbconstraint.dbexpr AS dbexpr 
    FROM 
        Horizon_ODS.dbo.dbconstraint AS b_alg_dbconstraint 
    WHERE 
        dbconstraint = 'feemethod';
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_feetype] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide fee type lookups for DMS'   
AS 
    SELECT 
        b_alg_feetype.feetype AS feetype
        , b_alg_feetype.description AS description 
    FROM 
        Horizon_ODS.DBO.feetype AS b_alg_feetype;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_fercclass] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide FERC class lookups for DMS'   
AS 
    --SELECT 
    --    string AS class 
    --FROM 
    --    FLATTEN di018_fercclasslist AS v ( v.classes);
    SELECT 
        Trim(s.value) AS class 
    FROM 
        Horizon_ODS.dbo.dbconstraint b_alg_dbconstraint
            CROSS APPLY STRING_SPLIT(b_alg_dbconstraint.dbexpr, ',') s
    WHERE 
        b_alg_dbconstraint.dbconstraint = 'ferctransclass'    
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_fercclasslist] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to get the list of classes that are available for FERC'   
AS 
    SELECT 
        -- split(',', b_alg_dbconstraint.dbexpr) AS classes 
        b_alg_dbconstraint.dbexpr AS classes 
    FROM 
        Horizon_ODS.DBO.dbconstraint AS b_alg_dbconstraint 
    WHERE 
        dbconstraint = 'ferctransclass';
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_holidaycalendar] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide holiday calendar lookups for DMS'   
AS 
    SELECT 
        b_alg_holiday.holidaycalendar AS holidaycalendar
        , b_alg_holiday.holiday AS holiday
        , b_alg_holiday.description AS description 
    FROM 
        Horizon_ODS.DBO.holiday AS b_alg_holiday 
    WHERE 
        holidaycalendar = 'NERC';
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_icetradecompanytrader] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to get Allegro company and trader'   
AS 
    SELECT 
        DISTINCT 
            b_alg_icetrader.icetrader AS icetrader
            , b_alg_icetrader.icecompany AS icecompany
            , b_alg_icetrader.company AS company
            , b_alg_icetrader.trader AS trader
            , b_alg_icetrader.timezone AS timezone
            , b_alg_icetrader.creationname AS creationname
            , b_alg_icetrader.creationdate AS creationdate
            , b_alg_icetrader.revisionname AS revisionname
            , b_alg_icetrader.revisiondate AS revisiondate 
    FROM 
        Horizon_ODS.DBO.icetrader AS b_alg_icetrader;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_icetradecounterpartycontract] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to get counterparty and contract'   
AS 
    SELECT 
        b_alg_icecounterparty.counterparty AS counterparty
        , b_alg_icecounterpartyproduct.contract AS contract
        , b_alg_icecounterparty.icecounterparty AS icecounterparty
        , b_alg_icecounterpartyproduct.company AS company
        , b_alg_icecounterpartyproduct.icemarkettype AS icemarkettype
        , b_alg_icecounterpartyproduct.product AS product 
    FROM 
        HORIZON_ODS.DBO.icecounterparty AS b_alg_icecounterparty 
            INNER JOIN HORIZON_ODS.DBO.icecounterpartyproduct AS b_alg_icecounterpartyproduct 
                ON b_alg_icecounterparty.icecounterparty = b_alg_icecounterpartyproduct.icecounterparty ;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_icetradedata] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
AS 
    SELECT 
        DISTINCT 
            'Electricity' AS commodity
            , '1' AS commodityid
            , ty.description AS tradetype
            , ty.trade_type_id AS tradetypeid
            , ih.controlarea
            , ih.powerpoint AS point
            , ip.priceunit AS units
            , ip.currency
            , im.tradebook AS book
            , im.timezone
            , im.block
            , im.priceindex
            , case WHEN (im.priceindex is not null ) 
                    THEN 'VARIABLE' 
                    ELSE 'FIXED' 
                    END AS pricetype
            , ih.hubid
            , im.marketid
            , im.cficode
            , im.markettype
            , mt.product 
    FROM 
        (((HORIZON_ODS.DBO.icemarket AS im INNER JOIN HORIZON_ODS.DBO.icehub AS ih 
            ON ih.hubid = im.hubid ) 
                INNER JOIN HORIZON_ODS.DBO.iceproduct AS ip 
                    ON ip.productid = im.productid ) 
                        INNER JOIN HORIZON_ODS.DBO.icemarkettype AS mt 
                            ON im.markettype = mt.markettypename ) 
                                INNER JOIN 
                                [DMS_ODS].[DMS_TST].[dbo].[Trade_Type] --b_dms_trade_type 
                                AS ty 
                                    ON (
                                        im.tradetype = ty.description 
                                        AND upper(im.markettype) = 'POWER' 
                                        AND im.tradetype is not null 
                                    ) ;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_powerpoint] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide power point lookups for DMS'   
AS 
    SELECT 
        b_alg_powerpoint.controlarea AS controlarea
        , b_alg_powerpoint.point AS point 
    FROM 
        [energy_trading].[di018_controlarea] AS di018_market 
            INNER JOIN HORIZON_ODS.DBO.powerpoint AS b_alg_powerpoint 
                ON di018_market.controlarea = b_alg_powerpoint.controlarea  
    GROUP BY 
        b_alg_powerpoint.point, b_alg_powerpoint.controlarea, di018_market.powerregion;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_powerregion] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide power region lookups for DMS'   
AS 
    SELECT
        b_alg_powerregion.powerregion AS powerregion, b_alg_powerregion.description AS description 
    FROM 
        -- b_alg_powerregion
        Horizon_ODS.DBO.powerregion AS b_alg_powerregion 
    WHERE 
        description like '%west%';
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_powerservice] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide power service lookups for DMS'  
AS 
    --SELECT 
    --    string AS powerservice 
    --FROM 
    --    FLATTEN di018_powerservicelist AS v ( v.dbexpr);
    SELECT 
        Trim(s.value) AS powerservice 
    FROM 
        Horizon_ODS.dbo.dbconstraint b_alg_dbconstraint
            CROSS APPLY STRING_SPLIT(b_alg_dbconstraint.dbexpr, ',') s
    WHERE 
        b_alg_dbconstraint.dbconstraint = 'powerservice'    
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_powerservicelist] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to get the list of power services that are available'  
AS 
    SELECT 
        -- split(',', b_alg_dbconstraint.dbexpr) AS dbexpr 
        b_alg_dbconstraint.dbexpr AS dbexpr 
    FROM 
        Horizon_ODS.DBO.dbconstraint AS b_alg_dbconstraint
    WHERE 
        dbconstraint = 'powerservice';
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_priceindex] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide price index lookups for DMS'  
AS 
SELECT 
    DISTINCT b_alg_priceindex.priceindex AS priceindex 
FROM 
    Horizon_ODS.DBO.priceindex AS b_alg_priceindex 
        LEFT OUTER JOIN Horizon_ODS.DBO.location AS location 
            ON b_alg_priceindex.marketarea = location.marketarea  
WHERE 
    (
        b_alg_priceindex.product = 'Power' 
        AND b_alg_priceindex.status = 'active' 
        AND location.region in ('AESO', 'CAISO', 'ERCOT', 'SPP', 'WECC')
    );
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_pricetype] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide price type lookups for DMS'  
AS 
    SELECT 
        b_alg_pricetype.pricetype AS pricetype, b_alg_pricetype.description AS description 
    FROM 
        Horizon_ODS.DBO.pricetype AS b_alg_pricetype 
    WHERE 
        status = 'ACTIVE';
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_product] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide product lookups for DMS'  
AS 
    SELECT b_alg_product.product AS product, b_alg_product.description AS description 
    FROM 
        Horizon_ODS.DBO.product AS b_alg_product 
    WHERE 
        producttype = 'POWER';
GO;
--=======================================================================================

CREATE OR ALTER VIEW [energy_trading].[di018_settlementpoolcounterparty] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide settlement pool counterparty lookups for DMS'  
AS 
--    SELECT 
--        string AS counterparty 
--    FROM 
--        FLATTEN [energy_trading].[di018_settlementpoolcounterpartylist] AS v ( v.counterparties);
    SELECT 
        trim(s.[value]) AS counterparty
    FROM 
        (
            SELECT 
                SUBSTRING(parameter, TMP.first_dbl_quote + 1, TMP.second_dbl_quote - TMP.first_dbl_quote - 1) AS FOUND_COUNTERPARTY_LIST
            FROM
            (
                SELECT 
                    --REGEXP_REPLACE (parameter, '.+counterparty="(.+)",.*', '$1') AS counterparties 
                    PATINDEX('%counterparty%', parameter) AS first_counterparty,
                    CHARINDEX('"',
                            parameter
                            , PATINDEX('%counterparty%', parameter)
                            ) AS first_dbl_quote,

                    CHARINDEX('"',
                            parameter
                            , CHARINDEX('"',
                                        parameter
                                        , PATINDEX('%counterparty%', parameter)
                                        ) + 1
                            ) AS second_dbl_quote,
                    parameter, process
                FROM 
                    Horizon_ODS.DBO.gridschedule AS b_alg_gridschedule 
                WHERE 
                    process in ( 
                                'Daily Valuation Settlement Pool' -- Original VQL which does not exist anymore
                                , 'Daily Valuation Credit' -- alternate which should be removed in production
                                ) 
            ) AS TMP
        ) AS b_alg_gridschedule 
            CROSS APPLY STRING_SPLIT(b_alg_gridschedule.FOUND_COUNTERPARTY_LIST, ',') s
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_settlementpoolcounterpartylist] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide the counterparty list specified for the settlement pool'  
AS 
    SELECT 
        SUBSTRING(parameter, TMP.first_dbl_quote + 1, TMP.second_dbl_quote - TMP.first_dbl_quote - 1) AS FOUND_COUNTERPARTY_LIST
    FROM
    (
        SELECT 
            --REGEXP_REPLACE (parameter, '.+counterparty="(.+)",.*', '$1') AS counterparties 
            PATINDEX('%counterparty%', parameter) AS first_counterparty,
            CHARINDEX('"',
                    parameter
                    , PATINDEX('%counterparty%', parameter)
                    ) AS first_dbl_quote,

            CHARINDEX('"',
                    parameter
                    , CHARINDEX('"',
                                parameter
                                , PATINDEX('%counterparty%', parameter)
                                ) + 1
                    ) AS second_dbl_quote,
            parameter, process
        FROM 
            Horizon_ODS.DBO.gridschedule AS b_alg_gridschedule 
        WHERE 
            process in ( 
                        'Daily Valuation Settlement Pool' -- Original VQL which does not exist anymore
                        , 'Daily Valuation Credit' -- alternative which should be removed in Production
                        ) 
    ) TMP;

GO;




--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_timezone] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provied timezone lookups for DMS'  
AS 
    SELECT 
        b_alg_timezone.timezone AS timezone
        , b_alg_timezone.description AS description 
    FROM 
        Horizon_ODS.DBO.timezone AS b_alg_timezone 
    WHERE 
        (timezone like '%PT' AND autumnoffsethours between -8 AND -6);
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_tradebook] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide trade book lookups for DMS'  
AS 
    SELECT 
        b_alg_tradebook.tradebook AS tradebook 
    FROM 
        Horizon_ODS.DBO.tradebook AS b_alg_tradebook 
    WHERE 
        (
            ta_tradebookregion not in ('East Energy', 'Gas') 
            AND 
            (ta_tradebooksubregion <> 'East' OR ta_tradebooksubregion is null )
        ) 
    GROUP BY b_alg_tradebook.tradebook;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_traderprofile] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide accounting strategy lookups for DMS'  
AS 
    SELECT 
        DISTINCT dms_allegro_trader_profile.profile_name AS profilename
        , dms_allegro_trader_profile.allegrotradername AS allegrotradername
        , icetrader AS icetrader 
    FROM 
        [energy_trading].[dms_allegro_trader_profile]; -- Check VQL below
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[dms_allegro_trader_profile] 
--FOLDER = '/3_canonical_views/dms' 
AS 
    SELECT 
        b_dms_user_profile.user_profile_id AS user_profile_id
        , b_dms_user_profile.profile_name AS profile_name
        , b_dms_user_profile.active AS active
        , b_dms_user_profile.favorites AS favorites
        , b_dms_user_profile.preferences AS preferences
        , b_dms_user_profile.version AS version
        , b_dms_user_profile.create_date AS create_date
        , b_dms_user_profile.last_modified_date AS last_modified_date
        , b_dms_user_profile.create_by AS create_by
        , b_dms_user_profile.last_modified_by AS last_modified_by
        , b_dms_user_profile.cash_rt_region AS cash_rt_region
        , b_dms_user_profile.scheduler_volume_check AS scheduler_volume_check
        , b_dms_user_profile.allegrotradername AS allegrotradername
        , b_alg_icetrader.icetrader AS icetrader
        , b_alg_icetrader.icecompany AS icecompany
        , b_alg_icetrader.company AS company
        , b_alg_icetrader.trader AS trader
        , b_alg_icetrader.timezone AS timezone
        , b_alg_icetrader.creationname AS creationname
        , b_alg_icetrader.creationdate AS creationdate
        , b_alg_icetrader.revisionname AS revisionname
        , b_alg_icetrader.revisiondate AS revisiondate 
    FROM 
        Horizon_ODS.DBO.icetrader AS b_alg_icetrader 
            INNER JOIN 
            [DMS_ODS].[DMS_TST].[dbo].[User_Profile] -- b_dms_user_profile 
            AS b_dms_user_profile 
                ON b_alg_icetrader.trader = b_dms_user_profile.allegrotradername ;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_transactionclass] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide transaction class lookups for DMS'  
AS 
    SELECT 
        b_alg_transervclass.tsclass AS class
        , b_alg_transervclass.description AS description 
    FROM 
        Horizon_ODS.DBO.transervclass AS b_alg_transervclass;
GO;
--=======================================================================================
CREATE OR ALTER VIEW [energy_trading].[di018_transactiontype] 
--FOLDER = '/4_presentation_views/4_2_data_integration/di018' 
--DESCRIPTION = 'View used to provide transaction type lookups for DMS'  
AS 
    SELECT 
        b_alg_transervtype.tstype AS type 
    FROM 
        Horizon_ODS.DBO.transervtype AS b_alg_transervtype;
GO;