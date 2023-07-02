set dateformat dmy;
GO

USE master
Go
IF exists (SELECT * FROM sysdatabases WHERE name= 'QLBH')
DROP DATABASE QLBH
Go

create database QLBH
GO
use QLBH
GO

create table KHACHHANG
(
	MAKH CHAR(4) NOT NULL PRIMARY KEY, 
	HOTEN VARCHAR(40), 
	DCHI VARCHAR(50), 
	SODT VARCHAR(20), 
	NGSINH SMALLDATETIME, 
	DOANHSO MONEY, 
	NGDK SMALLDATETIME

)
GO

create table NHANVIEN
(
	MANV CHAR(4) NOT NULL PRIMARY KEY,
	HOTEN VARCHAR(40), 
	NGVL SMALLDATETIME, 
	SODT VARCHAR(20)

)
GO

create table SANPHAM
(
	MASP CHAR(4) NOT NULL PRIMARY KEY,
	TENSP VARCHAR(40), 
	DVT VARCHAR(20), 
	NUOCSX VARCHAR(40), 
	GIA MONEY
)
GO

create table HOADON
(
	SOHD INT NOT NULL PRIMARY KEY, 
	NGHD SMALLDATETIME, 
	MAKH CHAR(4), 
	MANV CHAR(4), 
	TRIGIA MONEY
)
GO

create table CTHD
(
	SOHD INT NOT NULL ,
	MASP CHAR(4) NOT NULL ,
	SL INT,
	constraint PK_CTHDON primary key (SOHD, MASP)
)
GO
-- TẠO KHÓA NGOẠI
ALTER TABLE dbo.HOADON ADD FOREIGN KEY(MANV) REFERENCES dbo.NHANVIEN(MANV) 
ALTER TABLE dbo.HOADON ADD FOREIGN KEY(MAKH) REFERENCES dbo.KHACHHANG(MAKH) 
ALTER TABLE dbo.CTHD ADD FOREIGN KEY(SOHD) REFERENCES dbo.HOADON(SOHD) 
ALTER TABLE dbo.CTHD ADD FOREIGN KEY (MASP) REFERENCES dbo.SANPHAM (MASP) 
ALTER TABLE dbo.CTHD ADD FOREIGN KEY (SOHD) REFERENCES dbo.HOADON(SOHD)

-- 2. Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM
ALTER TABLE dbo.SANPHAM ADD GHICHU VARCHAR(20)
--3. Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG
ALTER TABLE dbo.KHACHHANG ADD LOAIKH tinyint
--4. Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100)
ALTER TABLE dbo.SANPHAM ALTER COLUMN GHICHU VARCHAR(100)
--5. Xóa thuộc tính GHICHU trong quan hệ SANPHAM
ALTER TABLE dbo.SANPHAM DROP COLUMN GHICHU
--6. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”, ….
ALTER TABLE dbo.KHACHHANG ALTER COLUMN LOAIKH VARCHAR(20)
--7. Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”) **
ALTER TABLE SANPHAM ADD CONSTRAINT CHECK_DVT check (DVT IN ('cay', 'hop','cai','quyen','chuc'))
-- C2: ALTER TABLE SANPHAM ADD CONSTRAINT cK_dvt check (DVT ='cay' or DVT = 'hop' or DVT = 'cai' or DVT = 'quyen' or DVT = 'chuc')
--8. Giá bán của sản phẩm từ 500 đồng trở lên
ALTER TABLE SANPHAM ADD CONSTRAINT CHECK_SP CHECK (GIA >= 500)
--9. Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm. ***
ALTER TABLE CTHD ADD CONSTRAINT CHECK_SL CHECK (SL >= 1)
--10. Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó. ***
ALTER TABLE KHACHHANG ADD CONSTRAINT CHECK_KH CHECK (NGSINH < NGDK)
--11.Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó đăng ký thành viên (NGDK).


--12.Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm.1
--13.Mỗi một hóa đơn phải có ít nhất một chi tiết hóa đơn.
--14.Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.
--15.Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó đã mua.

