-- Ключ-система с улучшенным дизайном
local correctKey = "deepseekhackbeta"
local inputKey = ""

-- Анимация загрузки
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingGUI"
loadingGui.Parent = game.CoreGui

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 350, 0, 180)
loadingFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
loadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
loadingFrame.BackgroundTransparency = 0.2
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = loadingGui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 12)
loadingCorner.Parent = loadingFrame

-- Эффект стекла
local glassEffect = Instance.new("Frame")
glassEffect.Size = UDim2.new(1, 0, 1, 0)
glassEffect.BackgroundTransparency = 0.95
glassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassEffect.BorderSizePixel = 0
glassEffect.Parent = loadingFrame

local loadingTitle = Instance.new("TextLabel")
loadingTitle.Text = "DEEPSEEK HACK v2.0"
loadingTitle.Size = UDim2.new(1, 0, 0, 40)
loadingTitle.Position = UDim2.new(0, 0, 0, 0)
loadingTitle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
loadingTitle.TextColor3 = Color3.new(1, 1, 1)
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.TextSize = 18
loadingTitle.BorderSizePixel = 0
loadingTitle.Parent = loadingFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12, 0, 0)
titleCorner.Parent = loadingTitle

local loadingIcon = Instance.new("ImageLabel")
loadingIcon.Size = UDim2.new(0, 60, 0, 60)
loadingIcon.Position = UDim2.new(0.5, -30, 0.5, -50)
loadingIcon.BackgroundTransparency = 1
loadingIcon.Image = "rbxassetid://7072717162"
loadingIcon.Parent = loadingFrame

local loadingText = Instance.new("TextLabel")
loadingText.Text = "Загрузка премиум интерфейса..."
loadingText.Size = UDim2.new(1, -20, 0, 20)
loadingText.Position = UDim2.new(0, 10, 0, 110)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadingText.Font = Enum.Font.Gotham
loadingText.TextSize = 14
loadingText.TextXAlignment = Enum.TextXAlignment.Left
loadingText.Parent = loadingFrame

local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(1, -20, 0, 4)
loadingBar.Position = UDim2.new(0, 10, 0, 140)
loadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loadingBar.BorderSizePixel = 0
loadingBar.Parent = loadingFrame

local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBar

local loadingProgress = 0
local loadingTween = game:GetService("TweenService"):Create(
    loadingBarFill,
    TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = UDim2.new(1, 0, 1, 0)}
)
loadingTween:Play()

-- Функция для создания ключ-системы
local function createKeySystem()
    -- Красивая ключ-система
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeyInputGUI"
    keyGui.Parent = game.CoreGui

    -- Фон с эффектом размытия
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 10
    blurEffect.Parent = game:GetService("Lighting")

    -- Основной контейнер
    local mainContainer = Instance.new("Frame")
    mainContainer.Size = UDim2.new(0, 400, 0, 450)
    mainContainer.Position = UDim2.new(0.5, -200, 0.5, -225)
    mainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainContainer.BackgroundTransparency = 0.2
    mainContainer.Parent = keyGui

    -- Анимация появления
    mainContainer.Position = UDim2.new(0.5, -200, 1.5, 0)
    game:GetService("TweenService"):Create(
        mainContainer,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -200, 0.5, -225)}
    ):Play()

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 12)
    containerCorner.Parent = mainContainer

    -- Логотип
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 150, 0, 150)
    logo.Position = UDim2.new(0.5, -75, 0.1, 0)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://7072717162"
    logo.Parent = mainContainer

    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Text = "DEEPSEEK HACK v2.0"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0.45, -100)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 50, 50)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.Parent = mainContainer

    -- Подзаголовок
    local subtitle = Instance.new("TextLabel")
    subtitle.Text = "PREMIUM EDITION"
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0.45, -70)
    subtitle.BackgroundTransparency = 1
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.Parent = mainContainer

    -- Поле ввода ключа
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0, 300, 0, 50)
    inputFrame.Position = UDim2.new(0.5, -150, 0.45, -10)
    inputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = mainContainer

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = inputFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -20, 1, 0)
    textBox.Position = UDim2.new(0, 10, 0, 0)
    textBox.PlaceholderText = "Введите ключ доступа..."
    textBox.Text = ""
    textBox.ClearTextOnFocus = false
    textBox.BackgroundTransparency = 1
    textBox.TextColor3 = Color3.new(1, 1, 1)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.Parent = inputFrame

    -- Кнопка активации
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0, 150, 0, 40)
    submitBtn.Position = UDim2.new(0.5, -75, 0.45, 60)
    submitBtn.Text = "АКТИВИРОВАТЬ"
    submitBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    submitBtn.TextColor3 = Color3.new(1, 1, 1)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 14
    submitBtn.AutoButtonColor = false
    submitBtn.Parent = mainContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = submitBtn

    -- Анимация кнопки
    submitBtn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            submitBtn,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}
        ):Play()
    end)

    submitBtn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            submitBtn,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}
        ):Play()
    end)

    -- Обработка активации
    submitBtn.MouseButton1Click:Connect(function()
        inputKey = textBox.Text
        
        -- Анимация нажатия
        game:GetService("TweenService"):Create(
            submitBtn,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 140, 0, 38)}
        ):Play()
        wait(0.1)
        game:GetService("TweenService"):Create(
            submitBtn,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 150, 0, 40)}
        ):Play()
        
        -- Проверка ключа
        if inputKey == correctKey then
            -- Анимация успеха
            submitBtn.Text = "УСПЕШНО!"
            submitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            
            -- Эффект исчезновения
            game:GetService("TweenService"):Create(
                mainContainer,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0.5, -200, 1.5, 0)}
            ):Play()
            
            wait(0.5)
            blurEffect:Destroy()
            keyGui:Destroy()
            
            -- Загрузка основного интерфейса
            loadMainInterface()
        else
            -- Анимация ошибки
            submitBtn.Text = "НЕВЕРНЫЙ КЛЮЧ"
            submitBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            
            -- Тряска
            local shake = 5
            for i = 1, 8 do
                mainContainer.Position = UDim2.new(0.5, -200 + math.random(-shake, shake), 0.5, -225 + math.random(-shake, shake))
                shake = shake - 0.5
                wait(0.03)
            end
            mainContainer.Position = UDim2.new(0.5, -200, 0.5, -225)
            
            wait(1)
            submitBtn.Text = "АКТИВИРОВАТЬ"
            submitBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
end

-- Имитация загрузки с обновлением текста
coroutine.wrap(function()
    local steps = {
        "Инициализация компонентов...",
        "Загрузка модулей ESP...", 
        "Настройка Aimbot...",
        "Подготовка интерфейса...",
        "Почти готово..."
    }
    
    for i, text in ipairs(steps) do
        wait(0.3)
        loadingText.Text = text
    end
    
    wait(0.5)
    loadingGui:Destroy()
    
    -- Только после завершения загрузки показываем ключ-систему
    createKeySystem()
end)()

repeat task.wait() until inputKey ~= ""

if inputKey ~= correctKey then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ОШИБКА",
        Text = "Неверный ключ активации!",
        Duration = 5,
        Icon = "rbxassetid://11166503712"
    })
    return
end

-- Сервисы
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")

-- Настройки (объединенные)
local settings = {
    esp = {
        enabled = false,
        color = Color3.fromRGB(255, 50, 50),
        showName = false,
        showHealth = false,
        showWeapon = false,
        showDistance = false,
        showBox = false,
        showTracers = false
    },
    aimbot = {
        enabled = false,
        fov = 160,
        smoothness = 0.1,
        targetPart = "Head",
        keybind = Enum.KeyCode.LeftAlt,
        silentAim = false,
        prediction = 0.1,
        hitChance = 100,
        autoShoot = false,
        autoWall = false,
        visibleCheck = false
    },
    movement = {
        fly = false,
        flySpeed = 50,
        flyKey = Enum.KeyCode.F,
        bunnyHop = false,
        hopPower = 10,
        spinBot = false,
        spinSpeed = 20,
        noClip = false,
        speedHack = false,
        speedMultiplier = 1.5
    },
    visuals = {
        watermark = true,
        skyColor = false,
        skyColorValue = Color3.fromRGB(0, 150, 255),
        ultraAttack = false,
        attackKey = Enum.KeyCode.U,
        thirdPerson = false,
        fovChanger = false,
        customFOV = 70
    }
}

