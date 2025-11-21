local HttpService = game:GetService("HttpService")
local pastebinUrl = "https://pastebin.com/raw/Ne3M5eB1"

local CONFIG_FOLDER = "Spyt1kHack"

local function ensureConfigDir()
    if typeof(isfolder) == "function" and not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end

local keyList = {}
local keyStorage = {}
local keyStorageFile = CONFIG_FOLDER .. "/spytik_keys.json"
local rememberFile = CONFIG_FOLDER .. "/spytik_remember.json"
local licenseValid = false
local currentLicense = nil
local rememberMe = false

local function loadKeyStorage()
    ensureConfigDir()

    local ok, hasFile = pcall(function()
        return typeof(isfile) == "function" and isfile(keyStorageFile)
    end)
    if not ok or not hasFile then return end

    local success, data = pcall(function()
        return readfile(keyStorageFile)
    end)
    if not success or not data then return end

    local decodeOk, decoded = pcall(function()
        return HttpService:JSONDecode(data)
    end)
    if decodeOk and type(decoded) == "table" then
        keyStorage = decoded
    end
end

local function saveKeyStorage()
    ensureConfigDir()

    local ok = pcall(function()
        return typeof(writefile) == "function"
    end)
    if not ok then return end

    local encodeOk, encoded = pcall(function()
        return HttpService:JSONEncode(keyStorage)
    end)
    if encodeOk and encoded then
        pcall(function()
            writefile(keyStorageFile, encoded)
        end)
    end
end

local function fetchKeysFromPastebin()
    local success, result = pcall(function()
        return game:HttpGet(pastebinUrl)
    end)
    if not success or not result then return end

    for line in string.gmatch(result, "[^\r\n]+") do
        local key, keyType = string.match(line, "^%s*([%w%-]+)%s*|%s*(%S+)")
        if key and keyType then
            keyList[key] = keyType
        end
    end
end

-- Функция blur для маскировки ключа ("размытие" текста ключа)
local function blurKey(key)
    if type(key) ~= "string" or key == "" then
        return ""
    end

    local len = #key

    -- Для очень коротких ключей просто заменяем все символы
    if len <= 4 then
        return string.rep("*", len)
    end

    -- Скрываем большую часть ключа, оставляя последние 4 символа
    local visible = string.sub(key, len - 3, len)
    local hidden = string.rep("*", len - 4)
    return hidden .. visible
end

local function getLicenseInfo(inputKeyValue, playerName)
    local keyType = keyList[inputKeyValue]
    if not keyType then
        return false, "КЛЮЧ НЕ НАЙДЕН"
    end

    local record = keyStorage[inputKeyValue]
    local now = os.time()

    if record then
        if record.nick ~= playerName then
            return false, "КЛЮЧ УЖЕ АКТИВИРОВАН"
        end
        if record.expireTime and now > record.expireTime then
            return false, "СРОК ДЕЙСТВИЯ КЛЮЧА ИСТЁК"
        end
        return true, record
    end

    local expireTime = nil
    if keyType == "1H" then
        expireTime = now + 1 * 60 * 60
    elseif keyType == "3H" then
        expireTime = now + 3 * 60 * 60
    elseif keyType == "24H" then
        expireTime = now + 24 * 60 * 60
    elseif keyType == "7D" or keyType == "7d" then
        expireTime = now + 7 * 24 * 60 * 60
    elseif keyType == "30D" or keyType == "30d" then
        expireTime = now + 30 * 24 * 60 * 60
    elseif keyType == "LIFETIME" or keyType == "Lifetime" then
        expireTime = nil
    end

    record = {
        nick = playerName,
        keyType = keyType,
        expireTime = expireTime
    }
    keyStorage[inputKeyValue] = record
    saveKeyStorage()

    return true, record
end

loadKeyStorage()
fetchKeysFromPastebin()

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingGUI"
loadingGui.Parent = game.CoreGui

-- Эффект размытия для загрузки
local loadingBlurEffect = Instance.new("BlurEffect")
loadingBlurEffect.Size = 10
loadingBlurEffect.Parent = game:GetService("Lighting")

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 450, 0, 300)
loadingFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
loadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
loadingFrame.BackgroundTransparency = 0.05
loadingFrame.BorderSizePixel = 1
loadingFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
loadingFrame.Parent = loadingGui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 4)
loadingCorner.Parent = loadingFrame

-- Заголовок в стиле CS2
local loadingTitle = Instance.new("Frame")
loadingTitle.Size = UDim2.new(1, 0, 0, 45)
loadingTitle.Position = UDim2.new(0, 0, 0, 0)
loadingTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
loadingTitle.BorderSizePixel = 0
loadingTitle.Parent = loadingFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 4, 0, 0)
titleCorner.Parent = loadingTitle

local titleDivider = Instance.new("Frame")
titleDivider.Size = UDim2.new(1, 0, 0, 1)
titleDivider.Position = UDim2.new(0, 0, 1, -1)
titleDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleDivider.BorderSizePixel = 0
titleDivider.Parent = loadingTitle

local loadingTitleText = Instance.new("TextLabel")
loadingTitleText.Text = ""
loadingTitleText.Size = UDim2.new(1, -20, 1, 0)
loadingTitleText.Position = UDim2.new(0, 10, 0, 0)
loadingTitleText.BackgroundTransparency = 1
loadingTitleText.TextColor3 = Color3.fromRGB(255, 200, 0)
loadingTitleText.Font = Enum.Font.GothamBold
loadingTitleText.TextSize = 16
loadingTitleText.TextXAlignment = Enum.TextXAlignment.Left
loadingTitleText.Parent = loadingTitle

local loadingIcon = Instance.new("ImageLabel")
loadingIcon.Size = UDim2.new(0, 80, 0, 80)
loadingIcon.Position = UDim2.new(0.5, -40, 0, 70)
loadingIcon.BackgroundTransparency = 1
loadingIcon.Image = "rbxassetid://111597178752736"
loadingIcon.Parent = loadingFrame

local loadingText = Instance.new("TextLabel")
loadingText.Text = "Загрузка премиум интерфейса..."
loadingText.Size = UDim2.new(1, -20, 0, 25)
loadingText.Position = UDim2.new(0, 10, 0, 170)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.fromRGB(220, 220, 220)
loadingText.Font = Enum.Font.Gotham
loadingText.TextSize = 14
loadingText.TextXAlignment = Enum.TextXAlignment.Center
loadingText.Parent = loadingFrame

local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(1, -40, 0, 6)
loadingBar.Position = UDim2.new(0, 20, 0, 210)
loadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loadingBar.BorderSizePixel = 0
loadingBar.Parent = loadingFrame

local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(0, 3)
loadingBarCorner.Parent = loadingBar

local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBar

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 3)
loadingBarFillCorner.Parent = loadingBarFill

local loadingProgress = 0
local loadingTween = game:GetService("TweenService"):Create(
    loadingBarFill,
    TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = UDim2.new(1, 0, 1, 0)}
)
loadingTween:Play()

-- Функция загрузки основного интерфейса
local function loadMainInterface()
    -- Меню уже создано, просто активируем его при необходимости
    -- Можно добавить дополнительные действия здесь
end

-- Функция для создания ключ-системы в стиле CS2
local function createKeySystem()
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeyInputGUI"
    keyGui.Parent = game.CoreGui

    -- Фон с эффектом размытия
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 10
    blurEffect.Parent = game:GetService("Lighting")

    -- Основной контейнер в стиле CS2
    local mainContainer = Instance.new("Frame")
    mainContainer.Size = UDim2.new(0, 450, 0, 500)
    mainContainer.Position = UDim2.new(0.5, -225, 0.5, -250)
    mainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainContainer.BackgroundTransparency = 0.05
    mainContainer.BorderSizePixel = 1
    mainContainer.BorderColor3 = Color3.fromRGB(40, 40, 40)
    mainContainer.Parent = keyGui

    -- Анимация появления
    mainContainer.Position = UDim2.new(0.5, -225, 1.5, 0)
    game:GetService("TweenService"):Create(
        mainContainer,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -225, 0.5, -250)}
    ):Play()

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 4)
    containerCorner.Parent = mainContainer

    -- Заголовок в стиле CS2
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainContainer

    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 4, 0, 0)
    titleBarCorner.Parent = titleBar

    local titleDivider = Instance.new("Frame")
    titleDivider.Size = UDim2.new(1, 0, 0, 1)
    titleDivider.Position = UDim2.new(0, 0, 1, -1)
    titleDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleDivider.BorderSizePixel = 0
    titleDivider.Parent = titleBar

    local title = Instance.new("TextLabel")
    title.Text = ""
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 200, 0)
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    -- Логотип
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 120, 0, 120)
    logo.Position = UDim2.new(0.5, -60, 0, 70)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://111597178752736"
    logo.Parent = mainContainer

    -- Подзаголовок
    local subtitle = Instance.new("TextLabel")
    subtitle.Text = "BETA VERSION"
    subtitle.Size = UDim2.new(1, 0, 0, 25)
    subtitle.Position = UDim2.new(0, 0, 0, 200)
    subtitle.BackgroundTransparency = 1
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 12
    subtitle.Parent = mainContainer

    -- Поле ввода ключа в стиле CS2
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0, 350, 0, 45)
    inputFrame.Position = UDim2.new(0.5, -175, 0, 250)
    inputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    inputFrame.BorderSizePixel = 1
    inputFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
    inputFrame.Parent = mainContainer

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 3)
    inputCorner.Parent = inputFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -20, 1, 0)
    textBox.Position = UDim2.new(0, 10, 0, 0)
    textBox.PlaceholderText = "Введите ключ доступа..."
    textBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    textBox.Text = ""
    textBox.ClearTextOnFocus = false
    textBox.BackgroundTransparency = 1
    textBox.TextColor3 = Color3.fromRGB(220, 220, 220)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.Parent = inputFrame

    -- Слой с размытым ключом поверх поля ввода
    local blurredKeyLabel = Instance.new("TextLabel")
    blurredKeyLabel.Size = UDim2.new(1, -20, 1, 0)
    blurredKeyLabel.Position = UDim2.new(0, 10, 0, 0)
    blurredKeyLabel.BackgroundTransparency = 1
    blurredKeyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    blurredKeyLabel.Font = Enum.Font.Gotham
    blurredKeyLabel.TextSize = 14
    blurredKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    blurredKeyLabel.Text = ""
    blurredKeyLabel.ZIndex = textBox.ZIndex + 1
    blurredKeyLabel.Visible = false
    blurredKeyLabel.Parent = inputFrame

    local blurEnabled = false

    -- Загружаем сохранённый ключ и состояние блюра (если есть)
    do
        if typeof(readfile) == "function" and typeof(isfile) == "function" and isfile(rememberFile) then
            local ok, raw = pcall(readfile, rememberFile)
            if ok and raw then
                local ok2, decoded = pcall(HttpService.JSONDecode, HttpService, raw)
                if ok2 and type(decoded) == "table" and decoded.remember and type(decoded.key) == "string" then
                    textBox.Text = decoded.key
                    rememberMe = true
                    if type(decoded.blur) == "boolean" then
                        blurEnabled = decoded.blur
                    end
                end
            end
        end
    end

    -- Фокус эффект
    textBox.Focused:Connect(function()
        game:GetService("TweenService"):Create(
            inputFrame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BorderColor3 = Color3.fromRGB(255, 200, 0)}
        ):Play()
    end)

    textBox.FocusLost:Connect(function()
        game:GetService("TweenService"):Create(
            inputFrame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BorderColor3 = Color3.fromRGB(40, 40, 40)}
        ):Play()
    end)

    -- Обновление размытого ключа при изменении текста
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        if blurEnabled then
            blurredKeyLabel.Text = blurKey(textBox.Text)
        end
    end)

    -- Чекбокс "Запомнить меня"
    local rememberFrame = Instance.new("TextButton")
    rememberFrame.Size = UDim2.new(0, 150, 0, 20)
    rememberFrame.Position = UDim2.new(0.5, -175, 0, 300)
    rememberFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    rememberFrame.BorderSizePixel = 0
    rememberFrame.Text = ""
    rememberFrame.AutoButtonColor = false
    rememberFrame.Parent = mainContainer

    local rememberCorner = Instance.new("UICorner")
    rememberCorner.CornerRadius = UDim.new(0, 3)
    rememberCorner.Parent = rememberFrame

    local rememberBox = Instance.new("Frame")
    rememberBox.Size = UDim2.new(0, 14, 0, 14)
    rememberBox.Position = UDim2.new(0, 6, 0.5, -7)
    rememberBox.BackgroundColor3 = rememberMe and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(40, 40, 40)
    rememberBox.BorderSizePixel = 0
    rememberBox.Parent = rememberFrame

    local rememberBoxCorner = Instance.new("UICorner")
    rememberBoxCorner.CornerRadius = UDim.new(0, 2)
    rememberBoxCorner.Parent = rememberBox

    local rememberLabel = Instance.new("TextLabel")
    rememberLabel.Size = UDim2.new(1, -26, 1, 0)
    rememberLabel.Position = UDim2.new(0, 24, 0, 0)
    rememberLabel.BackgroundTransparency = 1
    rememberLabel.Text = "Запомнить меня"
    rememberLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    rememberLabel.Font = Enum.Font.Gotham
    rememberLabel.TextSize = 12
    rememberLabel.TextXAlignment = Enum.TextXAlignment.Left
    rememberLabel.Parent = rememberFrame

    -- Переключатель BLUR в том же стиле, что и "Запомнить меня"
    local blurFrame = Instance.new("TextButton")
    blurFrame.Size = UDim2.new(0, 150, 0, 20)
    blurFrame.Position = UDim2.new(0.5, 0, 0, 300)
    blurFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    blurFrame.BorderSizePixel = 0
    blurFrame.Text = ""
    blurFrame.AutoButtonColor = false
    blurFrame.Parent = mainContainer

    local blurCorner = Instance.new("UICorner")
    blurCorner.CornerRadius = UDim.new(0, 3)
    blurCorner.Parent = blurFrame

    local blurBox = Instance.new("Frame")
    blurBox.Size = UDim2.new(0, 14, 0, 14)
    blurBox.Position = UDim2.new(0, 6, 0.5, -7)
    blurBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    blurBox.BorderSizePixel = 0
    blurBox.Parent = blurFrame

    local blurBoxCorner = Instance.new("UICorner")
    blurBoxCorner.CornerRadius = UDim.new(0, 2)
    blurBoxCorner.Parent = blurBox

    local blurLabel = Instance.new("TextLabel")
    blurLabel.Size = UDim2.new(1, -26, 1, 0)
    blurLabel.Position = UDim2.new(0, 24, 0, 0)
    blurLabel.BackgroundTransparency = 1
    blurLabel.Text = "Блюр ключа"
    blurLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    blurLabel.Font = Enum.Font.Gotham
    blurLabel.TextSize = 12
    blurLabel.TextXAlignment = Enum.TextXAlignment.Left
    blurLabel.Parent = blurFrame

    local function updateBlurVisual()
        if blurEnabled then
            blurBox.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            textBox.TextTransparency = 1
            blurredKeyLabel.Visible = true
            blurredKeyLabel.Text = blurKey(textBox.Text)
        else
            blurBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            textBox.TextTransparency = 0
            blurredKeyLabel.Visible = false
        end
    end

    blurFrame.MouseButton1Click:Connect(function()
        blurEnabled = not blurEnabled
        updateBlurVisual()

        -- Сохраняем только состояние блюра отдельно, чтобы оно не зависело от активации
        if typeof(writefile) == "function" then
            local current = {
                remember = false,
                key = "",
                blur = blurEnabled
            }

            if typeof(readfile) == "function" and typeof(isfile) == "function" and isfile(rememberFile) then
                local okRead, raw = pcall(readfile, rememberFile)
                if okRead and raw then
                    local okDecode, decoded = pcall(HttpService.JSONDecode, HttpService, raw)
                    if okDecode and type(decoded) == "table" then
                        -- переносим старые значения, если они есть
                        if decoded.remember ~= nil then current.remember = decoded.remember end
                        if type(decoded.key) == "string" then current.key = decoded.key end
                    end
                end
            end

            local okEncode, encoded = pcall(HttpService.JSONEncode, HttpService, current)
            if okEncode and encoded then
                pcall(writefile, rememberFile, encoded)
            end
        end
    end)

    -- Устанавливаем начальное визуальное состояние блюра
    updateBlurVisual()

    local function updateRememberVisual()
        rememberBox.BackgroundColor3 = rememberMe and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(40, 40, 40)
    end

    rememberFrame.MouseButton1Click:Connect(function()
        rememberMe = not rememberMe
        updateRememberVisual()
    end)

    -- Кнопка активации в стиле CS2
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0, 200, 0, 45)
    submitBtn.Position = UDim2.new(0.5, -100, 0, 320)
    submitBtn.Text = "АКТИВИРОВАТЬ"
    submitBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    submitBtn.TextColor3 = Color3.fromRGB(15, 15, 15)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 14
    submitBtn.AutoButtonColor = false
    submitBtn.BorderSizePixel = 0
    submitBtn.Parent = mainContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 3)
    btnCorner.Parent = submitBtn

    -- Анимация кнопки
    submitBtn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            submitBtn,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(255, 220, 50)}
        ):Play()
    end)

    submitBtn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            submitBtn,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(255, 200, 0)}
        ):Play()
    end)

    -- Обработка активации
    submitBtn.MouseButton1Click:Connect(function()
        inputKey = textBox.Text

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

        local player = game:GetService("Players").LocalPlayer

        local ok, infoOrError = getLicenseInfo(inputKey, player and player.Name or "Unknown")

        if ok then
            licenseValid = true
            currentLicense = infoOrError
            submitBtn.Text = "УСПЕШНО!"
            submitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

            game:GetService("TweenService"):Create(
                mainContainer,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0.5, -200, 1.5, 0)}
            ):Play()

            wait(0.5)
            blurEffect:Destroy()
            keyGui:Destroy()

            -- Сохраняем ключ и состояние блюра, если выбрано "Запомнить меня"
            if rememberMe and typeof(writefile) == "function" then
                local payload = {
                    remember = true,
                    key = textBox.Text or "",
                    blur = blurEnabled
                }
                local okSave, encoded = pcall(HttpService.JSONEncode, HttpService, payload)
                if okSave and encoded then
                    pcall(writefile, rememberFile, encoded)
                end
            elseif typeof(isfile) == "function" and typeof(delfile) == "function" then
                -- Если чекбокс снят, а файл есть — удаляем
                if isfile(rememberFile) then
                    pcall(delfile, rememberFile)
                end
            end

            local introGui = Instance.new("ScreenGui")
            introGui.Name = "IntroLogoGui"
            introGui.Parent = game.CoreGui

            local introLogo = Instance.new("ImageLabel")
            introLogo.Size = UDim2.new(0, 0, 0, 0)
            introLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
            introLogo.AnchorPoint = Vector2.new(0.5, 0.5)
            introLogo.BackgroundTransparency = 1
            introLogo.Image = "rbxassetid://111597178752736"
            introLogo.ImageTransparency = 1
            introLogo.Parent = introGui

            local tweenService = game:GetService("TweenService")
            tweenService:Create(
                introLogo,
                TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 220, 0, 220), ImageTransparency = 0}
            ):Play()

            wait(0.8)

            tweenService:Create(
                introLogo,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {ImageTransparency = 1}
            ):Play()

            wait(0.5)
            introGui:Destroy()

            loadMainInterface()
        else
            submitBtn.Text = infoOrError or "НЕВЕРНЫЙ КЛЮЧ"
            submitBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

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
    loadingBlurEffect:Destroy()
    loadingGui:Destroy()
    
    -- Только после завершения загрузки показываем ключ-систему
    createKeySystem()
