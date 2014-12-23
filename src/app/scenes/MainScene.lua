
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    display.newSprite("img/cover.jpg")
        :pos(display.cx, display.cy)
        :addTo(self)

    cc.ui.UIPushButton.new("img/play_button.png")
        :onButtonClicked(function()
            math.newrandomseed()
            app:enterScene("PlayScene", nil, "Random", 1.0)
        end)
        :pos(display.cx, display.cy - 200)
        :addTo(self)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