-- GUI (объединенный)
local gui = Instance.new("ScreenGui")
gui.Name = "Nixware_Style_Menu"
gui.Parent = game.CoreGui

-- Водяной знак (улучшенный с анимацией и динамическим размером)
local watermark = Instance.new("Frame")
watermark.Size = UDim2.new(0, 0, 0, 24) -- Ширина будет динамической
watermark.Position = UDim2.new(1, -10, 0, 10) -- Начальная позиция (справа с отступом 10 пикселей)
watermark.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
watermark.BackgroundTransparency = 0.3
watermark.BorderSizePixel = 0
watermark.Parent = gui

local watermarkCorner = Instance.new("UICorner")
watermarkCorner.CornerRadius = UDim.new(0, 4)
watermarkCorner.Parent = watermark

local watermarkText = Instance.new("TextLabel")
watermarkText.Text = "DEEPSEEK HACK | BETA | " .. localPlayer.Name .. " | FPS: 0 | Ping: 0"
watermarkText.Size = UDim2.new(0, 0, 1, 0) -- Ширина текста будет динамической
watermarkText.Position = UDim2.new(0, 5, 0, 0)
watermarkText.BackgroundTransparency = 1
watermarkText.TextColor3 = Color3.fromRGB(255, 255, 255)
watermarkText.Font = Enum.Font.GothamBold
watermarkText.TextSize = 12
watermarkText.TextXAlignment = Enum.TextXAlignment.Left
watermarkText.TextWrapped = false -- Отключаем перенос текста
watermarkText.Parent = watermark
watermark.Visible = settings.visuals.watermark

-- Динамическая подстройка размера водяного знака
local function updateWatermarkSize()
    local textBounds = watermarkText.TextBounds.X -- Получаем ширину текста
    watermark.Size = UDim2.new(0, textBounds + 15, 0, 24) -- Добавляем небольшой отступ (5 слева + 10 справа)
    
    -- Проверяем, не выходит ли водяной знак за правый край экрана
    local screenWidth = gui.Parent.Parent:GetService("GuiService"):GetScreenResolution().X
    local watermarkPosX = watermark.Position.X.Offset - watermark.Size.X.Offset
    if watermarkPosX < 0 then
        -- Если выходит за экран, смещаем влево
        watermark.Position = UDim2.new(1, -textBounds - 25, 0, 10)
    else
        watermark.Position = UDim2.new(1, -10, 0, 10)
    end
end

-- Анимация цвета текста водяного знака
local function animateWatermark()
    while true do
        for i = 0, 1, 0.01 do
            watermarkText.TextColor3 = Color3.fromHSV(i, 0.7, 1)
            wait(0.05)
        end
    end
end

-- Обновление FPS и пинга
local lastFrameTime = tick()
local frameCount = 0
local fps = 0

runService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastFrameTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastFrameTime = tick()
    end
    local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    watermarkText.Text = "DEEPSEEK HACK | BETA | " .. localPlayer.Name .. " | FPS: " .. fps .. " | Ping: " .. ping
    updateWatermarkSize() -- Обновляем размер каждый кадр, чтобы подстроиться под новый текст
end)

-- Запуск анимации водяного знака
spawn(animateWatermark)

-- Первоначальное обновление размера
updateWatermarkSize()

-- Эффект размытия (добавляется перед меню)
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0 -- Начальное значение (выключен)
blurEffect.Parent = game:GetService("Lighting")

-- Меню (улучшенный дизайн с Drag и Blur)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 650)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.2 -- Лёгкая прозрачность для эффекта
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainFrame

-- Заголовок меню (для перетаскивания)
local title = Instance.new("TextLabel")
title.Text = "DEEPSEEK HACK v2.0"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BorderSizePixel = 0
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 6, 0, 0)
titleCorner.Parent = title

-- Перетаскивание меню
local dragging = false
local dragStart = nil
local startPos = nil

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

uis.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Вкладки
local tabs = {"ESP", "Aimbot", "Movement", "Visuals"}
local currentTab = "ESP"

local tabButtons = {}
local contentFrames = {}

local function createTab(name, index)
    -- Кнопка вкладки
    local tabBtn = Instance.new("TextButton")
    tabBtn.Text = name
    tabBtn.Size = UDim2.new(0.25, 0, 0, 30)
    tabBtn.Position = UDim2.new(0.25 * (index - 1), 0, 0, 40)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 14
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = mainFrame
    tabButtons[name] = tabBtn
    
    -- Контент вкладки
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -80)
    contentFrame.Position = UDim2.new(0, 10, 0, 80)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = mainFrame
    contentFrames[name] = contentFrame
    
    tabBtn.MouseButton1Click:Connect(function()
        currentTab = name
        for tabName, frame in pairs(contentFrames) do
            frame.Visible = (tabName == name)
        end
        for tabName, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = (tabName == name) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(30, 30, 30)
        end
    end)
end

-- Создаем вкладки
for i, tabName in ipairs(tabs) do
    createTab(tabName, i)
end

-- Активируем первую вкладку
tabButtons["ESP"].BackgroundColor3 = Color3.fromRGB(255, 50, 50)
contentFrames["ESP"].Visible = true

-- Функция создания переключателей (объединенная)
local function createToggle(parent, text, setting, yPos, category)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPos)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Text = text
    toggleText.Size = UDim2.new(0.7, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 0, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.TextColor3 = Color3.new(1, 1, 1)
    toggleText.Font = Enum.Font.Gotham
    toggleText.TextSize = 14
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
    toggleBtn.Text = settings[category][setting] and "ON" or "OFF"
    toggleBtn.BackgroundColor3 = settings[category][setting] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = toggleFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        settings[category][setting] = not settings[category][setting]
        toggleBtn.Text = settings[category][setting] and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = settings[category][setting] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        
        -- Специальные действия для некоторых функций
        if category == "movement" and setting == "fly" then
            toggleFly()
        elseif category == "visuals" and setting == "skyColor" then
            updateSky()
        elseif category == "esp" and setting == "enabled" then
            updateESP()
        elseif category == "movement" and setting == "spinBot" then
            toggleSpinBot()
        elseif category == "visuals" and setting == "thirdPerson" then
            updateThirdPerson()
        elseif category == "visuals" and setting == "fovChanger" then
            updateFOV()
        end
    end)
    
    return toggleBtn
end