end)()

repeat task.wait() until licenseValid

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
        color = Color3.fromRGB(255, 80, 80),
        showName = false,
        showHealth = false,
        showHealthBar = false, 
        showWeapon = false,
        showDistance = false,
        showBox = false,
        show3D = false,
        fill3D = false,
        showTracers = false,
        showSkeleton = false, 
        boxThickness = 3,
        tracerThickness = 3,
        healthBarThickness = 3, 
        healthBarWidth = 4, 
        nameSize = 14, 
        distanceSize = 12, 
        weaponSize = 12, 
        carESP = false,
        bind = Enum.KeyCode.Insert
    },
    misc = {
        autoRespawn = false,
        antiKick = false,
        rejoinOnKick = false,
        theme = "CS2",
        visualColor = "Default",
        wallShot = false,
        invisible = false
    },
    movement = {
        fly = false,
        flySpeed = 50,
        flyKey = nil, 
        platformFly = false,
        platformFlySpeed = 20,
        bunnyHop = false,
        hopPower = 10,
        spinBot = false,
        spinSpeed = 20,
        spinBotKey = nil, 
        noClip = false,
        noClipKey = nil, 
        speedHack = false,
        speedMultiplier = 1.5,
        silentFling = false,
        flingPower = 3000,
        antiFling = false,
        spider = false,
        spiderKey = nil, 
        airJump = false,
        airJumpKey = nil
    },
    visuals = {
        watermark = true,
        skyColor = false,
        skyColorValue = Color3.fromRGB(0, 150, 255),
        skyPreset = "Default",
        ultraAttack = false,
        attackKey = nil, 
        thirdPerson = false,
        thirdPersonKey = nil, 
        fovChanger = false,
        customFOV = 70,
        hitSoundEnabled = false,
        headHitbox = false, 
        headHitboxSize = 5,
        headHitboxKey = nil, 
        chams = false, 
        neonEnemies = false, 
        enemyGlow = false, 
        customCrosshair = false, 
        hitColor = false
    },
    aimbot = {
        enabled = false,
        fov = 30,
        smoothness = 0.1,
        targetPart = "Head",
        aimMode = "camera",
        showFOV = false,
        keybind = Enum.KeyCode.LeftAlt,
        prediction = 0.1,
        hitChance = 100,
        autoShoot = false,
        autoWall = false,
        visibleCheck = false,
        teamCheck = false, 
        tpKill = false,
        tpKillDistance = 1,
        antiAim = false,
        antiAimKey = nil 
    }
}

-- Система тем
local themes = {
    CS2 = {
        mainBg = Color3.fromRGB(15, 15, 15),
        secondaryBg = Color3.fromRGB(20, 20, 20),
        tertiaryBg = Color3.fromRGB(18, 18, 18),
        border = Color3.fromRGB(40, 40, 40),
        accent = Color3.fromRGB(255, 200, 0),
        text = Color3.fromRGB(220, 220, 220),
        textSecondary = Color3.fromRGB(150, 150, 150),
        title = Color3.fromRGB(255, 200, 0)
    },
    Dark = {
        mainBg = Color3.fromRGB(10, 10, 10),
        secondaryBg = Color3.fromRGB(15, 15, 15),
        tertiaryBg = Color3.fromRGB(12, 12, 12),
        border = Color3.fromRGB(30, 30, 30),
        accent = Color3.fromRGB(255, 50, 50),
        text = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(180, 180, 180),
        title = Color3.fromRGB(255, 50, 50)
    },
    Light = {
        mainBg = Color3.fromRGB(240, 240, 240),
        secondaryBg = Color3.fromRGB(250, 250, 250),
        tertiaryBg = Color3.fromRGB(230, 230, 230),
        border = Color3.fromRGB(200, 200, 200),
        accent = Color3.fromRGB(0, 100, 200),
        text = Color3.fromRGB(30, 30, 30),
        textSecondary = Color3.fromRGB(100, 100, 100),
        title = Color3.fromRGB(0, 100, 200)
    },
    Purple = {
        mainBg = Color3.fromRGB(20, 10, 25),
        secondaryBg = Color3.fromRGB(30, 15, 35),
        tertiaryBg = Color3.fromRGB(25, 12, 30),
        border = Color3.fromRGB(60, 30, 70),
        accent = Color3.fromRGB(200, 100, 255),
        text = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(200, 200, 200),
        title = Color3.fromRGB(200, 100, 255)
    },
    Blue = {
        mainBg = Color3.fromRGB(10, 15, 25),
        secondaryBg = Color3.fromRGB(15, 20, 30),
        tertiaryBg = Color3.fromRGB(12, 18, 28),
        border = Color3.fromRGB(30, 40, 60),
        accent = Color3.fromRGB(100, 150, 255),
        text = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(200, 200, 200),
        title = Color3.fromRGB(100, 150, 255)
    }
}

-- Палитра глобальных цветов для визуала
local visualColors = {
Default = Color3.fromRGB(255, 50, 50),
Red = Color3.fromRGB(255, 60, 60),
Green = Color3.fromRGB(80, 255, 120),
Blue = Color3.fromRGB(80, 160, 255),
Purple = Color3.fromRGB(180, 80, 255),
Cyan = Color3.fromRGB(80, 255, 255),
Yellow = Color3.fromRGB(255, 220, 80),
Pink = Color3.fromRGB(255, 120, 200),
Orange = Color3.fromRGB(255, 140, 50),
Magenta = Color3.fromRGB(255, 0, 255),
Lime = Color3.fromRGB(150, 255, 50),
Teal = Color3.fromRGB(0, 180, 180),
Lavender = Color3.fromRGB(200, 150, 255),
Brown = Color3.fromRGB(150, 100, 50),
White = Color3.fromRGB(255, 255, 255),
Black = Color3.fromRGB(0, 0, 0)

}

local function getVisualColor()
    return visualColors[settings.misc.visualColor] or visualColors.Default
end

-- Функция применения темы
local function applyTheme()
    local currentTheme = themes[settings.misc.theme] or themes.CS2
    
    -- Применяем тему ко всем элементам интерфейса
    if mainFrame then
        mainFrame.BackgroundColor3 = currentTheme.mainBg
        mainFrame.BorderColor3 = currentTheme.border
    end
    
    if titleBar then
        titleBar.BackgroundColor3 = currentTheme.secondaryBg
    end
    
    if title then
        title.TextColor3 = currentTheme.title
    end
    
    if sidebar then
        sidebar.BackgroundColor3 = currentTheme.tertiaryBg
    end
    
    -- Обновляем все кнопки вкладок
    if tabButtons then
        for _, btn in pairs(tabButtons) do
            if currentTab == btn.Text then
                btn.BackgroundColor3 = currentTheme.secondaryBg
                btn.TextColor3 = currentTheme.accent
            else
                btn.BackgroundColor3 = currentTheme.tertiaryBg
                btn.TextColor3 = currentTheme.textSecondary
            end
        end
    end
    
    -- Обновляем цвета всех элементов интерфейса
    if watermark then
        watermark.BackgroundColor3 = currentTheme.secondaryBg
    end
end

-- Глобальное применение visualColor к основным визуальным элементам чита
local function applyVisualColor()
    local mainColor = getVisualColor()

    -- Основной цвет ESP
    settings.esp.color = mainColor

    -- Цвет круга аима
    settings.aimbot.fovColor = mainColor

    -- Цвет неба для кастомного скайбокса
    settings.visuals.skyColorValue = mainColor
end

-- Отслеживание смены visualColor
local lastVisualColor = settings.misc.visualColor
runService.Heartbeat:Connect(function()
    if settings.misc.visualColor ~= lastVisualColor then
        lastVisualColor = settings.misc.visualColor
        applyVisualColor()
    end
end)

-- GUI (объединенный)
local gui = Instance.new("ScreenGui")
gui.Name = "Nixware_Style_Menu"
gui.Parent = game.CoreGui

-- Небольшой HUD-логотип в углу экрана
local hudLogo = Instance.new("ImageLabel")
hudLogo.Size = UDim2.new(0, 64, 0, 64)
hudLogo.Position = UDim2.new(0, 10, 0, 10)
hudLogo.BackgroundTransparency = 1
hudLogo.Image = "rbxassetid://111597178752736"
hudLogo.ImageTransparency = 0.1
hudLogo.Parent = gui

-- Водяной знак (улучшенный с красивым дизайном)
local watermark = Instance.new("Frame")
watermark.Size = UDim2.new(0, 0, 0, 28) -- Увеличенная высота
watermark.Position = UDim2.new(1, -10, 0, 10)
watermark.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
watermark.BackgroundTransparency = 0.2
watermark.BorderSizePixel = 1
watermark.BorderColor3 = Color3.fromRGB(255, 200, 0)
watermark.Parent = gui

local watermarkCorner = Instance.new("UICorner")
watermarkCorner.CornerRadius = UDim.new(0, 6)
watermarkCorner.Parent = watermark

-- Градиентный эффект (через UIGradient)
local watermarkGradient = Instance.new("UIGradient")
watermarkGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 0))
})
watermarkGradient.Rotation = 90
watermarkGradient.Transparency = NumberSequence.new(0.8)
watermarkGradient.Parent = watermark

local watermarkInfo = Instance.new("TextLabel")
watermarkInfo.Text = ""
watermarkInfo.Size = UDim2.new(0, 0, 1, 0)
watermarkInfo.Position = UDim2.new(0, 0, 0, 0)
watermarkInfo.BackgroundTransparency = 1
watermarkInfo.TextColor3 = Color3.fromRGB(220, 220, 220)
watermarkInfo.Font = Enum.Font.Gotham
watermarkInfo.TextSize = 11
watermarkInfo.TextXAlignment = Enum.TextXAlignment.Left
watermarkInfo.Parent = watermark

watermark.Visible = settings.visuals.watermark

-- Динамическая подстройка размера водяного знака
local function updateWatermarkSize()
    local infoBounds = watermarkInfo.TextBounds.X
    local totalWidth = infoBounds + 20
    watermark.Size = UDim2.new(0, totalWidth, 0, 28)
    watermark.Position = UDim2.new(1, -totalWidth - 10, 0, 10)
end

