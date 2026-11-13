# Khắc phục sự cố

[← Hướng dẫn sử dụng](../README.md)

## Vẫn lỗi -101 hoặc mất ô tìm kiếm

1. Đảm bảo đã chạy `Start-Steam-Network.cmd` sau khi bật máy và đã chọn **Yes** ở hộp thoại Administrator.
2. Kiểm tra Task Manager có tiến trình `goodbyedpi.exe`.
3. Quay lại Store, nhấn **Ctrl + R**. Nếu cần, thoát Steam bằng **Steam → Exit**, rồi mở lại sau khi công cụ đã chạy.
4. Nếu có bản GoodbyeDPI khác đang chạy, dừng bản đó trước. Script từ chối chạy thêm bản khác để tránh xung đột.
5. Xem `logs/goodbyedpi.log` và `logs/goodbyedpi-error.log`. Một số dòng log có thể chưa xuất hiện ngay do chương trình đệm đầu ra.

Sau mỗi lần khởi động lại Windows, bạn cần chạy Start lại. Bộ script không tự khởi động cùng Windows.

## Tải hoặc kiểm tra file không thành công

- **SHA256 mismatch:** không chạy file vừa tải. Thử tải lại từ bản phát hành chính thức. Không sửa checksum để bỏ qua lỗi.
- **Runtime integrity check failed:** dừng công cụ, xóa riêng thư mục `.runtime`, rồi chạy Start hoặc Setup để tải bản sạch.
- **Không truy cập được GitHub:** thử lại khi kết nối tới GitHub hoạt động. Lần cài đầu cần tải gói upstream từ GitHub.
- **Driver signature verification failed:** giữ nguyên cơ chế kiểm tra chữ ký driver của Windows và gửi thông báo lỗi để kiểm tra.

Nếu phần mềm bảo vệ chặn driver, hướng dẫn này không yêu cầu bạn tắt Defender hoặc tắt các cơ chế bảo vệ của Windows.

## Không bật được công cụ

- Dùng Windows 10/11 **x64**, không phải ARM64 hoặc Windows 32-bit.
- Giải nén toàn bộ ZIP vào thư mục có quyền ghi trước khi chạy.
- Chấp nhận hộp thoại Administrator. WinDivert cần quyền này để lọc gói tin.
- Nếu xuất hiện `Another copy of GoodbyeDPI is running`, dừng bản trước bằng script Stop tương ứng hoặc đóng chương trình đó.
- Nếu báo `Administrator helper failed` mà chưa có log, mở PowerShell bằng **Run as administrator**, vào thư mục đã giải nén rồi chạy `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Steam-Network.ps1` để xem lỗi cụ thể.

## Báo lỗi

Mở [issue](https://github.com/hngoos/steam-store-fix-vn/issues/new), cho biết phiên bản Windows, nhà mạng, triệu chứng và thông báo lỗi liên quan.

Không gửi mật khẩu, mã Steam Guard, cookie hoặc token đăng nhập. Nếu gửi ảnh, che tên tài khoản và thông tin cá nhân.

Kết quả phụ thuộc nhà mạng và thời điểm. Hãy kiểm tra việc tải Store thực tế: việc script chạy thành công chưa đảm bảo mọi kết nối Steam đều hoạt động.
