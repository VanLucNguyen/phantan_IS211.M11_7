--YEU CAU 3: DEMO CAC MUC CO LAP (ISOLATION LEVEL) TRONG MOI TRUONG PHAN TAN 

--CAI DAT CAU LENH DUNG DE XEM MUC CO LAP

declare 
    trans_id Varchar2(100);
begin
    trans_id := dbms_transaction.local_transaction_id( TRUE );
end;
        
--XEM MUC CO LAP HIEN TAI TRONG ORACLE

SELECT s.sid, s.serial#,
       CASE BITAND(t.flag, POWER(2, 28))
          WHEN 0 THEN 'READ COMMITTED'
          ELSE 'SERIALIZABLE'
       END AS isolation_level
    FROM v$transaction t 
    JOIN v$session s ON t.addr = s.taddr AND s.sid = sys_context('USERENV', 'SID');
    
--SET MUC CO LAP O TRANSACTION

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

--DEADLOCK

UPDATE CN02.NHAN_VIEN
SET LUONG = 5500000
WHERE MA_NV = 'NV05';

UPDATE CN02.NHAN_VIEN
SET LUONG = 3500000
WHERE MA_NV = 'NV03';

SELECT * FROM CN02.NHAN_VIEN;

--NON-REPEATABLE READ

SELECT * FROM CN02.NHAN_VIEN;
COMMIT;

--LOST UPDATE

SELECT * FROM CN02.NHAN_VIEN;

UPDATE CN02.NHAN_VIEN
SET LUONG = 6500000
WHERE MA_NV = 'NV03';

COMMIT;

SELECT * FROM CN02.NHAN_VIEN;

--PHANTOM READ

SELECT COUNT(*) AS SLNV FROM CN02.NHAN_VIEN;
