local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"
local servers = require "nvim-lsp-installer.servers"
local server = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.path"
local platform = require "nvim-lsp-installer.platform"
local shell = require "nvim-lsp-installer.installers.shell"
local std = require "nvim-lsp-installer.core.managers.std"

local server_name = "ols"

-- 1. (optional, only if lspconfig doesn't already support the server)
--    Create server entry in lspconfig
configs[server_name] = {
    default_config = {
        filetypes = { "odin" },
        root_dir = lspconfig.util.root_pattern ".git",
    },
}

local root_dir = server.get_server_root_path(server_name)

-- You may also use one of the prebuilt installers (e.g., std, npm, pip3, go, gem, shell).
local my_installer = function(server, callback, context)
    std.ensure_executable("odin", { help_url = "https://odin-lang.org" })

    when(platform.is_linux, linux)
    when(platform.is_windows, linux)
    if is_success then
        callback(true)
    else
        callback(false)
    end
end

-- 2. (mandatory) Create an nvim-lsp-installer Server instance
local my_server = server.Server:new {
    name = server_name,
    root_dir = root_dir,
    installer = function()
        std.ensure_executable("odin", { help_url = "https://odin-lang.org" })
        local command = coalesce(
            when(
                platform.is_linux,
                coalesce("git clone --depth 1 https://github.com/DanielGavin/ols.git . && build.sh")
            )
            when(
                platform.is_win,
                coalesce("git clone --depth 1 https://github.com/DanielGavin/ols.git . && build.bat")
            )
        )
        when( platform.is_win,
        shell.cmd(command)
        )
        when( platform.is_linux,
        shell.bash(command))
    end
    default_options = {
        cmd = { path.concat { root_dir, "ols" },},
    },
}

-- 3. (optional, recommended) Register your server with nvim-lsp-installer.
--    This makes it available via other APIs (e.g., :LspInstall, lsp_installer.get_available_servers()).
servers.register(my_server)
