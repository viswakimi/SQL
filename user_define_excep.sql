-- user defined exception , cursor , if else condition


create table employees_bckup as
select * from employees
where 1=2;
/
select count(*) from employees_bckup
/
drop table employees_bckup



/
set serveroutput on

declare
 cursor c1 is select * from employees;
 l_emp_details c1%rowtype;
 l_count number;
 e_user_define exception;
L_ERROR_MSG varchar2(500);
begin
open c1;
loop
fetch c1 into l_emp_details;
exit when c1%notfound;
select count(*) into l_count from employees_bckup
where employee_id = l_emp_details.employee_id;
if l_count = 0
then
insert into employees_bckup(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
values(l_emp_details.EMPLOYEE_ID,
l_emp_details.FIRST_NAME,
l_emp_details.LAST_NAME,
l_emp_details.EMAIL,
l_emp_details.PHONE_NUMBER,
l_emp_details.HIRE_DATE,
l_emp_details.JOB_ID,
l_emp_details.SALARY,
l_emp_details.COMMISSION_PCT,
l_emp_details.MANAGER_ID,
l_emp_details.DEPARTMENT_ID
);
else
l_error_msg := 'Record already exist';
raise e_user_define;
--dbms_output.put_line ('EMPLOYEE_ID : ' || l_emp_details.EMPLOYEE_ID || ' is already exist');
end if;
end loop;
close c1;
exception
WHEN e_user_define THEN
        dbms_output.put_line ('ERROR : ' ||  L_ERROR_MSG);
when others then
dbms_output.put_line ('ERROR : ' || sqlerrm);
end;
/




DECLARE
    l_file_name VARCHAR2(50) := 'Bank_Statemsdsd.txt';
    e_user_defile EXCEPTION;
    l_error_msg VARCHAR2(2000);
    l_account_number  number := 39814010; --HSBC
BEGIN
    --dbms_output.put_line('File Name : ' || l_file_name);
   -- dbms_output.put_line('File Length : ' || length(l_file_name));
    IF length(l_file_name) <> 15 THEN
      dbms_output.put_line('**Invalid  Valid File Name**');
        l_error_msg := 'The file name must be 15 char length. but now the file length is ' || length(l_file_name);
        RAISE e_user_defile;
    END IF;
    
    if length(l_account_number) <> 8
    then
    l_error_msg := 'Account Number must be 8 char length. but here the account number size is '||length(l_account_number);
    raise e_user_defile;
    end if;
        
dbms_output.put_line('**Valid File Name**');
EXCEPTION
    WHEN e_user_defile THEN
        dbms_output.put_line('Error in User Define area ' || l_error_msg);
    WHEN OTHERS
    THEN
    dbms_output.put_line('>>>> Standard Error '||sqlerrm);
END;
