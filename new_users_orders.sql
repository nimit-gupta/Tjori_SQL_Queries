--strucutred query language; query

SELECT 
        user_id
       ,lsq.full_name
       ,lsq._email
       ,lsq._phone
       ,lsq._orders_count
FROM 
     customer_userprofile AS cu
LEFT JOIN 
     (
       SELECT 
              sq.user_id AS _user_id
             ,concat(sq.first_name,'',sq.last_name) AS full_name
				 ,sq.email AS _email
				 ,sq.phone AS _phone 
             ,COUNT(sq.*) AS _orders_count
       FROM 
            order_order AS sq
       GROUP by
             1
            ,2
            ,3
            ,4
       HAVING 
            COUNT(sq.*) >= 1
       ) AS lsq ON (lsq._user_id = cu.user_id)
WHERE 
     cu.created >= CURRENT_DATE - INTERVAL '30 day'
     AND lsq._orders_count IS NOT NULL 

;