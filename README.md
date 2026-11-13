# Steam Store Fix VN

Hỗ trợ xử lý **Steam Error Code -101**, Store tải thiếu nội dung hoặc mất thanh điều hướng / ô tìm kiếm khi kết nối tới máy chủ Steam bị ngắt trên đường mạng.

Chạy trên **Windows 10/11 x64**, sử dụng [GoodbyeDPI](https://github.com/ValdikSS/GoodbyeDPI). Không cần Cloudflare WARP hay VPN.

> Đây là bộ script cộng đồng, không phải phần mềm của Valve. Công cụ chỉ phù hợp với một số trường hợp kết nối bị can thiệp trên đường mạng; không sửa được mọi nguyên nhân gây lỗi Store.

## Tải và chạy

1. Vào [Releases](https://github.com/hngoos/steam-store-fix-vn/releases/latest), tải **steam-store-fix-vn-v0.1.0.zip**. Bạn cũng có thể chọn **Code → Download ZIP**.
2. **Giải nén toàn bộ** ra một thư mục riêng, ví dụ `D:\Tools\SteamStoreFix`. Không chạy trực tiếp bên trong file ZIP.
3. Nhấp đúp **`Start-Steam-Network.cmd`**. Lần đầu, script tự tải GoodbyeDPI từ kho chính thức, kiểm tra SHA256 của gói và chữ ký driver WinDivert.
4. Khi Windows hỏi quyền **Administrator**, chọn **Yes**. GoodbyeDPI sẽ chạy nền.
5. Quay lại Steam → **Store**, nhấn **Ctrl + R** để tải lại trang.

Sau khi khởi động lại Windows, chạy lại `Start-Steam-Network.cmd` trước khi sử dụng Store. Công cụ không tự khởi động cùng Windows.

**Muốn tắt:** nhấp đúp **`Stop-Steam-Network.cmd`** và chấp nhận yêu cầu Administrator. Script chỉ dừng bản GoodbyeDPI nằm trong thư mục này.

**Muốn gỡ:** tắt công cụ rồi xóa thư mục đã giải nén.

## Những trường hợp có thể phù hợp

- Steam hiển thị **Error Code: -101** / **Unable to connect to server**.
- Store hiện ảnh game nhưng thiếu thanh menu hoặc ô tìm kiếm.
- Store tải được một phần, còn ảnh, CSS, JavaScript hoặc API bị lỗi kết nối.
- Steam hoạt động qua VPN hoặc mạng khác nhưng lỗi khi dùng đường mạng hiện tại.

Các dấu hiệu trên giúp khoanh vùng, không chứng minh chắc chắn nguyên nhân. Nếu Steam đang bảo trì, mạng bị mất kết nối hoặc tài khoản có vấn đề, công cụ này có thể không giúp được.

## Công cụ thay đổi gì?

- Áp dụng cấu hình GoodbyeDPI `-5 --blacklist steam-domains.txt --max-payload 0`.
- Các thao tác với HTTP/TLS được giới hạn theo **tên miền Steam và tên miền con** trong `steam-domains.txt`, không giới hạn theo tên tiến trình. Ứng dụng khác truy cập cùng tên miền cũng nằm trong phạm vi này.
- Giữ nguyên DNS, proxy của Windows, cài đặt Steam và các file game.
- Không tạo mục tự khởi động hoặc cài GoodbyeDPI thành dịch vụ nền thường trực. Driver WinDivert cần quyền Administrator để lọc gói tin khi công cụ hoạt động.
- Bản tải được cố định ở **GoodbyeDPI 0.2.3rc3**, gói phát hành `goodbyedpi-0.2.3rc3-2.zip`. Đây là bản upstream gắn nhãn release candidate, không phải bản ổn định mới nhất. Repo không tự chuyển sang bản khác.
- Kiểm tra SHA256 của cả gói tải và các file thực thi; kiểm tra chữ ký driver trước khi sử dụng.

Không có file thực thi của GoodbyeDPI trong mã nguồn repo. Chúng được tải trực tiếp từ [bản phát hành chính thức](https://github.com/ValdikSS/GoodbyeDPI/releases/tag/0.2.3rc3) vào `.runtime/`.

## Nếu vẫn mất ô tìm kiếm hoặc còn lỗi -101

1. Đảm bảo đã chạy `Start-Steam-Network.cmd` sau khi bật máy và đã chọn **Yes** ở hộp thoại Administrator.
2. Kiểm tra Task Manager có tiến trình `goodbyedpi.exe`.
3. Tải lại Store bằng **Ctrl + R**. Nếu cần, thoát Steam từ menu **Steam → Exit**, rồi mở lại sau khi công cụ đã chạy.
4. Nếu có bản GoodbyeDPI khác đang chạy, dừng bản đó trước. Script sẽ từ chối chạy thêm một bản để tránh xung đột.
5. Kiểm tra `logs/goodbyedpi.log` và `logs/goodbyedpi-error.log`. Một số dòng log có thể chưa được ghi ngay do chương trình đệm đầu ra.

Nếu thấy **SHA256 mismatch**, không chạy file vừa tải. Thử tải lại từ nguồn chính thức. Nếu thấy **Runtime integrity check failed**, dừng công cụ, xóa riêng thư mục `.runtime`, rồi chạy lại để tải bản sạch. Không thay checksum để bỏ qua lỗi.

Nếu phần mềm bảo vệ chặn driver, hoặc thông báo chữ ký driver không hợp lệ, giữ nguyên các cơ chế bảo vệ và gửi thông báo lỗi để kiểm tra; hướng dẫn này không yêu cầu tắt Defender hay kiểm tra chữ ký driver của Windows.

Khi [báo lỗi](https://github.com/hngoos/steam-store-fix-vn/issues), cho biết phiên bản Windows, nhà mạng, triệu chứng và thông báo lỗi. Không gửi mật khẩu, mã Steam Guard, cookie hoặc token đăng nhập. Nếu gửi ảnh, che tên tài khoản và thông tin cá nhân.

## Cấu trúc

| File | Công dụng |
| --- | --- |
| `Start-Steam-Network.cmd` | Tải thành phần cần thiết nếu chưa có, xin quyền Administrator và bật công cụ |
| `Stop-Steam-Network.cmd` | Dừng bản công cụ trong thư mục hiện tại |
| `Setup.cmd` | Chỉ tải và kiểm tra GoodbyeDPI, chưa bật lọc kết nối |
| `Steam-Network.ps1` | Quản lý bật/tắt và ghi log |
| `Install-GoodbyeDPI.ps1` | Tải, giải nén và kiểm tra tính toàn vẹn |
| `steam-domains.txt` | Phạm vi tên miền Steam |
| `upstream.json` | URL và SHA256 của phiên bản upstream đã cố định |

Không hỗ trợ Windows ARM64, Windows 32-bit, macOS hoặc Linux. Máy cần kết nối được GitHub để tải thành phần ở lần chạy đầu.

## Kiểm thử và đóng góp

Yêu cầu Windows PowerShell 5.1 trở lên trên Windows x64:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\Verify-Package.ps1
```

Bộ kiểm thử xác nhận file tải sai checksum bị chặn trước khi giải nén, cài được vào đường dẫn có dấu cách, tái sử dụng bản cài hợp lệ và từ chối file thực thi bị sửa. Kiểm thử không bật lọc mạng và không cần cấp quyền Administrator. Kiểm thử tích hợp tải gói upstream từ GitHub; cũng có thể truyền `-ArchivePath` tới gói ZIP chính thức đã tải sẵn.

Kết quả phụ thuộc nhà mạng và thời điểm. Hãy xác minh việc tải Store thực tế trên máy gặp lỗi; việc script chạy thành công chưa đảm bảo mọi kết nối Steam đều hoạt động.

## Ghi công và giấy phép

Phần xử lý kết nối do [GoodbyeDPI của ValdikSS](https://github.com/ValdikSS/GoodbyeDPI) và [WinDivert của basil00](https://github.com/basil00/WinDivert) cung cấp. Xem [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

Các script trong repo này sử dụng [giấy phép MIT](LICENSE).

## English

A small Windows x64 launcher for GoodbyeDPI, intended for Steam Store connection resets (`-101`) and incomplete Store pages, including a missing search bar. Download the release ZIP, extract it, run `Start-Steam-Network.cmd`, accept the Administrator prompt, then refresh the Steam Store with Ctrl+R. Run `Stop-Steam-Network.cmd` to stop this copy. Run Start again after restarting Windows.

No VPN or Cloudflare WARP is required. HTTP/TLS modifications are limited to the listed Steam domains and their subdomains. The launcher downloads a pinned official upstream release, verifies archive and binary hashes and the WinDivert driver signature, and leaves Windows DNS/proxy settings unchanged. It cannot fix every cause of Steam Store errors.
