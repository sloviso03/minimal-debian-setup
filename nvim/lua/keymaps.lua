-- Editor
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

-- Clipboard
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("v", "<C-x>", '"+d')
vim.keymap.set("n", "<C-v>", '"+P')
vim.keymap.set("i", "<C-v>", '<C-r>+')
vim.keymap.set("v", "<C-v>", '"+P')

-- Selection
vim.keymap.set("n", "<C-a>", "ggVG")
vim.keymap.set("i", "<C-a>", "<C-o>ggVG")

-- File Management
vim.keymap.set("n", "<C-n>", "<cmd>enew<CR>")

-- Navigation
vim.keymap.set("n", "<Home>", "^")
vim.keymap.set("n", "<End>", "$")
vim.keymap.set("i", "<Home>", "<C-o>^")
vim.keymap.set("i", "<End>", "<C-o>$")

vim.keymap.set("i", "<S-Home>", "<C-o>v<C-o>^")
vim.keymap.set("i", "<S-End>", "<C-o>v<C-o>$")

vim.keymap.set("n", "<PageUp>", "<C-u>")
vim.keymap.set("n", "<PageDown>", "<C-d>")
vim.keymap.set("i", "<PageUp>", "<C-o><C-u>")
vim.keymap.set("i", "<PageDown>", "<C-o><C-d>")

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

-- Arrow Selection
vim.keymap.set("n", "<S-Left>", "v<Left>")
vim.keymap.set("n", "<S-Right>", "v<Right>")
vim.keymap.set("n", "<S-Up>", "v<Up>")
vim.keymap.set("n", "<S-Down>", "v<Down>")

vim.keymap.set("v", "<S-Left>", "<Left>")
vim.keymap.set("v", "<S-Right>", "<Right>")
vim.keymap.set("v", "<S-Up>", "<Up>")
vim.keymap.set("v", "<S-Down>", "<Down>")

vim.keymap.set("i", "<S-Left>", "<C-o>v<Left>")
vim.keymap.set("i", "<S-Right>", "<C-o>v<Right>")
vim.keymap.set("i", "<S-Up>", "<C-o>v<Up>")
vim.keymap.set("i", "<S-Down>", "<C-o>v<Down>")

-- Line Movement
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")

-- Window Navigation
vim.keymap.set("n", "<leader>h", "<C-w>h", { silent = true })
vim.keymap.set("n", "<leader>j", "<C-w>j", { silent = true })
vim.keymap.set("n", "<leader>k", "<C-w>k", { silent = true })
vim.keymap.set("n", "<leader>l", "<C-w>l", { silent = true })

vim.keymap.set("n", "<leader><Left>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<leader><Down>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<leader><Up>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<leader><Right>", "<C-w>l", { silent = true })

-- Mouse
vim.opt.mouse = "a"

-- Window Resizing
vim.keymap.set("n", "<C-Left>", ":vertical resize -5<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +5<CR>")
vim.keymap.set("n", "<C-Up>", ":resize +5<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -5<CR>")

