require "AppUtil"
require "Resources"

Game = {
    new = function()
        local this = {}
        -- 戻すための入れ物

        local options = {}
        -- 配置するためのオプション

        local countNum = 0
        -- カウントダウンしている変数

        this.questionIndex = 1
        this.questions = {}
        -- 問題が入るいれもの

        this.viewGroup = display.newGroup()
        -- 画面に配置されているものを管理しているグループ

        -- ここから
        this.backGround = display.newImageRect(this.viewGroup, backGroundImage, w, h)
        this.backGround.x = w/2
        this.backGround.y = h/2
        -- ここまでが画面に物を置くときのおまじない

        -- 同じように置く
        this.swimmer = display.newImageRect(this.viewGroup, swimmerImage, w/4, w/4)
        this.swimmer.x = w/2
        this.swimmer.y = h/3 + this.swimmer.height
        -- 同じように置く

        this.shark = display.newImageRect(this.viewGroup, sharkImage, w/2, w/2)
        this.shark.x = w/2
        this.shark.y = h - this.shark.height/2

        this.ship = display.newImageRect(this.viewGroup, shipImage, w/5, w/10)
        this.ship.x = getLeftX(this.backGround) + this.ship.width/2
        -- getLeftX(カッコの中の物の左側のX座標を取得)
        this.ship.y = h/3

        this.island = display.newImageRect(this.viewGroup, islandImage, w/5, w/5)
        this.island.x = this.island.width/2
        this.island.y = h/3

        this.buttonTrue = display.newImageRect(this.viewGroup, trueImage, w/4, w/4)
        this.buttonTrue.x = w/4
        this.buttonTrue.y = h * 3/5
        this.buttonTrue.name = "buttonTrue"

        this.buttonFalse = display.newImageRect(this.viewGroup, falseImage, w/4, w/4)
        this.buttonFalse.x = w * 3/4
        this.buttonFalse.y = h * 3/5
        this.buttonFalse.name = "buttonFalse"

        this.questionBG = display.newImageRect(this.viewGroup, questionImage, w, h/3)
        this.questionBG.x = w/2
        this.questionBG.y = getTopY(this.swimmer) - this.questionBG.height/2
        this.questionBG.alpha = 0.8

        options = {}
        -- Optionを初期化
        options = {
           text = "",
           x = this.questionBG.x,
           y = this.questionBG.y,
           fontSize = 50,
           width = this.questionBG.width * 4/5,
           height = this.questionBG.height * 2/3,
           align = "center"
        }
        -- newTextするためのオプション

        this.question = display.newText(options)
        this.question:setTextColor(0, 0, 0)
        this.viewGroup:insert(this.question)

        options = {}
        -- Optionを初期化
        options = {
           text = "",
           x = this.shark.x,
           y = this.shark.y,
           fontSize = 400,
           width = this.shark.width,
           height = this.shark.height,
           align = "center"
        }
        -- newTextするためのオプション

        this.countText = display.newText(options)
        this.viewGroup:insert(this.countText)

        options = {}
        -- Optionを初期化
        options = {
           text = "",
           x = this.shark.x,
           y = this.shark.y,
           fontSize = 200,
           width = w,
           height = 200,
           align = "center"
        }
        -- newTextするためのオプション

        this.resultText = display.newText(options)
        this.viewGroup:insert(this.resultText)

        function onCount()
            -- タイマーによって1000ms(1s)に一度呼び出される
            countNum = countNum - 1
            this.countText.text = countNum

            if (countNum <= 0) then
                this.countText.text = ""
                timer.cancel(this.onCountTimer)
                this.onCountTimer = nil
                this.startShipMove()
                this.question.text = this.questions[this.questionIndex].question

                this.buttonTrue:addEventListener("tap", onButtonClick)
                this.buttonFalse:addEventListener("tap", onButtonClick)
            end
        end

        function onShipMove()
            -- タイマーによって20msに一度呼び出される
                this.ship.x = this.ship.x + (w-this.ship.width)/300
                -- 20ms * 300 = 6000(6秒で画面横断)

                if (getRightX(this.ship) >= w) then
                -- shipの右側が画面右端よりも右にいってたら
                    timer.cancel(this.onShipMoveTimer)
                    this.onShipMoveTimer = nil
                    -- アニメーションをストップ
                end
        end

        function onButtonClick(event)
            local myAns
            if (event.target.name == "buttonTrue") then
                myAns = true
            else
                myAns = false
            end

            if (myAns == this.questions[this.questionIndex].answer) then
                this.resultText.text = "正解"
            else
                this.resultText.text = "ハズレ"
            end
        end

        this.startCount = function()
            countNum = 5
            this.countText.text = countNum
            this.onCountTimer = timer.performWithDelay(1000, onCount, 0)
        end

        this.startShipMove = function()
            this.onShipMoveTimer = timer.performWithDelay(20, onShipMove, 0)
            -- 20秒に1度onTickを呼び出すタイマーを起動
        end

        this.delete = function ()
            local i
            for i = this.viewGroup.numChildren, 1, -1 do
                local child = this.viewGroup[i]
                child.parent:remove(child)
                child = nil
            end
        end

        return this
        -- thisを返す（これによってship等を外からいじれるようになる）
    end
}
