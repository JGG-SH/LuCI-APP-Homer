#!/usr/bin/lua
-- LuCI controller for Homer management page
-- Backup is handled here; restore is handled by /www/cgi-bin/homer_restore (CGI)

module("luci.controller.homer", package.seeall)

function index()
    entry({"admin", "services", "homer"}, call("action_manager"), _("Homer"), 100).leaf = true
end

function action_manager()
    local http = require "luci.http"
    local fs = require "nixio.fs"

    -- 全套备份（打包整个 /www/homer 目录为 zip）
    if http.formvalue("fullbackup") then
        local timestamp = os.date("%Y%m%d%H%M%S")
        local backup_file = "/tmp/Homer_" .. timestamp .. ".zip"
        -- 7z 排除语法：-x"!pattern"（注意 ! 前缀，不是 * 前缀）
        local cmd = 'cd /www/homer && 7z a -tzip "' .. backup_file .. '" . -x"!.git*" >/dev/null 2>&1'
        os.execute(cmd)
        if fs.access(backup_file) then
            http.header("Content-Type", "application/zip")
            http.header("Content-Disposition", "attachment; filename=\"Homer_" .. timestamp .. ".zip\"")
            http.write(fs.readfile(backup_file))
            os.remove(backup_file)
        else
            http.header("Status", "500 Internal Server Error")
            http.write("Backup failed")
        end
        return
    end

    -- 恢复功能由 /www/cgi-bin/homer_restore CGI 脚本处理
    -- 表单直接 POST 到 CGI，不走这里

    -- 渲染管理页面
    local template = require "luci.template"
    template.render("homer/homer_manager")
end
