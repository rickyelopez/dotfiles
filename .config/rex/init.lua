local rex = rex

-- tabs
rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>n", "client.tab.next")
rex.bind("ctrl+a>p", "client.tab.previous")
rex.bind("ctrl+a>,", "client.tab.rename")

-- panes
rex.bind("ctrl+a>shift+\\", "pane.split", { direction = "right" })
rex.bind("ctrl+a>-", "pane.split", { direction = "down" })
rex.bind("ctrl+a>z", "pane.zoom")
rex.bind("ctrl+a>x", "pane.close")

rex.bind("ctrl+a>l", "pane.focus.right")
rex.bind("ctrl+a>h", "pane.focus.left")
rex.bind("ctrl+a>j", "pane.focus.down")
rex.bind("ctrl+a>k", "pane.focus.up")


-- session
rex.bind("ctrl+a>s", "session.switch")
rex.bind("ctrl+a>shift+4", "session.rename")

-- misc
rex.bind("ctrl+a>r", "client.config.reload")
rex.bind("ctrl+a>shift+;", "client.palette.toggle")

-- Press Ctrl+A twice to send one to the terminal
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+b" })
