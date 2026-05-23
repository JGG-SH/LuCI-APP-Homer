本插件是为实现移植bastienwirtz/homer个人主页导航用于Openwrt系统
由于Homer是一个静态的网页架构，不用做任何更改，原作者的运行基础是Docker，实际任何平台都是可以的，因为它只是一个网页
本插件简要说明如下：
1、在openwrt主目录下新建www/homer文件夹
2、在服务菜单下生成Homer项
3、进入Homer具有：
   A、bastienwirtz/homer原始下载路径；（可至官方下载最新网页模板）
   B、导出www/homer已个性化设置的网页；（个性化修改需借助第三方工具，本插件只做导入导出作用）
   C、清空www/homer下已有网页；
   D、导入www/homer已定制后或者原版或者第三方主题的网页（均以homer为基础）
4、以上所有导入导出借助openwrt原始具有的.zip与.unzip功能，使导入导出均实现一个zip包的形式

以上功能简易，实现个人使用需求，不喜勿喷~