-- Убрана RGB анимация (мешала)

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
    
    local ping = 0
    pcall(function()
        ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    
    local gameTime = math.floor(workspace.DistributedGameTime)
    local minutes = math.floor(gameTime / 60)
    local seconds = gameTime % 60

    local licenseText = "NO LICENSE"
    if currentLicense then
        if currentLicense.expireTime == nil then
            licenseText = "LIFETIME"
        else
            local remaining = currentLicense.expireTime - os.time()
            if remaining < 0 then
                licenseText = "EXPIRED"
            else
                local remDays = math.floor(remaining / 86400)
                local remHours = math.floor((remaining % 86400) / 3600)
                local remMinutes = math.floor((remaining % 3600) / 60)

                if remDays > 0 then
                    licenseText = string.format("%dd %dh %dm", remDays, remHours, remMinutes)
                else
                    licenseText = string.format("%dh %dm", remHours, remMinutes)
                end
            end
        end
    end

    watermarkInfo.Text = string.format("FPS: %d | PING: %dms | TIME: %02d:%02d | LICENSE: %s", 
        fps, ping, minutes, seconds, licenseText)
    
    updateWatermarkSize()
end)

-- RGB анимация отключена

-- Первоначальное обновление размера
updateWatermarkSize()

-- Эффект размытия (добавляется перед меню)
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0 -- Начальное значение (выключен)
blurEffect.Parent = game:GetService("Lighting")

-- Меню в стиле CS2 (улучшенный дизайн с Drag и Blur)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 360)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Очень темный фон как в CS2
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40) -- Тонкая граница
mainFrame.Visible = false
mainFrame.Parent = gui

-- Нижняя мобильная панель для открытия меню (фон убран, только полоска)
local mobileBar = Instance.new("Frame")
mobileBar.Size = UDim2.new(1, 0, 0, 30)
mobileBar.Position = UDim2.new(0, 0, 1, -30)
mobileBar.BackgroundTransparency = 1
mobileBar.BorderSizePixel = 0
mobileBar.Parent = gui

local mobileHandle = Instance.new("TextButton")
mobileHandle.Size = UDim2.new(0, 120, 0, 6)
mobileHandle.Position = UDim2.new(0.5, -60, 0.5, -3)
mobileHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mobileHandle.BackgroundTransparency = 0.1
mobileHandle.BorderSizePixel = 0
mobileHandle.AutoButtonColor = false
mobileHandle.Text = ""
mobileHandle.Parent = mobileBar

local mobileHandleCorner = Instance.new("UICorner")
mobileHandleCorner.CornerRadius = UDim.new(0, 3)
mobileHandleCorner.Parent = mobileHandle

local function toggleMenu()
    local newState = not mainFrame.Visible
    mainFrame.Visible = newState
    if newState then
        blurEffect.Size = 10
    else
        blurEffect.Size = 0
    end
end

mobileHandle.MouseButton1Click:Connect(toggleMenu)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 4)
mainCorner.Parent = mainFrame

-- Внутренняя тень эффект (убрана, так как мешает взаимодействию)
-- Можно использовать для визуального эффекта, но с низким ZIndex

-- Заголовок меню (для перетаскивания) - CS2 стиль
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 4, 0, 0)
titleBarCorner.Parent = titleBar

-- Разделитель под заголовком
local titleDivider = Instance.new("Frame")
titleDivider.Size = UDim2.new(1, 0, 0, 1)
titleDivider.Position = UDim2.new(0, 0, 0, 35)
titleDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleDivider.BorderSizePixel = 0
titleDivider.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = ""
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Логотип в самом меню
local menuLogo = Instance.new("ImageLabel")
menuLogo.Size = UDim2.new(0, 96, 0, 96)
menuLogo.Position = UDim2.new(0, 18, 0, 45)
menuLogo.BackgroundTransparency = 1
menuLogo.Image = "rbxassetid://111597178752736"
menuLogo.ImageTransparency = 0
menuLogo.Parent = mainFrame

-- Кнопка закрытия (опционально)
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
end)

closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Перетаскивание меню
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
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

-- Боковая панель в стиле CS2
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 150, 1, -35)
sidebar.Position = UDim2.new(0, 0, 0, 35)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarDivider = Instance.new("Frame")
sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
sidebarDivider.Position = UDim2.new(1, -1, 0, 0)
sidebarDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sidebarDivider.BorderSizePixel = 0
sidebarDivider.Parent = sidebar

-- Вкладки (боковая панель)
local tabs = {"ESP", "Aimbot", "Movement", "Visuals", "Misc", "Config"}
local currentTab = "ESP"

local tabButtons = {}
local contentFrames = {}

local function createTab(name, index)
    -- Кнопка вкладки в стиле CS2
    local tabBtn = Instance.new("TextButton")
    tabBtn.Text = name
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.Position = UDim2.new(0, 0, 0, (index - 1) * 40)
    tabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextSize = 13
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = sidebar
    tabButtons[name] = tabBtn
    
    -- Индикатор активной вкладки
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 1, 0)
    indicator.Position = UDim2.new(0, 0, 0, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 200, 0) -- Золотистый цвет как в CS2
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.Parent = tabBtn
    
    -- Контент вкладки
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -150, 1, -35)
    contentFrame.Position = UDim2.new(0, 150, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    contentFrame.Visible = false
    contentFrame.Parent = mainFrame
    contentFrames[name] = contentFrame
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 5)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = contentFrame
    
    -- Автоматическое обновление размера контента
    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 10)
    end)
    
    tabBtn.MouseButton1Click:Connect(function()
        currentTab = name
        
        -- Анимация переключения
        for tabName, frame in pairs(contentFrames) do
            if tabName == name then
                frame.Visible = true
                game:GetService("TweenService"):Create(
                    frame,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundTransparency = 1}
                ):Play()
            else
                game:GetService("TweenService"):Create(
                    frame,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundTransparency = 1}
                ):Play()
                wait(0.2)
                frame.Visible = false
            end
        end
        
        for tabName, btn in pairs(tabButtons) do
            local indicator = btn:FindFirstChildOfClass("Frame")
            if tabName == name then
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                btn.TextColor3 = Color3.fromRGB(255, 200, 0)
                if indicator then indicator.Visible = true end
                
                -- Плавная анимация
                game:GetService("TweenService"):Create(
                    btn,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}
                ):Play()
            else
                btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                btn.TextColor3 = Color3.fromRGB(150, 150, 150)
                if indicator then indicator.Visible = false end
            end
        end
    end)
    
    -- Hover эффект
    tabBtn.MouseEnter:Connect(function()
        if currentTab ~= name then
            game:GetService("TweenService"):Create(
                tabBtn,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(22, 22, 22)}
            ):Play()
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if currentTab ~= name then
            game:GetService("TweenService"):Create(
                tabBtn,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(18, 18, 18)}
            ):Play()
        end
    end)
end

-- Создаем вкладки
for i, tabName in ipairs(tabs) do
    createTab(tabName, i)
end

-- Активируем первую вкладку
tabButtons["ESP"].BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabButtons["ESP"].TextColor3 = Color3.fromRGB(255, 200, 0)
local espIndicator = tabButtons["ESP"]:FindFirstChildOfClass("Frame")
if espIndicator then espIndicator.Visible = true end
contentFrames["ESP"].Visible = true

-- Система биндов
local binds = {}
local bindModes = {}
local bindsFile = CONFIG_FOLDER .. "/spytik_binds.json"

local function saveBinds()
    ensureConfigDir()
    if typeof(writefile) ~= "function" then return end

    local data = {}
    for id, keyCode in pairs(binds) do
        data[id] = {
            key = keyCode and keyCode.Name or nil,
            mode = bindModes[id] or "toggle"
        }
    end
    local ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
    if ok and encoded then
        pcall(writefile, bindsFile, encoded)
    end
end

local function loadBinds()
    ensureConfigDir()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then return end
    if not isfile(bindsFile) then return end

    local ok, raw = pcall(readfile, bindsFile)
    if not ok or not raw then return end
    local ok2, decoded = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok2 or type(decoded) ~= "table" then return end
    for id, info in pairs(decoded) do
        if type(info) == "table" then
            if info.key and Enum.KeyCode[info.key] then
                binds[id] = Enum.KeyCode[info.key]
            end
            if info.mode == "toggle" or info.mode == "hold" then
                bindModes[id] = info.mode
            end
        end
    end
end

loadBinds()

local activeBindMenu
local activeBindId
local bindCaptureConnection

local mobileBindCircles = {}
local mobileBindCount = 0

local createMobileBindCircle

local function getBindId(category, setting)
    return category .. "_" .. setting
end

local function closeBindMenu()
    if activeBindMenu then
        activeBindMenu:Destroy()
        activeBindMenu = nil
    end
    if bindCaptureConnection then
        bindCaptureConnection:Disconnect()
        bindCaptureConnection = nil
    end
    activeBindId = nil
end

local function openBindMenu(category, setting, displayName)
    closeBindMenu()
    local id = getBindId(category, setting)
    activeBindId = id

    local mousePos = uis:GetMouseLocation()
    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(0, 210, 0, 110)
    menu.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
    menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    menu.BorderSizePixel = 1
    menu.BorderColor3 = Color3.fromRGB(40, 40, 40)
    menu.Parent = gui
    activeBindMenu = menu

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 18, 0, 18)
    closeBtn.Position = UDim2.new(1, -22, 0, 4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.Parent = menu

    closeBtn.MouseButton1Click:Connect(function()
        closeBindMenu()
    end)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 0, 20)
    titleLabel.Position = UDim2.new(0, 5, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = "Bind: " .. displayName
    titleLabel.Parent = menu

    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(1, -10, 0, 20)
    keyLabel.Position = UDim2.new(0, 5, 0, 30)
    keyLabel.BackgroundTransparency = 1
    keyLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    keyLabel.Font = Enum.Font.Gotham
    keyLabel.TextSize = 13
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    local currentKey = binds[id]
    keyLabel.Text = "Key: " .. (currentKey and currentKey.Name or "None")
    keyLabel.Parent = menu

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -10, 0, 16)
    infoLabel.Position = UDim2.new(0, 5, 0, 48)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 11
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Text = "Press key to set bind"
    infoLabel.Parent = menu

    local mode = bindModes[id] or "toggle"

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 90, 0, 22)
    toggleBtn.Position = UDim2.new(0, 10, 0, 70)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleBtn.Text = "Toggle"
    toggleBtn.BorderSizePixel = 0
    toggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.TextSize = 12
    toggleBtn.Parent = menu

    local holdBtn = Instance.new("TextButton")
    holdBtn.Size = UDim2.new(0, 90, 0, 22)
    holdBtn.Position = UDim2.new(0, 110, 0, 70)
    holdBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    holdBtn.Text = "Hold"
    holdBtn.BorderSizePixel = 0
    holdBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    holdBtn.Font = Enum.Font.Gotham
    holdBtn.TextSize = 12
    holdBtn.Parent = menu

    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0, 90, 0, 20)
    clearBtn.Position = UDim2.new(0, 10, 0, 94)
    clearBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
    clearBtn.BorderSizePixel = 0
    clearBtn.Text = "Clear"
    clearBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    clearBtn.Font = Enum.Font.Gotham
    clearBtn.TextSize = 12
    clearBtn.Parent = menu

    local addBtn = Instance.new("TextButton")
    addBtn.Size = UDim2.new(0, 90, 0, 20)
    addBtn.Position = UDim2.new(0, 110, 0, 94)
    addBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
    addBtn.BorderSizePixel = 0
    addBtn.Text = "Add"
    addBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    addBtn.Font = Enum.Font.Gotham
    addBtn.TextSize = 12
    addBtn.Parent = menu

    local function updateModeButtons()
        if mode == "toggle" then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            toggleBtn.TextColor3 = Color3.fromRGB(15, 15, 15)
            holdBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            holdBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        else
            holdBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            holdBtn.TextColor3 = Color3.fromRGB(15, 15, 15)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            toggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        end
    end

    updateModeButtons()

    toggleBtn.MouseButton1Click:Connect(function()
        mode = "toggle"
        bindModes[id] = mode
        updateModeButtons()
        saveBinds()
    end)

    holdBtn.MouseButton1Click:Connect(function()
        mode = "hold"
        bindModes[id] = mode
        updateModeButtons()
        saveBinds()
    end)

    clearBtn.MouseButton1Click:Connect(function()
        binds[id] = nil
        keyLabel.Text = "Key: None"
        saveBinds()
    end)

    addBtn.MouseButton1Click:Connect(function()
        createMobileBindCircle(displayName, category, setting)
    end)

    if bindCaptureConnection then
        bindCaptureConnection:Disconnect()
        bindCaptureConnection = nil
    end

    bindCaptureConnection = uis.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if not activeBindMenu or id ~= activeBindId then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Escape then
                binds[id] = nil
                keyLabel.Text = "Key: None"
                saveBinds()
                closeBindMenu()
                return
            end
            binds[id] = input.KeyCode
            keyLabel.Text = "Key: " .. (input.KeyCode and input.KeyCode.Name or "None")
            saveBinds()
        end
    end)
end

local function applySpecialToggle(category, setting)
    if category == "movement" and setting == "fly" then
        toggleFly()
    elseif category == "movement" and setting == "platformFly" then
        togglePlatformFly()
    elseif category == "visuals" and setting == "skyColor" then
        updateSky()
    elseif category == "esp" and setting == "enabled" then
        toggleESP()
    elseif category == "movement" and setting == "spinBot" then
        toggleSpinBot()
    elseif category == "visuals" and setting == "fovChanger" then
        updateFOV()
    elseif category == "aimbot" and setting == "antiAim" then
        toggleAntiAim()
    elseif category == "visuals" and setting == "headHitbox" then
        toggleHeadHitbox()
    elseif category == "movement" and setting == "noClip" then
        toggleNoClip()
    elseif category == "movement" and setting == "spider" then
        toggleSpider()
    elseif category == "visuals" and setting == "thirdPerson" then
        toggleThirdPerson()
    elseif category == "misc" and setting == "invisible" then
        if typeof(SetInvisible) == "function" then
            SetInvisible(settings.misc.invisible)
        end
    end
end

createMobileBindCircle = function(labelText, category, setting)
    settings[category] = settings[category] or {}
    if settings[category][setting] == nil then
        settings[category][setting] = false
    end

    local id = getBindId(category, setting)
    if mobileBindCircles[id] then return end

    mobileBindCount = mobileBindCount + 1
    -- Располагаем кнопки как AIM: снизу справа, столбиком вверх
    local offsetY = -90 - (mobileBindCount * 80)

    local circle = Instance.new("TextButton")
    circle.Size = UDim2.new(0, 70, 0, 70)
    circle.Position = UDim2.new(1, -90, 1, offsetY)
    circle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    circle.BackgroundTransparency = 0.4
    circle.BorderSizePixel = 0
    circle.AutoButtonColor = false
    circle.Text = labelText
    circle.TextColor3 = Color3.fromRGB(255, 255, 255)
    circle.Font = Enum.Font.GothamBold
    circle.TextSize = 12
    circle.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle

    local function updateVisual()
        local enabled = settings[category][setting] == true
        if enabled then
            circle.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            circle.BackgroundTransparency = 0.2
            circle.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            circle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            circle.BackgroundTransparency = 0.4
            circle.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end

    circle.MouseButton1Click:Connect(function()
        settings[category][setting] = not settings[category][setting]
        updateVisual()
        applySpecialToggle(category, setting)
    end)

    updateVisual()

    if makeDraggableButton then
        makeDraggableButton(circle)
    end

    mobileBindCircles[id] = circle
