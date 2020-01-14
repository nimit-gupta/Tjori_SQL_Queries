SELECT 
      soi.created::DATE AS order_date 
     ,sp.sku AS product_sku
     ,sp.name AS product_name
     ,SUM(soi.quanity) AS product_quanity
FROM 
     order_order AS so
LEFT JOIN 
     order_orderproduct AS soi ON (so.id = soi.order_id)
LEFT JOIN 
     store_product AS sp ON (soi.product_id = sp.id)
WHERE
     sp.sku SIMILAR TO 'TJ-PCO-01-269'
     AND so.status SIMILAR TO 'confirmed'
     AND soi.created >= NOW() - INTERVAL '7 days'
     AND so.email NOT LIKE '%@tjori.com%'
GROUP BY 
      soi.created::DATE 
     ,sp.sku
     ,sp.name
ORDER BY
     soi.created::date DESC

;

   