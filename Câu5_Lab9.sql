CREATE TRIGGER tr_updateNhap
ON Nhap
AFTER UPDATE
AS
BEGIN
    -- Kiểm tra số bản ghi thay đổi
    IF (SELECT COUNT(*) FROM inserted) > 1
    BEGIN
        RAISERROR('Chỉ được phép cập nhật 1 bản ghi tại một thời điểm', 16, 1)
        ROLLBACK
    END
    
    -- Kiểm tra số lượng nhập
    DECLARE @masp INT
    DECLARE @soluongN INT
    DECLARE @soluong INT
    
    SELECT @masp = i.masp, @soluongN = i.soluongN, @soluong = s.soluong
    FROM inserted i
    INNER JOIN Sanpham s ON i.masp = s.masp
    
    IF (@soluongN > @soluong)
    BEGIN
        RAISERROR('Số lượng nhập không được vượt quá số lượng hiện có trong kho', 16, 1)
        ROLLBACK
    END
    
    -- Cập nhật số lượng trong bảng Sanpham
    UPDATE Sanpham
    SET soluong = soluong + (@soluongN - (SELECT soluongN FROM deleted WHERE masp = @masp))
    WHERE masp = @masp
END

go

go