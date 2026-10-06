return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    config = function()
        local treesitter = require("nvim-treesitter")

        -- Languages we know nvim-treesitter supports.
        local available = {}
        for _, lang in ipairs(treesitter.get_available()) do
            available[lang] = true
        end

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local buf = args.buf
                local ft = vim.bo[buf].filetype
                local lang = vim.treesitter.language.get_lang(ft)

                -- No Tree-sitter parser exists for this filetype.
                if not lang or not available[lang] then
                    return
                end

                local function start()
                    if not vim.api.nvim_buf_is_valid(buf) then
                        return
                    end

                    pcall(vim.treesitter.start, buf, lang)
                end

                -- Parser isn't installed → install it, then start Tree-sitter.
                if #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 then
                    treesitter.install({ lang }):await(start)
                else
                    start()
                end
            end,
        })
    end,
}
