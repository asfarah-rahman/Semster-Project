--Asfarah Rahman
--Project Schema


--VIEW 1
CREATE OR REPLACE VIEW gym_4200
(gym, gym_location,employee_name, employee_contact)
AS SELECT g.gym_name, g.gym_street ||' '|| g.gym_city ||', '|| g.gym_state ||' '|| g.gym_zip, 
    e.emp_first ||' '|| e.emp_last, e.emp_phone
    FROM gyms g JOIN gym_employees e
    ON g.gym_id= e.gym_id;
    
SELECT * FROM gym_4200; 

SELECT gym, employee_name, employee_contact
FROM gym_4200
WHERE gym LIKE 'B%';


--VIEW 2
CREATE OR REPLACE VIEW gym_life
(name, email, avg_payments)
AS SELECT m.mem_first ||' '|| m.mem_last, m.mem_email, TO_CHAR(AVG(p.pay_amount), '$999.99') 
    FROM gym_members m JOIN gym_payments p
    ON m.mem_id = p.mem_id
    GROUP BY m.mem_first, m.mem_last, m.mem_email
    HAVING AVG(p.pay_amount) > 50;

SELECT * FROM gym_life;

SELECT name, avg_payments
FROM gym_life
WHERE name LIKE 'John_Wick';


--INDEX
CREATE INDEX gn_gym_name_idx
ON gyms (gym_name);


--FLASHBACK
CREATE TABLE TEMP_SP (A NUMBER);
INSERT INTO TEMP_SP VALUES(7);
SELECT* FROM TEMP_SP;
DROP TABLE TEMP_SP;
SELECT* FROM TEMP_SP;
FLASHBACK TABLE TEMP_SP TO BEFORE DROP;
SELECT* FROM TEMP_SP;