-- Функция создания слайдеров (объединенная)
local function createSlider(parent, text, setting, min, max, yPos, category)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.Position = UDim2.new(0, 0, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Text = text .. ": " .. settings[category][setting]
    sliderText.Size = UDim2.new(1, 0, 0, 20)
    sliderText.Position = UDim2.new(0, 0, 0, 0)
    sliderText.BackgroundTransparency = 1
    sliderText.TextColor3 = Color3.new(1, 1, 1)
    sliderText.Font = Enum.Font.Gotham
    sliderText.TextSize = 14
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 5)
    sliderBar.Position = UDim2.new(0, 0, 0, 25)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(1, 0)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((settings[category][setting] - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 15, 0, 15)
    sliderBtn.Position = UDim2.new((settings[category][setting] - min) / (max - min), -7, 0, -5)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBar
    
    local sliderBtnCorner = Instance.new("UICorner")
    sliderBtnCorner.CornerRadius = UDim.new(1, 0)
    sliderBtnCorner.Parent = sliderBtn
    
    local dragging = false
    
    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local percent = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
            local value = math.floor(min + (max - min) * percent)
            value = math.clamp(value, min, max)
            settings[category][setting] = value
            sliderText.Text = text .. ": " .. value
            sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            sliderBtn.Position = UDim2.new((value - min) / (max - min), -7, 0, -5)
        end
    end)
    
    runService.Heartbeat:Connect(function()
        if dragging then
            local mouse = uis:GetMouseLocation()
            local percent = (mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
            local value = math.floor(min + (max - min) * percent)
            value = math.clamp(value, min, max)
            settings[category][setting] = value
            sliderText.Text = text .. ": " .. value
            sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            sliderBtn.Position = UDim2.new((value - min) / (max - min), -7, 0, -5)
        end
    end)
end

-- Вкладка ESP
createToggle(contentFrames["ESP"], "ESP", "enabled", 10, "esp")
createToggle(contentFrames["ESP"], "Show Names", "showName", 50, "esp")
createToggle(contentFrames["ESP"], "Show Health", "showHealth", 90, "esp")
createToggle(contentFrames["ESP"], "Show Weapons", "showWeapon", 130, "esp")
createToggle(contentFrames["ESP"], "Show Distance", "showDistance", 170, "esp")
createToggle(contentFrames["ESP"], "Box ESP", "showBox", 210, "esp")
createToggle(contentFrames["ESP"], "Tracers", "showTracers", 250, "esp")

-- Вкладка Aimbot
createToggle(contentFrames["Aimbot"], "Aimbot", "enabled", 10, "aimbot")
createSlider(contentFrames["Aimbot"], "FOV", "fov", 10, 360, 50, "aimbot")
createSlider(contentFrames["Aimbot"], "Smoothness", "smoothness", 0.01, 1, 110, "aimbot")
createToggle(contentFrames["Aimbot"], "Silent Aim", "silentAim", 170, "aimbot")
createToggle(contentFrames["Aimbot"], "Auto Shoot", "autoShoot", 210, "aimbot")
createToggle(contentFrames["Aimbot"], "Visible Check", "visibleCheck", 250, "aimbot")
createSlider(contentFrames["Aimbot"], "Hit Chance", "hitChance", 0, 100, 290, "aimbot")
createSlider(contentFrames["Aimbot"], "Prediction", "prediction", 0, 0.5, 330, "aimbot")

-- Вкладка Movement
createToggle(contentFrames["Movement"], "Fly", "fly", 10, "movement")
createSlider(contentFrames["Movement"], "Fly Speed", "flySpeed", 10, 100, 50, "movement")
createToggle(contentFrames["Movement"], "Bunny Hop", "bunnyHop", 110, "movement")
createSlider(contentFrames["Movement"], "Hop Power", "hopPower", 5, 50, 150, "movement")
createToggle(contentFrames["Movement"], "Spin Bot", "spinBot", 210, "movement")
createSlider(contentFrames["Movement"], "Spin Speed", "spinSpeed", 5, 50, 250, "movement")
createToggle(contentFrames["Movement"], "NoClip", "noClip", 310, "movement")
createToggle(contentFrames["Movement"], "Speed Hack", "speedHack", 350, "movement")
createSlider(contentFrames["Movement"], "Speed Multiplier", "speedMultiplier", 1, 5, 390, "movement")
createToggle(contentFrames["Movement"], "Anti-AFK", "antiAFK", 430, "movement", "onAntiAFKToggle")
createToggle(contentFrames["Movement"], "Air Jump", "airJump", 470, "movement")
createToggle(contentFrames["Movement"], "Spider", "spider", 510, "movement")
-- Вкладка Visuals
createToggle(contentFrames["Visuals"], "Watermark", "watermark", 10, "visuals")
createToggle(contentFrames["Visuals"], "Custom Sky", "skyColor", 50, "visuals")
createToggle(contentFrames["Visuals"], "Ultra Attack", "ultraAttack", 90, "visuals")
createToggle(contentFrames["Visuals"], "Third Person", "thirdPerson", 130, "visuals")
createToggle(contentFrames["Visuals"], "FOV Changer", "fovChanger", 170, "visuals")
createSlider(contentFrames["Visuals"], "Custom FOV", "customFOV", 70, 120, 210, "visuals")
createToggle(contentFrames["Visuals"], "Head Hitbox", "headHitbox", 250, "visuals") 
createToggle(contentFrames["Visuals"], "Show FOV", "showFov", 290, "visuals")
createToggle(contentFrames["Visuals"], "Custom Crosshair", "customCrosshair", 330, "visuals")
createToggle(contentFrames["Visuals"], "Chams (Visible + Through Walls)", "chams", 380, "visuals")
createToggle(contentFrames["Visuals"], "Neon Enemies", "neonEnemies", 420, "visuals")
-- Улучшенный ESP (управление только через меню) с полоской HP слева от Box ESP
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

local espData = {} -- Храним данные ESP для каждого игрока

local function createESP(player)
    if player == localPlayer or not player.Character then return end
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    -- BillboardGui для ника, расстояния, здоровья и оружия
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPBillboard"
    billboard.Size = UDim2.new(2, 0, 1.5, 0)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = rootPart

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.2, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.2, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.2, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceLabel.TextSize = 12
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = billboard

    local healthFrame = Instance.new("Frame")
    healthFrame.Size = UDim2.new(1, 0, 0.2, 0)
    healthFrame.Position = UDim2.new(0, 0, 0.4, 0)
    healthFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    healthFrame.Parent = billboard

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.Parent = healthFrame

    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Size = UDim2.new(1, 0, 0.2, 0)
    weaponLabel.Position = UDim2.new(0, 0, 0.6, 0)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Text = ""
    weaponLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    weaponLabel.TextSize = 12
    weaponLabel.Font = Enum.Font.Gotham
    weaponLabel.Parent = billboard

    -- Трассер (линия к игроку)
    local tracer = Drawing.new("Line")
    tracer.Color = Color3.fromRGB(0, 255, 0)
    tracer.Thickness = 2
    tracer.Transparency = 1

    -- Box ESP
    local box = {
        topLeft = Drawing.new("Line"),
        topRight = Drawing.new("Line"),
        bottomLeft = Drawing.new("Line"),
        bottomRight = Drawing.new("Line")
    }
    for _, line in pairs(box) do
        line.Color = Color3.fromRGB(255, 0, 0)
        line.Thickness = 2
        line.Transparency = 1
    end

    -- Полоска HP слева от Box ESP
    local hpBar = {
        background = Drawing.new("Line"),
        fill = Drawing.new("Line")
    }
    hpBar.background.Color = Color3.fromRGB(255, 0, 0)
    hpBar.background.Thickness = 4
    hpBar.background.Transparency = 1
    hpBar.fill.Color = Color3.fromRGB(0, 255, 0)
    hpBar.fill.Thickness = 4
    hpBar.fill.Transparency = 1

    -- Скелет (5 линий: тело, руки, ноги)
    local skeletonLines = {
        body = Drawing.new("Line"),
        leftArm = Drawing.new("Line"),
        rightArm = Drawing.new("Line"),
        leftLeg = Drawing.new("Line"),
        rightLeg = Drawing.new("Line")
    }
    for _, line in pairs(skeletonLines) do
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = 1
        line.Transparency = 1
    end

    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    local head = character:FindFirstChild("Head")
    local leftArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm")
    local rightArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")
    local leftLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
    local rightLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")

    espData[player] = {
        billboard = billboard,
        nameLabel = nameLabel,
        distanceLabel = distanceLabel,
        healthFrame = healthFrame,
        healthFill = healthFill,
        weaponLabel = weaponLabel,
        tracer = tracer,
        box = box,
        hpBar = hpBar,
        skeletonLines = skeletonLines,
        torso = torso,
        head = head,
        leftArm = leftArm,
        rightArm = rightArm,
        leftLeg = leftLeg,
        rightLeg = rightLeg
    }
end

local function updateESP()
    for player, data in pairs(espData) do
        if not player.Character or not settings.esp.enabled then
            -- Удаляем ESP, если игрок ушёл или ESP выключен
            data.billboard:Destroy()
            data.tracer:Remove()
            for _, line in pairs(data.box) do
                line:Remove()
            end
            for _, line in pairs(data.hpBar) do
                line:Remove()
            end
            for _, line in pairs(data.skeletonLines) do
                line:Remove()
            end
            espData[player] = nil
            continue
        end

        local character = player.Character
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then continue end

        -- Обновляем видимость элементов
        data.nameLabel.Visible = settings.esp.showName
        data.distanceLabel.Visible = settings.esp.showDistance
        data.healthFrame.Visible = settings.esp.showHealth
        data.weaponLabel.Visible = settings.esp.showWeapon

        -- Обновляем данные
        if settings.esp.showDistance then
            local localChar = localPlayer.Character
            local distance = localChar and localChar:FindFirstChild("HumanoidRootPart") and (rootPart.Position - localChar.HumanoidRootPart.Position).Magnitude or 0
            data.distanceLabel.Text = math.floor(distance) .. "m"
        end

        if settings.esp.showHealth then
            data.healthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
        end

        if settings.esp.showWeapon then
            local tool = character:FindFirstChildOfClass("Tool")
            data.weaponLabel.Text = tool and tool.Name or "None"
        end

        -- Обновляем трассер
        if settings.esp.showTracers then
            local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                data.tracer.Visible = true
                data.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                data.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
            else
                data.tracer.Visible = false
            end
        else
            data.tracer.Visible = false
        end

        -- Обновляем Box ESP и полоску HP
        if settings.esp.showBox then
            local headPos = camera:WorldToViewportPoint(data.head.Position + Vector3.new(0, 1, 0))
            local feetPos = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 4, 0))
            local onScreen = headPos.Z > 0 and feetPos.Z > 0

            if onScreen then
                -- Рассчитываем ширину и высоту бокса
                local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
                local boxWidth = 2000 / distance -- Динамическая ширина в зависимости от расстояния
                local boxHeight = feetPos.Y - headPos.Y

                -- Ограничиваем минимальную и максимальную ширину
                boxWidth = math.clamp(boxWidth, 30, 100)

                -- Рисуем бокс
                data.box.topLeft.Visible = true
                data.box.topLeft.From = Vector2.new(headPos.X - boxWidth / 2, headPos.Y)
                data.box.topLeft.To = Vector2.new(headPos.X + boxWidth / 2, headPos.Y)

                data.box.topRight.Visible = true
                data.box.topRight.From = Vector2.new(headPos.X + boxWidth / 2, headPos.Y)
                data.box.topRight.To = Vector2.new(headPos.X + boxWidth / 2, feetPos.Y)

                data.box.bottomLeft.Visible = true
                data.box.bottomLeft.From = Vector2.new(headPos.X - boxWidth / 2, headPos.Y)
                data.box.bottomLeft.To = Vector2.new(headPos.X - boxWidth / 2, feetPos.Y)

                data.box.bottomRight.Visible = true
                data.box.bottomRight.From = Vector2.new(headPos.X - boxWidth / 2, feetPos.Y)
                data.box.bottomRight.To = Vector2.new(headPos.X + boxWidth / 2, feetPos.Y)

                -- Рисуем полоску HP слева от бокса
                local hpBarWidth = 5 -- Ширина полоски HP
                local hpBarOffset = 10 -- Отступ от бокса слева
                local hpPercentage = humanoid.Health / humanoid.MaxHealth

                -- Фон полоски HP
                data.hpBar.background.Visible = true
                data.hpBar.background.From = Vector2.new(headPos.X - boxWidth / 2 - hpBarOffset, headPos.Y)
                data.hpBar.background.To = Vector2.new(headPos.X - boxWidth / 2 - hpBarOffset, feetPos.Y)

                -- Заполнение полоски HP
                local hpBarHeight = boxHeight * hpPercentage
                data.hpBar.fill.Visible = true
                data.hpBar.fill.From = Vector2.new(headPos.X - boxWidth / 2 - hpBarOffset, feetPos.Y - hpBarHeight)
                data.hpBar.fill.To = Vector2.new(headPos.X - boxWidth / 2 - hpBarOffset, feetPos.Y)
            else
                for _, line in pairs(data.box) do
                    line.Visible = false
                end
                for _, line in pairs(data.hpBar) do
                    line.Visible = false
                end
            end
        else
            for _, line in pairs(data.box) do
                line.Visible = false
            end
            for _, line in pairs(data.hpBar) do
                line.Visible = false
            end
        end

        -- Обновляем скелет
        local function updateLine(line, part1, part2)
            if part1 and part2 then
                local pos1, visible1 = camera:WorldToViewportPoint(part1.Position)
                local pos2, visible2 = camera:WorldToViewportPoint(part2.Position)
                if visible1 and visible2 then
                    line.Visible = true
                    line.From = Vector2.new(pos1.X, pos1.Y)
                    line.To = Vector2.new(pos2.X, pos2.Y)
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end

        updateLine(data.skeletonLines.body, data.torso, data.head)
        updateLine(data.skeletonLines.leftArm, data.torso, data.leftArm)
        updateLine(data.skeletonLines.rightArm, data.torso, data.rightArm)
        updateLine(data.skeletonLines.leftLeg, data.torso, data.leftLeg)
        updateLine(data.skeletonLines.rightLeg, data.torso, data.rightLeg)
    end
