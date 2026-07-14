# Phase 1 项目骨架与设计 Token 报告

## 阶段目标

- 清理前序 HarmonyOS 残留。
- 创建 Flutter 手机端项目骨架。
- 建立分层目录与基础设计 token。
- 生成一个使用原型视觉语言的基础首屏。
- 完成 Phase 1 范围内的 UI 与功能验证，并在进入 Phase 2 前等待用户确认。

## 已完成内容

- 已删除 HarmonyOS 残留目录 `AppScope/` 与 `entry/`。
- 已创建 Flutter 项目配置：`pubspec.yaml`、`analysis_options.yaml`。
- 已通过 `flutter create . --platforms=android,ios --project-name quit_count_flutter --org com.haiha` 补齐 Android/iOS 平台工程。
- 已统一移动端包名为 `com.haiha.quitcount`。
- 已创建 Flutter 入口：`lib/main.dart`、`lib/app/quit_count_app.dart`。
- 已建立核心主题 token：
  - `lib/core/theme/app_colors.dart`
  - `lib/core/theme/app_spacing.dart`
  - `lib/core/theme/app_text_styles.dart`
  - `lib/core/theme/app_theme.dart`
- 已创建 Phase 1 基础首屏：`lib/features/home/presentation/home_shell_page.dart`。
- 已声明并使用原型肺部素材：`assets/images/human-lungs-nih.png`。
- 已重写 README，移除 HarmonyOS 说明和乱码内容。
- 已保留后续阶段需要的分层目录占位：features、domain、data。
- 已将默认 Flutter 计数器测试替换为 Phase 1 首屏 smoke test。

## 新增或修改文件

- `.gitignore`
- `README.md`
- `pubspec.yaml`
- `analysis_options.yaml`
- `lib/main.dart`
- `lib/app/quit_count_app.dart`
- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_spacing.dart`
- `lib/core/theme/app_text_styles.dart`
- `lib/core/theme/app_theme.dart`
- `lib/features/home/presentation/home_shell_page.dart`
- `android/`
- `ios/`
- `test/widget_test.dart`
- `docs/reports/phase_1_project_setup_report.md`

## UI 验证方式与结果

- 静态核对首屏源码，确认使用原型相关设计 token：
  - 浅绿背景：`AppColors.pageBase`
  - 深绿主色：`AppColors.primary`
  - 珊瑚风险色：`AppColors.risk`
  - 薄荷状态面：`AppColors.surfaceMint`
  - 8px 圆角：`AppSpacing.radius`
  - 34x34 图标按钮：`AppSpacing.iconButton`
- 静态核对首页元素：
  - 应用名“戒烟有数”
  - “真实成本 A1 · Flutter Phase 1”
  - “肺部负担指数”
  - 肺部素材 `assets/images/human-lungs-nih.png`
  - “当日危害警示分用于行为干预，不代表医学诊断。”
  - “真实日耗”“健康负债”“取出一支”
- Widget test 使用 390x844 surface size，验证上述核心首屏信号可渲染。该尺寸是原型对齐验收基准之一，不是实现固定尺寸。
- 结果：Phase 1 源码级 UI 验证和 390x844 widget 渲染验证通过。

## 已验证移动端尺寸

- 已验证：`390x844` widget surface size，作为当前原型对齐基准之一。
- 未覆盖：小屏、常规 Android、大屏、常见 iPhone 多尺寸截图。
- 原因：Phase 1 仅完成骨架与基础首屏；Android APK/模拟器仍受工具链和 Gradle 下载阻塞，无法采集真实设备或模拟器截图。
- 补验计划：Android 工具链补齐后，先补 Phase 1 APK 构建和 390x844 运行截图；Phase 3/6 按计划覆盖小屏、常规 Android、大屏、常见 iPhone 尺寸。

## 功能验证方式与结果

- Flutter SDK 验证：通过。
- 依赖解析：通过。
- 静态分析：通过。
- Widget test：通过。
- Android SDK 路径配置：通过，已配置为 `F:\Android\Sdk`。
- Android debug APK 构建：未通过，原因是 Gradle 分发包下载超时，且 SDK Command-line Tools / Android licenses 仍需补齐。
- 结果：Phase 1 Flutter 源码、依赖、分析和测试通过；Android 设备级构建/运行需补齐 Android 工具链和 Gradle 下载后补验。

## 原型截图对照结果

- Phase 1 只要求骨架和基础首屏，不进入完整页面复刻。
- 已按原型色彩、圆角、标题层级、风险提示、肺部素材和指标卡方向建立基础 token。
- 尚未逐页对照 full-validation 截图；该工作属于 Phase 3 起的核心 UI 阶段。

## 验证命令与结果

- `rtk cmd.exe /c F:\flutter\bin\flutter.bat --no-version-check --version`
  - 结果：通过，Flutter 3.44.1，Dart 3.12.1。
- `rtk cmd.exe /c F:\flutter\bin\flutter.bat --no-version-check create . --platforms=android,ios --project-name quit_count_flutter --org com.haiha`
  - 结果：通过，平台工程已补齐，依赖解析成功。
- `rtk cmd.exe /c F:\flutter\bin\flutter.bat --no-version-check pub get`
  - 结果：通过。
- `rtk cmd.exe /c F:\flutter\bin\flutter.bat --no-version-check analyze`
  - 结果：通过，`No issues found!`。
- `rtk cmd.exe /c F:\flutter\bin\flutter.bat --no-version-check test`
  - 结果：通过，`All tests passed!`。
- `rtk cmd.exe /c F:\flutter\bin\flutter.bat --no-version-check doctor -v`
  - 原结果：Flutter SDK、Chrome、Windows/Visual Studio 可用；Android SDK 未检测到；网络资源检查超时。
- `rtk cmd.exe /c F:\flutter\bin\flutter.bat --no-version-check build apk --debug`
  - 原结果：失败，`No Android SDK found. Try setting the ANDROID_HOME environment variable.`
- `rtk cmd.exe /c set ANDROID`
  - 结果：未设置 `ANDROID_HOME` / `ANDROID_SDK_ROOT` 相关环境变量。
- `rtk cmd.exe /c if exist "%LOCALAPPDATA%\Android\Sdk" dir "%LOCALAPPDATA%\Android\Sdk"`
  - 结果：常见用户级 Android SDK 目录不存在。
- `rtk cmd.exe /c if exist "C:\Program Files\Android\Android Studio" dir "C:\Program Files\Android\Android Studio"`
  - 结果：常见 Android Studio 安装目录不存在。
- `rtk powershell.exe -NoProfile -Command "Get-Content -Encoding utf8 -Path 'android\local.properties'"`
  - 原结果：当前仅配置 `flutter.sdk=F:\\flutter`，未配置 Android SDK。
- `rtk cmd.exe /c dir /ad "F:\Android"`
  - 结果：发现 `F:\Android\Android Studio` 和 `F:\Android\Sdk`。
- `rtk cmd.exe /c F:\flutter\bin\flutter.bat --no-version-check config --android-sdk F:\Android\Sdk`
  - 结果：通过，Flutter 已记录 Android SDK 路径。
- `rtk cmd.exe /c F:\flutter\bin\flutter.bat --no-version-check doctor -v`
  - 结果：Android SDK 已识别为 `F:\Android\Sdk`，版本 `36.1.0`；仍提示 `cmdline-tools component is missing` 和 `Android license status unknown`。
- `rtk cmd.exe /c android\gradlew.bat --version --no-daemon`
  - 结果：需要下载 `https://services.gradle.org/distributions/gradle-9.1.0-all.zip`；沙箱内失败为 `Permission denied: connect`，提权后失败为 `Connection timed out: connect`。
