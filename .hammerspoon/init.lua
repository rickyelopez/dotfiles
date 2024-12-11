-- local bootstrap = require("bootstrap")

-- bootstrap()
hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.use_syncinstall = true
spoon.SpoonInstall:andUse("MouseFollowsFocus", { start = true })
