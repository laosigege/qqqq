
cc.FileUtils:getInstance():setPopupNotify(false)

local writablePath = cc.FileUtils:getInstance():getWritablePath()
cc.FileUtils:getInstance():addSearchPath(writablePath.."download/src/",true)
cc.FileUtils:getInstance():addSearchPath(writablePath.."download/res/",true)

cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")


local function checkUpdate()
    local code = jt.CPlatformCommunication:getInstance():sendLightMessage("getAppVersionCode")
    code = tonumber(code)
    if code == nil then
        code = 0
    end
    release_print("当前版本号:",code)
    local installCode = cc.UserDefault:getInstance():getIntegerForKey("installCode",-1)
    release_print("version","code:"..code..",installCode:"..installCode)
    if code > installCode then
        if installCode == -1 then
            release_print("首次安装,VersionCode:",code)
        else
            release_print("覆盖安装,VersionCode:",code)
        end
        local writablePath = cc.FileUtils:getInstance():getWritablePath()
        if cc.FileUtils:getInstance():isDirectoryExist(writablePath.."download/src/") then
            local b1 = cc.FileUtils:getInstance():removeDirectory(writablePath.."download/src/")
            local b2 = cc.FileUtils:getInstance():removeDirectory(writablePath.."download/res/")
            print("重置搜索目录")
            local arr = {}
            cc.FileUtils:getInstance():setSearchPaths(arr)
            cc.FileUtils:getInstance():addSearchPath(writablePath)
            cc.FileUtils:getInstance():addSearchPath("src/")
            cc.FileUtils:getInstance():addSearchPath("res/")
        end
    else
    end

    if installCode == -1 or code > installCode then
        cc.UserDefault:getInstance():setIntegerForKey("installCode",code)
        local transferKey = "transfer_"..device.platform.."_"..jt.CPlatformCommunication:getInstance():sendLightMessage("getAppVersionName")
        cc.UserDefault:getInstance():setIntegerForKey(transferKey,0)
        cc.UserDefault:getInstance():flush()
    end

end

require "config"
require "cocos.init"

local function init()

    --全局定义--
    require "app/library/bit.lua"
    require "cocos/cocos2d/bitExtend.lua"
    require "app/library/BtnGroup.lua"
    require "app/library/MotionUtil.lua"
    require "app/library/Resources.lua"
    require "src/app/control/CFrameDataHandler.lua"
    require "app/models/protocol/Protocol.lua"
    require "app/manager/GameManager.lua"
--    require "update.lua"
    --/
end

local function main()
    checkUpdate()
    init()
    require("app.MyApp"):create():run("scene/LaunchScene.lua")
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    release_print(msg)
end
