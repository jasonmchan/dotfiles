(let [plug (. vim.fn "plug#")
      plug-begin (. vim.fn "plug#begin")
      plug-end (. vim.fn "plug#end")]
  (plug-begin (.. (vim.fn.stdpath :data) :/plugged))
  (plug :nvim-treesitter/nvim-treesitter {:do :TSUpdate})
  (plug :neovim/nvim-lspconfig)
  (plug :nvim-lua/plenary.nvim)
  (plug :nvim-telescope/telescope.nvim)
  (plug :hrsh7th/nvim-cmp)
  (plug :hrsh7th/vim-vsnip)
  (plug :hrsh7th/cmp-nvim-lsp)
  (plug :windwp/nvim-autopairs)
  (plug :lewis6991/gitsigns.nvim)
  (plug :rhysd/conflict-marker.vim)
  (plug :catppuccin/nvim)
  (plug-end))

(macro opt [name value]
  (let [name (tostring name)]
    (if (= (name:sub -1) "+")
        `(: (. vim.opt ,(name:sub 1 -2)) :append ,value)
        `(tset vim.opt ,name ,value))))

(opt breakindent true)
(opt breakindentopt "shift:2")
(opt clipboard+ :unnamedplus)
(opt cursorline true)
(opt expandtab true)
(opt foldenable false)
(opt gdefault true)
(opt hlsearch false)
(opt ignorecase true)
(opt laststatus 0)
(opt mouse :a)
(opt scrolloff 5)
(opt shiftwidth 2)
(opt shortmess+ :c)
(opt showbreak "↳")
(opt showmatch true)
(opt signcolumn :yes)
(opt smartcase true)
(opt smartindent true)
(opt softtabstop -1)
(opt splitbelow true)
(opt splitright true)
(opt swapfile false)
(opt termguicolors true)

(set vim.g.mapleader " ")
(set vim.g.netrw_banner 0)
(set vim.g.tex_flavor :latex)

(vim.cmd "colorscheme catppuccin")

