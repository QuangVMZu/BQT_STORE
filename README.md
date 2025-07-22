# 🏬 **MÔ TẢ CHI TIẾT DỰ ÁN: BQT STORE**

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🔹 1. Giới thiệu tổng quan

**BQT STORE** là một hệ thống thương mại điện tử (E-commerce Website) được phát triển với mục đích mô phỏng quy trình mua bán trực tuyến các sản phẩm mô hình ô tô và phụ kiện. Đây là sản phẩm của nhóm sinh viên nhằm vận dụng kiến thức về **lập trình Java Web (JSP/Servlet)**, thiết kế giao diện với **Bootstrap**, và quản lý cơ sở dữ liệu bằng **SQL Server**.

Mục tiêu của dự án là tạo ra một website dễ sử dụng, có giao diện hiện đại, hỗ trợ đầy đủ các chức năng cơ bản của một hệ thống bán hàng online: quản lý sản phẩm, giỏ hàng, thanh toán đơn hàng, phân quyền người dùng, và quản trị nội dung.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🔹 2. Đối tượng sử dụng

| Vai trò        | Mô tả                                                                 |
| -------------- | --------------------------------------------------------------------- |
| **Khách hàng** | Có thể duyệt sản phẩm, xem chi tiết, thêm vào giỏ hàng, thanh toán.   |
| **Admin**      | Quản lý sản phẩm, đơn hàng, tài khoản người dùng, nội dung trang chủ. |

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🔹 3. Công nghệ sử dụng

| Thành phần           | Công nghệ                                                 |
| -------------------- | --------------------------------------------------------- |
| Giao diện người dùng | HTML5, CSS3, Bootstrap 5, JavaScript                      |
| Ngôn ngữ lập trình   | Java Servlet, JSP                                         |
| Xử lý động frontend  | JSTL (JSP Standard Tag Library), Expression Language (EL) |
| Cơ sở dữ liệu        | SQL Server                                                |
| IDE phát triển       | Apache NetBeans                                           |
| ChatBot              | ChatBase(bản thử nghiệm)                                  |
| Deploy thử nghiệm    | Ngrok (xuất localhost ra Internet)                        |
| Upload hình ảnh      | Apache Commons FileUpload                                 |

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🔹 4. Cấu trúc hệ thống

### 4.1 Kiến trúc tổng thể

Hệ thống tuân theo mô hình **MVC**:

* **Model (DAO Layer)**: xử lý truy vấn cơ sở dữ liệu, gồm các lớp `ProductDAO`, `CartDAO`, `OrderDAO`, `CustomerDAO`, v.v.
* **View (JSP Pages)**: hiển thị dữ liệu bằng JSTL + EL, responsive với Bootstrap.
* **Controller (Servlet)**: điều hướng luồng xử lý nghiệp vụ. Ví dụ: `ProductDetailServlet`, `CartServlet`, `AdminUploadIntroServlet`,...

### 4.2 Cơ sở dữ liệu

Gồm các bảng chính:

* `modelCar`, `accessory`: Lưu sản phẩm mô hình và phụ kiện
* `customer`, `admin`: Thông tin người dùng
* `orders`, `order_details`: Thông tin đơn hàng
* `customer_cart`: Giỏ hàng của từng người dùng
* `home_intro`, `home_gallery`: Dữ liệu nội dung trang chủ

Các bảng đều có khóa chính – khóa ngoại rõ ràng, chuẩn hóa dữ liệu theo dạng **third normal form (3NF)**.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🔹 5. Tính năng chi tiết

### 5.1 Trang chủ (Home)

* Banner lớn có thể chỉnh sửa nội dung qua admin.
* Carousel ảnh thư viện và giới thiệu về cửa hàng (cập nhật từ CSDL).
* Hiển thị sản phẩm mới nhất, sản phẩm nổi bật.

### 5.2 Trang danh sách sản phẩm

* Sử dụng carousel hoặc layout dạng lưới để hiển thị sản phẩm.
* Tách riêng giữa mô hình ô tô và phụ kiện.
* Mỗi sản phẩm hiển thị ảnh, tên, giá, và nút "Chi tiết".

### 5.3 Trang chi tiết sản phẩm

* Hiển thị thông tin chi tiết (mô tả, ảnh lớn, ảnh phụ).
* Hỗ trợ thêm vào giỏ hàng.
* Nếu là **ModelCar**: có thêm thông tin brand, scale.
* Nếu là **Accessory**: không hiển thị các chi tiết không liên quan.

### 5.4 Giỏ hàng (Cart)

* Quản lý sản phẩm đã chọn: số lượng, xóa, cập nhật.
* Tính tổng tiền tự động.
* Phân quyền: nếu chưa đăng nhập → chuyển hướng sang `login.jsp`.

