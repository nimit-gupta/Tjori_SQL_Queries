--strucutred query language; query

SELECT 
      so.created::TIMESTAMP::DATE AS exchange_order_date
     ,so.invoice_id AS exchange_order_invoice_id
     ,a.socreated AS parent_order_date
     ,a.so_invoice_id AS parent_order_invoice_id
FROM 
      order_order AS so
LEFT JOIN 
     (
       SELECT 
             so.created::TIMESTAMP::DATE AS socreated
            ,so.invoice_id AS so_invoice_id
            ,so.phone AS sophone
       FROM 
            order_order AS so
     ) AS a ON (a.so_invoice_id = so.parent_order) 
WHERE 
      so.created >= TIMESTAMP 'yesterday' AND so.created < TIMESTAMP 'today'
      AND so.coupon LIKE '%ex\_%'
      AND so.status NOT IN ('cancelled','Cancelled','cancelled-by-cs','Cancelled by Tjori','different-order-confirmed')
;
