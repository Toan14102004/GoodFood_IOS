# BÁO CÁO THỰC TẬP TỐT NGHIỆP: DỰ ÁN GOODFOOD_IOS

---

## I. PHẦN THỦ TỤC

**Trang bìa:**
- **Trường:** [Tên Trường của bạn]
- **Khoa:** [Khoa Công nghệ thông tin / Kỹ thuật phần mềm]
- **Tên báo cáo:** BÁO CÁO THỰC TẬP TỐT NGHIỆP
- **Tên đề tài:** Phát triển ứng dụng theo dõi dinh dưỡng và nhận diện món ăn bằng AI - GoodFood (iOS)
- **Công ty thực tập:** [Tên Công ty thực tập]
- **Thông tin sinh viên:** 
    - Họ tên: [Họ tên của bạn]
    - Mã SV: [Mã sinh viên]
    - Lớp: [Lớp]
- **Cán bộ hướng dẫn:** [Tên Giảng viên/Mentor]

**Lời cảm ơn:**
- **Đoạn 1:** Em xin gửi lời cảm ơn chân thành tới ban lãnh đạo [Tên Công ty] đã tạo điều kiện thuận lợi nhất để em được tham gia thực tập và tiếp cận với môi trường làm việc thực tế cùng dự án GoodFood.
- **Đoạn 2:** Đặc biệt, em xin cảm ơn [Tên Mentor/Leader] đã trực tiếp hướng dẫn, chỉ bảo tận tình và chia sẻ những kinh nghiệm quý báu trong suốt quá trình xây dựng ứng dụng iOS này.
- **Đoạn 3:** Em cũng xin gửi lời tri ân tới các thầy cô trong Khoa [Tên Khoa] đã trang bị cho em những kiến thức nền tảng vững chắc về lập trình và tư duy phát triển phần mềm để em hoàn thành tốt đợt thực tập này.

**Mục lục:** *(Tự động theo các tiêu đề dưới đây)*

**Danh sách từ viết tắt:**
- **API (Application Programming Interface):** Giao diện lập trình ứng dụng.
- **MVC/MVVM:** Các mô hình kiến trúc phần mềm (Model-View-ViewModel).
- **JSON (JavaScript Object Notation):** Định dạng dữ liệu trao đổi văn bản nhẹ.
- **Firebase:** Nền tảng phát triển ứng dụng di động của Google.
- **Core ML:** Framework học máy của Apple.
- **TDEE (Total Daily Energy Expenditure):** Tổng mức tiêu thụ năng lượng hàng ngày.

---

## CHƯƠNG 1: GIỚI THIỆU CƠ QUAN THỰC TẬP

**1.1. Tên và địa chỉ công ty:** [Tên đầy đủ công ty]
- Website: [Link website]
- Địa chỉ: [Địa chỉ trụ sở]

**1.2. Lịch sử hình thành:** [Tóm tắt ngắn gọn mô hình hoạt động của công ty].

**1.3. Cơ cấu tổ chức:** Công ty gồm các bộ phận: Mobile Team (iOS/Android), Backend Team, Design Team (UI/UX), và Quality Control (QC).

**1.4. Lĩnh vực hoạt động:** Phát triển sản phẩm (Product) về lĩnh vực sức khỏe và công nghệ AI.

**1.5. Nội dung lý thuyết liên quan:**
- **Swift & SwiftUI:** Ngôn ngữ và framework chính để xây dựng giao diện khai báo trên iOS.
- **Firebase Authentication:** Quản lý đăng nhập (Google Sign-In).
- **Cloud Firestore:** Cơ sở dữ liệu NoSQL lưu trữ thông tin người dùng và nhật ký ăn uống.
- **Gemini AI API:** Sử dụng model `gemini-2.0-flash-lite` để nhận diện hình ảnh món ăn và đưa ra gợi ý dinh dưỡng.
- **Apple Core ML:** Triển khai model phân loại món ăn (`DishsClassifier5`) trực tiếp trên thiết bị (Offline).

---

## CHƯƠNG 2: PHÂN TÍCH, THIẾT KẾ VÀ XÂY DỰNG HỆ THỐNG

**2.1. Mô tả công việc được giao:**
- Phân tích yêu cầu hệ thống theo dõi dinh dưỡng cá nhân.
- Thiết kế giao diện (UI) bằng SwiftUI đảm bảo tính thẩm mỹ và trải nghiệm người dùng.
- Tích hợp Firebase để lưu trữ dữ liệu thời gian thực.
- Triển khai tính năng nhận diện món ăn bằng AI thông qua Gemini API và Core ML.
- Xây dựng thuật toán tính toán Kcal và các chỉ số dinh dưỡng (Protein, Carbs, Fat).

**2.2. Phương thức làm việc:**
- **Mô hình:** Làm việc trực tiếp kết hợp trao đổi qua Slack/Git.
- **Quy trình:** Áp dụng mô hình Agile/Scrum với các vòng Sprint kéo dài 2 tuần. Daily meeting hàng sáng để báo cáo tiến độ và giải quyết vướng mắc.
- **Lộ trình:**
    - Tuần 1: Tìm hiểu cấu trúc dự án và training SwiftUI.
    - Tuần 2: Thiết kế Database Schema trên Firestore.
    - Tuần 3-6: Phát triển các module Home, Camera, Suggest.
    - Tuần 7-8: Fix bug, tối ưu hóa AI và hoàn thiện báo cáo.