end

local function toggleESP()
    if settings.esp.enabled then
        -- Создаём ESP для всех игроков
        for _, player in ipairs(players:GetPlayers()) do
            if player ~= localPlayer then
                createESP(player)
            end
        end

        -- Отслеживаем новых игроков
        players.PlayerAdded:Connect(function(player)
            if player ~= localPlayer then
                player.CharacterAdded:Connect(function()
                    if settings.esp.enabled then
                        createESP(player)
                    end
                end)
            end
        end)

        -- Обновляем ESP каждый кадр
        runService.RenderStepped:Connect(updateESP)
    else
        -- Удаляем весь ESP
        for _, data in pairs(espData) do
            data.billboard:Destroy()
            data.tracer:Remove()
            for _, line in pairs(data.box) do
                line:Remove()
            end
            for _, line in pairs(data.hpBar) do
                line:Remove()
            end
            for _, line in pairs(data.skeletonLines) do
                line:Remove()
            end
        end
        espData = {}
    end
end

-- Отслеживаем изменения настройки
local lastESPState = settings.esp.enabled
runService.Heartbeat:Connect(function()
    if settings.esp.enabled ~= lastESPState then
        lastESPState = settings.esp.enabled
        toggleESP()
    end
end)

-- Применяем ESP к уже существующим игрокам при запуске
for _, player in ipairs(players:GetPlayers()) do
    if player ~= localPlayer then
        player.CharacterAdded:Connect(function()
            if settings.esp.enabled then
                createESP(player)
            end
        end)
        if player.Character and settings.esp.enabled then
            createESP(player)
        end
    end
end

-- Авто-включение при респавне
localPlayer.CharacterAdded:Connect(function()
    if settings.esp.enabled then
        wait(1)
        toggleESP()
    end
end)

-- Улучшенный Aimbot
local players = game:GetService("Players")
local uis = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local localPlayer = players.LocalPlayer

local function getPredictedPosition(targetPart)
    if not targetPart then return nil end
    if not settings.aimbot.prediction or settings.aimbot.prediction <= 0 then return targetPart.Position end
    
    local character = targetPart.Parent
    if not character then return targetPart.Position end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return targetPart.Position end
    
    local velocity = targetPart.AssemblyLinearVelocity
    return targetPart.Position + (velocity * settings.aimbot.prediction)
end

local function isTargetVisible(targetPart)
    if not settings.aimbot.visibleCheck then return true end
    if not targetPart then return false end

    local localChar = localPlayer.Character
    local head = localChar and localChar:FindFirstChild("Head")
    if not localChar or not head then return false end -- Проверка на локального игрока

    -- Определяем точку начала луча
    local origin
    if camera.CameraType == Enum.CameraType.Custom and head then
        -- В режиме от первого лица начинаем луч чуть впереди головы
        origin = head.Position + (camera.CFrame.LookVector * 3) -- Увеличили смещение до 3 единиц
    else
        -- Для других режимов используем позицию камеры
        origin = camera.CFrame.Position
    end

    local direction = targetPart.Position - origin

    -- Проверяем, находится ли цель в зоне видимости камеры
    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then
        print("Target is not on screen")
        return false
    end

    -- Настраиваем Raycast
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {localChar} -- Игнорируем персонажа локального игрока
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true

    -- Выполняем Raycast
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)

    if raycastResult then
        local hitPart = raycastResult.Instance
        print("Raycast hit:", hitPart:GetFullName())
        return hitPart == targetPart or hitPart:IsDescendantOf(targetPart.Parent)
    else
        print("Raycast missed, assuming target is visible")
        return true
    end
end

