# 戒烟有数 Flutter 分阶段执行计划

## Summary

目标是在 `E:\myProject\QuitCount\QuitCountFlutter` 落地 Flutter 手机端首版。先维护本计划文件，再按阶段执行；每个阶段完成后必须验证 UI 和功能，并生成 `docs/reports/phase_xxx_report.md`。阶段报告必须由用户确认后，才能进入下一阶段。

UI 必须严格按最新原型落地，可做 Flutter 原生适配微调，但整体风格、信息架构、颜色气质、组件密度、页面层级、关键交互不能改变。每阶段 UI 验证要对照原型截图，`390x844` 作为对齐当前原型的核心验收基准之一，不是实现时的固定尺寸。

移动端布局必须响应式/自适应：不得把主页面、手机壳或内容区固定写死为 `390x844`；页面宽高应根据真实设备、安全区、状态栏和底部手势区自适应。实现时可使用 `SafeArea`、`LayoutBuilder`、`MediaQuery`、滚动容器、弹性布局和合理 max width；内容高度超出时必须可滚动，底部主操作不能被系统手势区遮挡，弹窗、Sheet、指标卡片、按钮不能写死单一设备宽度。

产品规则基准：`docs/product_spec.md` 是 Flutter 版与 Harmony 版共同遵循的权威产品规格。本文档只描述 Flutter 版工程阶段、验证门禁和实施顺序；产品范围、指标口径、交互规则、通知规则、验收原则以 `docs/product_spec.md` 为准。

优先级规则：如果 `docs/product_spec.md`、修改后的原型文件、本文档之间出现冲突，按 `docs/product_spec.md` -> 修改后的原型文件 -> Flutter 实施计划的顺序执行。原型负责“长什么样、怎么流转”，产品规格负责“规则是什么、哪些必须做、哪些不能做”，实施计划负责“怎么分阶段落地”。若本文档与产品规格冲突，先修正本文档，再实现。

最新原型参考：

- 原型目录：`C:\Users\haiha\Documents\Codex\2026-06-10\c-users-haiha-documents-codex-2026\work\quit-smoking-prototype-preview`
- 完整验证截图：`qa\screenshots\full-validation`
- 重点截图：`home-actions-simplified.png`、`05-add-asset-errors.png`、`17-reset-confirm-modal.png`

最新原型同步规则：

- 首页以当前 Web 原型和 `home-actions-simplified.png` 为准，不再沿用旧版首页。
- 首页顺序固定为：主卡 -> 三指标 -> 7 日危害趋势 -> 操作按钮 -> 最近账本。
- 首页操作区只保留“放回库存”和“取出一支”；不再显示“查看资产”按钮。
- 主卡信息使用紧凑文案：`库存 17 支 · 今日 4/5 支`，不再使用“今日取出 4 支 · 目标少于 5 支”的长文案。
- “当日危害说明”小 i 位于“今日危害评分”标题旁；首页不再保留重复的“当日危害：高危”警示条。
- 7 日危害趋势保持迷你状态，只保留标题和右侧状态（如“稳定”），不再显示重复“持平”小文案。
- 每日复盘弹窗以“今日 vs 目标线”柱状图为核心，下方保留真实日耗、焦油摄入、健康折算三项指标，不照搬旧版大段说明。
- 严厉危害警示不阻止取烟，达到干预线后只触发手机系统通知栏三连提醒；APP 内不做三连提示。
- 取烟 Sheet 中备注常驻显示且选填；记录取出后直接扣库存、写账本、更新首页指标。

当前项目状态冲突：

- 项目仍有 Harmony 残留目录 `AppScope/`、`entry/`，Phase 1 清理。
- `README.md` 仍是 HarmonyOS 内容且有乱码，Phase 1 重写为 Flutter 说明。
- 原型里已有手表页和“我的”页手表入口，但 Flutter 手机端首版不实现手表端。首版视觉验收基准排除 `10-watch-status.png`、`11-watch-quick.png`、`12-watch-review.png`；“我的”页手表入口首版不展示，或展示为未来扩展占位且不可进入完整手表功能。

## Phase Gate Rule

- 每阶段完成后生成 `docs/reports/phase_xxx_report.md`。
- 报告生成后立即停止，不继续下一阶段。
- 用户明确确认该阶段报告后，才开始下一阶段。
- 如果 UI 或功能验证未通过，先修复并更新同一阶段报告，再等待用户确认。
- 不能用“未验证但继续”跳过阶段门禁。
- 每阶段报告必须写清楚本阶段验证过哪些移动端尺寸；如暂时无法多尺寸验证，必须说明原因和补验计划。

## Phase Plan

### Step 0：生成计划与报告目录

- 创建 `docs/flutter_implementation_plan.md`，写入本计划。
- 创建 `docs/reports/`。
- 当前阶段只做计划文件，不开始 Phase 1 实现。

### Phase 1：Flutter 骨架与设计 Token

- 清理 Harmony 残留目录 `AppScope/`、`entry/`。
- 创建 Flutter 项目结构、Android/iOS 最小壳、资源声明和 README。
- 建立目录：`lib/app`、`lib/core/theme`、`lib/features/*`、`lib/domain/*`、`lib/data/*`。
- 从原型 CSS 和截图提炼设计 token：浅绿背景、深绿主按钮、珊瑚风险色、薄荷状态面、8px 圆角、紧凑移动端间距、页面顶部标题层级、底部导航尺寸、34x34 图标按钮。
- UI 验证：启动基础 App，确认首屏主题、背景、字体层级、资源加载与原型风格一致；`390x844` 作为原型对齐基准验收，同时记录本阶段可验证的其他移动端尺寸。
- 功能验证：App 可启动、路由初始化、无红屏/异常日志。
- 报告：`docs/reports/phase_1_project_setup_report.md`。
- 门禁：等待用户确认报告后再进入 Phase 2。