### 5.5 Thanh toán (Checkout)

* Gửi đơn hàng vào CSDL, lưu `orderId`, `orderDate`, `status`.
* Cập nhật bảng `order_details` với từng sản phẩm trong giỏ.
* Xử lý trạng thái đơn hàng (PENDING → CONFIRMED,...).

### 5.6 Tài khoản người dùng

* Đăng ký/Đăng nhập với vai trò `customer` hoặc `admin`.
* Duy trì trạng thái đăng nhập bằng session.
* Quản lý đơn hàng cá nhân (đang phát triển).

### 5.7 Quản trị viên

* Đăng nhập bằng tài khoản admin.
* Chức năng:

  * **Quản lý sản phẩm**: CRUD sản phẩm và ảnh.
  * **Quản lý thư viện ảnh trang chủ**.
  * **Chỉnh sửa nội dung giới thiệu homepage (text + ảnh)**.
  * **Quản lý đơn hàng**: xem chi tiết và cập nhật trạng thái.
  * **Phân quyền truy cập**: servlet kiểm tra `isAdmin`.
 
 ### 5.8 Chatbot hỗ trợ khách hàng (Chatbase)
* Tích hợp chatbot từ nền tảng Chatbase AI dưới dạng cửa sổ popup giống Messenger.
* Giao diện bật/tắt qua nút tròn nhỏ ở góc phải dưới trang.
* Lưu lịch sử trò chuyện theo session người dùng (ẩn danh hoặc đã đăng nhập).
* Ẩn API key trong Servlet, đảm bảo an toàn truy cập khi gửi truy vấn đến Chatbase.
* Hỗ trợ người dùng:
  ** Tìm kiếm sản phẩm nhanh.
  ** Gợi ý sản phẩm phổ biến.
* Có thể dễ dàng mở rộng để hỗ trợ thêm FAQ, phản hồi khách hàng, hoặc tư vấn sản phẩm theo ngữ cảnh.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🔹 6. Giao diện & UX/UI

* Thiết kế hiện đại, nhẹ, dễ điều hướng.
* Tương thích với mobile, tablet, desktop.
* Dùng hiệu ứng carousel cho phần sản phẩm và gallery.
* Icon từ **Bootstrap Icons**.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🔹 7. Khó khăn trong quá trình phát triển

| Vấn đề                                 | Giải pháp triển khai                                            |
| -------------------------------------- | --------------------------------------------------------------- |
| Upload ảnh qua servlet không hoạt động | Sử dụng thư viện `Apache Commons FileUpload` để xử lý multipart |
| Ảnh không hiển thị sau Clean & Build   | Chuyển sang lưu ảnh vào thư mục upload riêng & lưu path CSDL    |
| Phân quyền admin chưa hiệu quả         | Tạo phương thức `AuthUtils.isAdmin()` cho các servlet kiểm tra  |
| Ngrok lỗi 403 khi deploy               | Cấu hình lại servlet-mapping và testing port cố định            |

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🔹 8. Hướng phát triển trong tương lai

* 🎨 Giao diện tùy chỉnh theo từng người dùng
* 💳 Tích hợp thanh toán online (VNPay, Paypal)
* 💬 Hệ thống đánh giá + bình luận sản phẩm
* 📈 Trang dashboard thống kê cho admin (doanh thu, lượt mua, lượt truy cập,...)
* 🤖 Tích hợp Chatbot hỗ trợ khách (Chatbase, GPT, etc.)
* 🔒 Mã hóa mật khẩu, xác thực 2 lớp, quên mật khẩu

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🔹 9. Đánh giá tổng quan

| Tiêu chí          | Đánh giá                                                                   |
| ----------------- | -------------------------------------------------------------------------- |
| Mức độ hoàn thiện | 80–90% (hoạt động đầy đủ các chức năng chính, có thể nâng cấp thêm)        |
| Tính thực tế      | Cao – mô phỏng đúng quy trình e-commerce phổ biến                          |
| Tính học thuật    | Rõ ràng – áp dụng đúng mô hình MVC2, DAO, phân lớp theo nghiệp vụ           |
| Khả năng mở rộng  | Linh hoạt – có thể tích hợp API, nâng cấp UI, thêm module quản lý nâng cao |

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🔹 10. Tổng kết

**BQT STORE** là một dự án thương mại điện tử hoàn chỉnh quy mô nhỏ, thể hiện được khả năng áp dụng lý thuyết vào thực tiễn, từ xử lý backend đến thiết kế frontend. Dự án mang tính ứng dụng cao, có thể triển khai thực tế với một số nâng cấp nhỏ. Đây cũng là nền tảng quan trọng giúp nhóm thành viên nâng cao kỹ năng lập trình, thiết kế hệ thống, làm việc nhóm, và giải quyết vấn đề.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

