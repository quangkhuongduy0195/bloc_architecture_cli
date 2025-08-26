# 🚀 Hybrid CLI

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║         ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗██████╗              ║
║         ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║██╔══██╗             ║
║         ███████║ ╚████╔╝ ██████╔╝██████╔╝██║██║  ██║             ║
║         ██╔══██║  ╚██╔╝  ██╔══██╗██╔══██╗██║██║  ██║             ║
║         ██║  ██║   ██║   ██████╔╝██║  ██║██║██████╔╝             ║
║         ╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝╚═════╝              ║
║                                                                  ║
║                🚀Flutter BLoC Generator🚀                        ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```
## 🎯 Giới thiệu
Hybrid CLI là công cụ dòng lệnh được thiết kế để:
- ⚡ **Tăng tốc phát triển**: Tạo dự án Flutter hoàn chỉnh trong vài giây
- 🏗️ **Clean Architecture**: Generate các feature module với 3 layers chuẩn
- 📦 **Ready-to-use**: Thiết lập sẵn dependency injection, state management, routing
- 🎨 **Best Practices**: Áp dụng Flutter coding conventions và patterns ngay từ đầu
- 🚀 **Auto Routing**: Tự động cập nhật app routes khi tạo feature mới
- 🎯 **Focused**: Chỉ 2 lệnh chính dễ nhớ và sử dụng

> **📌 Lưu ý**: Phiên bản hiện tại tập trung vào 2 lệnh cốt lõi là `init` và `feature`. 
> Các lệnh khác như `generate` và `locale` đang được phát triển cho các phiên bản tiếp theo.

Một công cụ dòng lệnh mạnh mẽ để tạo code Flutter theo cấu trúc Clean Architecture với BLoC pattern một cách tự động và nhanh chóng.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Tính năng nổi bật

- 🏗️ **Clean Architecture**: Tự động tạo cấu trúc 3 layers (Data, Domain, Presentation)
- 🔄 **BLoC Pattern**: State management với BLoC/Cubit
- 🚀 **Auto Route Generation**: Tự động cập nhật routes khi tạo feature mới
- 📦 **Dependency Injection**: Thiết lập sẵn GetIt service locator
- 🎨 **UI Components**: Generate widgets và pages với templates chuyên nghiệp
- 🔧 **Code Generation Ready**: Hỗ trợ JSON serialization và build_runner
- 📱 **Responsive Design**: Templates responsive cho multi-platform
- ⚡ **Simple Commands**: Chỉ 2 lệnh chính: `init` và `feature`

## 📋 Mục lục

- [Tính năng nổi bật](#-tính-năng-nổi-bật)
- [Cài đặt](#-cài-đặt)
- [Sử dụng nhanh](#-sử-dụng-nhanh)
- [Các lệnh chi tiết](#-các-lệnh-chi-tiết)
- [Cấu trúc dự án](#-cấu-trúc-dự-án)
- [Ví dụ thực tế](#-ví-dụ-thực-tế)
- [Tùy chỉnh](#-tùy-chỉnh)
- [Đóng góp](#-đóng-góp)

## 🎯 Giới thiệu

Hybrid CLI là công cụ dòng lệnh được thiết kế để:
- ⚡ **Tăng tốc phát triển**: Tạo dự án Flutter hoàn chỉnh trong vài giây
- 🏗️ **Clean Architecture**: Generate các feature module với 3 layers chuẩn
-  **Ready-to-use**: Thiết lập sẵn dependency injection, state management, routing
- 🎨 **Best Practices**: Áp dụng Flutter coding conventions và patterns ngay từ đầu
- 🚀 **Auto Routing**: Tự động cập nhật app routes khi tạo feature mới
- 🎯 **Focused**: Chỉ 2 lệnh chính dễ nhớ và sử dụng

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

## 🛠️ Sử dụng nhanh

### 1. Khởi tạo dự án mới

```bash
# Tạo dự án Flutter với Clean Architecture
hybrid init my_awesome_app
cd my_awesome_app
flutter pub get
flutter run
```

### 2. Tạo feature module (🆕 Tự động cập nhật routes)

```bash
# Tạo feature authentication - tự động thêm vào app routes
hybrid feature authentication

