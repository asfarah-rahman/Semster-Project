--Asfarah Rahman
--Project Queries 

--Query 1
--This returns the name of the gym and the state for gyms in 
--georgia and new york
SELECT gym_id || ' ' || gym_name AS "GYM", gym_city || ', ' || gym_state AS "LOCATION"
FROM GYMS
WHERE gym_state = 'GA' OR gym_state = 'NY'
ORDER BY gym_id;


--Query 2
--This shows the members name and phone number for locations like atl
--using substition variable for member id
UNDEFINE mem_num
SELECT mem_first ||' '|| mem_last AS "Name", mem_phone AS "Phone Number", mem_city ||', '|| mem_state AS "Location"
FROM GYM_MEMBERS
WHERE mem_id > &mem_num OR mem_city LIKE 'Atl%'
ORDER BY mem_first;


--Query 3
--This shows the equipment type and the id for the first 8 rows
SELECT equip_type AS "Type of Equipment", equip_id AS "Equipment ID"
FROM GYM_EQUIPMENTS
WHERE equip_id BETWEEN 200 AND 1000  
ORDER BY equip_id
FETCH FIRST 8 ROWS ONLY;


--QUERY 4
--This shows the employees who's first name ends in y anf there phone number
SELECT RPAD(emp_id, 15, '*') || emp_last || ', ' || emp_first AS "Employee",
emp_phone AS "Employee Phone"
FROM gym_employees
WHERE SUBSTR(emp_first, -1) = 'y'
ORDER BY emp_first;

--Query 5 
--This shows the pay amount in whole dollars for the next months 
SELECT mem_id || ' ' || card_holder_name AS "Member",
ADD_MONTHS(pay_date, 1) AS "Next Month Payment Date", '$ ' || ROUND(pay_amount) AS "Amount Rounded"
FROM gym_payments
WHERE pay_id > 5
ORDER BY card_holder_name;


--Query 6
--This display the pay amount and pay date for the member for 6-15-19
SELECT mem_id AS "Member Id", TO_CHAR(pay_amount,'L99G990D00') AS "Pay Amount", pay_date AS "Date"
FROM gym_payments
WHERE pay_date = TO_DATE('June 15,2019', 'Month DD, YYYY')
ORDER BY mem_id;


--Query 7
--This displays the region for the gym
SELECT gym_name AS "Name", gym_street || ' ' || gym_city || ', ' || gym_state || ' '|| gym_zip AS "Address",
   (CASE WHEN gym_state = 'CA' THEN 'West'
        WHEN gym_state = 'GA' THEN 'South'
        WHEN gym_state = 'FL' THEN 'South'
        WHEN gym_state = 'NY' THEN 'North'
        ELSE 'Other'
    END) AS "Region" 
FROM gyms
ORDER BY "Region";


--order by pay_id;

--Query 8
--This shows the Eariest and Latest Replacemnt Dates
SELECT gym_id AS "Gym ID", equip_type AS "Equipment Type",
MIN(equip_replacement_date) AS "Early Replacement Date", 
MAX(equip_replacement_date) AS "Latest Replacemet Date"
FROM gym_equipments 
GROUP BY gym_id, equip_type
ORDER BY 1;

--Query 9
--This Displays total payments of the sum greater than 100
SELECT mem_id AS "Member ID  Number", card_holder_name AS "Name",
SUM(pay_amount) AS "Total Payments"
FROM gym_payments
GROUP BY mem_id, card_holder_name
HAVING SUM(pay_amount) >= 100
ORDER BY 1;

-- Query 10
--This displays the location that have rowing machines 
SELECT g.gym_name AS "Gym", 
g.gym_street ||' '|| g.gym_city ||', '|| g.gym_state AS "Address",
e.equip_type AS "Equipment"
FROM gyms g 
INNER JOIN gym_equipments e 
ON g.gym_id = e.gym_id
WHERE equip_type LIKE 'Rowing%'
ORDER BY 1;

--Query 11
--This displays the members and their total payments 
SELECT m.mem_first || ' ' || m.mem_last AS "NAME", 
SUM(p.pay_amount) AS "TOTAL PAYMENTS"
FROM gym_members m  
LEFT OUTER JOIN gym_payments p 
ON m.mem_id = p.mem_id
GROUP BY m.mem_first, m.mem_last
ORDER BY 1;

--Query 12
--This shows the gym and location for Max Smith 
SELECT g.gym_name AS "GYM NAME", 
g.gym_street ||' '|| g.gym_city ||', '|| g.gym_state AS "GYM ADDRESS", m.mem_first ||' '|| m.mem_last AS "MEMBER"
FROM gyms g JOIN gym_members m
ON g.gym_id = m.gym_id
WHERE mem_id = (SELECT mem_id 
                FROM gym_members
                WHERE mem_first LIKE 'Max'
                AND mem_last LIKE 'Smith')
ORDER BY 1;


--Query 13
--This will display all memebers that pay higher than the average
SELECT DISTINCT m.mem_first ||' '|| m.mem_last AS "Name", 
p.pay_amount AS "Payment greater than average"
FROM gym_members m JOIN gym_payments p
ON m.mem_id = p.mem_id
WHERE p.pay_amount >ANY (SELECT AVG(pay_amount)
                        FROM gym_payments)
ORDER BY p.pay_amount DESC;


--Query 14
--This shows the members and employees for the gym ID 60
SELECT emp_first AS "FRIST NAME", emp_last AS "LAST NAME", emp_email AS "EMAIL", 'Employee' "EMPLOYEE OR MEMBER"
FROM gym_employees
WHERE gym_id = 60
UNION
SELECT mem_first, mem_last, mem_email, 'Member'
FROM gym_members
WHERE gym_id = 60
ORDER BY 2;


--Query 15
--This shows all the members that don't have payments
SELECT mem_id AS "Member ID", mem_first AS "First Name", mem_last AS "Last Name"
FROM gym_members
MINUS
SELECT p.mem_id, m.mem_first, m.mem_last
FROM gym_payments p JOIN gym_members m
ON p.mem_id = m.mem_id
ORDER BY 3;