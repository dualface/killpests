
local BugBase = import(".BugBase")

local BugAnt = class("BugAnt", BugBase)

function BugAnt:ctor()
    BugAnt.super.ctor(self)
    self.type_ = BugBase.BUG_TYPE_ANT
    self.speed_ = 2
    self.touchRange_ = 70
end

function BugAnt:getSpriteName()
    return "img/bug1_01.png"
end

function BugAnt:getDeadSpriteName()
    return "img/bug1_dead.png"
end

return BugAnt
