# Homer 个人主页导航插件 for OpenWrt

本插件是为实现移植 <a href="https://github.com/bastienwirtz/homer" target="_blank">bastienwirtz/homer</a> 个人主页导航，用于 **OpenWrt** 系统。

Homer 是一个极其轻量化的静态网页架构，虽然初始是被运行于Docker，但实际上任何平台均可部署——因为它仅仅是一个网页（含支持架构）。

## 插件功能说明

1. 在 OpenWrt 主目录下新建 `www/homer` 文件夹  
2. 在 **服务** 菜单下生成 `Homer` 管理项  
3. 进入 Homer 管理界面后，提供以下操作：  

   - **A. 原始下载路径**  
     可跳转至 <a href="https://github.com/bastienwirtz/homer" target="_blank">bastienwirtz/homer</a> 官方仓库，下载最新网页模板  
   - **B. 导出已个性化设置的网页**  
     将 `/www/homer` 下已修改的页面导出为 `.zip` 压缩包  
     > 个性化修改需借助第三方工具，本插件仅做导入/导出作用  
   - **C. 清空现有网页**  
     一键清空 `/www/homer` 目录下的所有文件  
   - **D. 导入网页包**  
     支持导入已进行个人化修改的、原版的或第三方主题的 Homer 网页（必须以 Homer 为基础）  

4. 所有导入/导出功能均借助 OpenWrt 自带的 `.zip` 与 `.unzip` 命令实现，最终操作均以 **一个 ZIP 包** 的形式完成。

> 以上功能简易，满足个人使用需求，不喜勿喷～ 🤗

> 个人化修改我选择使用工具与AI同时助力，希望有更多朋友做出漂亮的主题
