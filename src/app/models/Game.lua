
local Game = class("Game")

Game.HOLE_POSITION = cc.p(display.cx - 30, display.cy - 75)
Game.INIT_STARS = 5
Game.BUG_ENTER_HOLE_EVENT = "BUG_ENTER_HOLE_EVENT"
Game.PLAYER_DEAD_EVENT = "PLAYER_DEAD_EVENT"

local BugAnt = import(".BugAnt")
local BugSpider = import(".BugSpider")

function Game:ctor(stage)
    self.stage_ = stage

    self.stars_ = Game.INIT_STARS
    self.bugs_ = {}
    self.bugsSprite_ = {}
    self.deadCount_ = 0

    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end

function Game:getStars()
    return self.stars_
end

function Game:getDeadCount()
    return self.deadCount_
end

function Game:addBug()
    local bug
    if math.random(1, 2) % 2 == 0 then
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

function Game:bugEnterHole_(index)
    local bug = self.bugs_[index]
    local sprite = self.bugsSprite_[index]

    transition.fadeOut(sprite, {
        time = 0.5,
        onComplete = function()
            sprite:removeSelf()
        end})

    table.remove(self.bugs_, index)
    table.remove(self.bugsSprite_, index)

    self.stars_ = self.stars_ - 1
    self:dispatchEvent({name = Game.BUG_ENTER_HOLE_EVENT})
    audio.playSound("sfx/bug_enter.wav")

    if self.stars_ <= 0 then
        self:playerDead_()
    end
end

function Game:playerDead_()
    self:dispatchEvent({name = Game.PLAYER_DEAD_EVENT})
    audio.playSound("sfx/player_dead.wav")
end

function Game:step()
    if self.stars_ <= 0 then return end

    for i = #self.bugs_, 1, -1 do
        local bug = self.bugs_[i]
        bug:step()

        local sprite = self.bugsSprite_[i]
        sprite:pos(bug:getPosition())

        if bug:getDist() <= 0 then
            self:bugEnterHole_(i)
        end
    end
end

function Game:bugDead_(index)
    local bug = self.bugs_[index]
    local sprite = display.newSprite(bug:getDeadSpriteName())
        :pos(bug:getPosition())
        :rotation(math.random(0, 360))
        :addTo(self.stage_)

    transition.fadeOut(sprite, {
        time = 0.5,
        delay = 2.0,
        onComplete = function()
            sprite:removeSelf()
        end})

    self.bugsSprite_[index]:removeSelf()
    table.remove(self.bugs_, index)
    table.remove(self.bugsSprite_, index)

    self.deadCount_ = self.deadCount_ + 1

    audio.playSound("sfx/bug_dead.wav")
end

function Game:onTouch(event)
    if self.stars_ <= 0 then return end

    if event.name == "began" then
        local x, y = event.x, event.y

        for i = #self.bugs_, 1, -1 do
            local bug = self.bugs_[i]
            if bug:checkTouch(x, y) then
                self:bugDead_(i)
            end
        end
    end

    return false
end

return Game
