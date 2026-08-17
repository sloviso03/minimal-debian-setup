-- Options
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
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
vim.opt.undofile = true
vim.opt.guicursor = "a:ver25"
vim.opt.virtualedit = "onemore"
vim.opt.shada = "'100,<50,s10,h"

vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 30
vim.g.netrw_altv = 1
vim.g.netrw_banner = 0

-- Theme
vim.cmd.colorscheme("carbonfox")

-- Keymaps
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")
vim.keymap.set("i", "<C-s>", "<C-o>:w<CR>")
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>")
vim.keymap.set("i", "<C-q>", "<C-o>:q<CR>")

vim.keymap.set("n", "<C-f>", "/")
vim.keymap.set("i", "<C-f>", "<C-o>/")

vim.keymap.set("n", "<C-z>", "u")
vim.keymap.set("i", "<C-z>", "<C-o>u")

vim.keymap.set("n", "<C-y>", "<C-r>")
vim.keymap.set("i", "<C-y>", "<C-o><C-r>")

vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("v", "<C-x>", '"+d')
vim.keymap.set("n", "<C-v>", '"+P')
vim.keymap.set("i", "<C-v>", '<C-r>+')

vim.keymap.set("n", "<C-a>", "ggVG")
vim.keymap.set("i", "<C-a>", "<C-o>ggVG")

vim.keymap.set("n", "<C-n>", "<cmd>enew<CR>")
vim.keymap.set("n", "<C-o>", "<cmd>edit ")

vim.keymap.set("n", "<Home>", "0")
vim.keymap.set("n", "<End>", "$l")

vim.keymap.set("i", "<Home>", "<C-o>0")
vim.keymap.set("i", "<End>", "<C-o>$<Right>")

vim.keymap.set("n", "<PageUp>", "10k")
vim.keymap.set("n", "<PageDown>", "10j")

vim.keymap.set("i", "<PageUp>", "<C-O>10k")
vim.keymap.set("i", "<PageDown>", "<C-O>10j")

vim.keymap.set("n", "<A-e>", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)

        if vim.bo[buf].filetype == "netrw" then
            vim.api.nvim_win_close(win, true)
            return
        end
    end

    vim.cmd("botright 30vnew")
    vim.cmd("Explore")
    vim.cmd("vertical resize 30")
end)


-- Autoclose
local autoclose = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ['"'] = '"',
    ["'"] = "'",
}

for open, close in pairs(autoclose) do
    vim.keymap.set("i", open, function()
        return open .. close .. "<Left>"
    end, { expr = true })
end


-- Text selection
vim.keymap.set("i", "<S-Left>", "<C-O>gh<Left>")
vim.keymap.set("i", "<S-Right>", "<C-O>gh<Right>")
vim.keymap.set("i", "<S-Up>", "<C-O>gh<Up>")
vim.keymap.set("i", "<S-Down>", "<C-O>gh<Down>")

vim.keymap.set("s", "<S-Left>", "<Left>")
vim.keymap.set("s", "<S-Right>", "<Right>")
vim.keymap.set("s", "<S-Up>", "<Up>")
vim.keymap.set("s", "<S-Down>", "<Down>")

vim.keymap.set("s", "<C-c>", '"+y<Esc>')
vim.keymap.set("s", "<C-x>", '"+d')
vim.keymap.set("s", "<C-v>", '"+P')

-- Move selection
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")

vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")

vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")


-- LSP
local function root(markers)
    return vim.fs.root(0, markers) or vim.fn.getcwd()
end

local function start_lsp()
    local ft = vim.bo.filetype

    if ft == "c" or ft == "cpp" then
        vim.lsp.start({
            name = "clangd",
            cmd = { "clangd" },
            root_dir = root({
                "compile_commands.json",
                "CMakeLists.txt",
                ".git",
            }),
        })
    elseif ft == "cs" then
        vim.lsp.start({
            name = "csharp_ls",
            cmd = { "csharp-ls" },
            root_dir = root({
                "*.sln",
                "*.csproj",
                ".git",
            }),
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
        vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
        start_lsp()
    end,
})


-- Completion
vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = {
        "*.c",
        "*.h",
        "*.cpp",
        "*.hpp",
        "*.cc",
        "*.cxx",
        "*.cs",
    },
    callback = function()
        if vim.fn.pumvisible() == 1 then
            return
        end

        local line = vim.api.nvim_get_current_line()
        local col = vim.fn.col(".") - 1
        local char = line:sub(col, col)

        if char:match("[%w_%.]") then
            vim.fn.feedkeys(
                vim.api.nvim_replace_termcodes(
                    "<C-x><C-o>",
                    true,
                    false,
                    true
                ),
                "n"
            )
        end
    end,
})


-- Cursor position
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
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "V-LINE",
        ["\22"] = "V-BLOCK",
        c = "COMMAND",
        s = "SELECT",
        S = "S-LINE",
        R = "REPLACE",
        t = "TERMINAL",
    }

    return modes[vim.fn.mode()] or vim.fn.mode()
end

function _G.nvim_filetype()
    local ft = vim.bo.filetype

    if ft == "" then
        return "Plain Text"
    end

    local names = {
        c = "C",
        cpp = "C++",
        cs = "C#",
        lua = "Lua",
        sh = "Bash",
        bash = "Bash",
        zsh = "Zsh",
        python = "Python",
        javascript = "JavaScript",
        typescript = "TypeScript",
        typescriptreact = "TypeScript React",
        javascriptreact = "JavaScript React",
        json = "JSON",
        yaml = "YAML",
        yml = "YAML",
        html = "HTML",
        css = "CSS",
        markdown = "Markdown",
        toml = "TOML",
        xml = "XML",
    }

    return names[ft] or ft
end

function _G.nvim_lsp()
    local clients = vim.lsp.get_clients({ bufnr = 0 })

    if #clients == 0 then
        return "LSP: -"
    end

    local names = {}

    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end

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
    " ",
    "%#StatusLineMode#",
    "%{v:lua.nvim_mode()}",
    "%#StatusLine#",
    "  %f",
    "  ",
    "%{v:lua.nvim_filetype()}",
    "  ",
    "%{v:lua.nvim_lsp()}",
    "  ",
    "%{v:lua.nvim_encoding()}",
    "  ",
    "%{v:lua.nvim_fileformat()}",
    "  %l:%c",
    "  %p%%",
    " ",
})
