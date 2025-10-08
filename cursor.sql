/*BI Publisher / Reports: Fetch data row-by-row for reporting logic.

Procedures: Return result sets using REF CURSOR or SYS_REFCURSOR.

ETL scripts: Move data between tables.

Auditing / Logging: Process multiple rows for tracking changes.

Dynamic query-REF Cursor / SYS_REFCURSOR

Update/Delete/Insert check- Implicit cursor attributes (SQL%ROWCOUNT)

*/

DECLARE
CURSOR C1 IS select * from item_master;
l_item_all_rec c1%rowtype;
BEGIN
 OPEN C1;
 LOOP
 FETCH C1 INTO l_item_all_rec;
 EXIT WHEN C1%NOTFOUND;
 DBMS_OUTPUT.put_line('Print Item NAme '||l_item_all_rec.item_name);
 END LOOP;
 CLOSE C1;
END;


/
--1 Single-row Fetch ,No cursor is needed here.

DECLARE
   v_employee_name employees.first_name%TYPE;
BEGIN
   SELECT first_name
   INTO v_employee_name
   FROM employees
   WHERE employee_id = 100;

   DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_employee_name);
END;
/

-- 2 Multi-row Fetch using Cursors-Here you need a cursor because SELECT INTO can’t handle multiple rows.

--Implicit Cursor
BEGIN
   UPDATE employees
   SET salary = salary * 1.1
   WHERE department_id = 50;

   DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);
END;
/

--Explicit Cursor


DECLARE
   CURSOR emp_cur IS
      SELECT first_name, salary FROM employees WHERE department_id = 50;

   v_name employees.first_name%TYPE;
   v_salary employees.salary%TYPE;
BEGIN
   OPEN emp_cur;
   LOOP
      FETCH emp_cur INTO v_name, v_salary;
      EXIT WHEN emp_cur%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(v_name || ' earns ' || v_salary);
   END LOOP;
   CLOSE emp_cur;
END;
/


-- 3️  Cursor FOR Loop [Simplified explicit cursor

BEGIN
   FOR emp_rec IN (SELECT first_name, salary FROM employees WHERE department_id = 50) LOOP
      DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' earns ' || emp_rec.salary);
   END LOOP;
END;
/


--4 ️⃣ Parameterized Cursor- When you need to pass values dynamically

DECLARE
   CURSOR emp_cur (p_dept_id NUMBER) IS
      SELECT first_name, salary FROM employees WHERE department_id = p_dept_id;

   v_name employees.first_name%TYPE;
   v_salary employees.salary%TYPE;
BEGIN
   OPEN emp_cur(90); -- Pass parameter
   LOOP
      FETCH emp_cur INTO v_name, v_salary;
      EXIT WHEN emp_cur%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(v_name || ' earns ' || v_salary);
   END LOOP;
   CLOSE emp_cur;
END;
/

--REF Cursor (Cursor Variables / Dynamic Cursors)-- When query structure changes dynamically (for example, table name or columns vary at runtime)



DECLARE
   TYPE ref_cursor IS REF CURSOR;
   c_emp ref_cursor;
   v_name employees.first_name%TYPE;
BEGIN
   OPEN c_emp FOR 'SELECT first_name FROM employees WHERE ROWNUM <= 5';
   LOOP
      FETCH c_emp INTO v_name;
      EXIT WHEN c_emp%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(v_name);
   END LOOP;
   CLOSE c_emp;
END;
/



--6 ️⃣ SYS_REFCURSOR--A predefined weak REF CURSOR type — you don’t need to declare your own type.


DECLARE
   c_emp SYS_REFCURSOR;
   v_name employees.first_name%TYPE;
BEGIN
   OPEN c_emp FOR SELECT first_name FROM employees WHERE ROWNUM <= 5;
   LOOP
      FETCH c_emp INTO v_name;
      EXIT WHEN c_emp%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(v_name);
   END LOOP;
   CLOSE c_emp;
END;
/

