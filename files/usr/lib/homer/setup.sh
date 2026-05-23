#!/bin/sh
# Homer 安装后初始化脚本（通用逻辑，可重复调用）

# 如果已经配置过了，直接退出
if grep -q "alias='/homer=/www/homer'" /etc/config/uhttpd 2>/dev/null; then
    exit 0
fi

# 追加 Homer 配置到 uhttpd
echo "list alias '/homer=/www/homer'" >> /etc/config/uhttpd

# 重启 uhttpd 使配置生效
/etc/init.d/uhttpd restart

exit 0