# Tạo feature user profile  
hybrid feature user_profile

# Tạo feature product catalog
hybrid feature product_catalog
```

### 3. Sử dụng các components có sẵn

```bash
# Dự án đã được tạo với cấu trúc hoàn chỉnh
# Bạn có thể bắt đầu develop ngay với:
# - BLoC pattern đã setup
# - Dependency injection đã cấu hình
# - Routes đã được tự động tạo
# - Clean architecture structure đã sẵn sàng

# Chỉ cần chạy:
flutter pub get
flutter packages pub run build_runner build
flutter run
```

## 📚 Các lệnh chi tiết

Hybrid CLI chỉ có **2 lệnh chính** đơn giản và mạnh mẽ:

### 🔧 `hybrid init <project_name>`

Tạo dự án Flutter hoàn toàn mới với Clean Architecture.

```bash
hybrid init ecommerce_app
```

**Tạo ra:**
- ✅ Cấu trúc thư mục Clean Architecture hoàn chỉnh
- ✅ pubspec.yaml với dependencies BLoC, GetIt, AutoRoute
- ✅ main.dart với dependency injection setup
- ✅ Core modules (network, storage, theme, utils)
- ✅ Example feature để tham khảo
- ✅ App routing configuration

### 🏗️ `hybrid feature <feature_name>`

Tạo feature module hoàn chỉnh với 3 layers + **tự động cập nhật routes**.

**Syntax:**
```bash
hybrid feature <feature_name>
```

**Ví dụ:**
```bash
# Tạo feature authentication
hybrid feature authentication

# Tạo feature user management
hybrid feature user_management

# Tạo feature orders
hybrid feature orders
```

**Tạo ra:** 
- ✅ **Data Layer**: Models, Data Sources (Remote/Local), Repository Implementation
- ✅ **Domain Layer**: Entities, Repository Interface, Use Cases, Services  
- ✅ **Presentation Layer**: BLoC/Cubit, Pages, Widgets
- ✅ **Auto Routing**: Tự động thêm CustomRoute vào `app_routes.dart`
- ✅ **Import Management**: Tự động thêm import cho page mới

### 🆘 `hybrid --help` hoặc `hybrid -h`

Hiển thị thông tin trợ giúp với ASCII art banner đẹp mắt.

### 📄 `hybrid --version` hoặc `hybrid -v`

Hiển thị phiên bản hiện tại của CLI tool (v1.0.0).

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

**Syntax:**
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

**Syntax:**
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
- ✅ **Auto Route**: Tự động thêm vào app_routes.dart

## 🌟 Ví dụ thực tế

### 🛒 Tạo ứng dụng E-commerce hoàn chỉnh

```bash
# 1. Khởi tạo dự án
hybrid init ecommerce_app
cd ecommerce_app

# 2. Tạo các feature chính (tự động thêm routes)
hybrid feature authentication
hybrid feature product_catalog  
hybrid feature shopping_cart
hybrid feature user_profile
hybrid feature order_management

# 3. Generate core models (nếu cần)
# Các models này sẽ được tạo trong core/models
# (Thực tế feature đã tạo sẵn entities trong domain layer)

# 4. Chạy application
flutter pub get
flutter pub run build_runner build -d
flutter run
```

### 📱 Tạo ứng dụng Social Media

```bash
# 1. Khởi tạo dự án
hybrid init social_media_app
cd social_media_app

# 2. Tạo các feature (routes tự động được thêm)
hybrid feature authentication
hybrid feature user_profile
hybrid feature posts
hybrid feature messaging
hybrid feature notifications
hybrid feature friends

# 3. Generate core entities (nếu cần shared models)
# Các entities đã được tạo trong mỗi feature's domain layer

# 4. Customize và extend features theo nhu cầu
# Mỗi feature đã có đầy đủ: entities, repositories, use cases, BLoC, pages, widgets

# 5. Chạy ứng dụng
flutter pub get
flutter pub run build_runner build -d
flutter run
```

### 🏥 Tạo ứng dụng Healthcare

```bash
# 1. Tạo dự án  
hybrid init healthcare_app
cd healthcare_app

