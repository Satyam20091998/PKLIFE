select * from {{ref("child_customer")}} cust
join
 {{source("new_src",'table1')}} tb1