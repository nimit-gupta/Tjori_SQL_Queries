--strucutred query langugae; query

SELECT 
      soi.order_id
     ,SUM((soi.quanity * soi.price) - COALESCE(discount, 0)) AS order_price
     ,coalesce(lsq._amount_recieved, 0) AS order_price_recieved
FROM 
     order_order AS so
LEFT JOIN 
     order_orderproduct AS soi ON (so.id = soi.order_id)
LEFT JOIN 
     (
      SELECT 
            sq.order_id AS _sq_order_id
           ,SUM(sq.amount_recieved) AS _amount_recieved
      FROM 
           oms_codremitance AS sq
	   GROUP BY 
		     1
	  ) AS lsq ON ( soi.order_id = lsq._sq_order_id)
WHERE 
     soi.created >= '2019-10-01' AND soi.created < '2020-01-01'
	  AND so.status = 'confirmed'
	  AND so.email NOT LIKE '%@tjori.com'  
GROUP BY 
     1
    ,3
   ;