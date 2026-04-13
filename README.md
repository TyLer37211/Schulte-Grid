# Schulte-Grid

舒尔特表格脑力训练 App（Flutter + Dart + Riverpod）。

## 项目状态

当前已初始化 MVP 骨架：
- feature-first 目录结构
- 基础页面（home/training/training_result/history/stats/settings）
- 轻量命名路由
- Riverpod `ProviderScope` 入口

## 目录结构（MVP）

```text
lib/
  app/
    app.dart
    router/app_router.dart
  features/
    home/presentation/home_page.dart
    training/presentation/training_page.dart
    training/presentation/training_result_page.dart
    history/presentation/history_page.dart
    stats/presentation/stats_page.dart
    settings/presentation/settings_page.dart
```

## 运行

```bash
flutter pub get
flutter run
```

## 测试

```bash
flutter test
flutter analyze
```