### Phase 2：Domain、算法与状态主闭环

- 按 `docs/product_spec.md` 实现实体：库存、账本、目标、设置、风险快照。
- 按 `docs/product_spec.md` 实现 `QuitCalculator`，覆盖包年、健康折算、健康负债、肺部负担指数、健康净值、当日危害警示分。
- Riverpod 作为统一状态源；页面只发 action。
- 跑通库存、账本、目标、设置、取烟、放回、清空。
- UI 验证：最小状态展示仍使用原型设计 token，不出现默认 Flutter 样式裸露。
- 功能验证：calculator/controller 单测。
- 报告：`docs/reports/phase_2_domain_state_report.md`。
- 门禁：等待用户确认报告后再进入 Phase 3。

### Phase 3：核心手机 UI

- 严格复刻原型手机端页面：`home-actions-simplified`、`02-home-info-modal`、`03-take-sheet`、`04-assets`、`05-add-asset-modal`、`05-add-asset-errors`、`06-ledger`、`07-ledger-info-modal`、`08-model`、`09-mine`、`13-goal-modal`、`14-help-modal`、`16-settings`、`18-daily-review-modal`、`19-login`、`20-mine-synced`、`21-login-synced`。
- 首版排除手表端截图：`10-watch-status`、`11-watch-quick`、`12-watch-review`。
- 页面内容、底部导航、二级入口、首页指标、资产表单、账本布局、小 i 入口均按 `docs/product_spec.md` 实现。
- UI 验证：逐页对照 full-validation 截图，允许平台字体、安全区和触摸反馈细微差异，不允许改变整体风格、布局层级和关键组件位置。
- 功能验证：Tab 切换、资产表单校验、默认资产、账本渲染。
- 报告：`docs/reports/phase_3_core_ui_report.md`。
- 门禁：等待用户确认报告后再进入 Phase 4。

### Phase 4：关键交互与产品规则

- 取烟流程、严厉危害警示、重置本地数据、小 i 说明弹窗、模型合规提示均按 `docs/product_spec.md` 实现。
- 取烟 sheet 对照 `03-take-sheet.png`；重置弹窗对照 `17-reset-confirm-modal.png`。
- UI 验证：对照说明弹窗、重置弹窗、模型页、每日复盘弹窗截图。
- 功能验证：取烟提交、系统通知服务调用、重置取消/确认、小 i 弹窗。
- 报告：`docs/reports/phase_4_interactions_report.md`。
- 门禁：等待用户确认报告后再进入 Phase 5。

### Phase 5：本地存储、通知、导出、同步占位

- Drift/SQLite 存库存、账本、每日记录。
- `shared_preferences` 存目标、默认资产、设置开关。
- `flutter_secure_storage` 预留登录 token。
- 通知、每日复盘、CSV 导出、账户同步占位均按 `docs/product_spec.md` 实现。
- UI 验证：设置页权限状态、账户同步页、导出入口、复盘弹窗仍保持原型样式。
- 功能验证：重启后数据仍在；系统通知栏收到三连提醒；APP 内无三连提示；CSV 内容正确。
- 报告：`docs/reports/phase_5_services_persistence_report.md`。
- 门禁：等待用户确认报告后再进入 Phase 6。

### Phase 6：测试与验收

- 补 calculator、repository、controller、widget、integration 测试。
- 移动端验收基准包含 `390x844`，并覆盖至少一个小屏、一个常规 Android 尺寸、一个大屏和一个常见 iPhone 尺寸。
- Widget 测试必须覆盖：
  - `docs/product_spec.md` 中列出的核心 UI、表单、弹窗、导航和说明入口。
- Integration 测试必须覆盖：
  - `docs/product_spec.md` 中列出的关键流程：新增资产、取烟、放回、通知、复盘、导出、重置和设置持久化。
- UI 验收：按 full-validation 截图逐页记录对照结果；可微调安全区、平台字体和触摸反馈，但不得改变整体视觉风格；验证响应式布局，确认窄屏文字不重叠、不被截断，内容超高可滚动，横屏不红屏、不崩溃且无不可恢复遮挡。
- 功能验收：新增资产、取烟、通知、复盘、导出、重置、设置持久化。
- 报告：`docs/reports/phase_6_testing_acceptance_report.md`。
- 门禁：等待用户确认最终报告后结束首版阶段。

## Report Template

每个阶段报告必须包含：

- 阶段目标
- 已完成内容
- 新增或修改文件
- UI 验证方式与结果
- 已验证移动端尺寸；如未覆盖多尺寸，写明原因和补验计划
- 功能验证方式与结果
- 原型截图对照结果
- 验证命令与结果
- 未能验证的内容和原因
- 遗留问题
- 下一阶段注意事项
- 用户确认状态：待确认 / 已确认

## Product Spec Reference

- 产品定位、首版范围、信息架构、页面规格、公式、通知、本地数据、手表端未来规格和关键测试以 `docs/product_spec.md` 为准。
- 本计划保留阶段门禁、报告模板和 Flutter 工程执行顺序。
- 若本计划与 `docs/product_spec.md` 产生冲突，以 `docs/product_spec.md` 为准，并同步修订本计划。

## Assumptions

- Flutter SDK 当前可能不在 PATH；若执行时仍不可用，先生成源码和文档，编译验证待 SDK 配置后补做。
- 原型乱码文案不迁移，Flutter 版统一改写为可读中文。
- 实施时以最新 full-validation 截图作为视觉验收基准。
- 首版视觉验收基准排除手表端截图；这与当前“先不做手表端”的产品边界一致。
