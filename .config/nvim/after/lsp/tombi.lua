return {
  settings = {
    tombi = {
      schemas = {
        {
          root = "tool.pyright",
          path = "https://raw.githubusercontent.com/DetachHead/basedpyright/refs/heads/main/packages/vscode-pyright/schemas/pyrightconfig.schema.json",
          include = { "pyproject.toml" },
        },
      },
    },
  },
}
