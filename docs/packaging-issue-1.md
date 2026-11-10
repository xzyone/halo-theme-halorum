# Issue #1：打包与发布核查（2026-10-28）

## 已确认的缺陷

基线：`a13e9b23be66b8303cc343bf1338376f117375b1`（main / v0.0.2）。

从 GitHub Release 下载的 `Halorum.zip` 为 9,430,432 字节，SHA-256：
`bdcc27ca1b452fe1f917a17fab9fb35bcc6f51418673226949b54c668d559291`，与 Release API 的 digest 一致。

该 ZIP 有 819 个条目，CRC 检查通过，但：

- `public/assets/theme/dist/` 下 13 个文件全部缺失：9 CSS、3 字体、1 PNG。
- `templates/assets/theme/dist/` 下对应的 13 个构建副本也全部缺失。
- 误包含 27 个 `.git/` 文件，以及 `.astro/` 构建缓存。

原因：`/dist/` 对绝对路径匹配，排除了任意层级的 dist；隐藏目录正则中的 `\\.` 也没有按预期匹配字面点号。修复改为仓库相对路径，仅排除 `^dist/`，并修正隐藏目录表达式。运行资源目录的结构保持不变。

从[应用市场](https://www.halo.run/store/apps/app-slsvrqpt)的实际下载入口取得的当前 0.0.2 包（release `app-release-wrfcwhfz` / asset `app-release-wrfcwhfz-9r0f76tn`）同为 9,430,432 字节，SHA-256 与上述 GitHub 包完全相同。两端实际分发包的缺失现已确认。

## 发布链路

[CD run 25744499122](https://github.com/xzyone/halo-theme-halorum/actions/runs/25744499122) 的 Package Theme、GitHub Release 和 App Store Release 均成功。该次运行使用共享 workflow 提交 `7ba7c1f88edeca4c685b0d62f9ea5af4fb3afbea`。

共享 workflow 在 Ubuntu 执行 `pnpm build`（Astro 构建后调用打包脚本），上传 `dist` 为 `theme-package`，两个发布 job 下载同一 artifact，分别上传 GitHub 和 Halo 应用市场。仓库 CD 配置为 `skip-appstore-release: false`、`app-id: app-slsvrqpt`。

新校验在打包脚本内执行，发生在复制兼容包及 CD 上传 artifact 之前；失败会移除无效输出 ZIP 并使构建失败。因此不必复制或替换共享发布 workflow。

## 验证边界与修复版本

PowerShell 回归测试实际生成 ZIP，覆盖父目录含 dist/node_modules、根目录输出排除、隐藏开发目录排除、嵌套 dist 保留、重复打包及兼容副本一致性；负例覆盖 CSS/字体/模板缺失、内容变化、开发文件混入和构建副本缺失。

独立校验器会拒绝现有 v0.0.2 发布包。它检查完整 public/templates 文件清单、关键元信息/模板和 SHA-256，不代表已经通过 Halo 运行时验证。

建议合并修复后发布 v0.0.3，同步版本元信息及更新日志，不覆盖旧 tag/资产。发布前需在 Halo 2.24.2 验证全新 ZIP 安装；发布后从应用市场全新安装及从 v0.0.2 升级，检查首页、文章页、CSS、字体和图片请求。两端实际下载包还应做 SHA-256/清单对比。

Issue 保持 Open，直到实际安装确认。GitHub 与应用市场实际下载包字节一致，均存在上述缺陷；仍未运行 Halo 安装，不能排除其他运行时问题。历史 job 日志已过期（API 410）。
