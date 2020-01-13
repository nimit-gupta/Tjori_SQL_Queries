--strucutred query language; query

SELECT 
      soi.created::TIMESTAMP(0) AS created
     ,so.invoice_id AS invoice_id
     ,sp.sku
     ,sc.name AS category
	  ,so.status AS status
     ,so.email AS email 
     ,so.currency AS currency
     ,soi.quanity AS quantity
     ,round(soi.price,2) AS price
     ,round(soi.discount,2) AS discount
     ,hsn.tax AS tax
     ,hsn.tax_under999 AS tax_under999
     ,sp.ribbon_id AS ribbon_id
     ,soi.removed AS removed
     ,soi.exchanged AS exchanged
     ,soi.returned AS returned
     ,CASE 
	      WHEN so.currency = 'USD' THEN ROUND(((soi.quanity * soi.price)*70),2)
	      WHEN so.currency = 'INR' THEN ROUND((soi.quanity * soi.price),2)
	   END AS gross_revenue
	  ,CASE
          WHEN so.currency = 'USD' THEN 
			   CASE 
				    WHEN (((soi.quanity * soi.price)*70) - (COALESCE(soi.discount, 0)*70)) < 999 THEN ROUND(((((soi.quanity * soi.price)*70) - (COALESCE(soi.discount, 0)*70)) - (((((soi.quanity * soi.price)*70) - (coalesce(soi.discount, 0) *70))*hsn.tax_under999::integer)/100)),2)
                WHEN (((soi.quanity * soi.price)*70) - (COALESCE(soi.discount, 0)*70)) > 999 THEN ROUND(((((soi.quanity * soi.price)*70) - (COALESCE(soi.discount, 0)*70)) - (((((soi.quanity * soi.price)*70) - (coalesce(soi.discount, 0) *70))*hsn.tax::integer)/100)),2)
            END 
          WHEN so.currency = 'INR' THEN 
			    CASE 
				    WHEN ((soi.quanity * soi.price) - coalesce(soi.discount,0)) < 999 THEN ROUND((((soi.quanity * soi.price) - coalesce(soi.discount,0)) - ((((soi.quanity * soi.price) - coalesce(soi.discount,0))*hsn.tax_under999::integer)/100)),2)
                WHEN ((soi.quanity * soi.price) - coalesce(soi.discount,0)) > 999 THEN ROUND((((soi.quanity * soi.price) - coalesce(soi.discount,0)) - ((((soi.quanity * soi.price) - coalesce(soi.discount,0))*hsn.tax::integer)/100)),2)
	          END
		END AS net_revenue
FROM 
     order_order AS so
LEFT JOIN 
     order_orderproduct AS soi ON (so.id = soi.order_id)
LEFT JOIN 
     store_product AS sp ON (soi.product_id = sp.id)
LEFT JOIN 
     store_category AS sc ON (sp.category_id = sc.id)
LEFT JOIN 
     tms_hsncode AS hsn ON (sp.hsncode_id = hsn.id)
WHERE
     soi.created >= TIMESTAMP 'yesterday' AND soi.created < TIMESTAMP 'today'
     AND so.status = 'confirmed'
     AND so.email NOT LIKE '%@tjori.com'
     AND soi.removed = False
     AND soi.returned = False
     AND soi.exchanged = False
ORDER BY
    1 asc
;