return {
  "mfussenegger/nvim-dap",
  optional = true,
  opts = function()
    local dap = require("dap")
    local registry = require("mason-registry")
    local package = registry.get_package("php-debug-adapter")
    if package then
      local path = package:get_install_path()
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { path .. "/extension/out/phpDebug.js" },
      }
    end
  end,
}
