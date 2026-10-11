# Hướng dẫn Coding Agent (Agent Guidelines)

Chào mừng coding agent đến với codebase **Quỹ Đạo**! Toàn bộ thư mục này chứa các quy tắc, quy trình chuẩn, checklist và mẫu prompt giúp bạn lập trình chính xác, tránh hallucination và tuân thủ 100% kiến trúc của dự án.

---

## 1. Thứ tự đọc BẮT BUỘC trước khi code

Mọi agent khi bắt đầu một phiên làm việc phải đọc tài liệu theo đúng thứ tự sau:

1. [agent/rules.md](file:///f:/Project/orbit-app/agent/rules.md): **11 quy tắc vàng bất biến** trong repo này. Vi phạm bất kỳ quy tắc nào đều bị từ chối code review.
2. [DESIGN.md](file:///f:/Project/orbit-app/DESIGN.md): Ngôn ngữ thiết kế Mastercard (màu nền kem putty `#F3F0EE`, bo góc stadium 40px, pill 999px, Ink Black `#141413`). Tuyệt đối không tự bịa giá trị design.
3. [docs/spec.md](file:///f:/Project/orbit-app/docs/spec.md): Nguồn sự thật (Source of Truth) về mô hình Firestore, logic nghiệp vụ và 18 tính năng MVP.
4. [docs/architecture.md](file:///f:/Project/orbit-app/docs/architecture.md): Cấu trúc 4 lớp Feature-First (UI -> Application -> Repository -> Domain).
5. [agent/workflows/](file:///f:/Project/orbit-app/agent/workflows): Workflow cụ thể cho công việc sắp làm (thêm tính năng, đổi schema, ghi batch giao dịch).

---

## 2. Cấu trúc thư mục agent/

```text
agent/
  README.md                  // Tài liệu này (hướng dẫn & thứ tự đọc)
  rules.md                   // 11 quy tắc bắt buộc của codebase
  workflows/
    add-feature.md           // Quy trình 8 bước triển khai một tính năng mới
    add-firestore-field.md   // Quy trình 7 bước thay đổi/mở rộng schema Firestore
    write-transaction-batch.md // Chuẩn mực ghi WriteBatch kèm code mẫu Dart
    release-checklist.md     // Quy trình 8 bước kiểm tra trước khi phát hành
  checklists/
    definition-of-done.md    // Tiêu chuẩn hoàn thành (DoD) trước khi bàn giao
    pr-review.md             // Checklist tự rà soát code
  prompts/
    new-screen.md            // Mẫu prompt giao việc tạo màn hình mới
    fix-bug.md               // Mẫu prompt giao việc sửa lỗi
```
