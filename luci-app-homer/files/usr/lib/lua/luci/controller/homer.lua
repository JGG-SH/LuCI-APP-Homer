module("luci.controller.homer", package.seeall)

function index()
    entry({"admin", "services", "homer"}, call("action_manager"), _("Homer"), 100).leaf = true
end

function action_manager()
    local http = require "luci.http"
    local fs = require "nixio.fs"

    -- 全套备份（打包整个 /www/homer 目录为 zip，内部不包含 homer 父目录）
    if http.formvalue("fullbackup") then
        local timestamp = os.date("%Y%m%d%H%M%S")
        local backup_file = "/tmp/Homer" .. timestamp .. ".zip"
        local cmd = 'cd /www/homer && zip -r ' .. backup_file .. ' . -x "*.git*"'
        os.execute(cmd)
        if fs.access(backup_file) then
            http.header('Content-Disposition', 'attachment; filename="Homer' .. timestamp .. '.zip"')
            http.write(fs.readfile(backup_file))
            os.remove(backup_file)
        else
            http.status(500, "Internal Server Error")
            http.write("打包失败，请检查是否安装了 zip 命令")
        end
        return
    end

    -- 全套恢复（上传 zip，自动适应内层是否包含 homer 目录）
    if http.formvalue("fullrestore") then
        local upload = http.getfile()
        if upload and upload.name == "restore_file" then
            local uploaded_file = "/tmp/homer_upload.zip"
            local f = io.open(uploaded_file, "w")
            if f then
                f:write(upload.data)
                f:close()
                -- 备份当前目录
                os.execute('rm -rf /www/homer_old_backup')
                os.execute('mv /www/homer /www/homer_old_backup 2>/dev/null')
                os.execute('mkdir -p /www/homer')
                local temp_dir = "/tmp/homer_extract"
                os.execute('rm -rf ' .. temp_dir)
                os.execute('mkdir -p ' .. temp_dir)
                local cmd = 'unzip -q ' .. uploaded_file .. ' -d ' .. temp_dir
                local ret = os.execute(cmd)
                if ret == 0 then
                    -- 检测压缩包内第一层内容
                    local handle = io.popen('ls ' .. temp_dir)
                    local first = handle:read("*l")
                    local second = handle:read("*l")
                    handle:close()
                    if second == nil and first == "homer" then
                        -- 如果只有单个 homer 文件夹，则将其内容移出
                        os.execute('cp -rf ' .. temp_dir .. '/homer/* /www/homer/')
                    else
                        -- 否则直接复制所有内容
                        os.execute('cp -rf ' .. temp_dir .. '/* /www/homer/')
                    end
                    os.execute('rm -rf ' .. temp_dir)
                    os.execute('chmod -R 755 /www/homer')
                    os.remove(uploaded_file)
                    http.redirect(luci.dispatcher.build_url("admin/services/homer"))
                else
                    -- 解压失败，恢复备份
                    os.execute('rm -rf /www/homer')
                    os.execute('mv /www/homer_old_backup /www/homer')
                    os.remove(uploaded_file)
                    http.status(500, "Internal Server Error")
                    http.write("解压失败，请确保上传的是有效的 zip 文件")
                end
            else
                http.write("上传文件写入失败")
            end
        else
            http.write("未收到文件")
        end
        return
    end

    local template = require "luci.template"
    template.render("homer/homer_manager")
end