(macro au [event c opts]
  `(->> {:group :settings :callback #,c}
        (vim.tbl_extend :keep ,(or opts {}))
        (vim.api.nvim_create_autocmd ,event)))

(vim.api.nvim_create_augroup :settings {})
(au [:CursorHold] (vim.cmd :checktime))
(au [:BufWinEnter] (vim.notify (.. " " (vim.fn.expand "%:t"))))
(au [:TextYankPost] (vim.highlight.on_yank))
(au [:FileType] [(set vim.bo.expandtab false)
                 (set vim.bo.tabstop 4)
                 (set vim.bo.shiftwidth 4)]
    {:pattern [:go :tex]})

(let [autopairs (require :nvim-autopairs)]
  (autopairs.setup {:disable_filetype [:TelescopePrompt :tex :fennel]}))

(let [cmp (require :cmp)]
  (fn feedkey [key]
    (-> key
        (vim.api.nvim_replace_termcodes true true true)
        (vim.api.nvim_feedkeys "" true)))

  (fn super-tab [fallback]
    (if (cmp.visible) (cmp.select_next_item)
        (= ((. vim.fn "vsnip#jumpable") 1) 1) (feedkey "<Plug>(vsnip-jump-next)")
        (fallback)))

  (fn super-s-tab [fallback]
    (if (cmp.visible) (cmp.select_prev_item)
        (= ((. vim.fn "vsnip#jumpable") -1) 1) (feedkey "<Plug>(vsnip-jump-prev)")
        (fallback)))

  (cmp.setup {:snippet {:expand #((. vim.fn "vsnip#anonymous") $1.body)}
              :mapping {:<Tab> (cmp.mapping super-tab [:i :s])
                        :<S-Tab> (cmp.mapping super-s-tab [:i :s])
                        :<CR> (cmp.mapping.confirm)
                        :<C-e> (cmp.mapping.close)
                        :<C-u> (cmp.mapping.scroll_docs -4)
                        :<C-d> (cmp.mapping.scroll_docs 4)}
              :sources [{:name :nvim_lsp}]}))

(local map vim.keymap.set)
(map :n :ga "<cmd>b#<cr>")

(let [gitsigns (require :gitsigns)]
  (gitsigns.setup)
  (map :n "]c" gitsigns.next_hunk)
  (map :n "[c" gitsigns.prev_hunk)
  (map [:n :v] :<leader>hs gitsigns.stage_hunk)
  (map [:n :v] :<leader>hr gitsigns.reset_hunk)
  (map :n :<leader>hS gitsigns.stage_buffer)
  (map :n :<leader>hu gitsigns.undo_stage_hunk)
  (map :n :<leader>hR gitsigns.reset_buffer)
  (map :n :<leader>hp gitsigns.preview_hunk)
  (map :n :<leader>hb gitsigns.blame_line)
  (map [:o :x] :ih gitsigns.select_hunk))

(let [treesitter (require :nvim-treesitter.configs)]
  (treesitter.setup {:ensure_installed :maintained
                     :highlight {:enable true}
                     :indent {:enable true}}))

(let [telescope (require :telescope)
      themes (require :telescope.themes)
      pickers (require :telescope.builtin)
      actions (require :telescope.actions)]
  (local ivy ((. themes :get_ivy) {:previewer false}))
  (set ivy.mappings
       {:n {:<C-u> actions.results_scrolling_up
            :<C-d> actions.results_scrolling_down}})
  (telescope.setup {:defaults ivy
                    :pickers {:buffers {:initial_mode :normal :sort_mru true}
                              :resume {:initial_mode :normal}
                              :git_status {:initial_mode :normal}}})
  (map :n :<leader><leader> pickers.builtin)
  (map :n :<leader>f pickers.find_files)
  (map :n :<leader>a pickers.git_files)
  (map :n :<leader>s pickers.git_status)
  (map :n :<leader>g pickers.live_grep)
  (map :n :<leader>t pickers.treesitter)
  (map :n "<leader>;" pickers.buffers)
  (map :n "<leader>'" pickers.resume)
  (map :n :gr pickers.lsp_references))

(local s {})

(set s.on_attach
     (fn [client bufnr]
       (let [map #(vim.keymap.set $1 $2 $3 {:buffer bufnr})
             capable? #(. client.resolved_capabilities $1)]
         (map :n :<leader>e vim.diagnostic.open_float)
         (map :n "[d" vim.diagnostic.goto_prev)
         (map :n "]d" vim.diagnostic.goto_next)
         (when (capable? :goto_definition)
           (map :n :gd vim.lsp.buf.definition))
         (when (capable? :hover)
           (map :n :K vim.lsp.buf.hover))
         (when (capable? :signature_help)
           (map [:n :i] :<C-k> vim.lsp.buf.signature_help))
         (when (capable? :rename)
           (map :n :<leader>r vim.lsp.buf.rename))
         (when (capable? :code_action)
           (map :n :<leader>c vim.lsp.buf.code_action))
         (when (capable? :document_formatting)
           (map :n :g= vim.lsp.buf.formatting))
         (when (capable? :document_range_formatting)
           (map :x "=" vim.lsp.buf.range_formatting))
         (when (= client.name :clangd)
           (map :n :gs :<cmd>ClangdSwitchSourceHeader<CR>)))))

(set s.capabilities
     (-> (vim.lsp.protocol.make_client_capabilities)
         ((. (require :cmp_nvim_lsp) :update_capabilities))))

(set s.settings
     {:texlab {:build {:onSave true
                       :args [:-pdf
                              :-output-directory=out
                              :-interaction=nonstopmode
                              :-synctex=1
                              "%f"]}
               :chktex {:onOpenAndSave true :onEdit true}}})

(let [lspconfig (require :lspconfig)]
  (each [_ server (pairs [:clangd :gopls :pyright :texlab])]
    ((. lspconfig server :setup) s)))