# 2. Tạo features cho healthcare
hybrid feature patient_management
hybrid feature appointments
hybrid feature medical_records
hybrid feature telemedicine
hybrid feature prescriptions

# 3. Customize medical entities (đã có sẵn trong features)
# Mỗi feature đã được tạo với đầy đủ entities, repositories, use cases

# 4. Setup và test
flutter pub get
flutter pub run build_runner build -d
flutter run
```

## 🎨 Tính năng tự động

### 🔄 Auto Route Management

Khi tạo feature mới, CLI tự động:

1. **Thêm Import**: 
   ```dart
   import '../../features/authentication/presentation/pages/authentication_page.dart';
   ```

2. **Thêm Route**:
   ```dart
   CustomRoute(
     page: AuthenticationRoute.page,
     path: '/authentication',
     transitionsBuilder: customAnimation,
   ),
   ```

3. **Cập nhật app_routes.dart**: Không cần chỉnh sửa thủ công!

### 📦 Generated Code Structure

Mỗi feature được tạo với cấu trúc hoàn chỉnh:

```
lib/features/authentication/
├── data/
│   ├── datasources/
│   │   ├── authentication_local_datasource.dart
│   │   └── authentication_remote_datasource.dart
│   ├── models/
│   │   └── authentication_model.dart
│   └── repositories/
│       └── authentication_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── authentication_entity.dart
│   ├── repositories/
│   │   └── authentication_repository.dart
│   ├── services/
│   │   └── authentication_service.dart
│   └── usecases/
│       └── get_authentication.dart
└── presentation/
    ├── bloc/
    │   ├── authentication_bloc.dart
    │   ├── authentication_event.dart
    │   └── authentication_state.dart
    ├── pages/
    │   └── authentication_page.dart
    └── widgets/
        └── authentication_widget.dart
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

- ✅ **Clean Architecture**: Tách biệt rõ ràng 3 layers (Data, Domain, Presentation)
- ✅ **BLoC Pattern**: State management với BLoC/Cubit pattern  
- ✅ **Auto Route Generation**: Tự động cập nhật routes khi tạo feature mới
- ✅ **Dependency Injection**: GetIt service locator setup sẵn
- ✅ **Error Handling**: Failure và Exception pattern chuẩn
- ✅ **Repository Pattern**: Data sources với remote/local implementation
- ✅ **JSON Serialization**: Ready cho build_runner code generation
- ✅ **Testing Structure**: Organized test folders cho unit/widget/integration tests
- ✅ **Localization Support**: ARB files và l10n configuration
- ✅ **Responsive Design**: Templates responsive cho mobile/tablet/desktop
- ✅ **Code Documentation**: Generated comments và README files
- ✅ **Best Practices**: Flutter coding conventions và performance optimization

## 🧪 Testing & Quality

### Test Coverage

CLI tool được test với multiple scenarios:

```bash
# Test project creation
dart run bin/main.dart init test_project

# Test feature generation với auto routing
dart run bin/main.dart feature test_feature
```

### Code Quality

- 📊 **Static Analysis**: Dart analyzer compliant
- 🔍 **Linting**: Flutter lints configuration
- 🧪 **Unit Tests**: Comprehensive test coverage
- 📱 **Widget Tests**: UI component testing
- 🔗 **Integration Tests**: End-to-end functionality

### Performance

- ⚡ **Fast Generation**: < 3 seconds cho complete feature
- 💾 **Memory Efficient**: Minimal memory footprint
- 🔄 **Incremental Updates**: Only update changed files
- 📦 **Small Bundle**: CLI package < 5MB

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

## 🆘 Hỗ trợ & Troubleshooting

### Các vấn đề thường gặp

**Q: Lệnh `hybrid` không được nhận diện**
```bash
# Kiểm tra PATH
echo $PATH

# Cài đặt lại global
dart pub global activate --source path .

# Hoặc chạy trực tiếp
dart run bin/main.dart --help
```

**Q: Route không được thêm tự động**
```bash
# Kiểm tra file app_routes.dart tồn tại
ls lib/core/routes/app_routes.dart

# Thử tạo feature với verbose output
dart run bin/main.dart feature test_feature
```

