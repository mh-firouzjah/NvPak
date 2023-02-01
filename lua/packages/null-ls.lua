local found_null_ls, null_ls = pcall(require, "null-ls")
local found_mason_null_ls, mason_null_ls = pcall(require, "mason-null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end

-- null ls config
if found_null_ls and found_mason_null_ls then
    -- null-ls server Configure
    local b = null_ls.builtins
    local packages = {
        b.diagnostics.markdownlint,
        b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
        b.formatting.black,
        b.formatting.prettier,
        b.formatting.shfmt,
        b.formatting.sql_formatter,
        b.formatting.stylua,
        b.completion.spell,
        b.formatting.xmlformat,
    }

    -- Null-ls Config
    null_ls.setup({
        on_attach = on_attach,
        debug = true,
        sources = packages,
    })

    -- Mason Package Manager config for null-ls
    mason_null_ls.setup({
        ensure_installed = {
            -- Write your desired package here instead of above (for people who don't like the automatic system and use space + f)
            -- for example "black"
        },
        automatic_installation = true,
        automatic_setup = false,
    })
else
    return
end