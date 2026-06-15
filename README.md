# 戒烟有数 Flutter

基于 Codex 生成并通过 QA 验证的戒烟原型，落地为 Flutter 手机端应用。

当前阶段：Phase 1，项目骨架与设计 token。业务闭环、持久化、通知和导出会按 `docs/flutter_implementation_plan.md` 分阶段实现；每阶段完成后生成报告并等待确认。

## 原型基准

- 原型目录：`C:\Users\haiha\Documents\Codex\2026-06-10\c-users-haiha-documents-codex-2026\work\quit-smoking-prototype-preview`
- 验证截图目录：`qa\screenshots\full-validation`
- 固定移动端验收尺寸：390 x 844

## 当前范围

- Flutter 手机端首版。
- 手表端暂不实现，仅保留未来扩展说明。
- UI 要严格保持原型整体风格，可做 Flutter 平台安全区、字体和触摸反馈的细微适配。

## 本机注意

当前可通过 `F:\flutter\bin\flutter.bat` 运行 Flutter 3.44.1 / Dart 3.12.1。`flutter` 和 `dart` 尚未加入系统 PATH；如需直接使用命令名，可把 `F:\flutter\bin` 加入 PATH。

Android SDK 当前未被 Flutter 检测到，Android 真机构建/模拟器运行需安装 Android Studio 或配置已有 SDK 路径。
