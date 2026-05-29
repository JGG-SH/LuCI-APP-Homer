# Homer 个人主页导航插件 for OpenWrt

（作者：阿拉杰哥哥 JGG-SH）

本插件是为实现移植 <a href="https://github.com/bastienwirtz/homer" target="_blank">bastienwirtz/homer</a> 个人主页导航，用于 **OpenWrt** 系统。

bastienwirtz/Homer 是一个极其轻量化的静态网页框架，虽然初始是被运行于 Docker，但实际上任何平台均可部署——因为它仅仅是一个网页（含支持架构）。

Homer 项目依然还在更新，具有生命力，感谢原作者。

---

## 插件是什么

本插件是一个 **轻量级静态网站容器**，在 OpenWrt 路由器上为 `/www/homer` 目录提供一个独立的 uhttpd 实例，使该目录下的网页内容可通过指定端口独立访问。

```
/www/homer/  ← 这个目录里放什么，访问时就显示什么
```

## 插件能做什么

| 类型 | 举例 | 支持 |
|------|------|:----:|
| 纯静态 HTML | 个人导航页、介绍页 | ✅ |
| CSS/JS 前端 | Vue、React 单页应用 | ✅ |
| 有交互的 | 表单、计算器、小游戏 | ✅（前端 JS 实现） |
| 需要后端的 | 数据库、用户登录、API | ❌ uhttpd 仅托管静态文件 |

> uhttpd 是纯静态文件服务器，不支持 PHP / Python / Node.js 后端、数据库或服务端渲染。
> 如需更复杂功能，可使用前端方案（Vue/React + LocalStorage/IndexDB）实现数据持久化。

---

## 插件功能说明

1. 在 OpenWrt 主目录下新建 `www/homer` 文件夹
2. 在 **服务** 菜单下生成 `Homer` 管理项
3. 进入 Homer 管理界面后，提供以下操作：

   - **A. 原始下载路径**
     可跳转至 <a href="https://github.com/bastienwirtz/homer" target="_blank">bastienwirtz/homer</a> 官方仓库，下载最新网页模板
   - **B. 导出已个性化设置的网页**
     将 `/www/homer` 下已修改的页面导出为 `.zip` 压缩包
   - **C. 导入网页包**
     支持导入已进行个人化修改的、原版的或第三方主题的 Homer 网页（必须以 Homer 为基础）
   - **D. 设置端口**
     为 Homer 设置独立访问端口，通过 `http://路由器IP:端口` 访问，方便反代穿透到外网

4. 所有导入/导出功能均借助 OpenWrt 自带的 `7z` 与 `unzip` 命令实现，最终操作均以 **一个 ZIP 包** 的形式完成。

---

## 运行所需文件

| 文件 | 作用 | 必须 |
|------|------|:----:|
| `index.html` | 主页面 | ✅ |
| `favicon.ico` | 浏览器标签页图标 | 建议有 |

其他文件（`assets/`、`config.yml`、`logo.png` 等）取决于你的 `index.html` 引用了什么。

---

## 其他说明

以上功能简易，满足个人使用需求，不喜勿喷～ 🤗

个性化修改我选择使用工具与 AI 同时助力，希望有更多朋友做出漂亮的主题并分享出来。

我目前借助 Lucky + 域名实现内网穿透，将个性化修改的个人主页导航放入 Homer 布置于家中路由器中，全时在线，不占内存，有外部访问才读取网页数据。

如有分享优质静态网页或者有更好项目，可拉我进群一起热闹，QQ：15097045 火浴凰