end

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    for id, keyCode in pairs(binds) do
        if keyCode == input.KeyCode then
            local category, setting = id:match("([^_]+)_(.+)")
            if category and setting and settings[category] ~= nil and settings[category][setting] ~= nil then
                local mode = bindModes[id] or "toggle"
                if mode == "toggle" then
                    settings[category][setting] = not settings[category][setting]
                else
                    settings[category][setting] = true
                end
                applySpecialToggle(category, setting)
            end
        end
    end
end)

uis.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    for id, keyCode in pairs(binds) do
        if keyCode == input.KeyCode then
            local category, setting = id:match("([^_]+)_(.+)")
            if category and setting and settings[category] ~= nil and settings[category][setting] ~= nil then
                local mode = bindModes[id] or "toggle"
                if mode == "hold" then
                    settings[category][setting] = false
                    applySpecialToggle(category, setting)
                end
            end
        end
    end
end)

-- Общий цвет визуалов (для ESP, FOV круга и др.)
local function applyVisualColor()
    local colorName = settings.misc and settings.misc.visualColor or "Default"
    local color = Color3.fromRGB(255, 50, 50)
    if colorName == "Red" then
        color = Color3.fromRGB(255, 60, 60)
    elseif colorName == "Green" then
        color = Color3.fromRGB(0, 200, 120)
    elseif colorName == "Blue" then
        color = Color3.fromRGB(80, 160, 255)
    elseif colorName == "Pink" then
        color = Color3.fromRGB(255, 105, 180)
    elseif colorName == "Purple" then
        color = Color3.fromRGB(180, 0, 255)
    elseif colorName == "Yellow" then
        color = Color3.fromRGB(255, 220, 0)
    elseif colorName == "Cyan" then
        color = Color3.fromRGB(0, 220, 220)
    elseif colorName == "White" then
        color = Color3.fromRGB(245, 245, 245)
    end

    settings.esp.color = color
    settings.aimbot.fovColor = color
end

-- Функция создания переключателей в стиле CS2
local toggleRegistry = {}

local function refreshTogglesFromSettings()
    for category, settingsTable in pairs(toggleRegistry) do
        for setting, data in pairs(settingsTable) do
            if data.update then
                data.update()
            end
        end
    end
end

local function createToggle(parent, text, setting, yPos, category)
    local toggleFrame = Instance.new("TextButton")
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.Position = UDim2.new(0, 10, 0, 0)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.LayoutOrder = yPos
    toggleFrame.Text = ""
    toggleFrame.AutoButtonColor = false
    toggleFrame.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 3)
    toggleCorner.Parent = toggleFrame
    
    -- Разделитель снизу
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 1, -1)
    divider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    divider.BorderSizePixel = 0
    divider.Parent = toggleFrame
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Text = text
    toggleText.Size = UDim2.new(0.75, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 10, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.TextColor3 = Color3.fromRGB(220, 220, 220)
    toggleText.Font = Enum.Font.Gotham
    toggleText.TextSize = 13
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Parent = toggleFrame
    
    -- Переключатель в стиле CS2
    local toggleContainer = Instance.new("TextButton")
    toggleContainer.Size = UDim2.new(0, 50, 0, 24)
    toggleContainer.Position = UDim2.new(1, -60, 0.5, -12)
    toggleContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleContainer.Text = ""
    toggleContainer.BorderSizePixel = 0
    toggleContainer.AutoButtonColor = false
    toggleContainer.Parent = toggleFrame
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 12)
    containerCorner.Parent = toggleContainer
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 20, 0, 20)
    toggleBtn.Position = UDim2.new(0, settings[category][setting] and 26 or 2, 0, 2)
    toggleBtn.BackgroundColor3 = settings[category][setting] and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(100, 100, 100)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = toggleContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = toggleBtn

    -- Кнопка-шестерёнка для бинда
    local gearButton = Instance.new("TextButton")
    gearButton.Size = UDim2.new(0, 20, 0, 20)
    gearButton.Position = UDim2.new(1, -5, 0.5, -10)
    gearButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    gearButton.BorderSizePixel = 0
    gearButton.AutoButtonColor = true
    gearButton.Text = "⚙"
    gearButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    gearButton.Font = Enum.Font.GothamBold
    gearButton.TextSize = 12
    gearButton.Parent = toggleFrame

    gearButton.MouseButton1Click:Connect(function()
        openBindMenu(category, setting, text)
    end)
    
    -- Анимация переключения
    local function updateToggle()
        local state = settings[category][setting]
        local targetPos = state and 26 or 2
        local targetColor = state and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(100, 100, 100)
        local containerColor = state and Color3.fromRGB(60, 50, 20) or Color3.fromRGB(40, 40, 40)
        
        game:GetService("TweenService"):Create(
            toggleBtn,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0, targetPos, 0, 2), BackgroundColor3 = targetColor}
        ):Play()
        
        game:GetService("TweenService"):Create(
            toggleContainer,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = containerColor}
        ):Play()
    end
    
    toggleContainer.MouseButton1Click:Connect(function()
        settings[category][setting] = not settings[category][setting]
        updateToggle()
        
        -- Специальные действия для некоторых функций
        applySpecialToggle(category, setting)
    end)
    
    -- Hover эффект
    toggleFrame.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            toggleFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}
        ):Play()
    end)
    
    toggleFrame.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            toggleFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}
        ):Play()
    end)
    
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton3 then
            local id = getBindId(category, setting)
            if activeBindMenu and activeBindId == id then
                closeBindMenu()
            else
                openBindMenu(category, setting, text)
            end
        end
    end)
    
    -- Регистрируем тоггл для последующего обновления из конфига
    toggleRegistry[category] = toggleRegistry[category] or {}
    toggleRegistry[category][setting] = toggleRegistry[category][setting] or {}
    toggleRegistry[category][setting].update = updateToggle

    -- Инициализируем визуальное состояние в соответствии с текущими settings
    updateToggle()

    return toggleBtn
end

local function createCycleButton(parent, text, setting, values, yPos, category)
    local btnFrame = Instance.new("TextButton")
    btnFrame.Size = UDim2.new(1, -20, 0, 40)
    btnFrame.Position = UDim2.new(0, 10, 0, 0)
    btnFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btnFrame.BorderSizePixel = 0
    btnFrame.LayoutOrder = yPos
    btnFrame.Text = ""
    btnFrame.AutoButtonColor = false
    btnFrame.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 3)
    btnCorner.Parent = btnFrame
    
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 1, -1)
    divider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    divider.BorderSizePixel = 0
    divider.Parent = btnFrame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.Text = text .. ": " .. settings[category][setting]
    btn.BackgroundTransparency = 1
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = btnFrame

    local index = table.find(values, settings[category][setting]) or 1
    btn.MouseButton1Click:Connect(function()
        index = index % #values + 1
        settings[category][setting] = values[index]
        btn.Text = text .. ": " .. settings[category][setting]
        
        -- Применяем тему при изменении
        if category == "misc" and setting == "theme" then
            applyTheme()
        end
    end)
    
    -- Hover эффект
    btnFrame.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            btnFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}
        ):Play()
    end)
    
    btnFrame.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            btnFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}
        ):Play()
    end)
end

-- Функция создания слайдеров в стиле CS2
local function createSlider(parent, text, setting, min, max, yPos, category)
    local sliderFrame = Instance.new("TextButton")
    sliderFrame.Size = UDim2.new(1, -20, 0, 55)
    sliderFrame.Position = UDim2.new(0, 10, 0, 0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.LayoutOrder = yPos
    sliderFrame.Text = ""
    sliderFrame.AutoButtonColor = false
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 3)
    sliderCorner.Parent = sliderFrame
    
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 1, -1)
    divider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    divider.BorderSizePixel = 0
    divider.Parent = sliderFrame
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Text = text .. ": " .. settings[category][setting]
    sliderText.Size = UDim2.new(1, -10, 0, 20)
    sliderText.Position = UDim2.new(0, 10, 0, 5)
    sliderText.BackgroundTransparency = 1
    sliderText.TextColor3 = Color3.fromRGB(220, 220, 220)
    sliderText.Font = Enum.Font.Gotham
    sliderText.TextSize = 13
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(settings[category][setting])
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 4)
    sliderBar.Position = UDim2.new(0, 10, 0, 32)
    sliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(0, 2)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((settings[category][setting] - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 2)
    sliderFillCorner.Parent = sliderFill
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 12, 0, 12)
    sliderBtn.Position = UDim2.new((settings[category][setting] - min) / (max - min), -6, 0, -4)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBar
    
    local sliderBtnCorner = Instance.new("UICorner")
    sliderBtnCorner.CornerRadius = UDim.new(1, 0)
    sliderBtnCorner.Parent = sliderBtn
    
    local dragging = false
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        settings[category][setting] = value
        sliderText.Text = text .. ": " .. value
        valueLabel.Text = tostring(value)
        
        local percent = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderBtn.Position = UDim2.new(percent, -6, 0, -4)
    end
    
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
            local value = min + (max - min) * percent
            if category == "aimbot" and setting == "smoothness" then
                value = math.floor(value * 100) / 100
            else
                value = math.floor(value)
            end
            updateSlider(value)
        end
    end)
    
    runService.Heartbeat:Connect(function()
        if dragging then
            local mouse = uis:GetMouseLocation()
            local percent = (mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
            local value = min + (max - min) * percent
            if category == "aimbot" and setting == "smoothness" then
                value = math.floor(value * 100) / 100
            else
                value = math.floor(value)
            end
            updateSlider(value)
        end
    end)
    
    -- Hover эффект
    sliderFrame.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            sliderFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}
        ):Play()
    end)
    
    sliderFrame.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            sliderFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}
        ):Play()
    end)
end

-- Вкладка ESP
local espY = 0
-- Добавляем настройки для биндов
settings.esp.bind = settings.esp.bind or Enum.KeyCode.Insert
settings.esp.color = settings.esp.color or Color3.fromRGB(255, 50, 50)

createToggle(contentFrames["ESP"], "ESP", "enabled", espY, "esp") espY = espY + 45
createToggle(contentFrames["ESP"], "Show Names", "showName", espY, "esp") espY = espY + 45
createToggle(contentFrames["ESP"], "Show Health", "showHealth", espY, "esp") espY = espY + 45
createToggle(contentFrames["ESP"], "Show Weapons", "showWeapon", espY, "esp") espY = espY + 45
createToggle(contentFrames["ESP"], "Show Distance", "showDistance", espY, "esp") espY = espY + 45
createToggle(contentFrames["ESP"], "Box ESP", "showBox", espY, "esp") espY = espY + 45
createToggle(contentFrames["ESP"], "3D ESP", "show3D", espY, "esp") espY = espY + 45
createToggle(contentFrames["ESP"], "Tracers", "showTracers", espY, "esp") espY = espY + 45
createToggle(contentFrames["ESP"], "Skeleton", "showSkeleton", espY, "esp") espY = espY + 45
createToggle(contentFrames["ESP"], "Health Bar", "showHealthBar", espY, "esp") espY = espY + 45
createToggle(contentFrames["ESP"], "Car ESP", "carESP", espY, "esp")

-- Вкладка Aimbot
local aimbotY = 0
createToggle(contentFrames["Aimbot"], "Aimbot", "enabled", aimbotY, "aimbot") aimbotY = aimbotY + 45
createToggle(contentFrames["Aimbot"], "Show FOV Circle", "showFOV", aimbotY, "aimbot") aimbotY = aimbotY + 45
createSlider(contentFrames["Aimbot"], "FOV", "fov", 10, 360, aimbotY, "aimbot") aimbotY = aimbotY + 60
createSlider(contentFrames["Aimbot"], "Smoothness", "smoothness", 0.01, 1, aimbotY, "aimbot") aimbotY = aimbotY + 60
createCycleButton(contentFrames["Aimbot"], "Aim Mode", "aimMode", {"camera", "mouse", "silent", "silent_v2", "silent_v3"}, aimbotY, "aimbot") aimbotY = aimbotY + 45
createToggle(contentFrames["Aimbot"], "Auto Shoot", "autoShoot", aimbotY, "aimbot") aimbotY = aimbotY + 45
createToggle(contentFrames["Aimbot"], "Visible Check", "visibleCheck", aimbotY, "aimbot") aimbotY = aimbotY + 45
createToggle(contentFrames["Aimbot"], "Team Check", "teamCheck", aimbotY, "aimbot") aimbotY = aimbotY + 45
createSlider(contentFrames["Aimbot"], "Hit Chance", "hitChance", 0, 100, aimbotY, "aimbot") aimbotY = aimbotY + 60
createSlider(contentFrames["Aimbot"], "Prediction", "prediction", 0, 0.5, aimbotY, "aimbot") aimbotY = aimbotY + 60
createToggle(contentFrames["Aimbot"], "Rage Bot", "enabled", aimbotY, "aimbot") aimbotY = aimbotY + 45
createToggle(contentFrames["Aimbot"], "TP Kill", "tpKill", aimbotY, "aimbot") aimbotY = aimbotY + 45
createSlider(contentFrames["Aimbot"], "TP Distance", "tpKillDistance", 1, 15, aimbotY, "aimbot") aimbotY = aimbotY + 60
createToggle(contentFrames["Aimbot"], "Anti-Aim", "antiAim", aimbotY, "aimbot")

-- Вкладка Movement
local movementY = 0
createToggle(contentFrames["Movement"], "Fly", "fly", movementY, "movement") movementY = movementY + 45
createSlider(contentFrames["Movement"], "Fly Speed", "flySpeed", 10, 100, movementY, "movement") movementY = movementY + 60
createToggle(contentFrames["Movement"], "Platform Fly", "platformFly", movementY, "movement") movementY = movementY + 45
createSlider(contentFrames["Movement"], "Platform Fly Speed", "platformFlySpeed", 5, 60, movementY, "movement") movementY = movementY + 60
createToggle(contentFrames["Movement"], "Bunny Hop", "bunnyHop", movementY, "movement") movementY = movementY + 45
createSlider(contentFrames["Movement"], "Hop Power", "hopPower", 5, 50, movementY, "movement") movementY = movementY + 60
createToggle(contentFrames["Movement"], "Spin Bot", "spinBot", movementY, "movement") movementY = movementY + 45
createSlider(contentFrames["Movement"], "Spin Speed", "spinSpeed", 5, 50, movementY, "movement") movementY = movementY + 60
createToggle(contentFrames["Movement"], "NoClip", "noClip", movementY, "movement") movementY = movementY + 45
createToggle(contentFrames["Movement"], "Speed Hack", "speedHack", movementY, "movement") movementY = movementY + 45
createSlider(contentFrames["Movement"], "Speed Multiplier", "speedMultiplier", 1, 5, movementY, "movement") movementY = movementY + 60
createToggle(contentFrames["Movement"], "Anti-AFK", "antiAFK", movementY, "movement") movementY = movementY + 45
createToggle(contentFrames["Movement"], "Air Jump", "airJump", movementY, "movement") movementY = movementY + 45
createToggle(contentFrames["Movement"], "Spider", "spider", movementY, "movement") movementY = movementY + 45
createToggle(contentFrames["Movement"], "Silent Fling", "silentFling", movementY, "movement") movementY = movementY + 45
createSlider(contentFrames["Movement"], "Fling Power", "flingPower", 1000, 10000, movementY, "movement") movementY = movementY + 60
createToggle(contentFrames["Movement"], "Anti Fling", "antiFling", movementY, "movement")