local function aimAt(targetPart)
    if not targetPart then return end
    
    local predictedPosition = getPredictedPosition(targetPart)
    if not predictedPosition then return end
    
    if settings.aimbot.visibleCheck and not isTargetVisible(targetPart) then return end
    
    if settings.aimbot.hitChance < 100 then
        if math.random(1, 100) > settings.aimbot.hitChance then return end
    end
    
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, predictedPosition)
    
    if settings.aimbot.silentAim then
        -- Даже для silentAim добавим небольшую плавность
        camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.9)
    else
        camera.CFrame = currentCFrame:Lerp(targetCFrame, settings.aimbot.smoothness)
    end
    
    if settings.aimbot.autoShoot then
        local tool = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            -- Проверяем, можно ли стрелять (примерная проверка)
            local lastShot = tool:GetAttribute("LastShot") or 0
            local fireRate = tool:GetAttribute("FireRate") or 0.1 -- Задержка между выстрелами (по умолчанию 0.1 сек)
            if tick() - lastShot >= fireRate then
                tool:Activate()
                tool:SetAttribute("LastShot", tick())
            end
        end
    end
end

local function getClosestPlayer()
    local closestPlayer, closestAngle = nil, math.rad(settings.aimbot.fov) -- FOV в градусах
    local cameraPos = camera.CFrame.Position
    local cameraLook = camera.CFrame.LookVector

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local targetPart = player.Character:FindFirstChild(settings.aimbot.targetPart)
            if targetPart and humanoid and humanoid.Health > 0 then
                -- Проверяем видимость, если включён visibleCheck
                if settings.aimbot.visibleCheck and not isTargetVisible(targetPart) then continue end

                local vectorToTarget = (targetPart.Position - cameraPos).Unit
                local angle = math.acos(vectorToTarget:Dot(cameraLook))

                if angle < closestAngle then
                    closestPlayer = player
                    closestAngle = angle
                end
            end
        end
    end

    return closestPlayer
end

-- Основной цикл Aimbot
game:GetService("RunService").RenderStepped:Connect(function()
    -- Проверяем, включён ли Aimbot и нажата ли клавиша
    if not settings.aimbot.enabled or not uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

    -- Проверяем, жив ли локальный игрок
    local localChar = localPlayer.Character
    if not localChar or not localChar:FindFirstChildOfClass("Humanoid") or localChar:FindFirstChildOfClass("Humanoid").Health <= 0 then return end

    local closestPlayer = getClosestPlayer()
    if closestPlayer and closestPlayer.Character then
        local targetPart = closestPlayer.Character:FindFirstChild(settings.aimbot.targetPart)
        if targetPart then
            aimAt(targetPart)
        end
    end
end)

-- Оптимизированная функция Neon Enemies
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local localPlayer = players.LocalPlayer

local neonEnemies = {} -- Кэшируем изменённые персонажи
local neonConnection

local function applyNeon(character)
    if not character then return end
    local parts = {}
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and not part:FindFirstChild("OriginalMaterial") then
            -- Сохраняем оригинальные свойства
            local originalMaterial = Instance.new("StringValue")
            originalMaterial.Name = "OriginalMaterial"
            originalMaterial.Value = part.Material.Name
            originalMaterial.Parent = part

            local originalTransparency = Instance.new("NumberValue")
            originalTransparency.Name = "OriginalTransparency"
            originalTransparency.Value = part.Transparency
            originalTransparency.Parent = part

            -- Применяем Neon-эффект
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(0, 255, 255) -- Яркий голубой цвет
            part.Transparency = 0.2 -- Чуть прозрачные
            parts[part] = true
        end
    end
    neonEnemies[character] = parts
end

local function removeNeon(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            local originalMaterial = part:FindFirstChild("OriginalMaterial")
            local originalTransparency = part:FindFirstChild("OriginalTransparency")
            if originalMaterial and originalTransparency then
                part.Material = Enum.Material[originalMaterial.Value] or Enum.Material.Plastic
                part.Transparency = originalTransparency.Value
                originalMaterial:Destroy()
                originalTransparency:Destroy()
            end
        end
    end
    neonEnemies[character] = nil
end

local function toggleNeon()
    if settings.visuals.neonEnemies then
        -- Применяем Neon ко всем существующим игрокам
        for _, player in ipairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                applyNeon(player.Character)
            end
        end

        -- Отслеживаем новых игроков
        if not neonConnection then
            neonConnection = players.PlayerAdded:Connect(function(player)
                if player ~= localPlayer then
                    player.CharacterAdded:Connect(function(character)
                        if settings.visuals.neonEnemies then
                            applyNeon(character)
                        end
                    end)
                end
            end)
        end
    else
        -- Удаляем Neon у всех игроков
        for character, _ in pairs(neonEnemies) do
            removeNeon(character)
        end
        neonEnemies = {}

        -- Отключаем подключение
        if neonConnection then
            neonConnection:Disconnect()
            neonConnection = nil
        end
    end
end

-- Отслеживаем изменения настройки
local lastNeonState = settings.visuals.neonEnemies
runService.Heartbeat:Connect(function()
    if settings.visuals.neonEnemies ~= lastNeonState then
        lastNeonState = settings.visuals.neonEnemies
        toggleNeon()
    end
end)

-- Применяем Neon к уже существующим игрокам при запуске
for _, player in ipairs(players:GetPlayers()) do
    if player ~= localPlayer then
        player.CharacterAdded:Connect(function(character)
            if settings.visuals.neonEnemies then
                applyNeon(character)
            end
        end)
        if player.Character and settings.visuals.neonEnemies then
            applyNeon(player.Character)
        end
    end
end

-- Chams через стены с изменением цвета
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local localPlayer = players.LocalPlayer

-- Сохраняем рисованные боксы
local chams = {}

-- Проверка видимости
local function isVisible(part)
    local origin = camera.CFrame.Position
    local direction = (part.Position - origin).Unit * 500 -- дальность луча

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {localPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(origin, direction, raycastParams)

    if result and result.Instance then
        return result.Instance:IsDescendantOf(part.Parent)
    end

    return false
end

local function clearChams()
    for _, cham in pairs(chams) do
        if cham and cham.Destroy then
            cham:Destroy()
        end
    end
    chams = {}
end

local function updateChams()
    clearChams()

    if settings.visuals.chams then
        for _, player in ipairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart

                local box = Drawing.new("Square")
                box.Visible = true
                box.Thickness = 2
                box.Transparency = 0.5
                box.Filled = false

                -- Проверяем видимость
                local isVisibleTarget = isVisible(rootPart)

                if isVisibleTarget then
                    box.Color = Color3.fromRGB(0, 255, 0) -- ЗЕЛЁНЫЙ, если видно
                else
                    box.Color = Color3.fromRGB(255, 0, 0) -- КРАСНЫЙ, если за стеной
                end

                local pos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    box.Size = Vector2.new(50, 100)
                    box.Position = Vector2.new(pos.X - 25, pos.Y - 50)
                else
                    box.Visible = false
                end

                table.insert(chams, box)
            end
        end
    end
end

-- Постоянное обновление
runService.RenderStepped:Connect(function()
    updateChams()
end)
-- Custom Crosshair (Крестик)

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

-- Создаем линии крестика
local crosshairTop = Drawing.new("Line")
local crosshairBottom = Drawing.new("Line")
local crosshairLeft = Drawing.new("Line")
local crosshairRight = Drawing.new("Line")

-- Настройки цвета и толщины
local crosshairColor = Color3.fromRGB(255, 0, 0) -- красный
local crosshairThickness = 2
local crosshairLength = 6 -- длина каждой линии

-- Инициализация линий
local function setupLine(line)
    line.Visible = false
    line.Color = crosshairColor
    line.Thickness = crosshairThickness
end

setupLine(crosshairTop)
setupLine(crosshairBottom)
setupLine(crosshairLeft)
setupLine(crosshairRight)

local function updateCrosshair()
    if settings.visuals.customCrosshair then
        local viewportSize = camera.ViewportSize
        local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

        -- Настройка каждой линии
        crosshairTop.Visible = true
        crosshairBottom.Visible = true
        crosshairLeft.Visible = true
        crosshairRight.Visible = true

        crosshairTop.From = Vector2.new(center.X, center.Y - 2)
        crosshairTop.To = Vector2.new(center.X, center.Y - crosshairLength)

        crosshairBottom.From = Vector2.new(center.X, center.Y + 2)
        crosshairBottom.To = Vector2.new(center.X, center.Y + crosshairLength)

        crosshairLeft.From = Vector2.new(center.X - 2, center.Y)
        crosshairLeft.To = Vector2.new(center.X - crosshairLength, center.Y)

        crosshairRight.From = Vector2.new(center.X + 2, center.Y)
        crosshairRight.To = Vector2.new(center.X + crosshairLength, center.Y)
    else
        crosshairTop.Visible = false
        crosshairBottom.Visible = false
        crosshairLeft.Visible = false
        crosshairRight.Visible = false
    end
end

-- Anti-Aim (С увеличенной скоростью x5)
local antiAimConnection
local currentDirection = 1 -- 1 = вправо, -1 = влево
local currentDuration = 0
local currentSpeed = 0
local nextChangeTime = tick()

local function toggleAntiAim()
    if settings.aimbot.antiAim then
        if antiAimConnection then return end
        antiAimConnection = runService.Heartbeat:Connect(function(deltaTime)
            local character = localPlayer.Character
            if not character then return end
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not rootPart then return end

            -- Проверяем, пора ли менять направление
            if tick() >= nextChangeTime then
                currentDirection = math.random(0, 1) == 0 and 1 or -1 -- Случайно влево или вправо
                currentDuration = math.random(1, 5) -- Случайная длительность (1-5 секунд)
                currentSpeed = math.random(750, 750) -- Увеличенная скорость (250-750 градусов в секунду)
                nextChangeTime = tick() + currentDuration

                -- Случайный прыжок (50% шанс)
                if math.random() < 0.5 then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end

                -- Движение в стороны
                local sideDirection = math.random(0, 1) == 0 and 1 or -1 -- Случайно влево или вправо
                local sideDistance = math.random(2, 5) -- Смещение на 1-3 юнита
                rootPart.CFrame = rootPart.CFrame * CFrame.new(sideDirection * sideDistance, 0, 0)

                print("Anti-Aim: Новое направление", currentDirection == 1 and "вправо" or "влево", "на", currentDuration, "секунд со скоростью", currentSpeed)
            end

            -- Поворачиваем персонажа
            local angle = math.rad(currentSpeed * deltaTime * currentDirection)
            rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, angle, 0)
        end)
    else
        if antiAimConnection then
            antiAimConnection:Disconnect()
            antiAimConnection = nil
        end
    end
end

-- Бинд на клавишу M
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        settings.aimbot.antiAim = not settings.aimbot.antiAim
        toggleAntiAim()
    end
end)

