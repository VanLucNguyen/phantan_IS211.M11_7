CREATE TABLE BaiTap3.HANGHANGKHONG
(
    MAHANG VARCHAR2(2),
    TENHANG VARCHAR(30),
    NGTL DATE,
    DUONGBAY NUMBER,
    CONSTRAINT PK_HANG PRIMARY KEY (MAHANG)
);

CREATE TABLE BaiTap3.CHUYENBAY
(
    MACB VARCHAR2(5),
    MAHANG VARCHAR2(2) REFERENCES BaiTap3.HANGHANGKHONG(MAHANG),
    XUATPHAT VARCHAR2(30),
    DIEMDEN VARCHAR2(30),
    BATDAU DATE,
    TGBAY NUMBER,
    CONSTRAINT PK_CB PRIMARY KEY (MACB)
)

CREATE TABLE BaiTap3.NHANVIEN
(
    MANV VARCHAR2(4),
    HOTEN VARCHAR2(30),
    GIOITINH VARCHAR2(5),
    NGSINH DATE,
    NGVL DATE,
    CHUYENMON VARCHAR2(20),
    CONSTRAINT PK_NV PRIMARY KEY (MANV)
)

CREATE TABLE BaiTap3.PHANCONG
(
    MACB VARCHAR2(5) REFERENCES BaiTap3.CHUYENBAY(MACB),
    MANV VARCHAR2(4) REFERENCES BaiTap3.NHANVIEN(MANV),
    NHIEMVU VARCHAR2(20),
    CONSTRAINT PK_PHCONG PRIMARY KEY (MACB,MANV)
)

ALTER SESSION SET NLS_DATE_FORMAT ='DD/MM/YYYY HH24:MI:SS';
INSERT INTO BaiTap3.HANGHANGKHONG VALUES('VN','Vietnam Airlines','15/01/1956', 52);
INSERT INTO BaiTap3.HANGHANGKHONG VALUES('VJ', 'Vietjet Air', '25/12/2011', 33);
INSERT INTO BaiTap3.HANGHANGKHONG VALUES('BL', 'Jetstar Pacific Airlines', '01/12/1990', 13);

INSERT INTO BaiTap3.CHUYENBAY VALUES('VN550', 'VN', 'TP.HCM', 'Singapore', '20/12/2015 13:15', 2);
INSERT INTO BaiTap3.CHUYENBAY VALUES('VJ331', 'VJ', '?a Nang', 'Vinh', '28/12/2015 22:30', 1);
INSERT INTO BaiTap3.CHUYENBAY VALUES('BL696', 'BL', 'TP. HCM', 'Da Lat', '24/12/2015 06:00', 0.5);

INSERT INTO BaiTap3.NHANVIEN VALUES('NV01', 'Lam Van Ben', 'Nam', '10/09/1978', '05/06/2000', 'Phi cong');
INSERT INTO BaiTap3.NHANVIEN VALUES('NV02', 'Duong Thi Luc', 'Nu', '22/03/1989', '12/11/2013', 'Tiep vien');
INSERT INTO BaiTap3.NHANVIEN VALUES('NV03', 'Hoang Thanh Tung','Nam', '29/07/1983', '11/04/2007', 'Tiep vien');

INSERT INTO BaiTap3.PHANCONG VALUES('VN550', 'NV01' ,'Co truong');
INSERT INTO BaiTap3.PHANCONG VALUES('VN550', 'NV02' ,'Tiep vien');
INSERT INTO BaiTap3.PHANCONG VALUES('BL696', 'NV03' ,'Tiep vien truong');

/*Trigger*/
                                
SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRIGGER_HANGHANGKHONG_CHUYENBAY
AFTER INSERT OR UPDATE ON BaiTap3.CHUYENBAY
FOR EACH ROW
DECLARE
    V_NGTL BaiTap3.HANGHANGKHONG.NGTL%TYPE;
BEGIN
    SELECT BaiTap3.HANGHANGKHONG.NGTL INTO V_NGTL
    FROM BaiTap3.HANGHANGKHONG
    WHERE BaiTap3.HANGHANGKHONG.MAHANG =:NEW.MAHANG;
    IF(:NEW.BATDAU < V_NGTL)
    THEN
      RAISE_APPLICATION_ERROR(-2000, 'NGAY BAT DAU CHUYEN BAY PHAI SAU NGAY THANH LAP HANG');
    END IF;
END;