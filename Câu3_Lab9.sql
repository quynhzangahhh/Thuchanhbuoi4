CREATE TRIGGER updateSoluongXoaPhieuXuat
ON Xuat
AFTER DELETE
AS
BEGIN
    -- Cập nhật số lượng hàng trong bảng Sanpham tương ứng với sản phẩm đã xuất
    UPDATE Sanpham
    SET Soluong = Sanpham.Soluong + deleted.soluongX
    FROM Sanpham
    JOIN deleted ON Sanpham.Masp = deleted.Masp
END
go

go