-- Авто-включение при респавне
localPlayer.CharacterAdded:Connect(function()
    if settings.aimbot.antiAim then
        wait(1)
        toggleAntiAim()
    end
end)

-- Создание rage bot
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Настройки рейдж-бота (меняй false/true здесь)
local RAGE_BOT_ENABLED = false -- Включён ли рейдж-бот по умолчанию
local VISIBLE_CHECK = true -- Проверять видимость (true = не целиться через стены)
local TEAM_CHECK = true -- Игнорировать игроков из своей команды
local TARGET_PART = "Head" -- Целевая часть (можно изменить на "HumanoidRootPart")
local FIRE_COOLDOWN = 0.1 -- Задержка между выстрелами (в секундах)
local lastFireTime = 0 -- Время последнего выстрела
local isFiring = true -- Флаг для стрельбы

-- Функция для получения предсказанной позиции
local function getPredictedPosition(targetPart)
    if not targetPart then return nil end
    local character = targetPart.Parent
    if not character then return targetPart.Position end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return targetPart.Position end
    local velocity = targetPart.AssemblyLinearVelocity
    return targetPart.Position + (velocity * 0.1) -- Предсказание на 0.1 секунды
end

-- Функция проверки видимости
local function isTargetVisible(targetPart)
    if not VISIBLE_CHECK then return true end
    if not targetPart then return false end

    local camera = workspace.CurrentCamera
    local character = localPlayer.Character
    local head = character and character:FindFirstChild("Head")

    local origin
    if camera.CameraType == Enum.CameraType.Custom and head then
        origin = head.Position + (camera.CFrame.LookVector * 2)
    else
        origin = camera.CFrame.Position
    end

    local direction = targetPart.Position - origin

    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then
        print("Rage Bot: Target is not on screen")
        return false
    end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true

    local raycastResult = workspace:Raycast(origin, direction, raycastParams)

    if raycastResult then
        local hitPart = raycastResult.Instance
        print("Rage Bot: Raycast hit:", hitPart:GetFullName())
        return hitPart == targetPart or hitPart:IsDescendantOf(targetPart.Parent)
    else
        print("Rage Bot: Raycast missed, assuming target is visible")
        return true
    end
end

-- Улучшенная функция проверки жив ли игрок
local function isPlayerAlive(player)
    -- Проверяем существует ли игрок и его персонаж
    if not player or not player:IsA("Player") then
        return false
    end
    
    local character = player.Character
    if not character then
        return false
    end
    
    -- Проверяем наличие Humanoid и его состояние
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return false
    end
    
    -- Проверяем несколько условий "смерти"
    if humanoid.Health <= 0 then
        return false
    end
    
    if humanoid:GetState() == Enum.HumanoidStateType.Dead then
        return false
    end
    
    -- Дополнительные проверки
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return false
    end
    
    -- Проверяем не находится ли персонаж в состоянии "уничтожения"
    if not character:IsDescendantOf(workspace) then
        return false
    end
    
    return true
end

-- Функция для поиска ближайшего живого игрока с приоритетом по здоровью
local function getClosestPlayer()
    local closestPlayer, lowestHealth = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and isPlayerAlive(player) then
            -- Проверка команды
            if TEAM_CHECK and player.Team == localPlayer.Team then
                print("Rage Bot: Skipping", player.Name, "due to Team Check")
                continue
            end
            local character = player.Character
            local targetPart = character:FindFirstChild(TARGET_PART)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if targetPart and humanoid and isTargetVisible(targetPart) then
                local health = humanoid.Health
                print("Rage Bot: Player", player.Name, "Health:", health)
                if health < lowestHealth then
                    closestPlayer = player
                    lowestHealth = health
                elseif health == lowestHealth and closestPlayer then
                    -- Если здоровье одинаковое, сравниваем расстояние
                    local distance = (targetPart.Position - camera.CFrame.Position).Magnitude
                    local currentDistance = (closestPlayer.Character:FindFirstChild(TARGET_PART).Position - camera.CFrame.Position).Magnitude
                    if distance < currentDistance then
                        closestPlayer = player
                        lowestHealth = health
                    end
                end
            else
                print("Rage Bot: Skipping", player.Name, "due to missing targetPart or visibility")
            end
        end
    end
    if closestPlayer then
        print("Rage Bot: Selected", closestPlayer.Name, "with Health:", lowestHealth)
    else
        print("Rage Bot: No valid target found")
    end
    return closestPlayer
end

-- Функция для управления автоматической стрельбой
local function handleAutoFire(tool)
    if not tool then
        if isFiring then
            isFiring = false
            print("Rage Bot: Stopped firing (no tool)")
        end
        return
    end
    if RAGE_BOT_ENABLED and (tick() - lastFireTime >= FIRE_COOLDOWN) then
        isFiring = true
        tool:Activate()
        lastFireTime = tick()
        print("Rage Bot: Firing")
    elseif not RAGE_BOT_ENABLED and isFiring then
        isFiring = false
        print("Rage Bot: Stopped firing")
    end
end

-- Функция рейдж-бота
local function handleRageBot()
    if not RAGE_BOT_ENABLED then
        handleAutoFire(nil)
        return
    end

    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        handleAutoFire(nil)
        print("Rage Bot: No rootPart for local player")
        return
    end

    local closestPlayer = getClosestPlayer()
    if not closestPlayer or not closestPlayer.Character then
        handleAutoFire(nil)
        return
    end

    local targetPart = closestPlayer.Character:FindFirstChild(TARGET_PART)
    if not targetPart then
        handleAutoFire(nil)
        print("Rage Bot: No targetPart for", closestPlayer.Name)
        return
    end

    local predictedPosition = getPredictedPosition(targetPart)
    if not predictedPosition then
        handleAutoFire(nil)
        print("Rage Bot: No predicted position for", closestPlayer.Name)
        return
    end

    camera.CFrame = CFrame.new(camera.CFrame.Position, predictedPosition)

    local tool = character:FindFirstChildOfClass("Tool")
    handleAutoFire(tool)
end

