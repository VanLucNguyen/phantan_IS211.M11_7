--3. Hi?n th?c r�ng bu?c to�n v?n sau: Chuy�n m�n c?a nh�n vi�n ch? ???c nh?n gi� tr? l� �Phi c�ng� ho?c �Ti?p vi�n�.
ALTER TABLE BAITAPHTTT3.NHANVIEN 
ADD CONSTRAINT CHK_NV_CM CHECK ( CHUYENMON='Phi cong' OR CHUYENMON='Tiep vien');

--4Hi?n th?c r�ng bu?c to�n v?n sau: Ng�y b?t ??u chuy?n bay lu�n l?n h?n ng�y th�nh l?p h�ng h�ng kh�ng qu?n l� chuy?n bay ?�.
CREATE OR REPLACE TRIGGER TRIGGER_BATDAU_NGTL
BEFORE INSERT OR UPDATE 
ON BAITAPHTTT3.CHUYENBAY
FOR EACH ROW
DECLARE
    V_NGTL DATE;
BEGIN
    SELECT BAITAPHTTT3.HANGHANGKHONG.NGTL INTO V_NGTL
    FROM BAITAPHTTT3.HANGHANGKHONG
    WHERE BAITAPHTTT3.HANGHANGKHONG.MAHANG = :NEW.MAHANG;
    
    IF :NEW.BATDAU <= V_NGTL THEN
        RAISE_APPLICATION_ERROR(-20100, 'NGAY BAT DAU CHUYEN BAY PHAI LON HON NGAY THANH LAP HANG HANG KHONG QUAN LY CHUYEN BAY.');
    END IF;
END;
