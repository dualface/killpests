
local BugBase = import(".BugBase")

local BugSpider = class("BugSpider", BugBase)

function BugSpider:ctor()
    BugSpider.super.ctor(self)
    self.type_ = BugBase.BUG_TYPE_SPIDER
    self.speed_ = 1
    self.touchRange_ = 50
end

function BugSpider:getSpriteName()
    return "img/bug2_01.png"
end


function BugSpider:getDeadSpriteName()
    return "img/bug2_dead.png"
end

return BugSpider
