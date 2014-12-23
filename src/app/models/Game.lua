
local Game = class("Game")

Game.HOLE_POSITION = cc.p(display.cx - 30, display.cy - 75)

Game.BUG_ENTER_HOLE_EVENT = "enter_hole"

local BugAnt = import(".BugAnt")
local BugSpider = import(".BugSpider")

function Game:ctor(stage)
    self.stage_ = stage

    self.bugs_ = {}
    self.bugsSprite_ = {}

    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end

function Game:addBug()
    local bug
    if math.random() % 2 == 0 then
        bug = BugAnt.new()
    else
        bug = BugSpider.new()
    end
    bug:setInitPosition(Game.HOLE_POSITION)

    self.bugs_[#self.bugs_ + 1] = bug

    local sprite = display.newSprite(bug:getSpriteName())
        :pos(bug:getPosition())
        :rotation(bug:getRotation())
        :addTo(self.stage_)
    self.bugsSprite_[#self.bugsSprite_ + 1] = sprite
end

function Game:step()
    for i = #self.bugs_, 1, -1 do
        local bug = self.bugs_[i]
        bug:step()

        local sprite = self.bugsSprite_[i]
        sprite:pos(bug:getPosition())

        if bug:getDist() <= 0 then
            transition.fadeOut(sprite, {
                time = 0.5,
                onComplete = function()
                    sprite:removeSelf()
                end})

            table.remove(self.bugs_, i)
            table.remove(self.bugsSprite_, i)

            self:dispatchEvent({name = Game.BUG_ENTER_HOLE_EVENT})
        end
    end
end

return Game