- `rtk cmd.exe /c F:\flutter\bin\flutter.bat --no-version-check build apk --debug`
  - 结果：超时；清理了该次构建留下的 `dart` / `java` 进程，未生成 APK。
- `rtk powershell.exe -NoProfile -Command "Get-Content -Encoding utf8 -Path 'android\local.properties'"`
  - 结果：当前已包含 `flutter.sdk=F:\\flutter` 和 `sdk.dir=F:\\Android\\Sdk`。

## 未能验证的内容和原因

- 未能生成 Android debug APK。
  - 原因：Android SDK 已配置，但 Gradle wrapper 需要下载 `gradle-9.1.0-all.zip`，当前网络连接 `services.gradle.org` 超时；SDK Command-line Tools 与 Android licenses 仍需补齐。
- 未能在 Android 模拟器或真机启动 App，也未能采集真实 390x844 设备截图。
  - 原因：Android APK 尚未构建成功；模拟器或真机运行需在 Gradle 和 Android 工具链补齐后继续验证。
- 未能做 iOS 真机构建。
  - 原因：当前为 Windows 环境，iOS 构建需 macOS/Xcode。

## 遗留问题

- 将 `F:\flutter\bin` 加入系统 PATH 后，可直接运行 `flutter` / `dart`。
- Android SDK 已发现并配置为 `F:\Android\Sdk`。
- 在 Android Studio 的 SDK Manager 中安装 Android SDK Command-line Tools。
- 安装后执行：
  - `F:\flutter\bin\flutter.bat doctor --android-licenses`
  - `F:\flutter\bin\flutter.bat doctor -v`
  - `F:\flutter\bin\flutter.bat build apk --debug`
- 若 `build apk` 仍卡在 Gradle 下载，请切换稳定网络或配置 Gradle/系统代理，确保可访问 `https://services.gradle.org/distributions/gradle-9.1.0-all.zip`。
- Phase 1 首屏只是视觉 token 预览，业务闭环和页面复刻从 Phase 2/3 开始。

## 下一阶段注意事项

- Phase 2 开始前需要用户确认本报告。
- Phase 2 只做 domain、算法、Riverpod 状态和内存仓库，不提前实现完整 UI。
- 继续遵守“每阶段报告由用户确认后才能进入下一阶段”。
- Phase 2 实现时以 `docs/product_spec.md` 为产品规则权威来源，修改后的原型作为 UI/流程参考。

## 用户确认状态

待确认。
