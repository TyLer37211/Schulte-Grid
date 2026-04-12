# Schulte-Grid

舒尔特表格脑力训练 App（Flutter + Dart）仓库。

## 当前仓库状态（2026-04-12）

当前仓库尚未初始化为可运行的 Flutter 工程，暂时只包含基础说明文件。

## 低风险质量基线（已补充）

为后续 MVP 开发降低风险，先建立如下质量护栏：

- 增加 `analysis_options.yaml`，启用官方推荐 lint 与更严格的空安全/风格约束。
- 增加 `.gitignore`，避免 Dart/Flutter 构建产物、IDE 文件与本地环境文件进入版本库。
- 明确分层约束（用于后续代码实现时遵守）：
  - `presentation`：仅放 UI 代码。
  - `application` / `domain`：仅放业务逻辑与用例。
  - `data`：仅放数据映射与存取（如 SQLite、SharedPreferences）。
  - 页面层不得直接访问 SQLite。

## 后续实现建议（MVP）

1. 初始化 Flutter 项目骨架（feature-first）。
2. 先落地 `training` MVP（3x3/4x4/5x5、正序点击、计时、错误计数、结果页跳转）。
3. 再接 SQLite 训练记录与 `history/stats` 聚合展示。
4. 补充核心逻辑测试（至少覆盖：网格生成、点击校验、计时统计）。
