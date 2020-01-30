--structured query language;query
DELIMITER //
CREATE OR REPLACE FUNCTION sku_sold(pg_sku VARCHAR) 
     RETURNS TABLE ( 
	                  yesterday  BIGINT 
						  ,day_before_yesterday BIGINT 
						  ,month_till_date BIGINT 
					  	 ) AS 
$func$
BEGIN 
    RETURN QUERY 
              SELECT 
                   SUM(soi.quanity) filter (WHERE soi.created >= CURRENT_DATE - INTERVAL '1 day') AS yesterday
                  ,SUM(soi.quanity) filter (WHERE soi.created >= CURRENT_DATE - INTERVAL '2 day') AS day_before_yesterday
                  ,SUM(soi.quanity) filter (WHERE soi.created >= DATE_TRUNC('month', CURRENT_DATE) AND soi.created < CURRENT_DATE) AS month_till_date
              FROM 
                  order_order AS so
              LEFT JOIN 
                  order_orderproduct AS soi ON (so.id = soi.order_id)
              LEFT JOIN 
                  store_product AS sp ON (soi.product_id = sp.id)
              WHERE 
                  so.status = 'confirmed'
                  AND sp.sku = 'pg_sku'
              ;
END 
$func$ LANGUAGE plpgsql;
