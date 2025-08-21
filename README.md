# 🚀 Hybrid CLI

Một công cụ dòng lệnh mạnh mẽ để tạo code Flutter theo cấu trúc Clean Architecture một cách tự động và nhanh chóng.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📋 Mục lục

- [Giới thiệu](#giới-thiệu)
- [Cài đặt](#cài-đặt)
- [Sử dụng](#sử-dụng)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Các lệnh chi tiết](#các-lệnh-chi-tiết)
- [Ví dụ thực tế](#ví-dụ-thực-tế)
- [Tùy chỉnh](#tùy-chỉnh)
- [Đóng góp](#đóng-góp)

## 🎯 Giới thiệu

Hybrid CLI là một công cụ được thiết kế để:
- ⚡ Tạo dự án Flutter với Clean Architecture trong vài giây
- 🏗️ Generate các feature module hoàn chỉnh với 3 layers
- 🔧 Tạo các component riêng lẻ (models, repositories, use cases, etc.)
- 📦 Thiết lập sẵn dependency injection và state management
- 🎨 Áp dụng Flutter best practices ngay từ đầu

## 📥 Cài đặt

### Cách 1: Cài đặt tự động (Khuyến nghị)

```bash
# Clone repository này
git clone <repository-url>
cd hybrid_cli

# Chạy script cài đặt
chmod +x install.sh
./install.sh
```

### Cách 2: Cài đặt thủ công

```bash
# Cài đặt dependencies
dart pub get

# Activate global
dart pub global activate --source path .
```

### Kiểm tra cài đặt

```bash
hybrid --help
```

## 🛠️ Sử dụng

### 1. Tạo dự án mới

```bash
hybrid init my_awesome_app
cd my_awesome_app
flutter pub get
flutter run
```

### 2. Tạo feature module

```bash
hybrid feature authentication
hybrid feature user_profile
hybrid feature product_catalog
```

### 3. Generate components riêng lẻ

```bash
# Generate trong core directory
hybrid generate model User
hybrid generate repository Product
hybrid generate usecase GetUserProfile

# Generate trong feature cụ thể
hybrid generate model Order orders
hybrid generate repository UserRepository authentication
hybrid generate screen LoginScreen authentication
hybrid generate widget ProductCard products
hybrid generate service NotificationService notifications
```

## 🏗️ Cấu trúc dự án

Dự án được tạo theo chuẩn Clean Architecture:

```
my_awesome_app/
├── lib/
│   ├── main.dart                     # Entry point của ứng dụng
│   ├── core/                         # Chức năng cốt lõi
│   │   ├── auth/                     # Xác thực người dùng
│   │   ├── error/                    # Xử lý lỗi
│   │   │   ├── failures.dart         # Các loại failure
│   │   │   └── exceptions.dart       # Các exception
│   │   ├── feature_flags/            # Feature flags
│   │   ├── images/                   # Tiện ích hình ảnh
│   │   ├── l10n/                     # Đa ngôn ngữ
│   │   ├── network/                  # Xử lý network
│   │   ├── storage/                  # Lưu trữ local
│   │   ├── theme/                    # Chủ đề ứng dụng
│   │   ├── ui/                       # UI components dùng chung
│   │   ├── usecases/                 # Base use case classes
│   │   │   └── usecase.dart          # Abstract use case
│   │   ├── utils/                    # Các hàm tiện ích
│   │   ├── updates/                  # Cập nhật ứng dụng
│   │   └── core.dart                 # Export file
│   ├── features/                     # Các module feature
│   │   ├── authentication/           # Feature xác thực
│   │   │   ├── data/                 # Data layer
│   │   │   │   ├── datasources/      # Data sources (API, local)
│   │   │   │   ├── models/           # Data models
│   │   │   │   └── repositories/     # Repository implementations
│   │   │   ├── domain/               # Domain layer
│   │   │   │   ├── entities/         # Business entities
│   │   │   │   ├── repositories/     # Repository interfaces
│   │   │   │   └── usecases/         # Business logic
│   │   │   └── presentation/         # UI layer
│   │   │       ├── controllers/      # State management (BLoC/Cubit)
│   │   │       ├── screens/          # Màn hình
│   │   │       └── widgets/          # UI widgets
│   │   └── user_profile/             # Feature hồ sơ người dùng
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   ├── gen/                          # Generated code (build_runner)
│   └── l10n/                         # Localization resources
│       └── arb/                      # ARB translation files
├── test/                             # Test files
│   ├── core/                         # Core tests
│   └── features/                     # Feature tests
├── pubspec.yaml                      # Dependencies
└── README.md                         # Documentation
```

## 📚 Các lệnh chi tiết

### `hybrid init <project_name>`

Tạo một dự án Flutter hoàn toàn mới với clean architecture.

**Options:**
- `<project_name>`: Tên dự án (bắt buộc)

**Ví dụ:**
```bash
hybrid init ecommerce_app
hybrid init social_media_app
```

**Kết quả:**
- ✅ Cấu trúc thư mục hoàn chỉnh
- ✅ pubspec.yaml với dependencies cần thiết
- ✅ main.dart cơ bản
- ✅ Core modules đầy đủ
- ✅ Example feature để tham khảo

### `hybrid feature <feature_name>`

Tạo một feature module hoàn chỉnh với 3 layers.

**Options:**
- `<feature_name>`: Tên feature (bắt buộc)

**Ví dụ:**
```bash
hybrid feature authentication
hybrid feature user_management
hybrid feature order_tracking
```

**Kết quả:**
- ✅ Entity classes
- ✅ Repository interface và implementation
- ✅ Use cases
- ✅ Data sources (remote và local)
- ✅ Models với JSON serialization
- ✅ BLoC/Cubit controller
- ✅ Screen và widgets cơ bản

### `hybrid generate <type> <name> [feature_name]`

Generate các component riêng lẻ, có thể chỉ định feature cụ thể.

**Options:**
- `<type>`: Loại component (bắt buộc)
- `<name>`: Tên component (bắt buộc)  
- `[feature_name]`: Tên feature (tùy chọn)

**Các loại component hỗ trợ:**

| Type | Mô tả | Vị trí tạo (core) | Vị trí tạo (feature) |
|------|-------|-------------------|----------------------|
| `model` | Data model với JSON serialization | `lib/core/models/` | `lib/features/{feature}/domain/entities/` |
| `repository` | Repository interface và implementation | `lib/core/repositories/` | `lib/features/{feature}/domain/repositories/` và `data/repositories/` |
| `usecase` | Business logic use case | `lib/core/usecases/` | `lib/features/{feature}/domain/usecases/` |
| `controller` | BLoC/Cubit controller | `lib/core/controllers/` | `lib/features/{feature}/presentation/controllers/` |
| `screen` | Flutter screen widget | `lib/core/screens/` | `lib/features/{feature}/presentation/screens/` |
| `widget` | Reusable UI widget | `lib/core/widgets/` | `lib/features/{feature}/presentation/widgets/` |
| `service` | Business service class | `lib/core/services/` | `lib/features/{feature}/data/datasources/` |

**Ví dụ:**
```bash
# Generate trong core directory  
hybrid generate model User
hybrid generate repository ProductRepository
hybrid generate usecase GetUserProfile

# Generate trong feature cụ thể
hybrid generate model Order orders                    # Tạo trong lib/features/orders/domain/entities/
hybrid generate repository UserRepo authentication    # Tạo trong lib/features/authentication/domain/repositories/ và data/repositories/
hybrid generate screen LoginScreen authentication     # Tạo trong lib/features/authentication/presentation/screens/
hybrid generate widget CustomButton                   # Tạo trong lib/core/widgets/
hybrid generate service NotificationService messaging # Tạo trong lib/features/messaging/data/datasources/
```

## 🌟 Ví dụ thực tế

### Tạo ứng dụng E-commerce hoàn chỉnh

```bash
# 1. Tạo dự án
hybrid init ecommerce_app
cd ecommerce_app

# 2. Tạo các feature chính
hybrid feature authentication
hybrid feature product_catalog
hybrid feature shopping_cart
hybrid feature user_profile
hybrid feature order_management

# 3. Generate các model cần thiết
hybrid generate model Product
hybrid generate model Order
hybrid generate model Category
hybrid generate model PaymentMethod

# 4. Generate các service
hybrid generate service PaymentService
hybrid generate service NotificationService
hybrid generate service AnalyticsService

# 5. Generate UI components
hybrid generate widget ProductCard
hybrid generate widget CartItem
hybrid generate widget CustomAppBar

# 6. Cài đặt dependencies và chạy
flutter pub get
flutter run
```

### Tạo ứng dụng Social Media

```bash
# 1. Tạo dự án
hybrid init social_app
cd social_app

# 2. Tạo features
hybrid feature authentication
hybrid feature user_profile
hybrid feature posts
hybrid feature messaging
hybrid feature notifications

# 3. Generate models
hybrid generate model User
hybrid generate model Post
hybrid generate model Comment
hybrid generate model Message

# 4. Chạy ứng dụng
flutter pub get
flutter run
```

## 🔧 Tùy chỉnh

### Mở rộng CLI tool

Bạn có thể mở rộng CLI bằng cách:

1. **Thêm templates mới:**
   - Tạo file trong `lib/templates/`
   - Định nghĩa template cho component mới

2. **Tạo generator mới:**
   - Thêm generator trong `lib/generators/`
   - Implement logic tạo code

3. **Thêm command mới:**
   - Tạo command class trong `lib/commands/`
   - Register trong `bin/main.dart`

### Ví dụ thêm template mới

```dart
// lib/templates/my_custom_template.dart
class MyCustomTemplate {
  static String generateCustomComponent(String className) {
    return '''
class ${className}Component {
  // Your custom template here
}
''';
  }
}
```

## 🎨 Features được hỗ trợ

- ✅ **Clean Architecture**: Tách biệt rõ ràng các layer
- ✅ **State Management**: BLoC/Cubit pattern
- ✅ **Dependency Injection**: GetIt service locator
- ✅ **Error Handling**: Failure và Exception pattern
- ✅ **Data Layer**: Repository pattern với data sources
- ✅ **JSON Serialization**: Sẵn sàng cho code generation
- ✅ **Testing Structure**: Organized test folders
- ✅ **Localization**: ARB files support
- ✅ **Best Practices**: Flutter coding conventions
- ✅ **Documentation**: Generated README files

## 🧪 Testing

CLI tool được test với:

```bash
# Test tạo dự án
dart run bin/main.dart init test_project

# Test tạo feature
dart run bin/main.dart feature test_feature

# Test generate components
dart run bin/main.dart generate model TestModel
```

## 🤝 Đóng góp

Chúng tôi hoan nghênh mọi đóng góp! Để đóng góp:

1. **Fork** repository này
2. **Tạo** feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** thay đổi (`git commit -m 'Add amazing feature'`)
4. **Push** lên branch (`git push origin feature/amazing-feature`)
5. **Mở** Pull Request

### Hướng dẫn phát triển

```bash
# Clone và setup
git clone <your-fork>
cd hybrid_cli
dart pub get

# Chạy tests
dart test

# Test CLI locally
dart run bin/main.dart --help
```

## 📝 License

Dự án này được phân phối dưới [MIT License](LICENSE).

## 🆘 Hỗ trợ

Nếu bạn gặp vấn đề hoặc có câu hỏi:

1. Kiểm tra [Issues](../../issues) đã có
2. Tạo [Issue mới](../../issues/new) với mô tả chi tiết
3. Liên hệ qua email: [your-email@example.com]

## 🙏 Cảm ơn

Cảm ơn tất cả những người đã đóng góp cho dự án này!

---

**Happy Coding! 🚀**

Made with ❤️ for Flutter Community
