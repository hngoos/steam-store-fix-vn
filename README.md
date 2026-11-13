<p align="center">
  <img src="docs/assets/steam-store-fix-wordmark.svg" width="740" alt="Steam Store Fix VN">
</p>

**Steam Store Fix VN** hỗ trợ xử lý lỗi **-101**, Store tải thiếu nội dung hoặc mất ô tìm kiếm khi kết nối tới máy chủ Steam bị ngắt trên đường mạng. Công cụ sử dụng GoodbyeDPI, không cần Cloudflare WARP hay VPN.

<p align="center">
  <a href="https://github.com/hngoos/steam-store-fix-vn/releases/latest"><img src="docs/assets/install-windows.svg" width="260" alt="Tải Steam Store Fix VN cho Windows"></a>
</p>

## Tính năng

- **Dành cho Steam:** giới hạn các thao tác với HTTP/TLS theo danh sách tên miền Steam và tên miền con.
- **Bật và tắt bằng một lần nhấp:** có sẵn script Start/Stop, tự hiển thị yêu cầu quyền Administrator.
- **Tải từ nguồn chính thức:** tự tải phiên bản GoodbyeDPI đã cố định, kiểm tra SHA256 của gói, các file thực thi và chữ ký driver WinDivert.
- **Giữ nguyên cài đặt:** không đổi DNS, proxy của Windows, cài đặt Steam hoặc file game.
- **Chạy khi cần:** không tự khởi động cùng Windows; có log để hỗ trợ tìm lỗi.

## Tải về

Phiên bản hiện tại: **v0.1.0**.

### Windows

**Windows 10/11 | x64**

[Tải bản ZIP cho Windows](https://github.com/hngoos/steam-store-fix-vn/releases/download/v0.1.0/steam-store-fix-vn-v0.1.0.zip)

Không cần cài Git, Python hoặc Node.js. Máy cần kết nối được GitHub để tải thành phần GoodbyeDPI trong lần chạy đầu. Bạn cũng có thể chọn **Code → Download ZIP** để tải mã nguồn kèm các script.

### Sử dụng

1. **Giải nén toàn bộ** file ZIP ra một thư mục riêng, ví dụ `D:\Tools\SteamStoreFix`.
2. Nhấp đúp **`Start-Steam-Network.cmd`**. Lần đầu, script tải và kiểm tra GoodbyeDPI.
3. Khi Windows hỏi quyền **Administrator**, chọn **Yes**. Công cụ sẽ chạy nền.
4. Mở Steam → **Store**, nhấn **Ctrl + R** để tải lại trang.

Sau khi khởi động lại Windows, chạy lại `Start-Steam-Network.cmd` trước khi sử dụng Store. Không chạy trực tiếp bên trong file ZIP; đóng bản GoodbyeDPI khác nếu đang sử dụng.

### Tắt và gỡ

- **Tắt:** chạy **`Stop-Steam-Network.cmd`** và chấp nhận yêu cầu Administrator. Script chỉ dừng bản công cụ trong thư mục này.
- **Gỡ:** tắt công cụ rồi xóa thư mục đã giải nén.

## Khi nào nên thử?

- Steam báo **Error Code: -101** hoặc **Unable to connect to server**.
- Store hiện ảnh game nhưng thiếu thanh điều hướng hoặc ô tìm kiếm.
- Một số nội dung, CSS, JavaScript hoặc API của Steam không tải được.
- Steam hoạt động khi dùng VPN hoặc mạng khác, nhưng lỗi trên đường mạng hiện tại.

Các dấu hiệu trên giúp khoanh vùng; chúng không chứng minh chắc chắn nguyên nhân. Công cụ không sửa được mọi lỗi Store, chẳng hạn khi Steam đang bảo trì, máy mất mạng hoặc tài khoản có vấn đề.

## Cách hoạt động

Script chạy [GoodbyeDPI](https://github.com/ValdikSS/GoodbyeDPI) với cấu hình `-5 --blacklist steam-domains.txt --max-payload 0`. WinDivert cần quyền Administrator để xử lý gói tin trên máy. Phạm vi được xác định theo **tên miền**, nên ứng dụng khác truy cập cùng tên miền Steam cũng nằm trong phạm vi này.

Repo cố định bản **GoodbyeDPI 0.2.3rc3**, gói `goodbyedpi-0.2.3rc3-2.zip`. Đây là bản upstream gắn nhãn release candidate. File thực thi được tải trực tiếp từ bản phát hành chính thức vào `.runtime/`; repo không tự chuyển sang phiên bản khác.

Không hỗ trợ Windows ARM64, Windows 32-bit, macOS hoặc Linux. Công cụ không cài GoodbyeDPI thành dịch vụ nền thường trực; driver WinDivert được sử dụng khi công cụ chạy.

## Hỗ trợ và đóng góp

- [Vẫn lỗi -101, mất ô tìm kiếm hoặc công cụ không chạy](docs/TROUBLESHOOTING.md)
- [Cấu trúc repo, kiểm thử và đóng góp](docs/DEVELOPMENT.md)
- [Lịch sử thay đổi](CHANGELOG.md)

<details>
<summary>English quick start</summary>

A Windows x64 launcher for GoodbyeDPI, intended for Steam Store connection resets (`-101`) and incomplete Store pages, including a missing search bar. Download and extract the release ZIP, run `Start-Steam-Network.cmd`, accept the Administrator prompt, then refresh the Steam Store with Ctrl+R. Run `Stop-Steam-Network.cmd` to stop this copy. Run Start again after restarting Windows.

No VPN or Cloudflare WARP is required. HTTP/TLS modifications are scoped to listed Steam domains and their subdomains. The launcher verifies a pinned official release, leaves Windows DNS/proxy settings unchanged, and cannot fix every cause of Store errors.

</details>

## Ghi công

Phần xử lý kết nối do [GoodbyeDPI của ValdikSS](https://github.com/ValdikSS/GoodbyeDPI) và [WinDivert của basil00](https://github.com/basil00/WinDivert) cung cấp. Xem [giấy phép thành phần bên thứ ba](THIRD_PARTY_NOTICES.md).

Đây là công cụ cộng đồng độc lập, không phải sản phẩm của Valve.

## Liên hệ

<p align="left">
  <a href="https://www.facebook.com/hngoos"><img src="docs/assets/contact-facebook.svg" width="40" height="40" alt="Facebook"></a>
  <a href="https://www.instagram.com/hngoos/"><img src="docs/assets/contact-instagram.svg" width="40" height="40" alt="Instagram"></a>
  <a href="mailto:1hngoos@gmail.com"><img src="docs/assets/contact-gmail.svg" width="40" height="40" alt="Email 1hngoos@gmail.com"></a>
  <a href="https://github.com/hngoos"><img src="docs/assets/contact-github.svg" width="40" height="40" alt="GitHub hngoos"></a>
</p>

[Báo lỗi](https://github.com/hngoos/steam-store-fix-vn/issues/new) · [Giấy phép MIT](LICENSE)
