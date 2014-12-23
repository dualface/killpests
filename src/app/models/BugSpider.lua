
local BugBase = import(".BugBase")

local BugSpider = class("BugSpider", BugBase)

function BugSpider:ctor()
    BugSpider.super.ctor(self)
    self.type_ = BugBase.BUG_TYPE_SPIDER
end

function BugSpider:getSpriteName()
    return "img/bug2_01.png"
end

return BugSpider
