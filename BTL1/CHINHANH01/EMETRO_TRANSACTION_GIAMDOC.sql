

BEGIN   
    CN01.tang_luong(11,'CN01');   
    dbms_output.put_line('Update successfully!!!!');    
END;
set serveroutput on ;

declare 
           trans_id Varchar2(100);
        begin
           trans_id := dbms_transaction.local_transaction_id( TRUE );
        end;
        
SELECT s.sid, s.serial#,
       CASE BITAND(t.flag, POWER(2, 28))
          WHEN 0 THEN 'READ COMMITTED'
          ELSE 'SERIALIZABLE'
       END AS isolation_level
    FROM v$transaction t 
    JOIN v$session s ON t.addr = s.taddr AND s.sid = sys_context('USERENV', 'SID');
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; 
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
-- DEADLOCK
UPDATE CN02.NHAN_VIEN@CN1_LINK_CN2
SET LUONG = 5000000
WHERE MA_NV = 'NV03';

UPDATE CN02.NHAN_VIEN@CN1_LINK_CN2
SET LUONG = 3000000
WHERE MA_NV = 'NV05';

COMMIT;
-- Non-Repeatable Read
BEGIN   
    CN01.tang_luong(11,'CN02');   
    dbms_output.put_line('Update successfully!!!!');    
END;
COMMIT;
-- Lost Update
UPDATE CN02.NHAN_VIEN@CN1_LINK_CN2
SET LUONG = 6000000
WHERE MA_NV = 'NV03';
COMMIT;


-- Phantom Read
INSERT INTO CN02.NHAN_VIEN@CN1_LINK_CN2(MA_NV, HO_TEN, DIA_CHI, SO_DT, LUONG, MA_CN) VALUES ('NV07', 'Le BIM', 'Quan 9', '0934676065', '5000000', 'CN02');
COMMIT;
