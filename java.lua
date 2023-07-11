-- I should be linked in /home/churlin/.config/nvim/ftplugin/java.lua
local config = {
    cmd = {'/home/churlin/tools/jdt-language-server-1.25.0-202306291518/bin/jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)
