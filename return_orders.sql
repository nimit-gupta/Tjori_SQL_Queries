--strucutred query langugae; query

SELECT 
      os.created::TIMESTAMP::date AS return_request_date
     ,so.created::TIMESTAMP::date AS order_create_date
     ,so.invoice_id
     ,os.return_shipment
FROM 
     order_order AS so
LEFT JOIN 
     order_shipment AS os ON (so.id = os.order_id)
WHERE 
     os.created >= TIMESTAMP 'yesterday' AND os.created < TIMESTAMP 'today'
     AND os.return_shipment = True
;