**Q: Generated code có lỗi**
```bash
# Chạy code generation
flutter packages pub run build_runner build

# Clean và rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Getting Help

Nếu bạn gặp vấn đề hoặc có câu hỏi:

1. 📋 Kiểm tra [Issues](../../issues) đã có
2. 🆕 Tạo [Issue mới](../../issues/new) với:
   - Mô tả chi tiết vấn đề
   - Output của lệnh bị lỗi
   - Environment info (Flutter/Dart version)
   - Steps to reproduce
3. 📧 Liên hệ qua email: [your-email@example.com]
4. 💬 Tham gia Discord community: [your-discord-link]

### Contributing Guidelines

Chúng tôi hoan nghênh mọi đóng góp! 

**Quick Start:**
```bash
# Fork repository
git clone <your-fork>
cd hybrid_cli

# Setup development environment  
dart pub get

# Run tests
dart test

# Test CLI locally
dart run bin/main.dart --help
```

**Development Process:**
1. 🍴 **Fork** repository
2. 🌿 **Tạo** feature branch (`git checkout -b feature/amazing-feature`)
3. ✅ **Test** changes thoroughly
4. 📝 **Commit** với clear message (`git commit -m 'Add amazing feature'`)
5. 🚀 **Push** to branch (`git push origin feature/amazing-feature`)
6. 🔄 **Mở** Pull Request với detailed description

**Code Standards:**
- Follow Dart style guide
- Add tests for new features
- Update documentation
- Ensure backward compatibility

## � Roadmap

### 🔮 Upcoming Features

- [ ] **Component Generator**: Thêm lại lệnh `generate` cho individual components
- [ ] **Localization Support**: Lệnh `locale` để generate locale keys
- [ ] **GraphQL Support**: Templates for GraphQL integration
- [ ] **Firebase Integration**: Auto-setup for Firebase services  
- [ ] **Testing Generator**: Auto-generate unit/widget/integration tests
- [ ] **Documentation Generator**: Auto-generate API documentation
- [ ] **CI/CD Templates**: GitHub Actions & other CI/CD configs
- [ ] **Docker Support**: Containerization templates
- [ ] **Design System**: Material 3 & custom design system templates

### 📈 Version History

- **v1.0.0**: *(Current)* Core functionality với 2 lệnh chính
  - `hybrid init`: Tạo project với Clean Architecture
  - `hybrid feature`: Tạo feature với auto route generation
  - ASCII banner đẹp mắt
  - BLoC pattern integration
  - Dependency injection setup

## 📝 License

Dự án này được phân phối dưới [MIT License](LICENSE).

```
MIT License

Copyright (c) 2025 Hybrid CLI Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## 🙏 Acknowledgments

### Contributors

Cảm ơn những người đã đóng góp cho dự án:

- 👨‍💻 **Core Team**: Initial development và architecture
- 🎨 **Design Team**: UI/UX templates và ASCII art
- 🧪 **QA Team**: Testing và quality assurance
- 📝 **Documentation Team**: Comprehensive documentation
- 🌍 **Community**: Feedback, bug reports, và feature requests

### Dependencies

Dự án sử dụng các packages mã nguồn mở tuyệt vời:

- 📦 **args**: Command-line argument parsing
- 📁 **path**: File system path manipulation  
- 🔧 **yaml**: YAML parsing and generation
- 🎯 **Various Flutter packages**: BLoC, GetIt, AutoRoute, etc.

### Inspiration

Được lấy cảm hứng từ:

- 🏗️ **Clean Architecture** by Robert C. Martin
- 🔄 **BLoC Pattern** by Felix Angelov
- ⚡ **Flutter Best Practices** by Flutter team
- 🚀 **Developer Experience** từ các CLI tools khác

---

<div align="center">

**Happy Coding! 🚀**

Made with ❤️ for Flutter Community

[![Follow on GitHub](https://img.shields.io/github/followers/quangkhuongduy0195?style=social)](https://github.com/quangkhuongduy0195)
[![Star this repo](https://img.shields.io/github/stars/quangkhuongduy0195/bloc_architecture_cli?style=social)](https://github.com/quangkhuongduy0195/bloc_architecture_cli)

</div>
