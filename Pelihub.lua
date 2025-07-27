local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()

-- ✅ GUI Setup
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "FarelHubGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 400)
frame.Position = UDim2.new(0.5, -125, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local UIList = Instance.new("UIListLayout", frame)
UIList.Padding = UDim.new(0, 8)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Center

local function createBtn(text, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.8, 0, 0, 40)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
end

-- 🛠 FUNCTION ZONE ---------------------

local function flyMe()
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local bv = Instance.new("BodyVelocity", hrp)
	bv.Velocity = Vector3.new(0, 50, 0)
	bv.MaxForce = Vector3.new(1, 1, 1) * math.huge
end

local function bigHitbox()
	for _,v in pairs(Players:GetPlayers()) do
		if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = v.Character.HumanoidRootPart
			hrp.Size = Vector3.new(10,10,10)
			hrp.Transparency = 0.5
			hrp.CanCollide = false
		end
	end
end

local function makeESP()
	for _,v in pairs(Players:GetPlayers()) do
		if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and not v.Character.Head:FindFirstChild("FarelESP") then
			local esp = Instance.new("BillboardGui", v.Character.Head)
			esp.Name = "FarelESP"
			esp.Size = UDim2.new(0,100,0,40)
			esp.AlwaysOnTop = true
			local txt = Instance.new("TextLabel", esp)
			txt.Text = v.Name
			txt.Size = UDim2.new(1,0,1,0)
			txt.BackgroundTransparency = 1
			txt.TextColor3 = Color3.new(1,0,0)
			txt.TextStrokeTransparency = 0
		end
	end
end

local function noclip()
	RunService.Stepped:Connect(function()
		if lp.Character then
			for _, part in pairs(lp.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end)
end

local aimbotActive = false
local function toggleAimbot()
	aimbotActive = not aimbotActive
	if aimbotActive then
		RunService.RenderStepped:Connect(function()
			if not aimbotActive then return end
			local closest, dist = nil, math.huge
			for _,v in pairs(Players:GetPlayers()) do
				if v ~= lp and v.Character and v.Character:FindFirstChild("Head") then
					local headPos = workspace.CurrentCamera:WorldToScreenPoint(v.Character.Head.Position)
					local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(headPos.X, headPos.Y)).Magnitude
					if distance < dist then
						dist = distance
						closest = v
					end
				end
			end
			if closest and closest.Character and closest.Character:FindFirstChild("Head") then
				workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Character.Head.Position)
			end
		end)
	end
end

local function speedBoost()
	if lp.Character and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid.WalkSpeed = 100
	end
end

-- 🔘 TOMBOL GUI
createBtn("FLY", flyMe)
createBtn("ESP", makeESP)
createBtn("BIG HITBOX", bigHitbox)
createBtn("NOCLIP", noclip)
createBtn("AIMBOT", toggleAimbot)
createBtn("SPEED x10", speedBoost)

print("✅ FarelHub v2.0 Loaded!")