-- Вкладка Visuals
local visualsY = 0
createToggle(contentFrames["Visuals"], "Watermark", "watermark", visualsY, "visuals") visualsY = visualsY + 45
createToggle(contentFrames["Visuals"], "Custom Sky", "skyColor", visualsY, "visuals") visualsY = visualsY + 45
createCycleButton(contentFrames["Visuals"], "Sky Preset", "skyPreset", {"Default", "Pink", "Red", "White", "Blue", "Green", "Purple"}, visualsY, "visuals") visualsY = visualsY + 45
createToggle(contentFrames["Visuals"], "FOV Changer", "fovChanger", visualsY, "visuals") visualsY = visualsY + 45
createSlider(contentFrames["Visuals"], "Custom FOV", "customFOV", 70, 120, visualsY, "visuals") visualsY = visualsY + 60
createToggle(contentFrames["Visuals"], "Head Hitbox", "headHitbox", visualsY, "visuals") visualsY = visualsY + 45
createSlider(contentFrames["Visuals"], "Head Hitbox Size", "headHitboxSize", 1, 10, visualsY, "visuals") visualsY = visualsY + 60
createToggle(contentFrames["Visuals"], "Custom Crosshair", "customCrosshair", visualsY, "visuals") visualsY = visualsY + 45
createToggle(contentFrames["Visuals"], "Chams (Visible + Through Walls)", "chams", visualsY, "visuals") visualsY = visualsY + 45
createToggle(contentFrames["Visuals"], "Neon Enemies", "neonEnemies", visualsY, "visuals") visualsY = visualsY + 45
createToggle(contentFrames["Visuals"], "Enemy Glow", "enemyGlow", visualsY, "visuals") visualsY = visualsY + 45
createToggle(contentFrames["Visuals"], "Hit Sound", "hitSoundEnabled", visualsY, "visuals") visualsY = visualsY + 45
createToggle(contentFrames["Visuals"], "Hit Color", "hitColor", visualsY, "visuals") visualsY = visualsY + 45

-- Вкладка Misc
local miscY = 0
settings.misc = settings.misc or {}
settings.misc.autoRespawn = settings.misc.autoRespawn or false
settings.misc.antiKick = settings.misc.antiKick or false
settings.misc.rejoinOnKick = settings.misc.rejoinOnKick or false
settings.misc.theme = settings.misc.theme or "CS2"
settings.misc.visualColor = settings.misc.visualColor or "Default"
settings.misc.wallShot = settings.misc.wallShot or false
settings.misc.invisible = settings.misc.invisible or false

createToggle(contentFrames["Misc"], "Auto Respawn", "autoRespawn", miscY, "misc") miscY = miscY + 45
createToggle(contentFrames["Misc"], "Anti Kick", "antiKick", miscY, "misc") miscY = miscY + 45
createToggle(contentFrames["Misc"], "Rejoin On Kick", "rejoinOnKick", miscY, "misc") miscY = miscY + 45
createCycleButton(contentFrames["Misc"], "Theme", "theme", {"CS2", "Dark", "Light", "Purple", "Blue"}, miscY, "misc") miscY = miscY + 45
createCycleButton(contentFrames["Misc"], "Visual Color", "visualColor", {"Default", "Red", "Green", "Blue", "Purple", "Cyan", "Yellow", "Pink"}, miscY, "misc") miscY = miscY + 45
createToggle(contentFrames["Misc"], "Wall Shot", "wallShot", miscY, "misc") miscY = miscY + 45
createToggle(contentFrames["Misc"], "Invisible", "invisible", miscY, "misc") miscY = miscY + 45

-- Кнопка полного отключения чита (Unhook)
local unhookBtnFrame = Instance.new("TextButton")
unhookBtnFrame.Size = UDim2.new(1, -20, 0, 40)
unhookBtnFrame.Position = UDim2.new(0, 10, 0, miscY)
unhookBtnFrame.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
unhookBtnFrame.BorderSizePixel = 0
unhookBtnFrame.Text = ""
unhookBtnFrame.AutoButtonColor = false
unhookBtnFrame.Parent = contentFrames["Misc"]

local unhookBtnCorner = Instance.new("UICorner")
unhookBtnCorner.CornerRadius = UDim.new(0, 3)
unhookBtnCorner.Parent = unhookBtnFrame

local unhookDivider = Instance.new("Frame")
unhookDivider.Size = UDim2.new(1, 0, 0, 1)
unhookDivider.Position = UDim2.new(0, 0, 1, -1)
unhookDivider.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
unhookDivider.BorderSizePixel = 0
unhookDivider.Parent = unhookBtnFrame

local unhookBtn = Instance.new("TextButton")
unhookBtn.Size = UDim2.new(1, 0, 1, 0)
unhookBtn.Position = UDim2.new(0, 0, 0, 0)
unhookBtn.Text = "Unhook (Полностью выключить чит)"
unhookBtn.BackgroundTransparency = 1
unhookBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
unhookBtn.Font = Enum.Font.GothamBold
unhookBtn.TextSize = 13
unhookBtn.BorderSizePixel = 0
unhookBtn.Parent = unhookBtnFrame

unhookBtn.MouseButton1Click:Connect(function()
    if unhook then
        pcall(unhook)
    end
end)

unhookBtnFrame.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(
        unhookBtnFrame,
        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(60, 30, 30)}
    ):Play()
end)

unhookBtnFrame.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(
        unhookBtnFrame,
        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(40, 20, 20)}
    ):Play()
end)

miscY = miscY + 45

local configY = 0

-- Поле для имени конфига
local configNameFrame = Instance.new("Frame")
configNameFrame.Size = UDim2.new(1, -20, 0, 45)
configNameFrame.Position = UDim2.new(0, 10, 0, configY)
configNameFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
configNameFrame.BorderSizePixel = 0
configNameFrame.Parent = contentFrames["Config"]

local configNameCorner = Instance.new("UICorner")
configNameCorner.CornerRadius = UDim.new(0, 3)
configNameCorner.Parent = configNameFrame

local configNameLabel = Instance.new("TextLabel")
configNameLabel.Size = UDim2.new(0.4, -10, 1, 0)
configNameLabel.Position = UDim2.new(0, 10, 0, 0)
configNameLabel.BackgroundTransparency = 1
configNameLabel.Text = "Config name:"
configNameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
configNameLabel.Font = Enum.Font.Gotham
configNameLabel.TextSize = 13
configNameLabel.TextXAlignment = Enum.TextXAlignment.Left
configNameLabel.Parent = configNameFrame

local configNameBox = Instance.new("TextBox")
configNameBox.Size = UDim2.new(0.6, -20, 1, -10)
configNameBox.Position = UDim2.new(0.4, 10, 0, 5)
configNameBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
configNameBox.BorderSizePixel = 1
configNameBox.PlaceholderText = "default"
configNameBox.Text = "default"
configNameBox.ClearTextOnFocus = false
configNameBox.TextColor3 = Color3.fromRGB(220, 220, 220)
configNameBox.Font = Enum.Font.Gotham
configNameBox.TextSize = 13
configNameBox.Parent = configNameFrame

local configNameBoxCorner = Instance.new("UICorner")
configNameBoxCorner.CornerRadius = UDim.new(0, 3)
configNameBoxCorner.Parent = configNameBox

configY = configY + 50

local function setConfigNameFromBox()
    if configNameBox.Text ~= "" then
        setCurrentConfigName(configNameBox.Text)
    end
end

configNameBox.FocusLost:Connect(function()
    setConfigNameFromBox()
end)

local function createConfigButton(text, callback)
    local btnFrame = Instance.new("TextButton")
    btnFrame.Size = UDim2.new(1, -20, 0, 40)
    btnFrame.Position = UDim2.new(0, 10, 0, configY)
    btnFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btnFrame.BorderSizePixel = 0
    btnFrame.LayoutOrder = configY
    btnFrame.Text = ""
    btnFrame.AutoButtonColor = false
    btnFrame.Parent = contentFrames["Config"]

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 3)
    btnCorner.Parent = btnFrame

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 1, -1)
    divider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    divider.BorderSizePixel = 0
    divider.Parent = btnFrame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.Text = text
    btn.BackgroundTransparency = 1
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = btnFrame

    btn.MouseButton1Click:Connect(function()
        setConfigNameFromBox()
        callback()
    end)

    btnFrame.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            btnFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}
        ):Play()
    end)

    btnFrame.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            btnFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}
        ):Play()
    end)

    configY = configY + 45
end

createConfigButton("Save Config", function()
    local ok, err = pcall(saveConfig)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Config",
        Text = ok and "Config saved!" or ("Save error: " .. tostring(err)),
        Duration = 3
    })
end)

createConfigButton("Load Config", function()
    local ok, err = pcall(loadConfig)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Config",
        Text = ok and "Config loaded!" or ("Load error: " .. tostring(err)),
        Duration = 3
    })
end)

createConfigButton("Delete Config", function()
    local ok, err = pcall(deleteConfig)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Config",
        Text = ok and "Config deleted!" or ("Delete error: " .. tostring(err)),
        Duration = 3
    })
end)

createConfigButton("Reset To Defaults", function()
    resetConfigToDefaults()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Config",
        Text = "Config reset!",
        Duration = 3
    })
end)

local lastESPUpdate = 0

local function clearESP()
    -- Защита от nil: если по какой-то причине таблица ещё не создана
    if espDrawings == nil then
        espDrawings = {}
        return
    end
    for _, drawings in pairs(espDrawings) do
        for _, drawing in pairs(drawings) do
            if drawing and drawing.Remove then
                drawing:Remove()
            end
        end
    end
    espDrawings = {}
end

local function clearESP3D()
    -- Защита от nil: если таблица ещё не создана
    if esp3DBoxes == nil then
        esp3DBoxes = {}
        return
    end
    for player, box in pairs(esp3DBoxes) do
        if box and box.Destroy then
            box:Destroy()
        end
        esp3DBoxes[player] = nil
    end
end

local function updateESP()
    -- Если ESP выключен, просто очищаем и выходим
    if not settings.esp.enabled then
        if next(espDrawings or {}) or next(esp3DBoxes or {}) then
            clearESP()
            clearESP3D()
        end
        return
    end

    -- Троттлинг по времени, чтобы не обновлять каждый кадр (меньше нагрузка)
    -- Делаем почаще (≈33 раза/сек), чтобы ESP выглядел более плавно
    local now = tick()
    if now - lastESPUpdate < 0.03 then
        return
    end
    lastESPUpdate = now

    clearESP()

    -- Гарантируем, что вспомогательные таблицы существуют
    espDrawings = espDrawings or {}
    esp3DBoxes = esp3DBoxes or {}
    carESPBoxes = carESPBoxes or {}

    if not settings.esp.enabled then return end

    local activeVehicles = {}

    for _, player in ipairs(players:GetPlayers()) do
        if player == localPlayer or not player.Character then continue end

        local character = player.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")

        if not humanoid or not rootPart or not head or humanoid.Health <= 0 then continue end

        local drawings = {}

        -- Box ESP
        if settings.esp.showBox then
            local headPos, headOnScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
            local feetPos, feetOnScreen = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 4, 0))

            if headOnScreen and feetOnScreen and headPos.Z > 0 and feetPos.Z > 0 then
                local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
                local boxWidth = math.clamp(2000 / distance, 30, 100)
                local boxHeight = feetPos.Y - headPos.Y

                local box = Drawing.new("Square")
                box.Visible = true
                box.Color = settings.esp.color or Color3.fromRGB(255, 80, 80)
                box.Thickness = settings.esp.boxThickness or 3
                box.Transparency = 1 
                box.Filled = false

                box.Size = Vector2.new(boxWidth, boxHeight)
                box.Position = Vector2.new(headPos.X - boxWidth / 2, headPos.Y)
                table.insert(drawings, box)
            end
        end

        -- Name, Distance, Health, Weapon
        local headPos, headOnScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
        if headOnScreen and headPos.Z > 0 then
            local yOffset = -20

            -- Name
            if settings.esp.showName then
                local nameText = Drawing.new("Text")
                nameText.Text = player.Name
                nameText.Size = settings.esp.nameSize or 14
                nameText.Center = true
                nameText.Outline = true
                nameText.Color = settings.esp.color or Color3.fromRGB(255, 255, 255)
                nameText.Position = Vector2.new(headPos.X, headPos.Y + yOffset)
                nameText.Visible = true
                table.insert(drawings, nameText)
                yOffset = yOffset + 15
            end

            -- Distance
            if settings.esp.showDistance then
                local localChar = localPlayer.Character
                local distance = localChar and localChar:FindFirstChild("HumanoidRootPart") and
                    math.floor((rootPart.Position - localChar.HumanoidRootPart.Position).Magnitude) or 0
                local distText = Drawing.new("Text")
                distText.Text = distance .. "m"
                distText.Size = settings.esp.distanceSize or 12
                distText.Center = true
                distText.Outline = true
                distText.Color = Color3.fromRGB(255, 255, 255)
                distText.Position = Vector2.new(headPos.X, headPos.Y + yOffset)
                distText.Visible = true
                table.insert(drawings, distText)
                yOffset = yOffset + 15
            end

            -- Health
            if settings.esp.showHealth then
                local hp = math.floor(humanoid.Health)
                local maxHp = math.floor(humanoid.MaxHealth)
                local hpPercent = humanoid.Health / humanoid.MaxHealth
                local hpColor = hpPercent > 0.6 and Color3.fromRGB(0, 255, 0) or
                               (hpPercent > 0.3 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0))
                local hpText = Drawing.new("Text")
                hpText.Text = hp .. "/" .. maxHp .. " HP"
                hpText.Size = settings.esp.distanceSize or 12
                hpText.Center = true
                hpText.Outline = true
                hpText.Color = hpColor
                hpText.Position = Vector2.new(headPos.X, headPos.Y + yOffset)
                hpText.Visible = true
                table.insert(drawings, hpText)
                yOffset = yOffset + 15
            end

            -- Weapon
            if settings.esp.showWeapon then
                local tool = character:FindFirstChildOfClass("Tool")
                local weaponText = Drawing.new("Text")
                weaponText.Text = tool and tool.Name or "None"
                weaponText.Size = settings.esp.weaponSize or 12
                weaponText.Center = true
                weaponText.Outline = true
                weaponText.Color = Color3.fromRGB(255, 255, 255)
                weaponText.Position = Vector2.new(headPos.X, headPos.Y + yOffset)
                weaponText.Visible = true
                table.insert(drawings, weaponText)
            end
        end

        -- Tracer
        if settings.esp.showTracers then
            local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            if onScreen and screenPos.Z > 0 then
                local tracer = Drawing.new("Line")
                tracer.Visible = true
                tracer.Color = settings.esp.color or Color3.fromRGB(255, 80, 80)
                tracer.Thickness = settings.esp.tracerThickness or 3
                tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                table.insert(drawings, tracer)
            end
        end

        -- Skeleton
        if settings.esp.showSkeleton then
            local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
            local leftArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm")
            local rightArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")
            local leftLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
            local rightLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")

            local function drawLine(part1, part2)
                if part1 and part2 then
                    local pos1, vis1 = camera:WorldToViewportPoint(part1.Position)
                    local pos2, vis2 = camera:WorldToViewportPoint(part2.Position)
                    if vis1 and vis2 and pos1.Z > 0 and pos2.Z > 0 then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.fromRGB(255, 255, 255)
                        line.Thickness = 1
                        line.From = Vector2.new(pos1.X, pos1.Y)
                        line.To = Vector2.new(pos2.X, pos2.Y)
                        table.insert(drawings, line)
                    end
                end
            end

            if torso then
                drawLine(torso, head)
                if leftArm then drawLine(torso, leftArm) end
                if rightArm then drawLine(torso, rightArm) end
                if leftLeg then drawLine(torso, leftLeg) end
                if rightLeg then drawLine(torso, rightLeg) end
            end
        end

        espDrawings[player] = drawings

        -- 3D ESP: видно через стены (Highlight с обводкой)
        if settings.esp.show3D then
            local box = esp3DBoxes[player]
            if not box or not box.Parent then
                if box then box:Destroy() end
                box = Instance.new("Highlight")
                box.Name = "ESP_3D_Highlight"
                box.Adornee = character
                box.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- видно через стены
                box.FillTransparency = 1 -- без заливки
                box.OutlineTransparency = 0
                box.OutlineColor = settings.esp.color or Color3.fromRGB(255, 80, 80)
                box.Parent = workspace.CurrentCamera
                esp3DBoxes[player] = box
            else
                box.Adornee = character
                box.OutlineColor = settings.esp.color or Color3.fromRGB(255, 80, 80)
            end
        else
            if esp3DBoxes[player] then
                esp3DBoxes[player]:Destroy()
                esp3DBoxes[player] = nil
            end
        end

        -- Car ESP: подсветка транспорта, в котором сидит игрок
        if settings.esp.carESP then
            local seatPart = humanoid.SeatPart
            if seatPart and (seatPart:IsA("VehicleSeat") or seatPart:IsA("Seat")) then
                local vehicleModel = seatPart:FindFirstAncestorOfClass("Model") or seatPart.Parent
                if vehicleModel then
                    activeVehicles[vehicleModel] = true
                    local carHighlight = carESPBoxes[vehicleModel]
                    if not carHighlight or not carHighlight.Parent then
                        if carHighlight then carHighlight:Destroy() end
                        carHighlight = Instance.new("Highlight")
                        carHighlight.Name = "Car_ESP_Highlight"
                        carHighlight.Adornee = vehicleModel
                        carHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        carHighlight.FillTransparency = 1
                        carHighlight.OutlineTransparency = 0
                        carHighlight.OutlineColor = settings.esp.color or Color3.fromRGB(255, 80, 80)
                        carHighlight.Parent = workspace.CurrentCamera
                        carESPBoxes[vehicleModel] = carHighlight
                    else
                        carHighlight.Adornee = vehicleModel
                        carHighlight.OutlineColor = settings.esp.color or Color3.fromRGB(255, 80, 80)
                    end
                end
            end
        end
    end

    -- Очистка неактивных машин или всех при выключенном carESP
    if settings.esp.carESP then
        for vehicle, highlight in pairs(carESPBoxes) do
            if not activeVehicles[vehicle] then
                if highlight and highlight.Destroy then
                    highlight:Destroy()
                end
                carESPBoxes[vehicle] = nil
            end
        end
    else
        for vehicle, highlight in pairs(carESPBoxes) do
            if highlight and highlight.Destroy then
                highlight:Destroy()
            end
            carESPBoxes[vehicle] = nil
        end
    end