--II.
SELECT * FROM KHACHHANG
-- NHẬP DỮ LIỆU KHACHHANG
INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES ('KH01','Nguyen Van A','731 Tran Hung Dao, Q5, TpHCM','08823451','22/10/1960',13060000,'22/07/2006')
INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES ('KH02','Tran Ngoc Han','3/5 Nguyen Trai, Q5, TpHCM','0908256478','3/4/1974',280000 ,'30/07/2006')
INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES ('KH03','Tran Ngoc Linh','45 Nguyen Canh Chan, Q1, TpHCM','0938776266','12/6/1980',3860000 ,'05/08/2006')
INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES ('KH04','Tran Minh Long','50/34 Le Dai Hanh, Q10, TpHCM','0917325476','9/3/1965',250000,'02/10/2006')
INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES ('KH05','Le Nhat Minh','34 Truong Dinh, Q3, TpHCM','08246108','10/3/1950',21000,'28/10/2006')
INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES ('KH06','Le Hoai Thuong','227 Nguyen Van Cu, Q5, TpHCM','08631738','31/12/1981',915000,'24/11/2006')
INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES ('KH07','Nguyen Van Tam','32/3 Tran Binh Trong, Q5, TpHCM','0916783565','6/4/1971',12500,'01/12/2006')
INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES ('KH08','Phan Thi Thanh','45/2 An Duong Vuong, Q5, TpHCM','0938435756','10/1/1971',365000,'13/12/2006')
INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES ('KH09','Le Ha Vinh','873 Le Hong Phong, Q5, TpHCM','08654763','3/9/1979',70000,'14/01/2007')
INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES ('KH10','Ha Duy Lap','34/34B Nguyen Trai, Q1, TpHCM','08768904','2/5/1983',67500,'16/01/2007')
SELECT * FROM NHANVIEN-- NHẬP DỮ LIỆU NHANVIENINSERT INTO NHANVIEN (MANV, HOTEN, NGVL, SODT) VALUES ('NV01','Nguyen Nhu Nhut','13/4/2006','0927345678')INSERT INTO NHANVIEN (MANV, HOTEN, NGVL, SODT) VALUES ('NV02','Le Thi Phi Yen','21/4/2006','0987567390')INSERT INTO NHANVIEN (MANV, HOTEN, NGVL, SODT) VALUES ('NV03','Nguyen Van B', '27/4/2006', '0997047382')INSERT INTO NHANVIEN (MANV, HOTEN, NGVL, SODT) VALUES ('NV04','Ngo Thanh Tuan','24/6/2006', '0913758498')INSERT INTO NHANVIEN (MANV, HOTEN, NGVL, SODT) VALUES ('NV05','Nguyen Thi Truc Thanh','20/7/2006','0918590387')SELECT * FROM NHANVIEN-- NHẬP DỮ LIỆU SANPHAMSELECT * FROM SANPHAMINSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('BC01','But chi','cay','Singapore',3000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('BC02','But chi','cay','Singapore',5000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('BC03','But chi','cay','Viet Nam',3500)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('BC04','But chi', 'hop','Viet Nam',30000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('BB01','But chi','cay','Viet Nam',5000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('BB02','But chi', 'cay','Trung Quoc',7000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('BB03','But chi', 'hop','Thai Lan',100000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('TV01','Tap 100 giay mong', 'quyen','Trung Quoc',2500)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('TV02','Tap 200 giay mong', 'quyen','Trung Quoc',4500)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('TV03','Tap 100 giay tot', 'quyen','Viet Nam',3000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('TV04','Tap 200 giay tot', 'quyen','Viet Nam',5500)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('TV05','Tap 100 trang', 'chuc','Viet Nam',23000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('TV06','Tap 200 trang', 'chuc','Viet Nam',53000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('TV07','Tap 100 trang', 'chuc','Trung Quoc',34000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('ST01','So tay 500 trang', 'quyen','Trung Quoc',34000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('ST02','So tay loai 1', 'quyen','Viet Nam',55000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('ST03','So tay loai 2', 'quyen','Viet Nam',51000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('ST04','So tay', 'quyen','Thai Lan',55000)INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('ST05','So tay mong', 'quyen','Thai Lan',20000)
INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('ST06','Phan viet bang', 'hop','Viet Nam',5000)
INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('ST07','Phan khong bui', 'hop','Viet Nam',7000)
INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('ST08','Bong bang', 'cai','Viet Nam',1000)
INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('ST09','But long', 'cay','Viet Namn',5000)
INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES ('ST10','But long', 'cay','Trung Quoc',7000)
-- NHẬP DỮ LIỆU HOADONSELECT * FROM HOADONINSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1001','23/07/2006','KH01','NV01',320000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1002','12/08/2006','KH01','NV02', 840000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1003','23/08/2006', 'KH02', 'NV01', 100000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1004', '01/09/2006', 'KH02', 'NV01', 180000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1005', '20/10/2006', 'KH01', 'NV02', 3800000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1006', '16/10/2006', 'KH01', 'NV03', 2430000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1007', '28/10/2006', 'KH03', 'NV03', 510000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1008', '28/10/2006', 'KH01', 'NV03', 40000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1009', '28/10/2006', 'KH03', 'NV04', 200000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1010', '01/11/2006', 'KH01', 'NV01', 5200000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1011', '04/11/2006', 'KH04', 'NV03', 250000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1012', '30/11/2006', 'KH05', 'NV03', 21000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1013', '12/12/2006', 'KH06', 'NV01', 5000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1014', '31/12/2006', 'KH03', 'NV02', 3150000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1015', '01/01/2007', 'KH06', 'NV01', 910000)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1016', '01/01/2007', 'KH07', 'NV02', 12500)INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1017', '02/01/2007', 'KH08', 'NV03', 35000)
INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1018', '13/01/2007', 'KH08', 'NV03', 330000)
INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1019', '13/01/2007', 'KH01', 'NV03',30000)
INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1020', '14/01/2007', 'KH09', 'NV04', 70000)
INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1021', '16/01/2007', 'KH10', 'NV03', 67500)
INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1022', '16/01/2007',  Null, 'NV03', 7000)
INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES ('1023', '17/01/2007',  Null,'NV01', 330000)

SELECT * FROM CTHD-- NHẬP DỮ LIỆU CTHDINSERT INTO CTHD (SOHD, MASP, SL) VALUES (1001, 'TV02', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1001, 'ST01', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1001, 'BC01', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1001, 'BC02', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1001, 'ST08', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1002, 'BC04', 20)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1002, 'BB01', 20)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1002, 'BB02', 20)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1003, 'BB03', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1004, 'TV01', 20)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1004, 'TV02', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1004, 'TV03', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1004, 'TV04', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1005, 'TV05', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1005, 'TV06', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1006, 'TV07', 20)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1006, 'ST01', 30)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1006, 'ST02', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1007, 'ST03', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1008, 'ST04', 8)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1009, 'ST05', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1010, 'TV07', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1010, 'ST07', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1010, 'ST08', 100)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1010, 'ST04', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1010, 'TV03', 100)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1011, 'ST06', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1012, 'ST07', 3)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1013, 'ST08', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1014, 'BC02', 80)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1014, 'BB02', 100)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1014, 'BC04', 60)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1014, 'BB01', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1015, 'BB02', 30)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1015, 'BB03', 7)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1016, 'TV01', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1017, 'TV02', 1)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1017, 'TV03', 1)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1017, 'TV04', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1018, 'ST04', 6)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1019, 'ST05', 1)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1019, 'ST06', 2)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1020, 'ST07', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1021, 'ST08', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1021, 'TV01', 7)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1021, 'TV02', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1022, 'ST07', 1)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1023, 'ST04', 6)

