-- Function
CREATE OR REPLACE FUNCTION ticket_in_day (thu in string , thang in number, cn in string)  
RETURN NUMBER
IS
countTicket NUMBER;
BEGIN 
IF cn='CN01' THEN

    SELECT COUNT(MA_VE) into countTicket
    FROM CN01.VE
    WHERE TRIM(TO_CHAR(NGAY_MUA, 'DAY')) = thu
    AND extract(month from NGAY_MUA) = thang;
ELSIF cn='CN02' THEN

    SELECT COUNT(MA_VE) into countTicket 
    FROM CN02.VE@dbl_CN02
    WHERE TRIM(TO_CHAR(NGAY_MUA, 'DAY')) = thu
    AND extract(month from NGAY_MUA) = thang;
ELSE 
    dbms_output.put_line('INVALID CN');
END IF; 
  RETURN countTicket; 
END;


DECLARE 
    sove number;
begin 
    sove := ticket_in_day('TUESDAY',11,'CN01');    
    dbms_output.put_line('So luong ve ban duoc la: ' || sove  );
end;

set serveroutput on ;
Drop function ticket_in_day;


-- Procedure
CREATE OR REPLACE PROCEDURE tang_luong ( mon in number, cn in string )
AS
BEGIN
    IF cn='CN01' THEN
BEGIN
  
    
    UPDATE CN01.NHAN_VIEN
    SET LUONG= LUONG + LUONG*3/100
    WHERE MA_NV in  ( SELECT MA_NV               
                    FROM CN01.VE
                    WHERE extract(month from NGAY_MUA) = mon
                    GROUP BY MA_NV
                    ORDER BY COUNT(MA_VE) desc
                    FETCH FIRST 1 ROWS ONLY 
                    );
END;   
ELSIF cn='CN02' THEN
BEGIN
    UPDATE CN02.NHAN_VIEN@dbl_CN02
    SET LUONG= LUONG + LUONG*3/100
    WHERE MA_NV in  (   SELECT MA_NV 
                        FROM CN02.VE@dbl_CN02
                        WHERE extract(month from NGAY_MUA) = mon
                        GROUP BY MA_NV
                        ORDER BY COUNT(MA_VE) desc
                        FETCH FIRST 1 ROWS ONLY
                        ); 
END;
ELSE 
    dbms_output.put_line('INVALID CN');
END IF;  
END;

drop procedure tang_luong;
BEGIN   
    tang_luong(11,'CN01');   
    dbms_output.put_line('Update successfully!!!!');    
END;

-- Trigger
CREATE OR REPLACE TRIGGER SL_VE_MAX
BEFORE INSERT ON VE FOR EACH ROW
DECLARE
    CountVe  INTEGER;   
    MaxVe   INTEGER := 3000;
BEGIN
    SELECT COUNT(MA_VE) INTO CountVe
    FROM VE
    WHERE MA_TUYEN = :NEW.MA_TUYEN
    AND NGAY_MUA = :NEW.NGAY_MUA
    AND :NEW.NGAY_MUA = TO_CHAR(SYSDATE, 'mm/dd/yyyy');
    IF CountVe > MaxVe THEN
         RAISE_APPLICATION_ERROR (-20000,'Tuyen tau nay hien da het ve.');      
    END IF;
END;
