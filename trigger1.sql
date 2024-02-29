Create or replace trigger trigger1
    after insert on master
    for each row    
declare
       empcode1 master.empcode%type;
       empname1 master.empname%type;
       basic1   master.basic%type;
       DA1      number(8);
       HRA1     number(8);
       MA1      number(8);
       Gross1   number(8);
       PTAX1    number(8);
       ITAX1    number(8);
       GPF1     number(8);
       Deduction1 number(8);
       Netsalary1 number(8);  
BEGIN
     empcode1:= :new.empcode;
     empname1:= :new.empname;
     basic1:= :new.basic;
     DA1:= basic1*0.10;
     MA1:= 500;
     if (basic1<=112000)
     then
        HRA1:= basic1*0.12;
      else
        HRA1:= basic1*0.15; 
     end if;
     Gross1:= basic1+ DA1+ HRA1+ MA1;
     if (Gross1<=20000) 
     then
          PTAX1:= 130;
      else 
          if (Gross1>20000 AND Gross1<=35000)
          then
              PTAX1:= 150;
      else
          if (Gross1>35000)
          then
              PTAX1:= 200;
          end if;
       end if;
      end if;  

     if (Gross1>1000000)
      then
          ITAX1:= Gross1*0.3;
      else 
          if (Gross1>=500000 AND Gross1<=1000000)
          then
              ITAX1:= Gross1*0.2;
          else
              if (Gross1>250000 AND Gross1<=50000)
              then
                  ITAX1:= Gross1*0.05;
          else 
              ITAX1:= 0;
              end if;
          end if;
      end if;

     GPF1:= basic1*0.06;
     Deduction1:= GPF1+PTAX1+ITAX1;
     Netsalary1:= Gross1-Deduction1; 

INSERT INTO salary VALUES(empcode1,empname1,basic1,DA1,HRA1,MA1,Gross1,PTAX1,ITAX1,GPF1,Deduction1,Netsalary1,SYSDATE);
END;
/