--2.
SELECT * INTO SANPHAM1 FROM SANPHAM
SELECT * INTO KHACHHANG1 FROM KHACHHANG
--3.Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)UPDATE SANPHAM1
SET GIA = GIA * 1.05
WHERE NUOCSX = 'Thai Lan'

--4.Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống(cho quan hệ SANPHAM1).
UPDATE SANPHAM1 SET GIA = GIA - GIA* 0.05
WHERE NUOCSX = 'Trung Quoc' AND GIA <= 10000


--5. Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày 1/1/2007 có doanh số từ 10.000.000 trở lên 
--hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).
UPDATE KHACHHANG
SET LOAIKH = 'Vip'
WHERE (NGDK < '1/1/2007' AND DOANHSO >= 10000000) OR (NGDK > '1/1/2007' AND DOANHSO >= 2000000)


--III.
--1.In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
SELECT MASP, TENSP FROM SANPHAM WHERE NUOCSX = 'Trung Quoc'
--2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.
SELECT MASP, TENSP FROM SANPHAM WHERE DVT IN ('cay', 'quyen')
--3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
SELECT MASP, TENSP FROM SANPHAM WHERE MASP LIKE 'B%01'
--4.In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP FROM SANPHAM WHERE NUOCSX = 'Trung Quoc' AND GIA BETWEEN 30000 AND 40000
--5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP FROM SANPHAM WHERE (NUOCSX = 'Trung Quoc' OR NUOCSX = 'Thai Lan') AND GIA BETWEEN 30000 AND 40000
--6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
SELECT SOHD, TRIGIA FROM HOADON WHERE NGHD = '1/1/2007' OR NGHD = '2/1/2007'
--7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
SELECT SOHD, TRIGIA FROM HOADON WHERE MONTH(NGHD) = 1 AND YEAR(NGHD) = 2007 ORDER BY NGHD ASC ,TRIGIA DESC

