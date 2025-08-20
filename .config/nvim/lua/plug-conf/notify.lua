return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")
    ---@diagnostic disable-next-line: missing-fields
    notify.setup({
      -- Animation style
      stages = "fade_in_slide_out",
      -- Default timeout for notifications
      timeout = 1500,
      background_colour = "#2E3440",
    })
  end,
}
