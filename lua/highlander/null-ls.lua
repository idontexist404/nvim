local M = {
	"nvimtools/none-ls.nvim",
}

function M.config()
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	local null_ls = require("null-ls")

	local formatting = null_ls.builtins.formatting

	null_ls.setup({
		sources = {
			formatting.gofumpt,
			formatting.goimports_reviser,
			formatting.golines,
			formatting.stylua,
			formatting.prettier,
			formatting.prettier.with({
				extra_filetypes = { "toml" },
				-- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
			}),
			-- null_ls.builtins.diagnostics.eslint,
			null_ls.builtins.completion.spell,
		},

		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({
					group = augroup,
					buffer = bufnr,
				})
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr })
					end,
				})
			end
		end,
	})
end

return M