--BTTH TUẦN 3
--8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
SELECT KHACHHANG.MAKH, HOTEN
FROM KHACHHANG JOIN HOADON 
ON KHACHHANG.MAKH = HOADON.MAKH WHERE NGHD = '1/1/2007'
--9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.SELECT SOHD, TRIGIA FROM HOADON JOIN NHANVIEN ON HOADON.MANV = NHANVIEN.MANVWHERE HOTEN = 'Nguyen Van B' AND NGHD = '28/10/2006'--10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
SELECT SP.MASP, SP.TENSP 
FROM KHACHHANG KH, SANPHAM SP, HOADON HD, CTHD CT  
WHERE HOTEN = 'Nguyen Van A' AND MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006 
AND KH.MAKH = HD.MAKH AND HD.SOHD = CT.SOHD AND SP.MASP = CT.MASP

--11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
SELECT DISTINCT HD.SOHD 
FROM CTHD CT, HOADON HD
WHERE MASP IN ('BB01', 'BB02') AND HD.SOHD = CT.SOHD
--12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT DISTINCT CT.SOHD
FROM CTHD CT
WHERE CT.MASP IN('BB01', 'BB02') AND SL BETWEEN 10 AND 20
--13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT DISTINCT CT.SOHD
FROM CTHD CT
WHERE CT.MASP = 'BB01' AND CT.SL BETWEEN 10 AND 20
INTERSECT
SELECT DISTINCT CT.SOHD
FROM CTHD CT
WHERE CT.MASP = 'BB02' AND CT.SL BETWEEN 10 AND 20
--14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007.
SELECT SP.MASP, SP.TENSP
FROM SANPHAM SP, HOADON HD, CTHD CT
WHERE SP.MASP = CT.MASP AND HD.SOHD = CT.SOHD AND NUOCSX = 'Trung Quoc' 
UNION
SELECT SP.MASP, SP.TENSP
FROM SANPHAM SP, HOADON HD, CTHD CT
WHERE SP.MASP = CT.MASP AND HD.SOHD = CT.SOHD AND NGHD = '1/1/2007' 

--15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
SELECT MASP, TENSP
FROM SANPHAM SP
WHERE NOT EXISTS (SELECT * FROM SANPHAM SP2 INNER JOIN CTHD CT ON SP2.MASP = CT.MASP AND SP2.MASP = SP.MASP)
--16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006
SELECT SP.MASP, TENSP
FROM SANPHAM SP
WHERE SP.MASP NOT IN
(SELECT CT.MASP FROM CTHD CT INNER JOIN HOADON HD ON CT.SOHD = HD.SOHD WHERE YEAR(NGHD) = 2006)
--17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
SELECT SP.MASP, TENSP
FROM SANPHAM SP
WHERE NUOCSX = 'Trung Quoc' AND 
SP.MASP NOT IN 
(SELECT CT.MASP FROM CTHD CT INNER JOIN HOADON HD ON CT.SOHD = HD.SOHD WHERE YEAR(NGHD) = 2006)
--18. Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.
SELECT HD.SOHD
FROM HOADON HD 
WHERE NOT EXISTS(SELECT * 
				 FROM SANPHAM SP
				 WHERE NUOCSX = 'Singapore'
				 AND NOT EXISTS(SELECT *
				 FROM CTHD CT
				 WHERE CT.SOHD = HD.SOHD
				 AND CT.MASP = SP.MASP))
--20 - 26
--19. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
SELECT HD.SOHD
FROM HOADON HD
WHERE YEAR(NGHD) = 2006 AND NOT EXISTS(SELECT * 
									   FROM SANPHAM SP
									   WHERE NUOCSX = 'Singapore'
									   AND NOT EXISTS(SELECT *
									   FROM CTHD CT
									   WHERE CT.SOHD = HD.SOHD
									   AND CT.MASP = SP.MASP))
