--Explain cau truy van chua toi uu tren moi truong tap trung
SELECT /*+ GATHER_PLAN_STATISTICS */ KH.MA_KH, KH.HO_TEN, SDT, CMND, TT.TEN_TUYEN
FROM KHACH_HANG KH, VE V, NHAN_VIEN NV, CHI_NHANH_QL CN, TUYEN_TAU TT
WHERE KH.MA_KH = V.MA_KH 
AND V.MA_NV = NV.MA_NV
AND NV.MA_CN = CN.MA_CN
AND TT.MA_TUYEN = V.MA_TUYEN
AND LOAI_KH = 'HS-SV'
AND v.LOAI_VE='Ve Thuong'
AND TT.MA_GA_XUAT_PHAT = 'GA01' ;

SELECT * FROM TABLE(DBMS_XPLAN.display_cursor(format=>'ALLSTATS LAST'));    

--Explain cau truy van da toi uu tren moi truong tap trung
SELECT /*+ GATHER_PLAN_STATISTICS */ KH.MA_KH, KH.HO_TEN, KH.SDT, KH.CMND, N3.TEN_TUYEN
FROM (
        SELECT MA_KH,HO_TEN,SDT,CMND
        FROM KHACH_HANG
        WHERE LOAI_KH='HS-SV'
     )KH
     JOIN 
     (  SELECT N1.MA_KH,N1.TEN_TUYEN
        FROM (
                SELECT TEN_TUYEN,MA_KH,MA_NV
                FROM (
                        SELECT MA_TUYEN,TEN_TUYEN
                        FROM TUYEN_TAU
                        WHERE MA_GA_XUAT_PHAT='GA01'
                      )TT
                      JOIN
                      (
                        SELECT MA_TUYEN,MA_KH,MA_NV
                        FROM VE     
                        WHERE LOAI_VE='Ve Thuong'
                      )V
                      ON TT.MA_TUYEN = V.MA_TUYEN
              )N1
              JOIN
              (
                SELECT MA_NV
                FROM (
                        SELECT MA_NV,MA_CN
                        FROM NHAN_VIEN
                     ) NV
                     JOIN
                     (
                        SELECT MA_CN
                        FROM CHI_NHANH_QL
                     )CN
                     ON CN.MA_CN = NV.MA_CN
              )N2
              ON N1.MA_NV = N2.MA_NV
      ) N3
      ON KH.MA_KH = N3.MA_KH;
      
SELECT * FROM TABLE(DBMS_XPLAN.display_cursor(format=>'ALLSTATS LAST')); 

--Cau truy van da toi uu tren moi truong phan tan
SELECT KH.MA_KH, KH.HO_TEN, KH.SDT, KH.CMND, N3.TEN_TUYEN
FROM (
        SELECT MA_KH,HO_TEN,SDT,CMND
        FROM CN01.KHACH_HANG
        WHERE LOAI_KH='HS-SV'
     )KH
     JOIN 
     (  SELECT N1.MA_KH,N1.TEN_TUYEN
        FROM (
                SELECT TEN_TUYEN,MA_KH,MA_NV
                FROM (
                        SELECT MA_TUYEN,TEN_TUYEN
                        FROM (
                                SELECT MA_TUYEN,TEN_TUYEN
                                FROM CN01.TUYEN_TAU_NV
                                WHERE MA_GA_XUAT_PHAT='GA01'
                              )
                              UNION
                              (
                                SELECT MA_TUYEN,TEN_TUYEN
                                FROM CN02.TUYEN_TAU_NV@dbl_CN02
                                WHERE MA_GA_XUAT_PHAT='GA01' 
                              )
                      )TT
                      JOIN
                      (
                        SELECT MA_TUYEN,MA_KH,MA_NV
                        FROM (
                                SELECT MA_TUYEN,MA_KH,MA_NV
                                FROM CN01.VE
                                WHERE LOAI_VE='Ve Thuong'
                              )
                              UNION
                              (
                                SELECT MA_TUYEN,MA_KH,MA_NV
                                FROM CN02.VE@dbl_CN02
                                WHERE LOAI_VE='Ve Thuong'
                              )
                      )V
                      ON TT.MA_TUYEN = V.MA_TUYEN
              )N1
              JOIN
              (
                SELECT MA_NV
                FROM (
                        SELECT MA_NV,MA_CN
                        FROM (
                                SELECT MA_NV,MA_CN
                                FROM CN01.NHAN_VIEN
                              )
                              UNION
                              (
                                SELECT MA_NV,MA_CN
                                FROM CN02.NHAN_VIEN@dbl_CN02
                              )
                     ) NV
                     JOIN
                     (
                        SELECT MA_CN
                        FROM (
                                SELECT MA_CN
                                FROM CN01.CHI_NHANH_QL
                              )
                              UNION
                              (
                                SELECT MA_CN
                                FROM CN02.CHI_NHANH_QL@dbl_CN02
                              )
                     )CN
                     ON CN.MA_CN = NV.MA_CN
              )N2
              ON N1.MA_NV = N2.MA_NV
      ) N3
      ON KH.MA_KH = N3.MA_KH;
