SET statement_timeout TO 900000;
SELECT
                 sp.created::TIMESTAMP::DATE AS created_on
                ,sp.id AS product_id 
                ,sp.sku AS product_sku
                ,coalesce(sc.name,'No Category') AS product_category
                ,sp.active AS active_status
                ,sp.name AS product_name
                ,string_agg (distinct concat(ssc.name), ',') AS subcategory
                ,string_agg (distinct concat(spsc.subcategory_id), ',') AS subcategory_id
                ,regexp_replace(regexp_replace(sp.description, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g') AS description
                ,regexp_replace(regexp_replace(sp.short_description, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g') AS short_description
                ,sp.cdn_small_image AS product_image
					 ,sp.visibility AS product_visibility
                ,coalesce(sp.ribbon_id, 0) AS ribbon_id
                ,sp.popularity_sequence AS popularity_sequence
                ,round(sp.price,2) AS price
                ,round(sp.special_price,2) AS special_price
                ,round(sp.price_usd, 2) AS price_usd
                ,round(coalesce(sp.cost_price,0),2) AS cost_price
                ,coalesce(cast(hsn.tax as INTEGER),0) AS tax
                ,coalesce(cast(hsn.tax_under999 AS INTEGER), 0) AS tax_under999
                ,coalesce(cast(hsn.code AS INTEGER), 0) AS hsn_code
                ,coalesce(sp.actual_stock,0) AS actual_stock
	             ,coalesce(sp.virtual_stock,0) AS virtual_stock
                ,coalesce(sp.stock,0) AS total_stock
                ,sp.in_stock AS in_stock_status
            FROM
                store_product AS sp
            LEFT JOIN 
                store_productattribute AS spa ON (sp.id = spa.product_id)
            LEFT JOIN
                store_category AS sc ON (sp.category_id = sc.id)
            LEFT JOIN
                store_product_subcategories AS spsc ON (sp.id = spsc.product_id)
            LEFT JOIN
                store_subcategory AS ssc ON (sc.id = ssc.id)
            LEFT JOIN
                tms_hsncode AS hsn ON (sp.hsncode_id = hsn.id)
            WHERE
                sp.active = TRUE 
            GROUP BY
                 sp.created
                ,sp.id 
                ,sp.sku 
                ,sc.name
                ,sp.active 
                ,sp.name 
                ,sp.description
                ,sp.short_description
                ,sp.cdn_square_image 
	             ,sp.visibility 
                ,sp.ribbon_id
                ,sp.popularity_sequence 
                ,sp.price
                ,sp.special_price
                ,sp.price_usd
                ,sp.cost_price
                ,hsn.tax 
                ,hsn.tax_under999 
                ,hsn.code 
                ,sp.actual_stock
	             ,sp.virtual_stock
                ,sp.stock
                ,sp.in_stock 
             ORDER BY
                sp.created asc    
          ;