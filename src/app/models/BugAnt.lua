
local BugBase = import(".BugBase")

local BugAnt = class("BugAnt", BugBase)

function BugAnt:ctor()
    BugAnt.super.ctor(self)
    self.type_ = BugBase.BUG_TYPE_ANT
end

function BugAnt:getSpriteName()
    return "img/bug1_01.png"
end

return BugAnt
