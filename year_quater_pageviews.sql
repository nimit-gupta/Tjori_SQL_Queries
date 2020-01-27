--strucutred query langugae; query

SELECT 
      sub.spsku AS product_sku
     ,SUM(sub.November) AS November_pageviews
     ,SUM(sub.December) AS December_pageviews
     ,SUM(sub.January) AS January_pageviews
FROM 
   (
    SELECT 
      sp.sku AS spsku
     ,SUM(ga.page_views) filter (WHERE(EXTRACT(MONTH FROM ga.DATE) = 11) AND (EXTRACT(YEAR FROM ga.DATE) = 2019)) AS November
     ,SUM(ga.page_views) filter (WHERE(EXTRACT(MONTH FROM ga.DATE) = 12) AND (EXTRACT(YEAR FROM ga.DATE) = 2019)) AS December
     ,SUM(ga.page_views) filter (WHERE(EXTRACT(MONTH FROM ga.DATE) = 01) AND (EXTRACT(YEAR FROM ga.DATE) = 2020)) AS January
FROM 
      ga_union_pageviews AS ga
LEFT JOIN 
      store_product AS sp ON (ga.product_id = sp.id)
GROUP BY 
      ga.date
     ,sp.sku
   ) AS sub
GROUP BY 
    1
;