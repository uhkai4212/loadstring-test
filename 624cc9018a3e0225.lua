loadstring(game:HttpGet("https://raw.githubusercontent.com/DeterDsl/Spacey-xploits/refs/heads/main/Spacey%20RedzLib.txt"))()

MakeWindow({
  Hub = {
    Title = "SHNMAXHUB | BROOKHAVEN RP",
    Animation = "By : Shelby"
  },
    Key = {
    KeySystem = false,
    Title = "Key System",
    Description = "Wolfpaq",
    KeyLink = "Wolfpaq",
    Keys = {"Wolfpaq"},
    Notifi = {
      Notifications = true,
      CorrectKey = "Running the Script...",
      Incorrectkey = "The key is incorrect",
      CopyKeyLink = "Copied to Clipboard"
    }
  }
})

MinimizeButton({
  Image = "rbxassetid://17802167990",
  Size = {42, 42},
  Color = Color3.fromRGB(0, 0, 0),
  Corner = true,
  Stroke = true,
  StrokeColor = Color3.fromRGB(255, 255, 255)
})

-- ID do som a ser reproduzido quando o código for executado
local soundId = "rbxassetid://1836973601"

-- Função para tocar o som
local function playSound()
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Parent = game.Workspace -- Coloque no Workspace para garantir que seja ouvido
    sound:Play()
end