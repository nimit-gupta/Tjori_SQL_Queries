--structured query language; query

WITH cte AS (
              SELECT 
                    TO_CHAR(soi.created, 'MM') AS months
                    ,ceil(SUM(soi.price * soi.quanity)) AS gross_revenue
              FROM 
                   order_order AS so
              LEFT JOIN 
                   order_orderproduct AS soi ON (so.id = soi.order_id)
              WHERE 
                   soi.created BETWEEN '2019-01-01' AND '2020-01-01'
                   AND so.status = 'confirmed'
                   AND so.email NOT LIKE '%@tjori.com'
              GROUP BY 
                   1
             ),
             
             cte_2 AS (
				           SELECT 
                             months
                            ,gross_revenue
                            ,lag(gross_revenue) over (ORDER BY MIN(months)) AS previous_month_revenue
                       FROM 
                            cte
                       GROUP BY 
                            1
                           ,2
                      )
                      
            SELECT 
                   months
                  ,gross_revenue
                  ,previous_month_revenue
                  ,CEIL((((gross_revenue - previous_month_revenue)/gross_revenue)*100)) || '%' AS percentage_increase_or_decrease
            FROM 
                 cte_2
               ;