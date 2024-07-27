--
-- The MIT License (MIT)
--
-- Copyright (c) 2022  Steffen Nuessle
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--

main = function()
    local files = {
        '.clang-format',
        '.clang-tidy',
        '.clangd',
        'LICENSE',
        'LICENSE.md',
        'LICENSE.txt',
    }

    local options = {
        upward = true,
        type = 'file',
        limit = 1,
    }

    local results = vim.fs.find(files, options)

    -- clangd automatically detects how many CPU cores are available and
    -- spawns the appropriate number of worker threads accordingly.
    vim.lsp.start({
        name = 'clangd',
        root_dir = vim.fs.dirname(results[0]),
        cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--completion-style=detailed',
            '--enable-config',
            '--header-insertion=never',
            '--pch-storage=memory',
            '--log=info',
        },
        detached = true,
        flags = {
            allow_incremental_sync = true,
            debounce_text_changes = 150,
            exit_timout = false,
        },
        on_attach = function(client, buf)
            local args = { 
                buffer = buf, 
                noremap = true, 
                silent = true,
            }

            local setloclist = function()
                vim.diagnostic.setloclist({
                    open = true,
                    severity = { 
                        min = vim.diagnostic.severity.HINT,
                        max = vim.diagnostic.severity.ERROR,
                    },
                    title = 'clangd: Diagnostics',
                })
            end

            vim.keymap.set('n', '<C-x><C-d>', setloclist, args)
            vim.keymap.set('n', '<C-x><C-b>', vim.diagnostic.goto_prev)
            vim.keymap.set('n', '<C-x><C-n>', vim.diagnostic.goto_next)

            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, args)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, args)

            -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, args)
            vim.keymap.set('n', '<C-x><C-a>', vim.lsp.buf.code_action, args)
            vim.keymap.set('n', '<C-x><C-h>', vim.lsp.buf.hover, args)
            vim.keymap.set('n', '<C-x><C-e>', vim.lsp.buf.rename, args)
            vim.keymap.set('n', '<C-x><C-r>', vim.lsp.buf.references, args)
            vim.keymap.set('n', '<C-x><C-s>', vim.lsp.buf.document_symbol, args)
            vim.keymap.set('n', '<C-x><C-i>', vim.lsp.buf.incoming_calls, args)
            vim.keymap.set('n', '<C-x><C-o>', vim.lsp.buf.outgoing_calls, args)

            vim.keymap.set('i', '<C-x><C-h>', vim.lsp.buf.signature_help, args)

            vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        end,
        on_exit = function(exit_code, signal, client_id)
        end,
        handlers = {
            ['textDocument/hover'] = vim.lsp.with(
                vim.lsp.handlers.hover, 
                {
                    style = 'minimal',
                    border = 'none',
                    focusable = false,
                    noautocmd = true,
                }
            ),
            ['textDocument/signatureHelp'] = vim.lsp.with(
                vim.lsp.handlers.signature_help, 
                {
                    style = 'minimal',
                    border = 'none',
                    focusable = false,
                    noautocmd = true,
                }
            ),
            ['textDocument/publishDiagnostics'] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                {
                    underline = true,
                    source = false,
                    virtual_text = {
                        spacing = 4,
                        severity = {
                            min = vim.diagnostic.severity.HINT,
                            max = vim.diagnostic.severity.ERROR,
                        },
                        prefix = '■',
                        suffix = false,
                        format = function(diagnostic)
                            return string.format('[%s]', diagnostic.code)
                        end,
                    },
                    signs = false,
                    update_in_insert = true,
                }
            ),
        },
    })

end

main()
