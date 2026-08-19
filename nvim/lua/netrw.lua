-- Netrw Position
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        local wins = vim.api.nvim_tabpage_list_wins(0)
        if #wins == 1 then
            vim.cmd("wincmd L")
        end
        vim.cmd("30wincmd |")
    end,
})

-- Netrw Width
vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "netrw" then
                vim.api.nvim_win_set_width(win, 30)
            end
        end
    end,
})

-- Netrw Toggle
vim.keymap.set("n", "<A-e>", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "netrw" then
            vim.api.nvim_win_close(win, true)
            return
        end
    end
    vim.cmd("silent rightbelow 30vsplit")
    vim.cmd("Explore")
    vim.cmd("wincmd L")
    vim.api.nvim_win_set_width(0, 30)
end, { silent = true })

