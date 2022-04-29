local server = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.path"
local Data = require "nvim-lsp-installer.data"
local platform = require "nvim-lsp-installer.platform"
local shell = require "nvim-lsp-installer.installers.shell"
local std = require "nvim-lsp-installer.core.managers.std"
local coalesce, when = Data.coalesce, Data.when

return function(name, root_dir)
  return server.Server:new {
    name = name,
    root_dir = root_dir,
    installer = function()
      std.ensure_executable("odin", { help_url = "https://odin-lang.org" })
      local command = coalesce(
        when(
          platform.is_linux,
          coalesce("git clone --depth 1 https://github.com/DanielGavin/ols.git . && build.sh")
        ),
        when(
          platform.is_win,
          coalesce("git clone --depth 1 https://github.com/DanielGavin/ols.git . && build.bat")
        )
      )
      when(platform.is_win, shell.cmd(command))
      when(platform.is_linux, shell.bash(command))
    end,
    default_options = {
      cmd = { path.concat { root_dir, "ols" }, },
    },
  }

end