--20. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(*)
FROM HOADON HD
WHERE MAKH NOT IN (SELECT KH.MAKH FROM KHACHHANG KH WHERE KH.MAKH = HD.MAKH)
--21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT COUNT(DISTINCT MASP)
FROM CTHD CT INNER JOIN HOADON HD
ON CT.SOHD = HD.SOHD
WHERE YEAR(NGHD) = 2006
--22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
SELECT MAX(TRIGIA) AS MAX, MIN(TRIGIA) AS MIN
FROM HOADON
--23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA)
FROM HOADON HD INNER JOIN CTHD CT
ON CT.SOHD = HD.SOHD
WHERE YEAR(NGHD) = 2006
--24. Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(NGHD) = 2006
--25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT SOHD
FROM HOADON
WHERE YEAR(NGHD) = 2006 AND TRIGIA = (SELECT MAX(TRIGIA) FROM HOADON)
--26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT HOTEN
FROM KHACHHANG KH INNER JOIN HOADON HD ON KH.MAKH = HD.MAKH
WHERE SOHD = (SELECT SOHD 
			  FROM HOADON 
			  WHERE TRIGIA = (SELECT MAX(TRIGIA) 
							  FROM HOADON)) AND YEAR(NGHD) = 2006

-- BTTH tuần 4:Làm từ câu 27 ---> 45
--27. In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất.
SELECT TOP 3 MAKH, HOTEN 
FROM KHACHHANG
ORDER BY DOANHSO DESC
--28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (SELECT DISTINCT TOP 3 GIA
			  FROM SANPHAM
			  ORDER BY GIA DESC)

--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Thai Lan' AND GIA IN (SELECT DISTINCT TOP 3 GIA 
									  FROM SANPHAM
									  ORDER BY GIA DESC)
--30. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIA IN (SELECT DISTINCT TOP 3 GIA
										FROM SANPHAM
										WHERE NUOCSX = 'Trung Quoc'
										ORDER BY GIA DESC)
--31. * In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).

--32. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(DISTINCT MASP)
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
--33. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT NUOCSX, COUNT(DISTINCT MASP) AS TONGSPTUNGNUOC
FROM SANPHAM
GROUP BY NUOCSX
--34. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX, MAX(GIA) AS GIA_MAX, MIN(GIA) AS GIA_MIN, AVG(GIA) AS TB_GIA
FROM SANPHAM
GROUP BY NUOCSX
--35. Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) AS DOANHTHUMOINGAY
FROM HOADON
GROUP BY NGHD
--36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT MASP, COUNT(DISTINCT MASP) AS TONGSL
FROM SANPHAM
WHERE MASP IN (SELECT MASP
			   FROM CTHD CT INNER JOIN HOADON HD
			   ON CT.SOHD = HD.SOHD
			   WHERE MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006)
GROUP BY MASP
--37. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHTHUMOITHANG
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
--38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT *
FROM HOADON
WHERE SOHD IN(SELECT SOHD
			  FROM CTHD 
			  WHERE SL >= 4)
--39. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT *
FROM HOADON
WHERE SOHD IN (SELECT SOHD
			   FROM CTHD CT INNER JOIN SANPHAM SP
			   ON CT.MASP = SP.MASP
			   WHERE NUOCSX = 'Viet Nam' AND SL >= 3)
--40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
SELECT MAKH, HOTEN
FROM KHACHHANG
WHERE MAKH IN (SELECT TOP 1 MAKH
			  FROM HOADON
			  GROUP BY MAKH
			  ORDER BY COUNT(DISTINCT SOHD) DESC)
--41. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT TOP 1 MONTH(NGHD) AS THANG_DS_MAX
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY SUM(TRIGIA) DESC
--42. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT MASP, TENSP   
FROM SANPHAM 
WHERE MASP = (SELECT TOP 1 MASP
			   FROM CTHD CT INNER JOIN HOADON HD
			   ON CT.SOHD = HD.SOHD
			   WHERE YEAR(NGHD) = 2006
			   GROUP BY MASP
			   ORDER BY SUM(SL) DESC)
--43. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
-- TÌM MAX GIÁ CỦA TỪNG NƯỚC SẢN XUẤT
SELECT NUOCSX, MAX(GIA) AS MAX_GIA
FROM SANPHAM
GROUP BY NUOCSX

SELECT B.NUOCSX, MASP, TENSP
FROM (SELECT NUOCSX, MAX(GIA) AS MAX
FROM SANPHAM
GROUP BY NUOCSX) AS B LEFT JOIN SANPHAM S 
ON S.GIA = B.MAX 
WHERE B.NUOCSX = S.NUOCSX
--
--44. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
--45. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
SELECT TOP 10 MAKH
FROM KHACHHANG
ORDER BY DOANHSO DESC

