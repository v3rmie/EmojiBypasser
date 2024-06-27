if _G.UILIBLOADED then
	error("The script is already loaded! Press the exit button if you want to execute the script again.")
end

_G.UILIBLOADED = true

-- Services

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Variables

local plr = Players.LocalPlayer
local mouse = plr:GetMouse()
local viewport = workspace.CurrentCamera.ViewportSize
local tweenInfo = TweenInfo.new(.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

local Library = {}

function Library:validate(defaults, options)
	options = options or {}
	for i, v in pairs(defaults) do
		if options[i] == nil then
			options[i] = v
		end
	end
	return options
end

function Library:tween(object, goal, callback)
	local tween = TweenService:Create(object, tweenInfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end

function Library:new(options)
	options = Library:validate({
		name = "UI Library"
	}, options or {})

	local GUI = {
		Dragging = false,
		DragInput = nil,
		DragStart = nil,
		StartPos = nil,
		Hover = false,
		MouseDown = false
	}
	
	-- Main UI
	do
		GUI["MainSGUI"] = Instance.new("ScreenGui")
		GUI["MainSGUI"].Name = string.gsub(game:GetService("HttpService"):GenerateGUID(), "[{}-]", "") or "MainGui"
		GUI["MainSGUI"].ZIndexBehavior = Enum.ZIndexBehavior.Global
		GUI["MainSGUI"].IgnoreGuiInset = true
		GUI["MainSGUI"].DisplayOrder = 10
		GUI["MainSGUI"].Parent = gethui and gethui() or (RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
		
		GUI["MainFrame"] = Instance.new("Frame")
		GUI["MainFrame"].BorderSizePixel = 0
		GUI["MainFrame"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["MainFrame"].AnchorPoint = Vector2.new(0.5, 0.5)
		GUI["MainFrame"].Size = UDim2.new(0, 450, 0, 300)
		GUI["MainFrame"].Position = UDim2.new(0.5, 0, 0.5, 0)
		GUI["MainFrame"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["MainFrame"].Name = "Main"
		GUI["MainFrame"].BackgroundTransparency = 1
		GUI["MainFrame"].ClipsDescendants = true
		GUI["MainFrame"].Parent = GUI["MainSGUI"]

		GUI["TopBar"] = Instance.new("Frame")
		GUI["TopBar"].BorderSizePixel = 0
		GUI["TopBar"].BackgroundColor3 = Color3.fromRGB(52, 52, 52)
		GUI["TopBar"].Size = UDim2.new(1, 0, 0, 20)
		GUI["TopBar"].Position = UDim2.new(0, 0, 0, 300)
		GUI["TopBar"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["TopBar"].Name = "TopBar"
		GUI["TopBar"].Parent = GUI["MainFrame"]

		GUI["CloseButton"] = Instance.new("TextButton")
		GUI["CloseButton"].BorderSizePixel = 0
		GUI["CloseButton"].AutoButtonColor = false
		GUI["CloseButton"].TextSize = 14
		GUI["CloseButton"].TextColor3 = Color3.fromRGB(0, 0, 0)
		GUI["CloseButton"].BackgroundColor3 = Color3.fromRGB(32, 32, 32)
		GUI["CloseButton"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		GUI["CloseButton"].Size = UDim2.new(0, 16, 0, 16)
		GUI["CloseButton"].BackgroundTransparency = 1
		GUI["CloseButton"].Name = "Close"
		GUI["CloseButton"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["CloseButton"].Text = ""
		GUI["CloseButton"].Position = UDim2.new(1, -18, 0, 2)
		GUI["CloseButton"].Parent = GUI["TopBar"]

		GUI["CloseCorner"] = Instance.new("UICorner")
		GUI["CloseCorner"].CornerRadius = UDim.new(0, 4)
		GUI["CloseCorner"].Parent = GUI["CloseButton"]

		GUI["CloseImage"] = Instance.new("ImageLabel")
		GUI["CloseImage"].BorderSizePixel = 0
		GUI["CloseImage"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["CloseImage"].Image = "rbxassetid://5054663650"
		GUI["CloseImage"].Size = UDim2.new(0, 10, 0, 10)
		GUI["CloseImage"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["CloseImage"].BackgroundTransparency = 1
		GUI["CloseImage"].Position = UDim2.new(0, 3, 0, 3)
		GUI["CloseImage"].Parent = GUI["CloseButton"]

		GUI["TopBarTitle"] = Instance.new("TextLabel")
		GUI["TopBarTitle"].BorderSizePixel = 0
		GUI["TopBarTitle"].TextXAlignment = Enum.TextXAlignment.Left
		GUI["TopBarTitle"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["TopBarTitle"].TextSize = 14
		GUI["TopBarTitle"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		GUI["TopBarTitle"].TextColor3 = Color3.fromRGB(255, 255, 255)
		GUI["TopBarTitle"].BackgroundTransparency = 1
		GUI["TopBarTitle"].Size = UDim2.new(1, -10, 0, 20)
		GUI["TopBarTitle"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["TopBarTitle"].Text = options.name
		GUI["TopBarTitle"].Name = "Title"
		GUI["TopBarTitle"].Position = UDim2.new(0, 5, 0, 0)
		GUI["TopBarTitle"].Parent = GUI["TopBar"]

		GUI["ContentContainer"] = Instance.new("Frame")
		GUI["ContentContainer"].BorderSizePixel = 0
		GUI["ContentContainer"].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		GUI["ContentContainer"].Size = UDim2.new(1, 0, 1, -20)
		GUI["ContentContainer"].Position = UDim2.new(0, 0, 0, 320)
		GUI["ContentContainer"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ContentContainer"].Name = "Content"
		GUI["ContentContainer"].Parent = GUI["MainFrame"]

		GUI["LineBorder"] = Instance.new("Frame")
		GUI["LineBorder"].BorderSizePixel = 0
		GUI["LineBorder"].BackgroundColor3 = Color3.fromRGB(33, 33, 33)
		GUI["LineBorder"].Size = UDim2.new(1, 0, 0, 1)
		GUI["LineBorder"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["LineBorder"].Name = "Line"
		GUI["LineBorder"].Parent = GUI["ContentContainer"]

		GUI["ContentList"] = Instance.new("ScrollingFrame")
		GUI["ContentList"].Active = true
		GUI["ContentList"].ScrollingDirection = Enum.ScrollingDirection.Y
		GUI["ContentList"].ZIndex = 2
		GUI["ContentList"].BorderSizePixel = 0
		GUI["ContentList"].TopImage = ""
		GUI["ContentList"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["ContentList"].Name = "List"
		GUI["ContentList"].BottomImage = ""
		GUI["ContentList"].Size = UDim2.new(1, 0, 1, 0)
		GUI["ContentList"].ScrollBarImageColor3 = Color3.fromRGB(61, 61, 61)
		GUI["ContentList"].Position = UDim2.new(0, 0, 0, 1)
		GUI["ContentList"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ContentList"].ScrollBarThickness = 16
		GUI["ContentList"].BackgroundTransparency = 1
		GUI["ContentList"].Parent = GUI["ContentContainer"]
		
		GUI["ListPadding"] = Instance.new("UIPadding")
		GUI["ListPadding"].PaddingTop = UDim.new(0, 4)
		GUI["ListPadding"].PaddingRight = UDim.new(0, 4)
		GUI["ListPadding"].PaddingLeft = UDim.new(0, 4)
		GUI["ListPadding"].PaddingBottom = UDim.new(0, 4)
		GUI["ListPadding"].Parent = GUI["ContentList"]

		GUI["UILayout"] = Instance.new("UIListLayout")
		GUI["UILayout"].Padding = UDim.new(0, 4)
		GUI["UILayout"].SortOrder = Enum.SortOrder.LayoutOrder
		GUI["UILayout"].Parent = GUI["ContentList"]

		GUI["ScrollBar"] = Instance.new("Frame")
		GUI["ScrollBar"].BorderSizePixel = 0
		GUI["ScrollBar"].BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		GUI["ScrollBar"].Size = UDim2.new(0, 16, 1, 0)
		GUI["ScrollBar"].Position = UDim2.new(1, -16, 0, 0)
		GUI["ScrollBar"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ScrollBar"].Name = "ScrollBar"
		GUI["ScrollBar"].Parent = GUI["ContentContainer"]

		GUI["ScrollBarUp"] = Instance.new("ImageButton")
		GUI["ScrollBarUp"].BorderSizePixel = 0
		GUI["ScrollBarUp"].AutoButtonColor = false
		GUI["ScrollBarUp"].BackgroundColor3 = Color3.fromRGB(75, 75, 75)
		GUI["ScrollBarUp"].Size = UDim2.new(0, 16, 0, 16)
		GUI["ScrollBarUp"].BackgroundTransparency = 1
		GUI["ScrollBarUp"].Name = "Up"
		GUI["ScrollBarUp"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ScrollBarUp"].Parent = GUI["ScrollBar"]

		GUI["ArrowUpContainer"] = Instance.new("Frame", GUI["ScrollBarUp"])
		GUI["ArrowUpContainer"].BorderSizePixel = 0
		GUI["ArrowUpContainer"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["ArrowUpContainer"].Size = UDim2.new(0, 16, 0, 16)
		GUI["ArrowUpContainer"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ArrowUpContainer"].Name = "Arrow"
		GUI["ArrowUpContainer"].BackgroundTransparency = 1

		GUI["ArrowUp1"] = Instance.new("Frame")
		GUI["ArrowUp1"].BorderSizePixel = 0
		GUI["ArrowUp1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["ArrowUp1"].Size = UDim2.new(0, 5, 0, 1)
		GUI["ArrowUp1"].Position = UDim2.new(0, 6, 0, 8)
		GUI["ArrowUp1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ArrowUp1"].Parent = GUI["ArrowUpContainer"]

		GUI["ArrowUp2"] = Instance.new("Frame")
		GUI["ArrowUp2"].BorderSizePixel = 0
		GUI["ArrowUp2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["ArrowUp2"].Size = UDim2.new(0, 3, 0, 1)
		GUI["ArrowUp2"].Position = UDim2.new(0, 7, 0, 7)
		GUI["ArrowUp2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ArrowUp2"].Parent = GUI["ArrowUpContainer"]

		GUI["ArrowUp3"] = Instance.new("Frame")
		GUI["ArrowUp3"].BorderSizePixel = 0
		GUI["ArrowUp3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["ArrowUp3"].Size = UDim2.new(0, 1, 0, 1)
		GUI["ArrowUp3"].Position = UDim2.new(0, 8, 0, 6)
		GUI["ArrowUp3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ArrowUp3"].Parent = GUI["ArrowUpContainer"]

		GUI["ArrowUp4"] = Instance.new("Frame")
		GUI["ArrowUp4"].BorderSizePixel = 0
		GUI["ArrowUp4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["ArrowUp4"].Size = UDim2.new(0, 7, 0, 1)
		GUI["ArrowUp4"].Position = UDim2.new(0, 5, 0, 9)
		GUI["ArrowUp4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ArrowUp4"].Parent = GUI["ArrowUpContainer"]

		GUI["ScrollBarDown"] = Instance.new("ImageButton")
		GUI["ScrollBarDown"].BorderSizePixel = 0
		GUI["ScrollBarDown"].AutoButtonColor = false
		GUI["ScrollBarDown"].BackgroundColor3 = Color3.fromRGB(75, 75, 75)
		GUI["ScrollBarDown"].Size = UDim2.new(0, 16, 0, 16)
		GUI["ScrollBarDown"].BackgroundTransparency = 1
		GUI["ScrollBarDown"].Name = "Down"
		GUI["ScrollBarDown"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ScrollBarDown"].Position = UDim2.new(0, 0, 1, -16)
		GUI["ScrollBarDown"].Parent = GUI["ScrollBar"]

		GUI["ArrowDownContainer"] = Instance.new("Frame")
		GUI["ArrowDownContainer"].BorderSizePixel = 0
		GUI["ArrowDownContainer"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["ArrowDownContainer"].Size = UDim2.new(0, 16, 0, 16)
		GUI["ArrowDownContainer"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ArrowDownContainer"].Name = "Arrow"
		GUI["ArrowDownContainer"].BackgroundTransparency = 1
		GUI["ArrowDownContainer"].Parent = GUI["ScrollBarDown"]

		GUI["ArrowDown1"] = Instance.new("Frame")
		GUI["ArrowDown1"].BorderSizePixel = 0
		GUI["ArrowDown1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["ArrowDown1"].Size = UDim2.new(0, 7, 0, 1)
		GUI["ArrowDown1"].Position = UDim2.new(0, 5, 0, 7)
		GUI["ArrowDown1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ArrowDown1"].Parent = GUI["ArrowDownContainer"]

		GUI["ArrowDown2"] = Instance.new("Frame")
		GUI["ArrowDown2"].BorderSizePixel = 0
		GUI["ArrowDown2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["ArrowDown2"].Size = UDim2.new(0, 5, 0, 1)
		GUI["ArrowDown2"].Position = UDim2.new(0, 6, 0, 8)
		GUI["ArrowDown2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ArrowDown2"].Parent = GUI["ArrowDownContainer"]

		GUI["ArrowDown3"] = Instance.new("Frame")
		GUI["ArrowDown3"].BorderSizePixel = 0
		GUI["ArrowDown3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["ArrowDown3"].Size = UDim2.new(0, 1, 0, 1)
		GUI["ArrowDown3"].Position = UDim2.new(0, 8, 0, 10)
		GUI["ArrowDown3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ArrowDown3"].Parent = GUI["ArrowDownContainer"]

		GUI["ArrowDown4"] = Instance.new("Frame")
		GUI["ArrowDown4"].BorderSizePixel = 0
		GUI["ArrowDown4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["ArrowDown4"].Size = UDim2.new(0, 3, 0, 1)
		GUI["ArrowDown4"].Position = UDim2.new(0, 7, 0, 9)
		GUI["ArrowDown4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["ArrowDown4"].Parent = GUI["ArrowDownContainer"]

		GUI["MainFrameOutline"] = Instance.new("ImageLabel")
		GUI["MainFrameOutline"].BorderSizePixel = 0
		GUI["MainFrameOutline"].SliceCenter = Rect.new(6, 6, 25, 25)
		GUI["MainFrameOutline"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GUI["MainFrameOutline"].ScaleType = Enum.ScaleType.Slice
		GUI["MainFrameOutline"].Image = "rbxassetid://1427967925"
		GUI["MainFrameOutline"].Size = UDim2.new(1, 10, 1, 10)
		GUI["MainFrameOutline"].BorderColor3 = Color3.fromRGB(0, 0, 0)
		GUI["MainFrameOutline"].BackgroundTransparency = 1
		GUI["MainFrameOutline"].Name = "Outlines"
		GUI["MainFrameOutline"].Position = UDim2.new(0, -5, 0, 305)
		GUI["MainFrameOutline"].Visible = false
		GUI["MainFrameOutline"].Parent = GUI["MainFrame"]
	end
	
	-- Dragging and Logic
	do
		-- Dragging
		do
			local function update(input)
				local delta = input.Position - GUI.DragStart
				GUI["MainFrame"].Position = UDim2.new(GUI.StartPos.X.Scale, GUI.StartPos.X.Offset + delta.X, GUI.StartPos.Y.Scale, GUI.StartPos.Y.Offset + delta.Y)
			end

			GUI["TopBar"].InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					GUI.Dragging = true
					GUI.DragStart = input.Position
					GUI.StartPos = GUI["MainFrame"].Position

					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							GUI.Dragging = false
						end
					end)
				end
			end)

			GUI["TopBar"].InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					GUI.DragInput = input
				end
			end)

			uis.InputChanged:Connect(function(input)
				if input == GUI.DragInput and GUI.Dragging then
					update(input)
				end
			end)
		end
		
		-- Exit Button Logic
		do
			GUI["CloseButton"].MouseEnter:Connect(function()
				GUI.Hover = true

				if not GUI.MouseDown then
					GUI["CloseButton"].BackgroundTransparency = 0.4
				end
			end)

			GUI["CloseButton"].MouseLeave:Connect(function()
				GUI.Hover = false

				if not GUI.MouseDown then
					GUI["CloseButton"].BackgroundTransparency = 1
				end
			end)
			
			uis.InputBegan:Connect(function(input)

				if input.UserInputType == Enum.UserInputType.MouseButton1 and GUI.Hover then
					GUI.MouseDown = true
					GUI["CloseButton"].BackgroundTransparency = 0
				end
			end)

			uis.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					GUI.MouseDown = false

					if GUI.Hover then
						GUI["CloseButton"].BackgroundTransparency = 0.4
						GUI["MainSGUI"]:Destroy()
						_G.UILIBLOADED = false
					else
						GUI["CloseButton"].BackgroundTransparency = 1
					end
				end
			end)
		end
		
		-- Intro Logic
		do
			task.spawn(function()
				Library:tween(GUI["ContentContainer"], {Position = UDim2.new(0, 0, 0, 20)})
				Library:tween(GUI["TopBar"], {Position = UDim2.new(0, 0, 0, 0)})
				Library:tween(GUI["MainFrameOutline"], {Position = UDim2.new(0, -5, 0, -5)})
				task.wait(1)
				GUI["MainFrame"].ClipsDescendants = false
				GUI["MainFrameOutline"].Visible = true
			end)
		end
	end
	
	function GUI:Button(options)
		options = Library:validate({
			name = "New Button",
			callback = function() end
		}, options or {})

		local Button = {
			Hover = false,
			MouseDown = false
		}
		
		-- Button UI
		do
			Button["MainContainer"] = Instance.new("TextLabel")
			Button["MainContainer"].BorderSizePixel = 0
			Button["MainContainer"].BackgroundColor3 = Color3.fromRGB(52, 52, 52)
			Button["MainContainer"].TextSize = 14
			Button["MainContainer"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			Button["MainContainer"].TextColor3 = Color3.fromRGB(0, 0, 0)
			Button["MainContainer"].Size = UDim2.new(1, -16, 0, 35)
			Button["MainContainer"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Button["MainContainer"].Text = ""
			Button["MainContainer"].Name = "Button"
			Button["MainContainer"].Parent = GUI["ContentList"]

			Button["ButtonText"] = Instance.new("TextLabel")
			Button["ButtonText"].BorderSizePixel = 0
			Button["ButtonText"].TextXAlignment = Enum.TextXAlignment.Left
			Button["ButtonText"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Button["ButtonText"].TextSize = 14
			Button["ButtonText"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			Button["ButtonText"].TextColor3 = Color3.fromRGB(255, 255, 255)
			Button["ButtonText"].BackgroundTransparency = 1
			Button["ButtonText"].Size = UDim2.new(1, -21, 1, 0)
			Button["ButtonText"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Button["ButtonText"].Text = options.name
			Button["ButtonText"].Position = UDim2.new(0, 20, 0, 0)
			Button["ButtonText"].Parent = Button["MainContainer"]
		end
		
		-- Methods
		function Button:Text(text)
			Button["ButtonText"].Text = text
			options.name = text
		end

		function Button:Callback(fn)
			options.callback = fn
		end
		
		-- Logic
		do
			Button["MainContainer"].MouseEnter:Connect(function()
				Button.Hover = true

				if not Button.MouseDown then
					Button["MainContainer"].BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				end
			end)

			Button["MainContainer"].MouseLeave:Connect(function()
				Button.Hover = false

				if not Button.MouseDown then
					Button["MainContainer"].BackgroundColor3 = Color3.fromRGB(52, 52, 52)
				end
			end)

			uis.InputBegan:Connect(function(input)

				if input.UserInputType == Enum.UserInputType.MouseButton1 and Button.Hover then
					Button.MouseDown = true
					options.callback()
				end
			end)

			uis.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Button.MouseDown = false

					if Button.Hover then
						
					else
						
					end
				end
			end)
		end
		
		return Button	
	end
	
	function GUI:Label(options)
		options = Library:validate({
			name = "New Label"
		}, options or {})

		local Label = {}

		-- Label UI
		do
			Label["Main"] = Instance.new("TextLabel")
			Label["Main"].BorderSizePixel = 0
			Label["Main"].TextXAlignment = Enum.TextXAlignment.Left
			Label["Main"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label["Main"].TextSize = 14
			Label["Main"].FontFace = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			Label["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)
			Label["Main"].BackgroundTransparency = 1
			Label["Main"].Size = UDim2.new(0, 200, 0, 20)
			Label["Main"].BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label["Main"].Text = options.name
			Label["Main"].Name = "Label"
			Label["Main"].Parent = GUI["ContentList"]
		end

		-- Methods
		function Label:Text(text)
			Label["Main"].Text = text
			options.name = text
		end

		return Label	
	end
	
	return GUI
end
return Library