end

-- Обновление ESP каждый кадр
local espConnection
toggleESP = function()
    if settings.esp.enabled then
        if espConnection then return end
        espConnection = runService.RenderStepped:Connect(updateESP)
    else
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        clearESP()
        clearESP3D()
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

-- Инициализация ESP
if settings.esp.enabled then
    toggleESP()
end

-- Улучшенный Aimbot

local mobileAimbotHold = false
local aimbotMobileButton

local function createAimbotMobileButton()
    if aimbotMobileButton then return end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 0, 70)
    btn.Position = UDim2.new(1, -90, 1, -90)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = "AIM"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local function updateVisual()
        if mobileAimbotHold and settings.aimbot.enabled then
            btn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            btn.BackgroundTransparency = 0.15
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            btn.BackgroundTransparency = 0.4
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end

    btn.MouseButton1Click:Connect(function()
        mobileAimbotHold = not mobileAimbotHold
        updateVisual()
    end)

    aimbotMobileButton = btn
    updateVisual()
end

local function makeDraggableButton(button)
    local dragging = false
    local dragStart
    local startPos

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
        end
    end)

    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    uis.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            button.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

createAimbotMobileButton()
if aimbotMobileButton then
    makeDraggableButton(aimbotMobileButton)
end

local silentOriginalHeadProps = {}
local silentOriginalCollisions = {}

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
        return hitPart == targetPart or hitPart:IsDescendantOf(targetPart.Parent)
    else
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

    if settings.aimbot.aimMode == "camera" then
        -- обычное наведение камерой
        camera.CFrame = currentCFrame:Lerp(targetCFrame, settings.aimbot.smoothness)

    elseif settings.aimbot.aimMode == "mouse" then
        local screenPos, onScreen = camera:WorldToViewportPoint(predictedPosition)
        if onScreen then
            local mouse = game:GetService("UserInputService"):GetMouseLocation()
            local deltaX = screenPos.X - mouse.X
            local deltaY = screenPos.Y - mouse.Y

            -- нормализуем движение и регулируем скорость
            local speed = settings.aimbot.smoothness * 100
            local moveX = deltaX * speed * runService.RenderStepped:Wait()
            local moveY = deltaY * speed * runService.RenderStepped:Wait()

            -- смещаем мышку постепенно
            mousemoverel(moveX, moveY)
        end

    elseif settings.aimbot.aimMode == "silent" then
        local character = targetPart.Parent
        if character then
            local head = character:FindFirstChild("Head")
            if head then
                -- сохраняем оригинальные свойства головы один раз
                if not silentOriginalHeadProps[head] then
                    silentOriginalHeadProps[head] = {
                        size = head.Size,
                        transparency = head.Transparency
                    }
                end

                -- если цель за стеной — не телепортируем
                if not isTargetVisible(head) then return end

                -- отключаем коллизию у всех частей персонажа
                for _, obj in ipairs(character:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        if silentOriginalCollisions[obj] == nil then
                            silentOriginalCollisions[obj] = obj.CanCollide
                        end
                        obj.CanCollide = false
                    end
                end

                -- увеличиваем хитбокс головы и делаем её прозрачной
                head.Size = Vector3.new(5, 5, 5)
                head.Transparency = 1

                -- телепортируем голову немного дальше перед камерой
                local forwardPos = currentCFrame.Position + currentCFrame.LookVector * 6
                head.CFrame = CFrame.new(forwardPos, forwardPos + currentCFrame.LookVector)
            end
        end
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
            -- Проверка команды (используем настройку teamCheck)
            if settings.aimbot.teamCheck and localPlayer.Team and player.Team and localPlayer.Team == player.Team then
                continue
            end

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

local currentTarget = nil

local function isAimbotActiveInput()
    if mobileAimbotHold then
        return true
    end
    if uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        return true
    end
    return false
end

-- Основной цикл Aimbot
game:GetService("RunService").RenderStepped:Connect(function()
    -- если silent не активен, возвращаем все свойства назад
    if settings.aimbot.aimMode ~= "silent" or not settings.aimbot.enabled or not isAimbotActiveInput() then
        for head, props in pairs(silentOriginalHeadProps) do
            if head and head.Parent then
                head.Size = props.size
                head.Transparency = props.transparency
            end
            silentOriginalHeadProps[head] = nil
        end

        for part, canCollide in pairs(silentOriginalCollisions) do
            if part and part.Parent then
                part.CanCollide = canCollide
            end
            silentOriginalCollisions[part] = nil
        end
    end

    -- Проверяем, включён ли Aimbot и активен ли ввод (ПКМ или мобильная кнопка)
    if not settings.aimbot.enabled or not isAimbotActiveInput() then
        currentTarget = nil
        return
    end

    -- Проверяем, жив ли локальный игрок
    local localChar = localPlayer.Character
    local localHumanoid = localChar and localChar:FindFirstChildOfClass("Humanoid")
    if not localChar or not localHumanoid or localHumanoid.Health <= 0 then
        currentTarget = nil
        return
    end

    -- Проверяем актуальность текущей цели
    if currentTarget and currentTarget.Character then
        local humanoid = currentTarget.Character:FindFirstChildOfClass("Humanoid")
        local targetPart = currentTarget.Character:FindFirstChild(settings.aimbot.targetPart)
        if humanoid and humanoid.Health > 0 and targetPart then
            -- Если всё ок, просто целимся в текущую цель
            aimAt(targetPart)
            return
        else
            -- Если цель умерла или пропала
            currentTarget = nil
        end
    end

    -- Если текущей цели нет — ищем ближайшую
    if not currentTarget then
        local newTarget = getClosestPlayer()
        if newTarget then
            currentTarget = newTarget
        end
    end

    -- Наводимся, если нашли цель
    if currentTarget and currentTarget.Character then
        local targetPart = currentTarget.Character:FindFirstChild(settings.aimbot.targetPart)
        if targetPart then
            aimAt(targetPart)
        end
    end
end)

-- === TP KILL FUNCTION ===
local tpKillConnection

local function getNextTarget()
    local closest, dist = nil, math.huge
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local d = (hrp.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = player
                end
            end
        end
    end
    return closest
end

local function startTPKill()
    if tpKillConnection then return end
    tpKillConnection = runService.Heartbeat:Connect(function()
        if not settings.aimbot.tpKill then return end
        local target = getNextTarget()
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if hrp and humanoid and humanoid.Health > 0 and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = localPlayer.Character.HumanoidRootPart
                -- телепортируемся за спину
                myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, settings.aimbot.tpKillDistance)
            end
        end
    end)
end

local function stopTPKill()
    if tpKillConnection then
        tpKillConnection:Disconnect()
        tpKillConnection = nil
    end
end

-- Автоматическое включение/выключение
runService.Heartbeat:Connect(function()
    if settings.aimbot.tpKill then
        startTPKill()
    else
        stopTPKill()
    end
end)

-- === AIM FOV CIRCLE ===
local AimFOV = {}
do
    local circle
    local conn

    local function createCircle()
        pcall(function()
            circle = Drawing.new("Circle")
            circle.Visible = false
            circle.Filled = false
            circle.Thickness = settings.aimbot.fovThickness or 2
            circle.Radius = 0
            circle.Color = settings.aimbot.fovColor or Color3.fromRGB(255, 50, 50)
            circle.Transparency = 1
        end)
    end

    local function updateCircle()
        if not circle then return end

        -- показываем только если включено и aimbot активен/или по желанию
        circle.Visible = settings.aimbot.showFOV and settings.aimbot.enabled

        if not circle.Visible then return end

        -- позиция (центр камеры или мышь)
        local viewport = camera.ViewportSize
        local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
        if settings.aimbot.aimMode == "mouse" then
            local mousePos = uis:GetMouseLocation()
            center = Vector2.new(mousePos.X, mousePos.Y)
        end

        -- вычисление радиуса в пикселях:
        -- корректируем желаемый угол (settings.aimbot.fov) относительно вертикального FOV камеры
        local desiredHalfRad = math.rad((settings.aimbot.fov or 90) / 2)
        local cameraHalfRad = math.rad(camera.FieldOfView / 2) -- FieldOfView — вертикальный FOV в градусах
        -- радиус по вертикали (используем Y размер экрана)
        local radius = 0
        if cameraHalfRad > 0 then
            radius = math.tan(desiredHalfRad) / math.tan(cameraHalfRad) * (viewport.Y / 2)
        end

        -- защита от NaN / слишком большого
        if not radius or radius ~= radius then radius = 0 end
        radius = math.clamp(radius, 0, math.max(viewport.X, viewport.Y) * 2)

        circle.Position = center
        circle.Radius = radius
        circle.Thickness = settings.aimbot.fovThickness or 2
        circle.Color = settings.aimbot.fovColor or circle.Color
    end

    function AimFOV.Start()
        if not circle then createCircle() end
        if conn then conn:Disconnect() end
        conn = runService.RenderStepped:Connect(function()
            local ok, err = pcall(updateCircle)
            if not ok then
                -- на случай ошибок — отключаем соединение, чтобы не spam-ить
                if conn then conn:Disconnect() conn = nil end
                warn("AimFOV update error:", err)
            end
        end)
    end

    function AimFOV.Stop()
        if conn then conn:Disconnect() conn = nil end
        if circle then
            pcall(function() circle.Visible = false circle:Remove() end)
            circle = nil
        end
    end

    -- автозапуск
    AimFOV.Start()
end

-- Wall Shot: временное "удаление" стен в радиусе точки прицела
local wallShotDisabledParts = {}

local function wallShotAtMouse()
    local mouseLocation = uis:GetMouseLocation()
    local ray = camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)

    -- Определяем пол под игроком (чтобы его не трогать)
    local floorPart = nil
    local char = localPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local floorParams = RaycastParams.new()
        floorParams.FilterType = Enum.RaycastFilterType.Blacklist
        floorParams.FilterDescendantsInstances = {char}
        local floorResult = workspace:Raycast(hrp.Position, Vector3.new(0, -10, 0), floorParams)
        if floorResult then
            floorPart = floorResult.Instance
        end
    end

    -- Проходим лучом вперёд и собираем все части, пока есть, без ограничения дистанции
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {localPlayer.Character}

    local origin = ray.Origin
    local direction = ray.Direction.Unit

    local hitParts = {}

    while true do
        local result = workspace:Raycast(origin, direction * 10000, rayParams)
        if not result or not result.Instance then
            break
        end

        local part = result.Instance
        table.insert(hitParts, part)

        -- Добавляем найденную часть в фильтр, чтобы луч пошёл дальше
        table.insert(rayParams.FilterDescendantsInstances, part)

        -- Смещаем origin чуть дальше точки попадания
        origin = result.Position + direction * 0.1
    end

    if #hitParts == 0 then return end

    -- Отключаем коллизию и делаем части прозрачными, учитывая мульти-клики
    for _, part in ipairs(hitParts) do
        if part:IsA("BasePart") and part ~= floorPart then
            -- пропускаем части всех игроков
            local characterModel = part:FindFirstAncestorOfClass("Model")
            local ownerPlayer = characterModel and players:GetPlayerFromCharacter(characterModel)
            if not ownerPlayer then
                local info = wallShotDisabledParts[part]
                if info then
                    info.count = info.count + 1
                else
                    wallShotDisabledParts[part] = {
                        count = 1,
                        canCollide = part.CanCollide,
                        transparency = part.Transparency
                    }
                end

                part.CanCollide = false
                part.Transparency = 1
            end
        end
    end

    -- Быстрое восстановление (≈0.3 секунды) с учетом нескольких кликов
    task.delay(0.3, function()
        for _, part in ipairs(hitParts) do
            local info = wallShotDisabledParts[part]
            if info then
                info.count = info.count - 1
                if info.count <= 0 then
                    if part and part.Parent then
                        part.CanCollide = info.canCollide
                        part.Transparency = info.transparency
                    end
                    wallShotDisabledParts[part] = nil
                end
            end
        end
    end)
