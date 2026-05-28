#!/usr/bin/lua
-- LuCI controller for Homer management page
-- Backup is handled here; restore is handled by /www/cgi-bin/homer_restore (CGI)

module("luci.controller.homer", package.seeall)

local function get_router_ip()
 local uci = require "luci.model.uci".cursor()
 local ip = uci:get("network", "lan", "ipaddr")
 if not ip then return "unknown" end
 if type(ip) == "table" then ip = ip[1] end
 ip = tostring(ip)
 local clean_ip = ip:match("^([^/]+)")
 return clean_ip or "unknown"
end

local function get_homer_port()
 local uci = require "luci.model.uci".cursor()
 local port = ""
 uci:foreach("uhttpd", "uhttpd", function(s)
 if s[".name"] == "homer" then
 local listeners = s["listen_http"] or {}
 for _, v in ipairs(listeners) do
 local p = v:match(":(%d+)$")
 if p then port = p; break end
 end
 end
 end)
 return port
end

local function set_homer_port(port)
 os.execute(string.format(
  [[uci set uhttpd.homer=uhttpd;
uci delete uhttpd.homer.listen_http 2>/dev/null;
uci add_list uhttpd.homer.listen_http="0.0.0.0:%s";
uci set uhttpd.homer.home='/www/homer';
uci set uhttpd.homer.index_page='index.html';
uci set uhttpd.homer.no_dirlists='1';
uci commit uhttpd;
/etc/init.d/uhttpd reload]],
  port))
end

function index()
 entry({"admin", "services", "homer"}, call("action_manager"), _("Homer"), 100).leaf = true
end

function action_manager()
 local http = require "luci.http"
 local fs = require "nixio.fs"

 -- 处理设置端口
 if http.formvalue("setport") then
 local port = http.formvalue("port")
 if port and port:match("^%d+$") then
 local pnum = tonumber(port)
 if pnum and pnum >= 1 and pnum <= 65535 then
 set_homer_port(port)
 -- 直接重新渲染页面
 local template = require "luci.template"
 template.render("homer/homer_manager", {
 homer_port = get_homer_port(),
 router_ip = get_router_ip(),
 })
 return
 end
 end
 end

 -- 全套备份
 if http.formvalue("fullbackup") then
 local timestamp = os.date("%Y%m%d%H%M%S")
 local backup_file = "/tmp/Homer_" .. timestamp .. ".zip"
 local cmd = "cd /www/homer && 7z a -tzip '" .. backup_file .. "' . -x'!.git*' >/dev/null 2>&1"
 os.execute(cmd)
 if fs.access(backup_file) then
 http.header("Content-Type", "application/zip")
 http.header("Content-Disposition", 'attachment; filename="Homer_' .. timestamp .. '.zip"')
 http.write(fs.readfile(backup_file))
 os.remove(backup_file)
 else
 http.header("Status", "500 Internal Server Error")
 http.write("Backup failed")
 end
 return
 end

 -- 渲染管理页面，传入端口 + 路由器IP
 local template = require "luci.template"
 template.render("homer/homer_manager", {
 homer_port = get_homer_port(),
 router_ip = get_router_ip(),
 })
end
