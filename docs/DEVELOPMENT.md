# Kiểm thử và đóng góp

[← Hướng dẫn sử dụng](../README.md)

## Cấu trúc

| File | Công dụng |
| --- | --- |
| `Start-Steam-Network.cmd` | Chuẩn bị thành phần nếu chưa có, xin quyền Administrator và bật công cụ |
| `Stop-Steam-Network.cmd` | Dừng bản công cụ trong thư mục hiện tại |
| `Setup.cmd` | Chỉ tải và kiểm tra GoodbyeDPI, chưa bật lọc kết nối |
| `Steam-Network.ps1` | Quản lý bật/tắt và ghi log |
| `Install-GoodbyeDPI.ps1` | Tải, giải nén và kiểm tra tính toàn vẹn |
| `steam-domains.txt` | Phạm vi tên miền Steam |
| `upstream.json` | URL và SHA256 của phiên bản upstream đã cố định |
| `docs/assets/` | Banner và biểu tượng dùng trong README |

Thiết kế phần giới thiệu và thương hiệu Hngoos được điều chỉnh từ [repo HDM](https://github.com/hngoos/hngoos-download-manager).

## Chạy kiểm thử

Yêu cầu Windows PowerShell 5.1 trở lên trên Windows x64:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\Verify-Package.ps1
```

Bộ kiểm thử xác nhận:

- Gói tải sai SHA256 bị chặn trước khi giải nén.
- Gói chính thức cài được trong đường dẫn có dấu cách.
- Setup tái sử dụng bản cài đã kiểm tra thay vì tải lại.
- File thực thi đã cài bị sửa sẽ bị từ chối.

Kiểm thử không bật lọc mạng và không cần cấp quyền Administrator. Mặc định, kiểm thử tích hợp tải gói upstream từ GitHub; có thể truyền `-ArchivePath` tới gói ZIP chính thức đã tải sẵn.

GitHub Actions kiểm tra cú pháp của các script và chạy bộ kiểm thử bằng Windows PowerShell. Đây là kiểm thử đóng gói; việc Store hoạt động phải được xác minh trên đường mạng gặp lỗi.

## Gửi thay đổi

Giữ phạm vi xử lý ở các tên miền Steam. Không đổi DNS/proxy hoặc bật tự khởi động như một tác dụng phụ. Khi cập nhật upstream, kiểm tra gói từ nguồn chính thức và cập nhật cả SHA256 của gói lẫn các file trong `upstream.json`; không bỏ qua kiểm tra để làm cho một bản tải lỗi chạy được.

Không commit `.runtime/`, log, cookie, ảnh tài khoản hoặc file thực thi tải về. Ghi nhận thay đổi có ảnh hưởng tới người dùng trong `CHANGELOG.md`.
