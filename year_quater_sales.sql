--strucutred query langugae; query

SELECT 
      sub.spsku AS product_sku
     ,SUM(sub.November) AS November_sales
     ,SUM(sub.December) AS December_sales
     ,SUM(sub.January) AS January_sales
FROM 
   (
    SELECT 
      sp.sku AS spsku
     ,SUM(soi.quanity) filter (WHERE(EXTRACT(MONTH FROM soi.created) = 11) AND (EXTRACT(YEAR FROM soi.created) = 2019)) AS November
     ,SUM(soi.quanity) filter (WHERE(EXTRACT(MONTH FROM soi.created) = 12) AND (EXTRACT(YEAR FROM soi.created) = 2019)) AS December
     ,SUM(soi.quanity) filter (WHERE(EXTRACT(MONTH FROM soi.created) = 01) AND (EXTRACT(YEAR FROM soi.created) = 2020)) AS January
FROM 
     order_order AS so
LEFT JOIN 
     order_orderproduct AS soi ON (so.id = soi.order_id)
LEFT JOIN 
     store_product AS sp ON (soi.product_id = sp.id)
WHERE 
    so.status = 'confirmed'
    AND so.email NOT LIKE '%@tjori.com'
GROUP BY 
      soi.created
     ,sp.sku
   ) AS sub
GROUP BY 
    1
;