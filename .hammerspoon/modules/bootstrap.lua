local spoonInstallZip = "SpoonInstall.spoon.zip";
local spoonDir = "~/.hammerspoon/Spoons"
local spoonInstallUrl = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/" .. spoonInstallZip
local installerZipPath = hs.fs.temporaryDirectory() .. spoonInstallZip
local spoonInstall = spoonDir .. "SpoonInstall.spoon"

return function()
  local exists, _ = hs.fs.touch(spoonInstall)
  if exists then
    -- print("Spoon installer exits.  No bootstrap required.")
    return
  end

  print("Initializing spoon installer")
  hs.execute("curl --location -vvv -o " .. installerZipPath .. " " .. spoonInstallUrl)
  hs.fs.mkdir(spoonDir)
  hs.fs.chdir(spoonDir)
  hs.execute("unzip -d " .. spoonDir .. " " .. installerZipPath)
end