end

local wallShotMouseDown = false

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wallShotMouseDown = true
    end
end)

uis.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wallShotMouseDown = false
    end
end)

runService.Heartbeat:Connect(function()
    if settings.misc and settings.misc.wallShot and wallShotMouseDown then
        wallShotAtMouse()
    end
end)

-- Enemy Glow для Murder Mystery 2
if not settings.visuals then
    settings.visuals = {}
end
settings.visuals.enemyGlow = false

local highlights = {}

-- определяем цвет по роли
local function getMM2RoleColor(player)
    if not player.Character then return Color3.fromRGB(0, 255, 0) end -- зелёный (невиновный)

    local tool = player.Backpack:FindFirstChildOfClass("Tool") or player.Character:FindFirstChildOfClass("Tool")
    if tool then
        local name = tool.Name:lower()
        if string.find(name, "knife") or string.find(name, "blade") or string.find(name, "sword") then
            return Color3.fromRGB(255, 0, 0) -- убийца красный
        elseif string.find(name, "gun") or string.find(name, "pistol") or string.find(name, "revolver") then
            return Color3.fromRGB(0, 100, 255) -- шериф синий
        end
    end

    return Color3.fromRGB(0, 255, 0) -- невиновный зелёный
end

local function removeGlow(player)
    local highlight = highlights[player]
    if highlight then
        highlight:Destroy()
        highlights[player] = nil
    end
end

local function applyGlow(player)
    if player == localPlayer or not player.Character then
        removeGlow(player)
        return
    end

    if not settings.visuals.enemyGlow then
        removeGlow(player)
        return
    end

    local highlight = highlights[player]
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = player.Character
        highlights[player] = highlight
    end

    highlight.FillColor = getMM2RoleColor(player)
end

local function handleEnemyGlow()
    for _, player in ipairs(players:GetPlayers()) do
        applyGlow(player)
    end
end

runService.RenderStepped:Connect(handleEnemyGlow)

players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if settings.visuals.enemyGlow then
            applyGlow(player)
        end
    end)
end)

players.PlayerRemoving:Connect(removeGlow)

-- Чтобы обновлялся при смене оружия
for _, player in ipairs(players:GetPlayers()) do
    player.Backpack.ChildAdded:Connect(function()
        applyGlow(player)
    end)
    player.Backpack.ChildRemoved:Connect(function()
        applyGlow(player)
    end)
end

-- Улучшенная версия Neon Enemies
local neonEnemies = {} -- Храним данные для каждого игрока
local neonConnections = {} -- Храним соединения для каждого игрока

local function applyNeon(character)
    if not character or neonEnemies[character] then return end

    local partsData = {}
    neonEnemies[character] = partsData

    -- Функция для применения неона к части
    local function applyToPart(part)
        if not part:IsA("BasePart") or part:FindFirstChild("OriginalMaterial") then return end

        -- Сохраняем оригинальные свойства
        local originalMaterial = Instance.new("StringValue")
        originalMaterial.Name = "OriginalMaterial"
        originalMaterial.Value = part.Material.Name
        originalMaterial.Parent = part

        local originalColor = Instance.new("Color3Value")
        originalColor.Name = "OriginalColor"
        originalColor.Value = part.Color
        originalColor.Parent = part

        local originalTransparency = Instance.new("NumberValue")
        originalTransparency.Name = "OriginalTransparency"
        originalTransparency.Value = part.Transparency
        originalTransparency.Parent = part

        -- Применяем Neon-эффект
        part.Material = Enum.Material.Neon
        part.Color = Color3.fromRGB(0, 255, 255) -- Яркий голубой цвет
        part.Transparency = 0.2

        partsData[part] = true
    end

    -- Применяем ко всем текущим частям
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            applyToPart(part)
        end
    end

    -- Отслеживаем новые части
    local descendantAddedConnection = character.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") and settings.visuals.neonEnemies then
            applyToPart(descendant)
        end
    end)

    -- Отслеживаем удаление персонажа
    local ancestryChangedConnection = character.AncestryChanged:Connect(function(_, parent)
        if not parent then
            removeNeon(character)
        end
    end)

    -- Сохраняем соединения
    neonConnections[character] = {
        descendantAdded = descendantAddedConnection,
        ancestryChanged = ancestryChangedConnection
    }
end

local function removeNeon(character)
    if not character or not neonEnemies[character] then return end

    -- Восстанавливаем оригинальные свойства
    for part, _ in pairs(neonEnemies[character]) do
        if part.Parent then
            local originalMaterial = part:FindFirstChild("OriginalMaterial")
            local originalColor = part:FindFirstChild("OriginalColor")
            local originalTransparency = part:FindFirstChild("OriginalTransparency")

            if originalMaterial and originalColor and originalTransparency then
                part.Material = Enum.Material[originalMaterial.Value] or Enum.Material.Plastic
                part.Color = originalColor.Value
                part.Transparency = originalTransparency.Value

                originalMaterial:Destroy()
                originalColor:Destroy()
                originalTransparency:Destroy()
            end
        end
    end

    -- Отключаем соединения
    local connections = neonConnections[character]
    if connections then
        connections.descendantAdded:Disconnect()
        connections.ancestryChanged:Disconnect()
        neonConnections[character] = nil
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
        players.PlayerAdded:Connect(function(player)
            if player ~= localPlayer then
                player.CharacterAdded:Connect(function(character)
                    if settings.visuals.neonEnemies then
                        applyNeon(character)
                    end
                end)
            end
        end)
    else
        -- Удаляем Neon у всех игроков
        for character, _ in pairs(neonEnemies) do
            removeNeon(character)
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

-- Chams через стены с изменением цвета (старый код)
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

local lastChamsUpdate = 0
local function clearChams()
    for _, cham in pairs(chams) do
        if cham and cham.Destroy then
            cham:Destroy()
        end
    end
    chams = {}
end

local function updateChams()
    -- Лёгкий троттлинг, чтобы не создавать/удалять боксы каждый кадр
    local now = tick()
    if now - lastChamsUpdate < 0.1 then
        return
    end
    lastChamsUpdate = now

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

-- Anti-Aim (С увеличенной скоростью x5)
local antiAimConnection
local currentDirection = 1 -- 1 = вправо, -1 = влево
local currentDuration = 0
local currentSpeed = 0
local nextChangeTime = tick()

toggleAntiAim = function()
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
                local sideDistance = math.random(2, 3) -- Смещение на 1-3 юнита
                rootPart.CFrame = rootPart.CFrame * CFrame.new(sideDirection * sideDistance, 0, 0)

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

-- Единый обработчик биндов (будет добавлен позже)

-- Авто-включение при респавне
localPlayer.CharacterAdded:Connect(function()
    if settings.aimbot.antiAim then
        wait(1)
        toggleAntiAim()
    end
end)

-- Настройки рейдж-бота (меняй false/true здесь)
RAGE_BOT_ENABLED = false -- Включён ли рейдж-бот по умолчанию
VISIBLE_CHECK = true -- Проверять видимость (true = не целиться через стены)
TEAM_CHECK = false -- Игнорировать игроков из своей команды
TARGET_PART = "Head" -- Целевая часть (можно изменить на "HumanoidRootPart")
FIRE_COOLDOWN = 0.1 -- Задержка между выстрелами (в секундах)
lastFireTime = 0 -- Время последнего выстрела
isFiring = true -- Флаг для стрельбы

-- Функция для получения предсказанной позиции (адаптирована из твоего аимбота)
local function getPredictedPosition(targetPart)
    if not targetPart then return nil end
    local character = targetPart.Parent
    if not character then return targetPart.Position end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return targetPart.Position end
    local velocity = targetPart.AssemblyLinearVelocity
    return targetPart.Position + (velocity * 0.1) -- Предсказание на 0.1 секунды
end

-- Функция проверки видимости (из твоего исправленного аимбота)
local function isTargetVisible(targetPart)
    if not VISIBLE_CHECK then return true end
    if not targetPart then return false end

    local camera = workspace.CurrentCamera
    local character = localPlayer.Character
    local head = character and character:FindFirstChild("Head")

    -- Определяем точку начала луча
    local origin
    if camera.CameraType == Enum.CameraType.Custom and head then
        origin = head.Position + (camera.CFrame.LookVector * 2)
    else
        origin = camera.CFrame.Position
    end

    local direction = targetPart.Position - origin

    -- Проверяем, находится ли цель в зоне видимости камеры
    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then
        return false
    end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true

    local raycastResult = workspace:Raycast(origin, direction, raycastParams)

    if raycastResult then
        local hitPart = raycastResult.Instance
        return hitPart == targetPart or hitPart:IsDescendantOf(targetPart.Parent)
    else
        return true
    end
end

-- Функция для поиска ближайшего игрока
local function getClosestPlayer()
    local closestPlayer, closestDistance = nil, math.huge
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            -- Проверка команды (исправлено)
            if localPlayer.Team and player.Team and localPlayer.Team == player.Team then
                continue
            end
            local targetPart = player.Character:FindFirstChild(TARGET_PART)
            if targetPart and isTargetVisible(targetPart) then
                local distance = (targetPart.Position - camera.CFrame.Position).Magnitude
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- Функция для управления автоматической стрельбой
local function handleAutoFire(tool)
    if not tool then
        if isFiring then
            isFiring = false
        end
        return
    end
    if RAGE_BOT_ENABLED and (tick() - lastFireTime >= FIRE_COOLDOWN) then
        isFiring = true
        tool:Activate()
        lastFireTime = tick()
    elseif not RAGE_BOT_ENABLED and isFiring then
        isFiring = false
    end
end

-- Anti-Fling 
local function antiFlingStep()
    if not settings.movement.antiFling then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            
            root.AssemblyAngularVelocity = Vector3.new(0,0,0)
            root.AssemblyLinearVelocity = Vector3.new(0,0,0)

            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end

runService.Heartbeat:Connect(antiFlingStep)

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
        return
    end

    local predictedPosition = getPredictedPosition(targetPart)
    if not predictedPosition then
        handleAutoFire(nil)
        return
    end

    camera.CFrame = CFrame.new(camera.CFrame.Position, predictedPosition)

    local tool = character:FindFirstChildOfClass("Tool")
    handleAutoFire(tool)
end

-- Обработчик нажатия клавиши L
uis.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.L then
        RAGE_BOT_ENABLED = not RAGE_BOT_ENABLED
        if not RAGE_BOT_ENABLED then
            isFiring = false
        end
    end
end)

runService.RenderStepped:Connect(handleRageBot)

-- Новая конфиг-система
local CONFIG_FOLDER = "Spyt1kHack"
local currentConfigName = "default"

local function sanitizeConfigName(name)
    name = tostring(name or "default")
    name = name:gsub("[^%w_%-]", "_")
    if name == "" then
        name = "default"
    end
    return name
end

local function ensureConfigFolder()
    if typeof(isfolder) == "function" and not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end

local function getConfigPath()
    ensureConfigFolder()
    local safeName = sanitizeConfigName(currentConfigName)
    return CONFIG_FOLDER .. "/" .. safeName .. ".json"
end

function setCurrentConfigName(name)
    currentConfigName = sanitizeConfigName(name)
end

function saveConfig()
    if typeof(writefile) ~= "function" or typeof(isfolder) ~= "function" then
        error("File functions are not available (writefile/isfolder)")
    end

    local path = getConfigPath()
    local encoded = HttpService:JSONEncode(settings)
    writefile(path, encoded)
end

function loadConfig()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then
        error("File functions are not available (readfile/isfile)")
    end

    local path = getConfigPath()
    if not isfile(path) then
        error("Config file not found")
    end

    local data = readfile(path)
    local loadedSettings = HttpService:JSONDecode(data)
    for category, options in pairs(loadedSettings) do
        if type(options) == "table" and settings[category] then
            for option, value in pairs(options) do
                if settings[category][option] ~= nil then
                    settings[category][option] = value
                end
            end
        end
    end

    -- После загрузки конфигурации обновляем визуальное состояние GUI
    if refreshTogglesFromSettings then
        pcall(refreshTogglesFromSettings)
    end
    if applyTheme then
        pcall(applyTheme)
    end
    if applyVisualColor then
        pcall(applyVisualColor)
    end
end

function deleteConfig()
    if typeof(delfile) ~= "function" or typeof(isfile) ~= "function" then
        error("File functions are not available (delfile/isfile)")
    end

    local path = getConfigPath()
    if isfile(path) then
        delfile(path)
    else
        error("Config file not found")
    end
end

function resetConfigToDefaults()
    -- Минимальный сброс в дефолтное состояние
    settings.esp.enabled = false
    settings.aimbot.enabled = false
    settings.movement.fly = false
    settings.visuals.watermark = true
end

-- Fly функция (исправленная)
local flyBodyVelocity
local flyConnection

toggleFly = function()
    if settings.movement.fly then
        if flyConnection then return end -- Уже запущено
        
        flyConnection = runService.Heartbeat:Connect(function()
            if not settings.movement.fly then
                if flyConnection then
                    flyConnection:Disconnect()
                    flyConnection = nil
                end
                if flyBodyVelocity then
                    flyBodyVelocity:Destroy()
                    flyBodyVelocity = nil
                end
                return
            end
            
            local character = localPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local rootPart = character.HumanoidRootPart
            
            -- Создаем или обновляем BodyVelocity
            if not flyBodyVelocity or not flyBodyVelocity.Parent then
                if flyBodyVelocity then flyBodyVelocity:Destroy() end
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                flyBodyVelocity.Parent = rootPart
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
            if uis:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, settings.movement.flySpeed, 0)
            end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVector = moveVector - Vector3.new(0, settings.movement.flySpeed, 0)
            end
            
            flyBodyVelocity.Velocity = moveVector
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
    end
end

-- Platform Fly (платформа под игроком)
local platformPart
local platformConnection

togglePlatformFly = function()
    if settings.movement.platformFly then
        if platformConnection then return end

        platformConnection = runService.Heartbeat:Connect(function(dt)
            if not settings.movement.platformFly then
                if platformConnection then
                    platformConnection:Disconnect()
                    platformConnection = nil
                end
                if platformPart then
                    platformPart:Destroy()
                    platformPart = nil
                end
                return
            end

            local character = localPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end

            local rootPart = character.HumanoidRootPart

            if not platformPart or not platformPart.Parent then
                if platformPart then platformPart:Destroy() end
                platformPart = Instance.new("Part")
                platformPart.Name = "PlatformFlyPart"
                platformPart.Anchored = true
                platformPart.CanCollide = true
                platformPart.Size = Vector3.new(6, 1, 6)
                platformPart.Material = Enum.Material.Neon
                platformPart.Color = Color3.fromRGB(255, 200, 0)
                platformPart.Parent = workspace
            end

            local speed = settings.movement.platformFlySpeed or 20
            local offsetY = 0
            if uis:IsKeyDown(Enum.KeyCode.Space) then
                offsetY = offsetY + speed * dt
            end
            if uis:IsKeyDown(Enum.KeyCode.LeftControl) then
                offsetY = offsetY - speed * dt
            end

            local basePos = rootPart.Position - Vector3.new(0, 3, 0)
            platformPart.CFrame = CFrame.new(basePos + Vector3.new(0, offsetY, 0))
        end)
    else
        if platformConnection then
            platformConnection:Disconnect()
            platformConnection = nil
        end
        if platformPart then
            platformPart:Destroy()
            platformPart = nil
        end
    end
