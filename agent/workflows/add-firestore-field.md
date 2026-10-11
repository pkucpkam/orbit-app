# Quy trình Thay đổi hoặc Thêm Trường trong Schema Firestore

Quy trình chuẩn 7 bước khi cần mở rộng hoặc chỉnh sửa schema dữ liệu trong Cloud Firestore:

---

1. **Đối chiếu yêu cầu với Spec:**
   Kiểm tra xem trường mới có nằm trong thiết kế dữ liệu tại [docs/spec.md](file:///f:/Project/orbit-app/docs/spec.md) mục 6 chưa. Nếu mâu thuẫn hoặc chưa có, cần xin xác nhận từ người dùng trước khi thực hiện.

2. **Cập nhật Model Freezed & Sinh lại code:**
   - Mở file model liên quan trong `lib/data/models/` hoặc `lib/features/<feature>/domain/`.
   - Thêm trường mới kèm annotation `@Default(...)` nếu trường không bắt buộc (optional) để tương thích ngược với dữ liệu cũ đã lưu trên Firestore.
   - Chạy lệnh build runner:
     ```bash
     dart run build_runner build --delete-conflicting-outputs
     ```

3. **Cập nhật Security Rules:**
   - Mở [firestore.rules](file:///f:/Project/orbit-app/firestore.rules).
   - Nếu trường mới cần ràng buộc kiểu dữ liệu hoặc giá trị hợp lệ (ví dụ: trường `status in ['active', 'completed']` hay số tiền nguyên), bổ sung điều kiện vào khối `allow create, update`.

4. **Cập nhật Composite Indexes (nếu có truy vấn phức tạp):**
   - Nếu trường mới được dùng kết hợp trong điều kiện `where` hoặc sắp xếp `orderBy` với trường khác, mở [firestore.indexes.json](file:///f:/Project/orbit-app/firestore.indexes.json).
   - Khai báo thêm cấu hình index composite theo chuẩn Firestore.

5. **Xác định chiến lược Di chuyển dữ liệu (Migration) & `schemaVersion`:**
   - Nếu thay đổi mang tính breaking change đối với document `users/{uid}`, kiểm tra trường `schemaVersion` tại [lib/data/firestore_paths.dart](file:///f:/Project/orbit-app/lib/data/firestore_paths.dart).
   - Chuẩn bị hàm chuyển đổi migration logic nếu `schemaVersion` của user cũ thấp hơn phiên bản mới.

6. **Cập nhật Tài liệu Đặc tả:**
   - Bổ sung định nghĩa trường mới, kiểu dữ liệu và mô tả vào bảng schema tại [docs/spec.md](file:///f:/Project/orbit-app/docs/spec.md) mục 6.
   - Nếu là thay đổi cấu trúc lớn, tạo thêm một bản ghi ADR trong `docs/decisions/`.

7. **Kiểm thử hồi quy toàn diện:**
   - Chạy kiểm thử:
     ```bash
     dart format .
     flutter analyze
     flutter test
     ```
   - Đảm bảo các unit test repository (đặc biệt là các test mock với `fake_cloud_firestore`) đều vượt qua.
