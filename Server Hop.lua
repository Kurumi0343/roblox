repeat wait() until game:IsLoaded()

local localPlayer = game.Players.LocalPlayer

            localPlayer.Character.Humanoid.Sit = false
            local tweenInfo = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
            local tweenService = game:GetService("TweenService"):Create(localPlayer.Character.HumanoidRootPart, tweenInfo, {CFrame = localPlayer.Character.HumanoidRootPart.CFrame})
            tweenService:Play()

            localPlayer.Character.Humanoid.Sit = false
            tweenInfo = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
            tweenService = game:GetService("TweenService"):Create(localPlayer.Character.HumanoidRootPart, tweenInfo, {CFrame = localPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,99999,0)})
            tweenService:Play()

local Settings = {}
local HttpService = game:GetService("HttpService")

local SaveFileName = "ThreadReaper Server Hop.json"

function SaveSettings()
  local HttpService = game:GetService("HttpService")
  if not isfolder("ThreadReaper") then
      makefolder("ThreadReaper")
  end
  writefile("ThreadReaper/" .. SaveFileName, HttpService:JSONEncode(Settings))
end

function ReadSetting()
  local s,e = pcall(function()
      local HttpService = game:GetService("HttpService")
      if not isfolder("Sea Hub") then
          makefolder("Sea Hub")
      end
      return HttpService:JSONDecode(readfile("ThreadReaper/" .. SaveFileName))
  end)
  if s then return e
  else
      SaveSettings()
      return ReadSetting()
  end
end
Settings = ReadSetting()

function HopServer()
  local function Hop()
      for i=1,100 do
          local huhu = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(i)
          for k,v in pairs(huhu) do
              if k~=game.JobId and v.Count < 10 then
                  if not Settings[k] or tick() - Settings[k].Time > 60*10  then
                       Settings[k] = {
                           Time = tick()
                       }
                       SaveSettings()
                      game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport",k)
                      return true
                  elseif tick() - Settings[k].Time > 60*60 then
                      Settings[k] = nil
                  end
              end
          end
      end
      return false
  end
  if not getgenv().Loaded then
      local function child(v)
          if v.Name == "ErrorPrompt" then
              if v.Visible then
                  if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                      HopServer()
                  end
              end
              v:GetPropertyChangedSignal("Visible"):Connect(function()
                  if v.Visible then
                      if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                          HopServer()
                      end
                  end
              end)
          end
      end
      for k,v in pairs(game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren()) do
          child(v)
      end
      game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(child)
      getgenv().Loaded = true
  end
  while not Hop() do wait() end
  SaveSettings()
end
HopServer()
