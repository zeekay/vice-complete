" Enable neocomplcache
func! vice#neocomplcache#enable()
    call vice#Extend({
        \ 'addons': [
            \ 'github:Shougo/neocomplcache.vim',
            \ 'github:Shougo/context_filetype.vim',
        \ ]
    \ })

    if !exists('g:neocomplcache_keyword_patterns')
      let g:neocomplcache_keyword_patterns = {}
    endif

    if !exists('g:neocomplcache_omni_functions')
        let g:neocomplcache_omni_functions = {}
    endif

    if !exists('g:neocomplcache_omni_patterns')
      let g:neocomplcache_omni_patterns = {}
    endif

    if !exists('g:neocomplcache_force_omni_patterns')
      let g:neocomplcache_force_omni_patterns = {}
    endif

    let g:neocomplcache_auto_completion_start_length = 3
    let g:neocomplcache_caching_limit_file_size = 500000
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_prefetch = 1
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_min_syntax_length = 3
    let g:neocomplcache_snippets_disable_runtime_snippets = 1

    " <CR> closes popup
    inoremap <expr><CR> vice#neocomplcache#auto_close_popup()

    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

    " Make arrow keys work properly in popup
    inoremap <expr><Up> pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr><Down> pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Left> neocomplcache#cancel_popup() . "\<Left>"
    inoremap <expr> <Right> neocomplcache#cancel_popup() . "\<Right>"

    inoremap <expr>OA pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr>OB pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr>OD neocomplcache#cancel_popup() . "\<Left>"
    inoremap <expr>OC neocomplcache#cancel_popup() . "\<Right>"

    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><space> pumvisible() ? neocomplcache#smart_close_popup()."\<space>" : "\<space>"

    " we don't want the completion menu to auto pop-up when we are in text files
    let g:neocomplcache_lock_buffer_name_pattern = '\v(\.md|\.txt|\.git\/COMMIT_EDITMSG)'

    " Define keyword.
    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

    " Enable heavy omni completion, which require computational power and may stall the vim.
    let g:neocomplcache_omni_patterns.c = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_omni_patterns.coffee = '[^. \t]\.\%(\h\w*\)\?'
    let g:neocomplcache_omni_patterns.cpp = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
endf

" Close popup and save indent. Supports delimitmate, if it's installed.
func! vice#neocomplcache#auto_close_popup()
    call neocomplcache#smart_close_popup()
    " If delimitMate_expand_cr is set, call manually
    if exists('g:delimitMate_expand_cr') && eval('g:delimitMate_expand_cr')
        if delimitMate#WithinEmptyPair()
            call delimitMate#ExpandReturn()
            return "\<Esc>a\<CR>\<Esc>zvO"
        endif
    endif
    return "\<CR>"
endf

func! vice#neocomplcache#enable_clang_complete()
    let g:neocomplcache_force_overwrite_completefunc = 1
    let g:neocomplcache_force_omni_patterns.c      = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
    let g:neocomplcache_force_omni_patterns.cpp    = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    let g:neocomplcache_force_omni_patterns.objc   = '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
    let g:neocomplcache_force_omni_patterns.objcpp = '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'

    call vice#complete#enable_clang_complete()
endf

func! vice#neocomplcache#enable_jedi()
    au FileType python call vice#ForceActivateAddon('github:davidhalter/jedi-vim')
    au FileType python let b:did_ftplugin = 1
    au FileType python setl completeopt-=preview
    au FileType python setl omnifunc=jedi#completions
    au FileType python nnoremap <buffer> <leader>d :call vice#neocompletion#jedi_show_documentation()<cr>

    let g:jedi#auto_initialization = 1
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#popup_on_dot = 0
    let g:jedi#popup_select_first = 0
    let g:jedi#show_call_signatures = 0
    let g:jedi#use_tabs_not_buffers = 0
    let g:jedi#use_splits_not_buffers = "right"
    let g:jedi#documentation_command = "<leader>d"
    let g:jedi#goto_assignments_command = "gd"
    let g:jedi#goto_definitions_command = "gD"
    let g:jedi#completions_command = ""
    let g:jedi#usages_command = "<leader>ju"
    let g:jedi#rename_command = "<leader>jr"

    let g:neocomplcache_force_overwrite_completefunc = 1
    let g:neocomplcache_force_omni_patterns.python = '[^. \t]\.\w*'
    let g:neocomplcache_omni_functions.python = 'jedi#completions'
endf

func! vice#neocomplcache#enable_necoghc()
    au FileType haskell call vice#ForceActivateAddon('github:eagletmt/neco-ghc')
    au FileType haskell setlocal omnifunc=necoghc#omnifunc

    let g:necoghc_enable_detailed_browse = 1
endf

func! vice#neocomplcache#enable_neosnippet()
    call vice#Extend({
        \ 'addons': [
            \ 'github:Shougo/neosnippet',
        \ ],
    \ })

    imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" :
endf

func! vice#neocomplcache#enable_tern()
    call vice#ForceActivateAddon('github:marijnh/tern_for_vim')

    " JavaScript
    let g:neocomplcache_omni_functions.javascript = 'tern#Complete'
    let g:neocomplcache_force_omni_patterns.javascript = '\h\w*\|[^. \t]\.\w*'

    " CoffeeScript (someday)
    " let g:neocomplete#sources#omni#functions.coffee = 'tern#Complete'
    " let g:neocomplete#sources#omni#input_patterns.coffee = '\h\w*\|[^. \t]\.\w*'
    " au FileType coffee call tern#Enable()
    au FileType coffee     setl omnifunc=javascriptcomplete#CompleteJS

    let g:tern_show_signature_in_pum = 1
    let g:tern_map_keys = 0
endf

" Enable Racer for rust completion
func! vice#neocomplcache#enable_racer()
    au FileType rust call vice#ForceActivateAddon('github:zeekay/vim-racer')
    let g:neocomplcache_omni_functions.rust = 'racer#Complete'
    let g:neocomplcache_force_omni_patterns.rust = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
endf