-- Обработчик нажатия клавиши L
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.Q then
        RAGE_BOT_ENABLED = not RAGE_BOT_ENABLED
        print("Rage Bot " .. (RAGE_BOT_ENABLED and "Enabled" or "Disabled"))
        if not RAGE_BOT_ENABLED then
            isFiring = false
        end
    end
end)

RunService.RenderStepped:Connect(handleRageBot)

-- Aim FOV (отображение круга)
runService.RenderStepped:Connect(function()
    if settings.visuals.showFov and settings.aimbot.enabled then
        local fovSize = settings.aimbot.fov * 2 or 200
        local mousePos = uis:GetMouseLocation()
        fovFrame.Size = UDim2.new(0, fovSize, 0, fovSize)
        fovFrame.Position = UDim2.new(0, mousePos.X - fovSize / 2, 0, mousePos.Y - fovSize / 2)
        fovFrame.Visible = true
    else
        fovFrame.Visible = false
    end
end)

--cfg
local HttpService = game:GetService("HttpService")
local userInputService = game:GetService("UserInputService")

local configFolder = "MyScriptConfigs"
local configName = "defaultConfig"
local configMenuOpen = false

-- Функция сохранения конфига
local function saveConfig()
    if not isfolder(configFolder) then
        makefolder(configFolder)
    end

    writefile(configFolder .. "/" .. configName .. ".json", HttpService:JSONEncode(settings))
    print("[Конфиг] Успешно сохранено!")
end

-- Функция загрузки конфига
local function loadConfig()
    if isfile(configFolder .. "/" .. configName .. ".json") then
        local data = readfile(configFolder .. "/" .. configName .. ".json")
        local loadedSettings = HttpService:JSONDecode(data)
        for category, options in pairs(loadedSettings) do
            for option, value in pairs(options) do
                if settings[category] and settings[category][option] ~= nil then
                    settings[category][option] = value
                end
            end
        end
        print("[Конфиг] Успешно загружено!")
    else
        print("[Конфиг] Файл не найден!")
    end
end

-- Создаём простое визуальное меню через Drawing API
local configMenu = {}

local function createConfigMenu()
    configMenu.frame = Drawing.new("Square")
    configMenu.frame.Size = Vector2.new(200, 100)
    configMenu.frame.Position = Vector2.new(50, 50)
    configMenu.frame.Color = Color3.fromRGB(0, 0, 0)
    configMenu.frame.Filled = true
    configMenu.frame.Transparency = 0.7
    configMenu.frame.Visible = false

    configMenu.saveButton = Drawing.new("Text")
    configMenu.saveButton.Text = "[1] Save Config"
    configMenu.saveButton.Size = 18
    configMenu.saveButton.Position = Vector2.new(60, 60)
    configMenu.saveButton.Color = Color3.fromRGB(255, 255, 255)
    configMenu.saveButton.Visible = false

    configMenu.loadButton = Drawing.new("Text")
    configMenu.loadButton.Text = "[2] Load Config"
    configMenu.loadButton.Size = 18
    configMenu.loadButton.Position = Vector2.new(60, 90)
    configMenu.loadButton.Color = Color3.fromRGB(255, 255, 255)
    configMenu.loadButton.Visible = false
end

createConfigMenu()

-- Переключение меню на кнопку P
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.P then
        configMenuOpen = not configMenuOpen

        configMenu.frame.Visible = configMenuOpen
        configMenu.saveButton.Visible = configMenuOpen
        configMenu.loadButton.Visible = configMenuOpen
    end

    if configMenuOpen then
        if input.KeyCode == Enum.KeyCode.One then
            saveConfig()
        elseif input.KeyCode == Enum.KeyCode.Two then
            loadConfig()
        end
    end
end)

-- Fly функция (объединенная)
local flyBodyVelocity
local flyConnection

local function toggleFly()
    if settings.movement.fly then
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        -- Удаляем старый BodyVelocity если есть
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        -- Создаем новый
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVelocity.Parent = localPlayer.Character.HumanoidRootPart
        
        -- Подключаем управление
        flyConnection = runService.Heartbeat:Connect(function()
            if not settings.movement.fly or not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") or not flyBodyVelocity then
                if flyConnection then flyConnection:Disconnect() end
                return
            end
            
            local cam = workspace.CurrentCamera.CFrame
            local moveVector = Vector3.new()
            
            if uis:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + (cam.LookVector * settings.movement.flySpeed)
            end
            if uis:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - (cam.LookVector * settings.movement.flySpeed)
            end
            if uis:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - (cam.RightVector * settings.movement.flySpeed)
            end
            if uis:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + (cam.RightVector * settings.movement.flySpeed)
            end
            
            flyBodyVelocity.Velocity = moveVector
        end)
    else
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
    end
end

-- Bunny Hop функция (объединенная)
local function handleBunnyHop()
    if settings.movement.bunnyHop and localPlayer.Character then
        local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
            if uis:IsKeyDown(Enum.KeyCode.Space) then
                local direction = camera.CFrame.LookVector * settings.movement.hopPower
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(
                    direction.X * humanoid.WalkSpeed,
                    humanoid.JumpPower,
                    direction.Z * humanoid.WalkSpeed
                )
            end
        end
    end
end

-- Spin Bot функция (объединенная)

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local userInputService = game:GetService("UserInputService")

local spinBotConnection

-- Проверяем, чтобы settings существовал
local settings = settings or {
    movement = {
        spinBot = false,
        spinSpeed = 5
    }
}

local function toggleSpinBot()
    if settings.movement.spinBot then
        if spinBotConnection then return end -- Уже запущено
        spinBotConnection = runService.Heartbeat:Connect(function()
            local character = localPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(settings.movement.spinSpeed), 0)
            end
        end)
    else
        if spinBotConnection then
            spinBotConnection:Disconnect()
            spinBotConnection = nil
        end
    end
end

-- Нажатие на кнопку Z для вкл/выкл SpinBot
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z then
        settings.movement.spinBot = not settings.movement.spinBot
        toggleSpinBot()
    end
end)

-- Автоматический перезапуск при респавне
localPlayer.CharacterAdded:Connect(function()
    if settings.movement.spinBot then
        wait(1)
        toggleSpinBot()
    end
end)

-- Head Hitbox функция

local players = game:GetService("Players")
local runService = game:GetService("RunService")

local headHitboxConnection

local function toggleHeadHitbox()
    if settings.visuals.headHitbox then
        if headHitboxConnection then return end
        
        headHitboxConnection = runService.Heartbeat:Connect(function()
            for _, player in pairs(players:GetPlayers()) do
                if player ~= players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local head = player.Character.Head
                    head.Size = Vector3.new(3, 3, 3) -- увеличиваем размер головы
                    head.Transparency = 0.5 -- делаем полупрозрачной, чтобы видно было
                    head.Material = Enum.Material.ForceField -- делаем красивый эффект
                    head.CanCollide = false -- голова не будет блокировать
                end
            end
        end)
    else
        if headHitboxConnection then
            headHitboxConnection:Disconnect()
            headHitboxConnection = nil
        end

        -- Сброс размеров обратно
        for _, player in pairs(players:GetPlayers()) do
            if player ~= players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                head.Size = Vector3.new(2, 1, 1) -- стандартный размер головы
                head.Transparency = 0
                head.Material = Enum.Material.Plastic
                head.CanCollide = true
            end
        end
    end
end

-- Биндим на клавишу например на H
local userInputService = game:GetService("UserInputService")

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then -- нажимаем H
        settings.visuals.headHitbox = not settings.visuals.headHitbox
        toggleHeadHitbox()
    end
end)

-- NoClip с биндом на кнопку K

-- Основные сервисы
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer

local noClipConnection

-- Функция включения/выключения NoClip
local function toggleNoClip()
    settings.movement.noClip = not settings.movement.noClip

    if settings.movement.noClip then
        if noClipConnection then return end
        
        noClipConnection = runService.Stepped:Connect(function()
            local character = localPlayer.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
        end
    end
end

-- Обработка нажатия клавиши
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then -- при нажатии K
        toggleNoClip()
    end
end)

-- Следим за респавном персонажа
localPlayer.CharacterAdded:Connect(function()
    if settings.movement.noClip then
        wait(1)
        toggleNoClip()
    end
end)

-- Авто-включение при старте (если нужно)
if settings.movement.noClip then
    toggleNoClip()
