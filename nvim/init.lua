-- Settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = false
vim.opt.signcolumn = "yes"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = false
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.updatetime = 250
vim.opt.undofile = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.guicursor = "a:ver25"
vim.opt.virtualedit = "onemore"
vim.opt.shada = "'100,<50,s10,h"

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1
vim.g.netrw_browse_split = 0
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.equalalways = false

-- Modules
require("plugins")
require("keymaps")
require("netrw")

-- Theme
vim.cmd.colorscheme("carbonfox")

-- Treesitter
local treesitter_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if treesitter_ok then
    treesitter.setup({
        ensure_installed = { "c", "cpp", "c_sharp", "lua", "bash" },
        highlight = { enable = true },
        indent = { enable = true },
    })
end

-- Completion
local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
cmp.setup({
    snippet = { expand = function(args) vim.snippet.expand(args.body) end },
    completion = { autocomplete = { cmp.TriggerEvent.TextChanged } },
    preselect = cmp.PreselectMode.None,
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.confirm({ select = true }) else fallback() end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item() else fallback() end
        end, { "i", "s" }),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping(function(fallback) fallback() end),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    }),
    sources = cmp.config.sources({ { name = "nvim_lsp" } }),
})

-- LSP
local capabilities = cmp_nvim_lsp.default_capabilities()
local function root(markers)
    return vim.fs.root(0, markers) or vim.fn.getcwd()
end

local function start_lsp()
    local ft = vim.bo.filetype
    if ft == "c" or ft == "cpp" then
        vim.lsp.start({
            name = "clangd",
            cmd = { "clangd" },
            root_dir = root({ "compile_commands.json", "CMakeLists.txt", ".git" }),
            capabilities = capabilities,
        })
    elseif ft == "cs" then
        vim.lsp.start({
            name = "csharp_ls",
            cmd = { "csharp-ls" },
            root_dir = root({ "*.sln", "*.csproj", ".git" }),
            capabilities = capabilities,
        })
    end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "cs" },
    callback = function()
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.softtabstop = 4
        vim.bo.expandtab = true
        vim.bo.autoindent = true
        vim.bo.smartindent = true
        vim.bo.cindent = true
        start_lsp()
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})

-- Cursor Restoration
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line = mark[1]
        if line > 0 and line <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Diagnostics
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
})

-- Statusline
function _G.nvim_mode()
    local modes = {
        n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE",
        ["\22"] = "V-BLOCK", c = "COMMAND", s = "SELECT", S = "S-LINE",
        R = "REPLACE", t = "TERMINAL",
    }
    return modes[vim.fn.mode()] or vim.fn.mode()
end

function _G.nvim_filetype()
    local ft = vim.bo.filetype
    if ft == "" then return "Plain Text" end
    local names = {
        c = "C", cpp = "C++", cs = "C#", lua = "Lua", sh = "Bash", bash = "Bash",
        python = "Python", javascript = "JavaScript", json = "JSON", html = "HTML",
    }
    return names[ft] or ft
end

function _G.nvim_lsp()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then return "LSP: -" end
    local names = {}
    for _, client in ipairs(clients) do table.insert(names, client.name) end
    return "LSP: " .. table.concat(names, ", ")
end

function _G.nvim_encoding()
    return vim.bo.fileencoding ~= "" and vim.bo.fileencoding or "UTF-8"
end

function _G.nvim_fileformat()
    return vim.bo.fileformat:upper()
end

vim.opt.laststatus = 2
vim.opt.statusline = table.concat({
    " ", "%#StatusLineMode#", "%{v:lua.nvim_mode()}", "%#StatusLine#", "  %f",
    "  ", "%{v:lua.nvim_filetype()}", "  ", "%{v:lua.nvim_lsp()}", "  ",
    "%{v:lua.nvim_encoding()}", "  ", "%{v:lua.nvim_fileformat()}", "  %l:%c",
    "  %p%% ", ""
})