**2.3. Quy trình thực hiện:**

**2.3.1. Khảo sát & Thu thập yêu cầu:** Xác định các tính năng then chốt: Quản lý Profile, Nhật ký calo hàng ngày, Chat/Gợi ý món ăn bằng AI, Quét ảnh thực phẩm.

**2.3.2. Phân tích hệ thống:**
- **Use Case chính:** Người dùng (Đăng ký -> Nhập thông tin sức khỏe -> Chụp ảnh món ăn -> Xem gợi ý menu).
- **Activity Diagram:** Luồng nhận diện: [User Chụp ảnh] -> [Gửi Gemini/CoreML] -> [Trả về JSON món ăn] -> [Lưu vào Firestore] -> [Cập nhật Dashboard].

**2.3.3. Thiết kế hệ thống:**
- **Kiến trúc:** MVVM (Model-View-ViewModel) tách biệt logic xử lý và giao diện.
- **Thiết kế cơ sở dữ liệu (Database Schema):**
    - `User`: Lưu thông tin cá nhân (Cân nặng, mục tiêu, lịch sử cân nặng).
    - `dailyRecord`: Lưu tổng lượng dinh dưỡng nạp vào theo từng ngày (Kcal, Protein, Carbs, Fat).
    - `dishHistory`: Lưu chi tiết các món ăn đã ăn kèm hình ảnh và công thức.
- **Thiết kế API:** Sử dụng Gemini API POST request với Prompt tùy chỉnh để nhận kết quả dạng JSON chuẩn (Entity: `GeminiDishResponse`).

**2.3.4. Xây dựng hệ thống (Implementation):**
- **Môi trường:** Xcode 15/16, iOS 17+, Cocoapods (Firebase, GoogleAds).
- **Module tiêu biểu:**
    - `FirebaseService.swift`: Xử lý CRUD dữ liệu người dùng.
    - `GeminiService.swift`: Giao tiếp với AI Google để phân tích thành phần món ăn từ Base64 Image.
    - `CameraView.swift`: Tích hợp camera và thực hiện nhận diện AI.

**2.4. Kết quả đạt được:** Hoàn thành các tính năng cốt lõi và tích hợp thành công hai luồng AI (Online/Offline).

---

## CHƯƠNG 3: KẾT QUẢ TRIỂN KHAI VÀ ĐÁNH GIÁ

**3.1. Môi trường cài đặt:**
- Xcode IDE trên macOS.
- Thiết bị demo: iPhone 14 Pro Max (Simulator & Physical Device).
- Firebase Console quản lý backend.

**3.2. Kết quả triển khai (Screenshots):**
*(Gợi ý: Bạn nên chụp các màn hình sau vào đây)*
1. **OnboardingScreen**: Màn hình giới thiệu 3 tab.
2. **SplashView**: Màn hình chào với logo GoodFood.
3. **HomeView**: Dashboard biểu đồ calo vòng tròn màu xanh đặc trưng.
4. **CameraView**: Giao diện chọn "Chụp ảnh" hoặc "Tải ảnh" kèm nút nhận diện bằng Gemini/CoreML.
5. **SuggestView**: Danh sách món ăn gợi ý với ảnh và calo chi tiết.
6. **ProfileView**: Thông tin cá nhân và biểu đồ cân nặng.

**3.3. Đánh giá hệ thống:**
- **Ưu điểm:** Tích hợp AI hiện đại nhất (Gemini 2.0-Flash-Lite), giao diện tinh tế, đồng bộ dữ liệu Cloud thời gian thực.
- **Nhược điểm:** Cần kết nối internet ổn định cho Gemini API; Dữ liệu dinh dưỡng là ước tính khoa học, không thay thế hoàn toàn bác sĩ.

---

## KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN

**Kết quả đạt được:**
- **Kiến thức:** Làm chủ SwiftUI, hiểu sâu về Firebase và cách triển khai AI vào ứng dụng thực tế.
- **Kỹ năng:** Cải thiện kỹ năng giải quyết vấn đề, quản lý source code qua Git.
- **Thực tế:** Hiểu được sự khác biệt giữa việc học lý thuyết và triển khai sản phẩm mượt mà cho người dùng cuối.

**Hướng phát triển:**
- Đồng bộ HealthKit của Apple để tự động lấy bước chân và calo tiêu thụ.
- Nâng cấp model Core ML để nhận diện được nhiều món ăn địa phương hơn.
- Thêm tính năng nhắc nhở uống nước và nhắc lịch ăn uống.

---

## TÀI LIỆU THAM KHẢO
1. Apple Developer Documentation: [developer.apple.com](https://developer.apple.com)
2. Firebase Documentation: [firebase.google.com/docs](https://firebase.google.com/docs)
3. Google Gemini API Documentation: [ai.google.dev](https://ai.google.dev)