SELECT MAKH, COUNT(SOHD)
FROM HOADON
GROUP BY MAKH

SELECT TOP 1 A.MAKH
FROM (SELECT TOP 10 MAKH
FROM KHACHHANG
ORDER BY DOANHSO DESC) AS A
LEFT JOIN 
(SELECT MAKH, COUNT(SOHD) AS SL
FROM HOADON
GROUP BY MAKH) AS B
ON A.MAKH = B.MAKH
ORDER BY SL DESC



-- BTTH tuần 5
-- QLBH
--11. Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó đăng ký thành viên (NGDK).
CREATE TRIGGER nghd_ngdk_hoadon_insert
ON HOADON
AFTER INSERT
AS
DECLARE @ng_muahang smalldatetime
DECLARE @ng_dangky smalldatetime
SELECT @ng_muahang=NGHD, @ng_dangky=NGDK
FROM KHACHHANG, inserted
WHERE KHACHHANG.MAKH=inserted.MAKH
IF @ng_muahang< @ng_dangky
BEGIN
rollback transaction
print ‘ngay mua hang phai lon hon ngay dang ky’
END;
------------------------------------------------------
CREATE TRIGGER nghd_ngdk_hoadon_update
ON HOADON
AFTER UPDATE
AS
IF (UPDATE (MAKH) OR UPDATE (NGHD))
BEGIN
DECLARE @ng_muahang smalldatetime
DECLARE @ng_dangky smalldatetime
SELECT @ng_muahang=NGHD, @ng_dangky=NGDK
FROM KHACHHANG, inserted
WHERE KHACHHANG.MAKH=inserted.MAKH
IF @ng_muahang< @ng_dangky
BEGIN
rollback transaction
print ‘ngay mua hang phai lon hon ngay dang ky’
END
END;
-------------------------------------------------------------
CREATE TRIGGER nghd_ngdk_khachhang_update
ON KHACHHANG
AFTER UPDATE
AS
DECLARE @ng_dangky smalldatetime, @makhhang char(4)
SELECT @ng_dangky=NGDK, @makhhang=MAKH
FROM inserted
IF (UPDATE (NGDK))
BEGIN
IF (EXISTS (SELECT *
FROM HOADON
WHERE MAKH=@makhhang AND @ng_dangky>NGHD))
BEGIN
rollback transaction
print ‘thao tac sua ngay dang ky phai nho hon ngay hoa don’
END
END;


--12. Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm.
-- Thêm cho bảng nhân viên
CREATE TRIGGER nghd_ngvl_nhanvien_insert
ON NHANVIEN 
AFTER INSERT
AS
DECLARE @ng_hoadon smalldatetime
DECLARE @ng_vaolam smalldatetime
SELECT @ng_hoadon=NGHD, @ng_vaolam=NGVL
FROM HOADON, inserted
WHERE HOADON.MANV=inserted.MANV
IF @ng_hoadon< @ng_vaolam
BEGIN
rollback transaction
print ‘ngay hoa don phai lon hon ngay vao lam’
END;---------------------------------------------------- Cập nhật cho bảng nhân viênCREATE TRIGGER nghd_ngvl_nhanvien_update
ON NHANVIEN
AFTER UPDATE
AS
DECLARE @ng_vaolam smalldatetime, @manvien char(4)
SELECT @ng_vaolam=NGVL, @manvien=MANV
FROM inserted
IF (UPDATE (NGVL))
BEGIN
IF (EXISTS (SELECT *
FROM HOADON
WHERE MANV=@manvien AND @ng_vaolam>NGHD))
BEGIN
rollback transaction
print ‘thao tac sua ngay vao lam phai nho hon ngay hoa don’
END
END;----------------------------------------------------------------- Cập nhật cho bảng hóa đơnCREATE TRIGGER nghd_ngvl_hoadon_update
ON HOADON
AFTER UPDATE
AS
IF (UPDATE (NGHD) OR UPDATE (MANV)  )
BEGIN
		DECLARE @ng_hoadon smalldatetime
		DECLARE @ng_vaolam smalldatetime
		SELECT @ng_hoadon=NGHD, @ng_vaolam=NGVL
		FROM HOADON, inserted
		WHERE HOADON.MANV=inserted.MANV
			IF @ng_hoadon< @ng_vaolam
			BEGIN
			rollback transaction
			print ‘ngay hoa don phai lon hon ngay vao lam’
			END
