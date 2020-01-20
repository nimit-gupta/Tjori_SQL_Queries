--strucutred query language; query
SET statement_timeout TO 900000;
SELECT so.id AS order_item_id
      ,soi.quanity AS item_quantity
      ,so.invoice_id AS order_invoice_id
      ,soi.created AS order_created_at
      ,oopo.created AS first_qc_at
      ,(EXTRACT(EPOCH FROM oopo.created) - EXTRACT(EPOCH FROM soi.created))/3600 AS inbound_time
      ,soi.exchanged AS is_item_exchanged
      ,sc.NAME AS product_category_name
FROM
    order_order AS so
LEFT JOIN 
    order_orderproduct AS soi ON (so.id = soi.order_id)
LEFT JOIN 
    store_product AS sp ON (soi.product_id = sp.id)
LEFT JOIN 
    store_category AS sc ON (sp.category_id = sc.id)
LEFT JOIN
    (
	   SELECT 
		      created AS created 
		     ,op_id AS op_id
		FROM 
		     order_orderproductowner 
		WHERE 
		     created >= '2019-12-01' AND created < '2020-01-01'
		     AND note SIMILAR TO '%QC%'
	  ) AS oopo ON (soi.id = oopo.op_id)
WHERE 
    soi.created >= '2019-12-01' AND soi.created < '2020-01-01'
    AND so.status SIMILAR TO 'confirmed'
ORDER BY 
    order_created_at asc
;
 