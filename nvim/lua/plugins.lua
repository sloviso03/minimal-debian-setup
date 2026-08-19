-- Plugins Setup
local ok, paq = pcall(require, "paq")
if not ok then
    vim.notify("Paq is not installed", vim.log.levels.ERROR)
    return
end

paq({
    "savq/paq-nvim",
    "EdenEast/nightfox.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    { "nvim-treesitter/nvim-treesitter", branch = "master" },
})