END;
--13. Mỗi một hóa đơn phải có ít nhất một chi tiết hóa đơn.
--Thêm vào cho bảng hóa đơn
CREATE TRIGGER hoadon_insert
ON HOADON
FOR INSERT 
AS
DECLARE @sohd int
SELECT @sohd=SOHD
FROM inserted
UPDATE CTHD
SET MASP ='NONE', SL=0
WHERE SOHD=@sohd
print'Thanh cong. De nghi cap nhat lai chi tiet hoa don'
------------------------------------------------------------
--Xóa bảng chi tiết hóa đơn
CREATE TRIGGER cthd_update_delete
ON CTHD
FOR DELETE, UPDATE
AS
DECLARE @sl int, @sohd int
SELECT @sl=COUNT(C.SOHD), @sohd=D.SOHD
FROM deleted D, CTHD C
WHERE C.SOHD=D.SOHD
GROUP BY D.SOHD

IF(@sl<1)
BEGIN
DELETE FROM HOADON
WHERE SOHD=@sohd
print'Da xoa chi tiet hoa don cuoi cung cua hoa don tren'
END
-----------------------------------------------------------
--14. Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.
-- Thêm cho bảng chi tiết hóa đơn
CREATE TRIGGER hoadon_insert
ON HOADON
FOR INSERT
AS
UPDATE HOADON 
SET TRIGIA=0
WHERE SOHD=(SELECT SOHD
			FROM inserted)
print'Da them 1 hoa don voi tri gia ban dau la 0 VND'
------------------------------------------------------------
-- Cập nhật cho bảng hóa đơn
CREATE TRIGGER hoadon_update
ON HOADON
FOR INSERT 
AS
UPDATE HOADON
SET TRIGIA=(SELECT TRIGIA
			FROM deleted)
WHERE SOHD=(SELECT SOHD
FROM inserted)
print'Da cap nhat 1 hoa don voi tri gia khong thay doi'
-----------------------------------------------------------
-- Thêm cho bảng chi tiết hóa đơn
CREATE TRIGGER cthd_insert
ON CTHD
FOR INSERT 
AS
DECLARE @sl int, @gia money, @sohd int
SELECT @gia=gia, @sl=SL, @sohd=SOHD
FROM inserted i, SANPHAM SP
WHERE i.MASP = SP.MASP

UPDATE HOADON
SET TRIGIA=TRIGIA+@sl*@gia
print'Da them 1 chi tiet hoa don va cap nhat lai tri gia cua hoa don tuong ung'
-----------------------------------------------------------------------------------
-- Xóa bảng chi tiết hóa đơn
CREATE TRIGGER cthd_delete
ON CTHD
FOR DELETE
AS
DECLARE @sl int, @gia money, @sohd int
SELECT @gia=GIA, @sl=SL,@sohd=SOHD
FROM deleted D, SANPHAM SP
WHERE D.MASP = SP.MASP

UPDATE HOADON 
SET TRIGIA=TRIGIA-@sl*@gia
PRINT'Da xoa 1 chi tiet hoa don va cap nhat lai tri gia cua hoa don tuong ung'
-- Cập nhật cho bảng chi tiết hóa đơn
CREATE TRIGGER cthd_update
ON CTHD
FOR UPDATE
AS
DECLARE @sl_old int,
		@sl_new int,
		@gia_old money,
		@gia_new money,
		@sohd_old int, 
		@sohd_new int

SELECT @gia_old=GIA, @sl_old=SL, @sohd_old=SOHD
FROM deleted D, SANPHAM SP
WHERE D.MASP = SP.MASP

SELECT @gia_new=GIA, @sl_new=SL, @sohd_new=SOHD
FROM inserted i, SANPHAM SP
WHERE I.MASP = SP.MASP

IF(@sohd_old=@sohd_new)
  BEGIN
  UPDATE HOADON
  SET TRIGIA=TRIGIA+@sl_new*@gia_new-@sl_old*@gia_old
  WHERE SOHD=@sohd_old
  END
ELSE
  BEGIN 
  UPDATE HOADON
  SET TRIGIA=TRIGIA-@sl_old*@gia_old
  WHERE SOHD=@sohd_old

  UPDATE HOADON
  SET TRIGIA=TRIGIA+@sl_new*@gia_new
  WHERE SOHD=@sohd_new
  END
