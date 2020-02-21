--structured query language; query

SELECT 
       COUNT(fsq.id) AS order_received
      ,COUNT(fsq.lsqorderid) filter (WHERE fsq.lsqorderid IS NOT NULL) AS order_shipped
      ,(COUNT(fsq.lsqorderid) filter (WHERE fsq.lsqorderid IS NOT NULL) / COUNT(fsq.id))* 100 AS delivery_ratio
FROM 
    (
SELECT 
       id
      ,lsq.orderid AS lsqorderid
      ,lsq.waybillnumber AS lsqwaybillnumber
      ,lsq.pickerlabel AS lsqpickerlabel
FROM 
     order_order 
LEFT JOIN 
     (
       SELECT 
              order_id AS orderid
             ,piccker_label AS pickerlabel
             ,way_bill_number AS waybillnumber
       FROM 
             order_shipment
       WHERE 
            created >= CURRENT_DATE - INTERVAL '90 days'
      ) AS lsq ON (lsq.orderid = id)
WHERE 
     created >= CURRENT_DATE - INTERVAL '90 days'
     AND email NOT LIKE '%@tjori.com'
     AND status = 'confirmed'
) fsq
 ;