--strucutred query language; query

SELECT 
       id AS order_id
      ,state_name AS order_destination
      ,created::date AS order_created_date
      ,CASE
           WHEN state_name IN ('Delhi','Maharashtra','Tamil Nadu','West Bengal', 'Punjab','Karnataka','Rajasthan') 
			      THEN (created + INTERVAL '3 days')::date 
					    ELSE (created::date + INTERVAL '5 days')::date
		                END AS estimated_shipping_date
FROM 
    order_order
WHERE 
     created >= current_date - INTERVAL '1 day'
     AND status = 'confirmed'
     AND email NOT LIKE '%@tjori.com'
;