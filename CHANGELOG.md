# Changelog

## v0.0.2

### 中文

#### 新增
- 首页文章标题支持显示 `置顶` 标识。
- 右侧 `文章榜`、`标签榜` 标题补充 icon。
- 首页分页模式支持更轻量的局部翻页体验，减少整页刷新带来的闪动。

#### 优化
- 首页文章列表调整为更符合论坛场景的展示逻辑：
  - 置顶文章优先展示。
  - 非置顶文章优先按最后回复时间排序。
- 右侧 `最新文章` 保持按发布时间排序，不受回复排序影响。
- 首页 `分页模式` 与 `无限瀑布流模式` 的实现拆分，避免两套逻辑互相干扰。
- 修复首页无限瀑布流在部分情况下只显示首屏文章、不继续加载的问题。
- 修复首页分页、刷新、点击 Logo 返回首页时的首屏样式闪动问题。
- 优化置顶标识与标题文字之间的间距，整体观感更紧凑。
- 首页、分类页、标签页的文章卡片样式与交互细节进一步统一。

#### 修复
- 修复置顶文章在首页瀑布流与分页场景下可能失效的问题。
- 修复测试回复后帖子不能正确提升到前列的问题。
- 修复分页模式下翻页瞬间右侧侧栏消失、主列放大、链接样式短暂异常的问题。
- 修复 `文章榜`、`标签榜` icon 显示不稳定的问题。

### English

#### Added
- Added a `Pinned` badge before pinned post titles on the homepage.
- Added icons to the `Post Rank` and `Tag Rank` sidebar section headers.
- Added a lighter partial page transition for homepage pagination to reduce full-page flicker.

#### Improved
- Refined homepage post ordering for a more forum-like experience:
  - Pinned posts are shown first.
  - Non-pinned posts are prioritized by latest reply activity.
- Kept the `Latest Posts` sidebar section sorted by publish time only.
- Split homepage `paged mode` and `infinite waterfall mode` into separate implementations to avoid logic conflicts.
- Fixed cases where infinite waterfall stopped after the first screen and failed to continue loading.
- Reduced first-load, refresh, and homepage-return visual flicker on the homepage.
- Tightened the spacing between the pinned badge and post title text.
- Further unified post card behavior and styling across home, category, and tag views.

#### Fixed
- Fixed pinned posts not being respected correctly in some homepage paged and waterfall scenarios.
- Fixed replied posts not moving forward correctly after new comments in testing.
- Fixed pagination flicker where the sidebar briefly disappeared, the main column stretched, and link styles temporarily fell back to browser defaults.
- Fixed unstable icon display for `Post Rank` and `Tag Rank`.
