/*1. TAO BANG USER*/
CREATE TABLE BAITAPHTTT2.USER_NEW 
(
    U_ID VARCHAR2(3) CONSTRAINT PK_USER_NEW PRIMARY KEY,
    USERNAME VARCHAR2(20),
    PASS VARCHAR2(20),
    REGDAY DATE,
    NATIONALITY VARCHAR(20)
)

/*2. TAO BANG USER*/
CREATE TABLE BAITAPHTTT2.CHANNEL 
(
    CHANNELID VARCHAR2(4) CONSTRAINT PK_CHANNEL PRIMARY KEY,
    CNAME VARCHAR2(20),
    SUBSCRIBES NUMBER,
    OWNNER VARCHAR2(3),
    CREATED DATE
)

/*3.TAO BANG VIDEO*/
CREATE TABLE BAITAPHTTT2.VIDEO
(
    VIDEOID VARCHAR(7) CONSTRAINT PK_VIDEO PRIMARY KEY,
    TITLE VARCHAR(100),
    DURATION NUMBER,
    AGE NUMBER
)

/*4.TAO BANG SHARE*/
CREATE TABLE BAITAPHTTT2.SHARE_NEW
(
    VIDEOID VARCHAR(7),
    CHANNELID VARCHAR(4),
    CONSTRAINT PK_SHARE_NEW PRIMARY KEY(VIDEOID, CHANNELID)
)

ALTER SESSION SET NLS_DATE_FORMAT =' DD/MM/YYYY HH24:MI:SS ';

/*NHAP DU LIEU BANG USER_NEW*/
INSERT INTO BAITAPHTTT2.USER_NEW VALUES('001', 'FAPTV', '12345ABC', '01/01/2014', 'VIET NAM');
INSERT INTO BAITAPHTTT2.USER_NEW VALUES('002', 'KEMXOITV', '@147869III', '05/06/2015', 'CAMPUCHIA');
INSERT INTO BAITAPHTTT2.USER_NEW VALUES('003', 'OPENSHARE', '12345ABC', '01/01/2014', 'VIET NAM');

/*NHAP DU LIEU BANG CHANNEL*/
INSERT INTO BAITAPHTTT2.CHANNEL VALUES('C120', 'FAP TV', 2343, '001', '02/01/2014');
INSERT INTO BAITAPHTTT2.CHANNEL VALUES('C905', 'KEM XOI TV', 1032, '002', '09/07/2015');
INSERT INTO BAITAPHTTT2.CHANNEL VALUES('C357', 'OPENSHARE CAFE', 5064, '003', '10/12/2010');

/*NHAP DU LIEU BANG VIDEO*/
INSERT INTO BAITAPHTTT2.VIDEO VALUES ('V100299', 'FAPTV COM NGUOI TAP 41 - DOT NHAP', 469, 18);
INSERT INTO BAITAPHTTT2.VIDEO VALUES ('V211002', 'KEM XOI: TAP 31 - MAY KOOL TINH YEU CUA ANH', 312, 16);
INSERT INTO BAITAPHTTT2.VIDEO VALUES ('V400002', 'NOI TINH YEU KET THUC - HOANG TUAN', 378, 0);

/*NHAP DU LIEU BANG SHARE_NEW*/
INSERT INTO BAITAPHTTT2.SHARE_NEW VALUES ('V100229','C905');
INSERT INTO BAITAPHTTT2.SHARE_NEW VALUES ('V211002','C120');
INSERT INTO BAITAPHTTT2.SHARE_NEW VALUES ('V400002','C357');

ALTER TABLE BAITAPHTTT2.CHANNEL ADD CONSTRAINT FK_CHANNEL_USER_NEW FOREIGN KEY (OWNNER) REFERENCES BAITAPHTTT2.USER_NEW(U_ID);

ALTER TABLE BAITAPHTTT2.SHARE_NEW ADD CONSTRAINT FK_SHARE_NEW_VIDEO FOREIGN KEY (VIDEOID) REFERENCES BAITAPHTTT2.VIDEO(VIDEOID);

ALTER TABLE BAITAPHTTT2.SHARE_NEW ADD CONSTRAINT FK_SHARE_NEW_CHANNEL FOREIGN KEY (CHANNELID) REFERENCES BAITAPHTTT2.CHANNEL(CHANNELID);

/*5. T�m t?t c? c�c video c� gi?i h?n ?? tu?i t? 16 tr? l�n.*/
SELECT *
FROM BAITAPHTTT2.VIDEO
WHERE AGE >= 16

/*6. T�m k�nh c� s? ng??i theo d�i nhi?u nh?t.*/
SELECT *
FROM BAITAPHTTT2.CHANNEL
ORDER BY SUBSCRIBES DESC
FETCH FIRST 1 ROW WITH TIES

/*7. V?i m?i video c� gi?i h?n ?? tu?i l� 18, th?ng k� s? k�nh ?� chia s?.*/
SELECT S.CHANNELID
FROM BAITAPHTTT2.SHARE_NEW S
WHERE S.VIDEOID IN (
    SELECT V.VIDEOID
    FROM BAITAPHTTT2.VIDEO V
    WHERE V.AGE = 18
)

/*8. T�m video ???c t?t c? c�c k�nh chia s?.*/
SELECT *
FROM BAITAPHTTT2.VIDEO V
WHERE NOT EXISTS (
    SELECT * 
    FROM BAITAPHTTT2.CHANNEL C
    WHERE NOT EXISTS (
        SELECT *
        FROM BAITAPHTTT2.SHARE_NEW S
        WHERE S.VIDEOID = V.VIDEOID AND S.CHANNELID = C.CHANNELID
    )
)