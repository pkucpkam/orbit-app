# Mẫu Prompt Giao việc: Sửa Lỗi (Fix Bug)

Dưới đây là mẫu prompt chuẩn để giao nhiệm vụ sửa lỗi cho coding agent. Thay thế các phần `{{...}}` bằng thông tin thực tế:

---

```markdown
# NHIỆM VỤ: Sửa lỗi {{TÊN_LỖI_NGẮN_GỌN}}

## Vị trí & Mã tính năng
- Màn hình / Thành phần gặp lỗi: {{TÊN_MÀN_HÌNH_HOẶC_COMPONENT}}
- File liên quan: `{{ĐƯỜNG_DẪN_FILE}}`
- Mã tính năng trong spec: {{MÃ_TÍNH_NĂNG}} (nếu có)

## Mô tả Hiện tượng & Tái hiện
- Hiện tượng lỗi: {{MÔ_TẢ_CHI_TIẾT_LỖI}}
- Các bước tái hiện:
  1. {{BƯỚC_1}}
  2. {{BƯỚC_2}}
  3. {{BƯỚC_3}}
- Kết quả mong muốn: {{KẾT_QUẢ_ĐÚNG_THEO_SPEC}}

## Tiêu chí Chấp nhận
{{LIỆT_KÊ_TIÊU_CHÍ_XÁC_NHẬN_ĐÃ_HẾT_LỖI}}

## Quy tắc Bắt buộc
1. Đọc kỹ `agent/rules.md` và `docs/spec.md` trước khi sửa code.
2. Viết thêm hoặc cập nhật unit test / widget test để tái hiện và đảm bảo không tái phát lỗi (Regression Test).
3. Sau khi sửa: Chạy `dart format .`, `flutter analyze`, `flutter test` đảm bảo 100% test pass và không phát sinh cảnh báo mới.
```