end

-- Авто-включение при респавне
localPlayer.CharacterAdded:Connect(function()
    if settings.movement.fly then
        wait(1)
        toggleFly()
    end
end)

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

-- Head Hitbox функция (исправленная)
local headHitboxConnection
local originalHeadSizes = {}

toggleHeadHitbox = function()
    if settings.visuals.headHitbox then
        if headHitboxConnection then return end
        
        headHitboxConnection = runService.Heartbeat:Connect(function()
            if not settings.visuals.headHitbox then
                if headHitboxConnection then
                    headHitboxConnection:Disconnect()
                    headHitboxConnection = nil
                end
                -- Восстанавливаем размеры
                for player, originalSize in pairs(originalHeadSizes) do
                    if player.Character and player.Character:FindFirstChild("Head") then
                        local head = player.Character.Head
                        head.Size = originalSize
                        head.Transparency = 0
                        head.Material = Enum.Material.Plastic
                        head.CanCollide = true
                    end
                end
                originalHeadSizes = {}
                return
            end
            
            for _, player in pairs(players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local head = player.Character.Head
                    if not originalHeadSizes[player] then
                        originalHeadSizes[player] = head.Size
                    end
                    local size = settings.visuals.headHitboxSize or 5
                    head.Size = Vector3.new(size, size, size)
                    head.Transparency = 0.5
                    head.Material = Enum.Material.ForceField
                    head.CanCollide = false
                end
            end
        end)
    else
        if headHitboxConnection then
            headHitboxConnection:Disconnect()
            headHitboxConnection = nil
        end
        -- Восстанавливаем размеры
        for player, originalSize in pairs(originalHeadSizes) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                head.Size = originalSize
                head.Transparency = 0
                head.Material = Enum.Material.Plastic
                head.CanCollide = true
            end
        end
        originalHeadSizes = {}
    end
end

-- NoClip функция (исправленная)
local noClipConnection

toggleNoClip = function()
    if settings.movement.noClip then
        if noClipConnection then return end
        
        noClipConnection = runService.Stepped:Connect(function()
            if not settings.movement.noClip then
                if noClipConnection then
                    noClipConnection:Disconnect()
                    noClipConnection = nil
                end
                return
            end
            
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

-- Следим за респавном персонажа
localPlayer.CharacterAdded:Connect(function()
    if settings.movement.noClip then
        wait(1)
        toggleNoClip()
    end
end)

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
updateSky = function()
    if settings.visuals.skyColor then
        local preset = settings.visuals.skyPreset or "Default"
        local color = settings.visuals.skyColorValue
        if preset == "Pink" then
            color = Color3.fromRGB(255, 105, 180)
        elseif preset == "Red" then
            color = Color3.fromRGB(255, 60, 60)
        elseif preset == "White" then
            color = Color3.fromRGB(245, 245, 245)
        elseif preset == "Blue" then
            color = Color3.fromRGB(0, 150, 255)
        elseif preset == "Green" then
            color = Color3.fromRGB(0, 200, 120)
        elseif preset == "Purple" then
            color = Color3.fromRGB(180, 0, 255)
        end
        settings.visuals.skyColorValue = color

        -- Ищем/создаем Atmosphere и меняем только небо
        local atmosphere = lighting:FindFirstChildOfClass("Atmosphere")
        if not atmosphere then
            atmosphere = Instance.new("Atmosphere")
            atmosphere.Name = "CustomSkyAtmosphere"
            atmosphere.Parent = lighting
        end
        atmosphere.Color = color
        atmosphere.Decay = color
        atmosphere.Density = 0.4
        atmosphere.Offset = 0.25
        atmosphere.Glare = 0
        atmosphere.Haze = 1
    else
        local atmosphere = lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere and atmosphere.Name == "CustomSkyAtmosphere" then
            atmosphere:Destroy()
        end
    end
end

-- Spider функция (исправленная)
local spiderConnection

toggleSpider = function()
    if settings.movement.spider then
        if spiderConnection then return end
        
        spiderConnection = runService.Stepped:Connect(function()
            if not settings.movement.spider then
                if spiderConnection then
                    spiderConnection:Disconnect()
                    spiderConnection = nil
                end
                return
            end
            
            local character = localPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid then return end

                -- Проверяем стены вокруг
                local rayOrigin = root.Position
                local directions = {
                    root.CFrame.LookVector * 3,
                    root.CFrame.RightVector * 3,
                    -root.CFrame.RightVector * 3
                }

                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {character}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                for _, direction in ipairs(directions) do
                    local raycastResult = workspace:Raycast(rayOrigin, direction, raycastParams)
                    if raycastResult then
                        -- Если нашли стену — двигаем вверх
                        root.Velocity = Vector3.new(root.Velocity.X, 30, root.Velocity.Z)
                        break
                    end
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

-- Следим за респавном
localPlayer.CharacterAdded:Connect(function()
    if settings.movement.spider then
        wait(1)
        toggleSpider()
    end
end)

-- FOV Changer функция
updateFOV = function()
    if settings.visuals.fovChanger then
        camera.FieldOfView = settings.visuals.customFOV
    else
        camera.FieldOfView = 70
    end
end


-- Обновление водяного знака (защита от nil и без watermarkText)
local function updateWatermark()
    if not settings.visuals.watermark then return end
    if not watermarkInfo then return end

    -- Здесь можно было бы обновлять текст, но фактическое обновление
    -- уже делается в рендере выше (RunService.RenderStepped),
    -- поэтому функция оставлена пустой, чтобы не ломать логику.
end

-- Открытие/закрытие меню (объединенное)
uis.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.Insert then
            mainFrame.Visible = not mainFrame.Visible
            -- Эффект размытия при открытии/закрытии меню
            if mainFrame.Visible then
                game:GetService("TweenService"):Create(
                    blurEffect,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = 10}
                ):Play()
            else
                game:GetService("TweenService"):Create(
                    blurEffect,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = 0}
                ):Play()
            end
        -- Бинды удалены - функции работают только через меню
        end
    end
end)

local invisCharacter
local invisHumanoid
local invisRoot
local invisible = false
local invisibleParts = {}
local invisibleConnections = {}

local function initInvisibleCharacter()
    invisCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    invisHumanoid = invisCharacter:WaitForChild("Humanoid")
    invisRoot = invisCharacter:WaitForChild("HumanoidRootPart")
    invisibleParts = {}
    for _, desc in pairs(invisCharacter:GetDescendants()) do
        if desc:IsA("BasePart") and desc.Transparency == 0 then
            table.insert(invisibleParts, desc)
        end
    end
end

local function applyInvisibleTransparency()
    for _, part in pairs(invisibleParts) do
        part.Transparency = invisible and 0.5 or 0
    end
end

function SetInvisible(state)
    invisible = state and true or false
    if not invisCharacter or not invisHumanoid or not invisRoot then
        if localPlayer.Character then
            initInvisibleCharacter()
        end
    end
    applyInvisibleTransparency()
end

if localPlayer.Character then
    initInvisibleCharacter()
end

table.insert(invisibleConnections, runService.Heartbeat:Connect(function()
    if invisible and invisRoot and invisHumanoid then
        local oldCFrame = invisRoot.CFrame
        local oldOffset = invisHumanoid.CameraOffset
        local newCFrame = oldCFrame * CFrame.new(0, -200000, 0)
        invisRoot.CFrame = newCFrame
        invisHumanoid.CameraOffset = newCFrame:ToObjectSpace(CFrame.new(oldCFrame.Position)).Position
        runService.RenderStepped:Wait()
        invisRoot.CFrame = oldCFrame
        invisHumanoid.CameraOffset = oldOffset
    end
end))

table.insert(invisibleConnections, localPlayer.CharacterAdded:Connect(function()
    invisible = false
    initInvisibleCharacter()
    applyInvisibleTransparency()
end))

-- Silent Aim V2 (Raycast hook)
do
	if hookmetamethod and getnamecallmethod and newcclosure and checkcaller then
		local oldNamecall
		local function getClosestHitPart()
			local bestPart = nil
			local bestDist = math.huge
			local camPos = camera.CFrame.Position
			local mousePos = uis:GetMouseLocation()
			for _, plr in ipairs(players:GetPlayers()) do
				if plr == localPlayer then continue end
				local char = plr.Character
				if not char then continue end
				if settings.aimbot.teamCheck and localPlayer.Team and plr.Team and localPlayer.Team == plr.Team then
					continue
				end
				local hum = char:FindFirstChildOfClass("Humanoid")
				local part = char:FindFirstChild(settings.aimbot.targetPart or "Head")
				if not hum or hum.Health <= 0 or not part then continue end
				if settings.aimbot.visibleCheck and not isTargetVisible(part) then continue end
				local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
				if not onScreen or screenPos.Z <= 0 then continue end
				local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
				local maxFov = (settings.aimbot.fov or 90) * 10
				if dist < bestDist and dist <= maxFov then
					bestDist = dist
					bestPart = part
				end
			end
			return bestPart
		end

		local function getDirection(origin, targetPos)
			return (targetPos - origin).Unit * 1000
		end

		oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
			local args = {...}
			local self = args[1]
			local method = getnamecallmethod()
			local enabled = settings.aimbot.enabled
			local mode = settings.aimbot.aimMode
			local chance = settings.aimbot.hitChance or 100
			if enabled
				and mode == "silent_v2"
				and self == workspace
				and not checkcaller()
				and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
			then
				if chance < 100 and math.random(1, 100) > chance then
					return oldNamecall(...)
				end
				if method == "Raycast" and typeof(args[2]) == "Vector3" and typeof(args[3]) == "Vector3" then
					local origin = args[2]
					local hitPart = getClosestHitPart()
					if hitPart then
						local targetPos = hitPart.Position
						local pred = settings.aimbot.prediction or 0
						local vel = hitPart.AssemblyLinearVelocity
						targetPos = targetPos + (vel * pred)
						args[3] = getDirection(origin, targetPos)
						return oldNamecall(unpack(args))
					end
				end
			end
			return oldNamecall(...)
		end))
	end
end

-- Silent Aim V2 (Raycast hook)
do
    if hookmetamethod and getnamecallmethod and newcclosure and checkcaller then
        local oldNamecall

        -- выбор цели по FOV (как сейчас)
        local function getClosestHitPartFOV()
            local bestPart = nil
            local bestDist = math.huge
            local mousePos = uis:GetMouseLocation()

            for _, plr in ipairs(players:GetPlayers()) do
                if plr == localPlayer then continue end
                local char = plr.Character
                if not char then continue end

                if settings.aimbot.teamCheck and localPlayer.Team and plr.Team and localPlayer.Team == plr.Team then
                    continue
                end

                local hum = char:FindFirstChildOfClass("Humanoid")
                local part = char:FindFirstChild(settings.aimbot.targetPart or "Head")
                if not hum or hum.Health <= 0 or not part then continue end

                if settings.aimbot.visibleCheck and not isTargetVisible(part) then continue end

                local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                if not onScreen or screenPos.Z <= 0 then continue end

                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                local maxFov = (settings.aimbot.fov or 90) * 10
                if dist < bestDist and dist <= maxFov then
                    bestDist = dist
                    bestPart = part
                end
            end

            return bestPart
        end

        -- выбор цели по минимальной дистанции (silent_v3)
        local function getClosestHitPartDistance()
            local bestPart = nil
            local bestDist = math.huge

            local localChar = localPlayer.Character
            local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
            if not localRoot then return nil end

            for _, plr in ipairs(players:GetPlayers()) do
                if plr == localPlayer then continue end
                local char = plr.Character
                if not char then continue end

                if settings.aimbot.teamCheck and localPlayer.Team and plr.Team and localPlayer.Team == plr.Team then
                    continue
                end

                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                local part = char:FindFirstChild(settings.aimbot.targetPart or "Head")
                if not hum or hum.Health <= 0 or not root or not part then continue end

                if settings.aimbot.visibleCheck and not isTargetVisible(part) then continue end

                local distance = (root.Position - localRoot.Position).Magnitude
                if distance < bestDist then
                    bestDist = distance
                    bestPart = part
                end
            end

            return bestPart
        end

        local function getDirection(origin, targetPos)
            return (targetPos - origin).Unit * 1000
        end

        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
            local args = {...}
            local self = args[1]
            local method = getnamecallmethod()

            local enabled = settings.aimbot.enabled
            local mode = settings.aimbot.aimMode
            local chance = settings.aimbot.hitChance or 100

            if enabled
                and (mode == "silent_v2" or mode == "silent_v3")
                and self == workspace
                and not checkcaller()
                and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
            then
                if chance < 100 and math.random(1, 100) > chance then
                    return oldNamecall(...)
                end

                if method == "Raycast" and typeof(args[2]) == "Vector3" and typeof(args[3]) == "Vector3" then
                    local origin = args[2]

                    local hitPart
                    if mode == "silent_v3" then
                        hitPart = getClosestHitPartDistance()
                    else
                        hitPart = getClosestHitPartFOV()
                    end

    if hitPart then
        local targetPos = hitPart.Position
        local pred = settings.aimbot.prediction or 0
        local vel = hitPart.AssemblyLinearVelocity
        targetPos = targetPos + (vel * pred)

        -- если включён silent_v3, поворачиваем трасер оружия на цель
        if mode == "silent_v3" then
            local char = localPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local rayPart = tool:FindFirstChild("RayPart")
                        or tool:FindFirstChild("reypart")
                        or tool:FindFirstChild("Raypart")
                    if rayPart and rayPart:IsA("BasePart") then
                        rayPart.CFrame = CFrame.new(rayPart.Position, targetPos)
                    end
                end
            end
        end

        args[3] = getDirection(origin, targetPos)
        return oldNamecall(unpack(args))
    end
                end
            end

            return oldNamecall(...)
        end))
    end
end

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
-- Применяем тему после создания всех элементов (исправлено)
spawn(function()
    wait(0.1) -- Небольшая задержка для создания всех элементов
    applyTheme()
end)
updateSky()
updateFOV()

getgenv().meowguy = {
    Prediction = 0.165, -- Adjust prediction as you want
    FOVSize = 360, -- Minimum is 60-150
    FOVTransparency = 0.2, -- Adjust to 0 if you want it streamable
    ShowLine = false, -- Set to true or false; now it's fully streamable
    HitPart = "UpperTorso",
    AutoAirHitPart = "UpperTorso",
    JumpOffset = 2.0, -- Example offset for jumping
    FallOffset = -2.0, -- Example offset for falling
    MacroPrediction = 0.32
}
