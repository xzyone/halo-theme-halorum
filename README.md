# Halorum

Halorum 是一款面向 Halo 2.x 的轻论坛风格主题，基于 `mulingyuer/Typecho_Theme_JJ` 的视觉语言移植并重构。主题使用 Astro 预渲染模板，保留原主题偏社区化、偏技术阅读的气质，同时围绕 Halo 的文章、评论、用户中心和主题设置体系做了适配。

当前版本：`v0.0.2`

## 特性

- 论坛式首页布局：左侧板块导航、中间文章流、右侧信息栏。
- 首页支持分页模式和无限加载模式，可在后台主题设置中切换。
- 支持自定义首页文章数量、分类卡片、最新文章、文章榜、作者榜和标签榜。
- 文章页提供更贴近社区讨论场景的评论区样式。
- 顶部集成发布入口、通知入口和用户中心头像菜单。
- 支持浅色 / 深色主题、Markdown 样式和代码高亮样式切换。
- 支持自定义 `Head HTML`、`CSS` 和 `JavaScript`。
- 使用 Astro 构建 Halo 模板，源码和产物分离，便于继续维护。

## 运行要求

- Halo `>= 2.0.0`
- Node.js `>= 18.17.1`
- pnpm `>= 10`

## 安装

1. 从 Release 下载 `Halorum.zip`。
2. 进入 Halo 后台：`外观` -> `主题` -> `安装主题`。
3. 上传 `Halorum.zip` 并启用主题。
4. 进入主题设置，根据站点需要配置 Logo、首页、评论和样式选项。

## 本地开发

```bash
pnpm install
pnpm build
pnpm pack:theme
```

`pnpm build` 会将 Astro 模板构建到 `templates/` 目录。  
`pnpm pack:theme` 会在仓库上级目录生成 `Halorum.zip`。

开发时可以使用：

```bash
pnpm dev
```

该命令会以 watch 模式持续构建，适合本地调试模板和样式。

## 主题设置

| 分组 | 说明 |
| --- | --- |
| `basic` | Logo、联系信息、备案信息、Markdown 样式、代码高亮样式 |
| `sidebar` | 首页文章数量、加载方式、最新文章、分类卡片和右侧模块 |
| `forum` | 评论排序和评论区文案 |
| `style` | 主题强调色、卡片圆角、顶部阴影 |
| `custom` | 自定义 `Head HTML`、`CSS`、`JavaScript` |

## 目录结构

```text
Halorum/
├─ public/       静态资源
├─ scripts/      打包脚本
├─ src/          Astro 源码
├─ templates/    Halo 模板构建产物
├─ settings.yaml 主题设置描述
└─ theme.yaml    Halo 主题元信息
```

## 打包说明

打包脚本会排除本地开发目录，例如 `.git`、`.astro`、`node_modules`、`.vscode` 和 `.idea`，避免生成过大的主题包。

生成的主题包为：

```text
../Halorum.zip
```

## 版本记录

### v0.0.2

- 首页文章列表增强论坛化排序逻辑，支持置顶优先与最后回复优先。
- 首页分页模式与无限瀑布流模式拆分实现，减少相互影响。
- 修复首页分页、刷新、点击 Logo 返回首页时的样式闪动问题。
- 新增首页文章置顶标识，并补充右侧文章榜、标签榜标题 icon。

### v0.0.1

- 初始发布版本。
- 完成 Typecho 主题视觉迁移和 Halo 主题结构适配。
- 完成首页分页 / 无限加载、论坛式评论区、用户菜单、通知入口和主题设置。
- 优化打包脚本，避免将本地开发目录带入发布包。

## 致谢

- 原主题：[`mulingyuer/Typecho_Theme_JJ`](https://github.com/mulingyuer/Typecho_Theme_JJ)
- Halo：<https://www.halo.run>
- Astro：<https://astro.build>

## 许可证

本项目采用 BSD-3-Clause 许可证，详见 [LICENSE](./LICENSE)。