end
-- anti afk функция

-- Основные сервисы
local players = game:GetService("Players")
local virtualUser = game:GetService("VirtualUser")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer

-- Настройки (предполагается, что у тебя есть таблица настроек settings)
settings.movement = settings.movement or {}
settings.movement.antiAFK = false -- Состояние анти-AFK

-- Функция анти-AFK
local function startAntiAFK()
    if settings.movement.antiAFK then
        spawn(function()
            while settings.movement.antiAFK do
                -- Эмулируем случайное действие (например, нажатие клавиши)
                virtualUser:CaptureController()
                virtualUser:ClickButton1(Vector2.new(0, 0))
                wait(math.random(30, 60)) -- Случайная задержка между действиями
            end
        end)
    end
end

-- Speed Hack функция
local function updateSpeedHack()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        if settings.movement.speedHack then
            localPlayer.Character.Humanoid.WalkSpeed = 16 * settings.movement.speedMultiplier
        else
            localPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end

-- Смена цвета неба (объединенная)
local function updateSky()
    if settings.visuals.skyColor then
        lighting.Ambient = settings.visuals.skyColorValue
        lighting.OutdoorAmbient = settings.visuals.skyColorValue
        lighting.ColorShift_Top = settings.visuals.skyColorValue
    else
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    end
end
-- Spider функция

local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer

local spiderConnection

local function toggleSpider()
    if settings.movement.spider then
        if spiderConnection then return end
        
        spiderConnection = runService.Stepped:Connect(function()
            local character = localPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart

                -- Если стоим на земле или около стены
                local rayOrigin = root.Position
                local rayDirection = root.CFrame.LookVector * 3 -- Пытаемся "нащупать" стену перед собой

                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {character}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

                if raycastResult then
                    -- Если нашли стену перед собой — двигаем вверх
                    root.Velocity = Vector3.new(0, 30, 0)
                end
            end
        end)
    else
        if spiderConnection then
            spiderConnection:Disconnect()
            spiderConnection = nil
        end
    end
end

-- Биндим на кнопку например G
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then -- на кнопку G
        settings.movement.spider = not settings.movement.spider
        toggleSpider()
    end
end)

-- Следим за респавном
localPlayer.CharacterAdded:Connect(function()
    if settings.movement.spider then
        wait(1)
        toggleSpider()
    end
end)

-- Авто-включение если стоит галочка
if settings.movement.spider then
    toggleSpider()
end
-- Функция AirJump
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not settings.movement.airJump then return end
    if input.KeyCode == Enum.KeyCode.Space then
        local character = localPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Third Person функция

-- Основные сервисы
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")

local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

local thirdPersonConnection

local function updateThirdPerson()
    if settings.visuals.thirdPerson then
        if thirdPersonConnection then return end
        
        camera.CameraType = Enum.CameraType.Scriptable
        local offset = CFrame.new(0, 2, 8) -- чуть выше чтобы лучше смотреть

        -- Обновляем камеру каждый кадр
        thirdPersonConnection = runService.Heartbeat:Connect(function()
            local character = localPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                camera.CFrame = character.HumanoidRootPart.CFrame * offset
            end
        end)
    else
        if thirdPersonConnection then
            thirdPersonConnection:Disconnect()
            thirdPersonConnection = nil
        end
        camera.CameraType = Enum.CameraType.Custom
    end
end

-- Следим за респавном игрока
localPlayer.CharacterAdded:Connect(function()
    if settings.visuals.thirdPerson then
        wait(1)
        updateThirdPerson()
    end
end)

-- Вызываем сразу, если включено
if settings.visuals.thirdPerson then
    updateThirdPerson()
end

-- FOV Changer функция
local function updateFOV()
    if settings.visuals.fovChanger then
        camera.FieldOfView = settings.visuals.customFOV
    else
        camera.FieldOfView = 70
    end
end

-- Ультра атака (объединенная)
local function ultraAttack()
    if not settings.visuals.ultraAttack or not localPlayer.Character then return end
    
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local direction = (root.Position - localRoot.Position).Unit
                root.Velocity = direction * 500 + Vector3.new(0, 500, 0)
                
                -- Эффект для визуализации атаки
                local explosion = Instance.new("Explosion")
                explosion.Position = root.Position
                explosion.BlastPressure = 0
                explosion.BlastRadius = 10
                explosion.ExplosionType = Enum.ExplosionType.NoCraters
                explosion.DestroyJointRadiusPercent = 0
                explosion.Parent = workspace
            end
        end
    end
end

-- Обновление водяного знака с FPS и пингом
local function updateWatermark()
    if not settings.visuals.watermark then return end
    
    -- Расчет FPS
    local fps = math.floor(1/workspace:GetRealPhysicsFPS())
    
    -- Расчет пинга (заглушка, в реальном скрипте нужно использовать Stats)
    local ping = math.random(10, 50) -- Замените на реальный метод получения пинга
    
    watermarkText.Text = string.format("DEEPSEEK HACK v2.0 | %s | FPS: %d | PING: %d", 
        localPlayer.Name, fps, ping)
end

-- Открытие/закрытие меню (объединенное)
uis.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.Insert then
            mainFrame.Visible = not mainFrame.Visible
        elseif input.KeyCode == settings.visuals.attackKey then
            ultraAttack()
        elseif input.KeyCode == settings.movement.flyKey then
            settings.movement.fly = not settings.movement.fly
            toggleFly()
        elseif input.KeyCode == Enum.KeyCode.V then
            settings.visuals.thirdPerson = not settings.visuals.thirdPerson
            updateThirdPerson()
        end
    end
end)

-- Основной цикл (объединенный)
runService.Heartbeat:Connect(function()
    -- Aimbot
    if settings.aimbot.enabled and uis:IsKeyDown(settings.aimbot.keybind) then
        local target = getClosestPlayer()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(settings.aimbot.targetPart)
            aimAt(targetPart)
        end
    end
    
    -- Bunny Hop
    handleBunnyHop()
    
    -- Speed Hack
    updateSpeedHack()
    
    -- Обновление водяного знака
    updateWatermark()
    
    -- Обновление FOV
    if settings.visuals.fovChanger then
        updateFOV()
    end
end)

-- Инициализация (объединенная)
updateESP()
updateSky()
updateFOV()

-- Автообновление ESP при появлении новых игроков
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if settings.esp.enabled then
            updateESP()
        end
    end)
end)

for _, player in pairs(players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        if settings.esp.enabled then
            updateESP()
        end
    end)
end

-- Уведомление о успешной загрузке
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "DEEPSEEK HACK v2.0",
    Text = "Чит успешно активирован!\nInsert - Меню\n"..
           settings.aimbot.keybind.Name.." - Aimbot\n"..
           settings.movement.flyKey.Name.." - Полёт\n"..
           settings.visuals.attackKey.Name.." - Ультра атака\n"..
           "V - Third Person",
    Duration = 10,
    Icon = "rbxassetid://11166503712"
})


loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()	
print("🔥 Версия: 2.0 | 🛠 Разработчики: DeepSeek AI, ChatGPT, GROK | ⚡ SPARTAC")
print("===========================================")
print("🎮 Полный список биндов:")
print(" - 📖 Меню: Нажми [Insert]")
print(" - 🎯 Aimbot: Удерживай [LeftAlt]")
print(" - 🛫 Fly: Нажми [F]")
print(" - 💥 Ultra Attack: Нажми [U]")
print(" - 🎥 Third Person: Нажми [V]")
print(" - 🔥 Rage Bot: Нажми [L-Q]")
print(" - 🔄 Spin Bot: Нажми [Z]")
print(" - 🗿 Head Hitbox: Нажми [H]")
print(" - 🚪 NoClip: Нажми [K]")
print(" - 🕷 Spider: Нажми [G]")
print(" - ⚙ Config Menu: Нажми [P]")
print(" - 💾 Save Config: Нажми [1] (в Config Menu)")
print(" - 📂 Load Config: Нажми [2] (в Config Menu)")
print(" - 🏃 Air Jump: Нажми [Space] (если включён)")
print(" - 🎯 Anti-Aim: Нажми [M]")
print(" - 🌐 Fake Lag: Нажми [B]")
print(" - 🛡️ God Mode: Нажми [N]")
print("===========================================")