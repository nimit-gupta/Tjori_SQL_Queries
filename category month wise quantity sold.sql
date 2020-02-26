--structured query language; query

SELECT 
      fsq.category
     ,sum(fsq.jan_sales) AS jan
     ,sum(fsq.feb_sales) AS feb
     ,sum(fsq.mar_sales) AS mar
     ,sum(fsq.apr_sales) AS apr
     ,sum(fsq.may_sales) AS may
     ,sum(fsq.jun_sales) AS jun
     ,sum(fsq.jul_sales) AS jul
     ,sum(fsq.aug_sales) AS aug
     ,sum(fsq.sep_sales) AS sep
     ,sum(fsq.oct_sales) AS oct
     ,sum(fsq.nov_sales) AS nov
     ,sum(fsq.dec_sales) AS dec
FROM 
     (

SELECT 
       sc.name AS category
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 01 AND EXTRACT(YEAR FROM soi.created) = 2019)AS jan_sales
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 02 AND EXTRACT(YEAR FROM soi.created) = 2019)AS feb_sales
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 03 AND EXTRACT(YEAR FROM soi.created) = 2019)AS mar_sales
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 04 AND EXTRACT(YEAR FROM soi.created) = 2019)AS apr_sales
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 05 AND EXTRACT(YEAR FROM soi.created) = 2019)AS may_sales
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 06 AND EXTRACT(YEAR FROM soi.created) = 2019)AS jun_sales
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 07 AND EXTRACT(YEAR FROM soi.created) = 2019)AS jul_sales
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 08 AND EXTRACT(YEAR FROM soi.created) = 2019)AS aug_sales
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 09 AND EXTRACT(YEAR FROM soi.created) = 2019)AS sep_sales
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 10 AND EXTRACT(YEAR FROM soi.created) = 2019)AS oct_sales
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 11 AND EXTRACT(YEAR FROM soi.created) = 2019)AS nov_sales
      ,SUM(soi.quanity) filter (WHERE EXTRACT(MONTH FROM soi.created) = 12 AND EXTRACT(YEAR FROM soi.created) = 2019)AS dec_sales
FROM 
     order_order AS so
LEFT JOIN 
     order_orderproduct AS soi ON (so.id = soi.order_id)
LEFT JOIN 
     store_product AS sp ON (soi.product_id = sp.id)
LEFT JOIN 
     store_category AS sc ON (sp.category_id = sc.id)
WHERE 
     
     so.status = 'confirmed'
GROUP BY 
     sc.name
    ,soi.created
) AS fsq
GROUP BY 
  1
;
     