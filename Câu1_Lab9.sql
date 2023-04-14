CREATE TRIGGER trg_Nhap_CheckConstraints
ON Nhap
AFTER INSERT
AS
BEGIN
    DECLARE @masp NVARCHAR(10)
    DECLARE @manv NVARCHAR(10)
    DECLARE @soluongN INT
    DECLARE @dongiaN FLOAT

    SELECT @masp = masp, @manv = manv, @soluongN = soluongN, @dongiaN = dongiaN
    FROM inserted
    
    -- Kiểm tra masp có trong bảng Sanpham chưa
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        RAISERROR('Lỗi: masp không tồn tại trong bảng Sanpham', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Kiểm tra manv có trong bảng Nhanvien chưa
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RAISERROR('Lỗi: manv không tồn tại trong bảng Nhanvien', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Kiểm tra ràng buộc dữ liệu
    IF @soluongN <= 0 OR @dongiaN <= 0
    BEGIN
        RAISERROR('Lỗi: soluongN và dongiaN phải lớn hơn 0', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Cập nhật số lượng sản phẩm trong bảng Sanpham
    UPDATE Sanpham
    SET soluong = soluong + @soluongN
    WHERE masp = @masp
END

go

go