PRINT 'Da cap nhat 1 chi tiet hoa don va cap nhat lai tri gia cua hoa don tuong ung'
--------------------------------------------------------------------------------------
--Cập nhật cho bảng hóa đơn
CREATE TRIGGER hoadon_update
ON HOADON
FOR INSERT
AS
DECLARE @gia_old money,
		@gia_new money, 
		@sohd int,
		@sl int

SELECT @gia_old=GIA
FROM deleted

SELECT @gia_new=GIA
FROM inserted

SELECT @sohd=SOHD, @sl=SL
FROM inserted i, CTHD C
WHERE i.SOHD = C.SOHD

UPDATE HOADON
SET TRIGIA=TRIGIA+@sl*(@gia_new-@gia_old)
WHERE SOHD=@sohd
PRINT 'Da cap nhat 1 hoa don voi tri gia khong thay doi'

--15. Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó đã mua.
--Thêm cho bảng khách hàng
CREATE TRIGGER kh_insert
ON KHACHHANG
FOR INSERT
AS
DECLARE @makh char(4)

SELECT @makh=MAKH FROM inserted

UPDATE KHACHHANG SET DOANHSO=0
WHERE MAKH=@makh
PRINT 'Da them 1 khach hang moi voi doanh so ban dau la 0 VND'
-----------------------------------------------------------------------
--Cập nhật cho bảng khách hầng
CREATE TRIGGER kh_update
ON KHACHHANG
FOR UPDATE
AS
DECLARE @makh char(4), @doanhso_old money

SELECT @makh=MAKH FROM inserted
SELECT @doanhso_old=DOANHSO FROM deleted

UPDATE KHACHHANG 
SET DOANHSO=@doanhso_old
WHERE MAKH=@makh
PRINT'Da cap nhat 1 khach hang'
---------------------------------------------------------------------
-- Thêm bảng hóa đơn
CREATE TRIGGER hd_insert
ON HOADON
FOR INSERT
AS
DECLARE @trigia money, @makh char(4)

SELECT @makh=MAKH, @trigia=TRIGIA FROM inserted

UPDATE KHACHHANG
SET DOANHSO=DOANHSO+@trigia
WHERE MAKH=@makh
PRINT'Da them 1 hoa don moi va cap nhat lai doanh so cua khach hang có so hoa don tren'
---------------------------------------------------------------------------------------------
-- Xóa bảng hóa đơn
CREATE TRIGGER hoadon_delete
ON HOADON
FOR DELETE
AS
DECLARE @trigia money, @makh char(4)

SELECT @makh=MAKH, @trigia=TRIGIA FROM DELETED

UPDATE KHACHHANG 
SET DOANHSO=DOANHSO-@trigia
WHERE MAKH=@makh
PRINT'Da xoa 1 hoa don moi va cap nhat lai doanh so của khach co so hoa don tren'
------------------------------------------------------------------------------------
--Cập nhật cho bảng hóa đơn
CREATE TRIGGER hoadon_update
ON HOADON
FOR UPDATE 
AS
DECLARE @trigia_old money, @trigia_new money, @makh char(4)

SELECT @makh=MAKH, @trigia_new=TRIGIA FROM inserted
SELECT @makh=MAKH, @trigia_old=TRIGIA FROM deleted

UPDATE KHACHHANG
SET DOANHSO=DOANHSO+@trigia_new-@trigia_old
WHERE MAKH=@makh
PRINT'Da cap nhat 1 hoa don moi va cap nhat lai doanh so cua khach hang c
co so hoa don tren'










-- QLGV
--10. Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”.
--15. Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong môn học này.
--16. Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn.
--17. Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó.
--18. Trong quan hệ DIEUKIEN giá trị của thuộc tính MAMH và MAMH_TRUOC trong cùng một bộ không được giống nhau (“A”,”A”) và cũng không tồn tại hai bộ (“A”,”B”) và (“B”,”A”).
--19. Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau.
--20. Học viên chỉ được thi lại (lần thi >1) khi điểm của lần thi trước đó dưới 5.
--21. Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước (cùng học viên, cùng môn học).
--22. Học viên chỉ được thi những môn mà lớp của học viên đó đã học xong.
--23. Khi phân công giảng dạy một môn học, phải xét đến thứ tự trước sau giữa các môn học (sau khi học xong những môn học phải học trước mới được học những môn liền sau).
--24. Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ trách.











