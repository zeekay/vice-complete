func! vice#neocomplete#enable()
    call vice#Extend({
        \ 'addons': [
            \ 'github:Shougo/neocomplete.vim',
            \ 'github:Shougo/context_filetype.vim',
        \ ]
    \ })

    if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}
    endif

    if !exists('g:neocomplete#sources#omni#functions')
        let g:neocomplete#sources#omni#functions = {}
    endif

    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif

    if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
    endif

    let g:neocomplete#auto_completion_start_length = 3
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_prefetch = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#sources#buffer#cache_limit_size = 500000
    let g:neocomplete#sources#syntax#min_keyword_length = 3

    " <CR> closes popup
    inoremap <expr><CR> vice#neocomplete#auto_close_popup()

    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

    " Make arrow keys work properly in popup
    inoremap <expr><Up> pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr><Down> pumvisible() ? "\<C-n>" : "\<Down>"

    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><space> pumvisible() ? neocomplete#smart_close_popup()."\<space>" : "\<space>"

    " we don't want the completion menu to auto pop-up when we are in text files
    let g:neocomplete#lock_buffer_name_pattern = '\v(\.md|\.txt|\.git\/COMMIT_EDITMSG)'

    " Define keyword.
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Enable heavy omni completion, which require computational power and may stall the vim.
    let g:neocomplete#sources#omni#input_patterns.c          = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp        = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.perl       = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.php        = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.ruby       = '[^. *\t]\.\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.javascript = '\h\w*\|[^. \t]\.\w*'
    let g:neocomplete#sources#omni#input_patterns.coffee     = '\h\w*\|[^. \t]\.\w*'
    " let g:neocomplete#sources#omni#input_patterns.coffee     = '[^. \t]\.\%(\h\w*\)\?'

    " let g:neocomplete#force_overwrite_completefunc = 1

    " Enable various third-party completion plugins and configure them to work
    " with neocomplete.
    if exists('g:vice.neocompletion.enable_clang_complete')
        call vice#neocomplete#enable_clang_complete()
    endif

    if exists('g:vice.neocompletion.enable_jedi')
        call vice#neocomplete#enable_jedi()
    endif

    if exists('g:vice.neocompletion.enable_necoghc')
        call vice#neocomplete#enable_necoghc()
    endif

    if exists('g:vice.neocompletion.enable_neosnippet')
        call vice#neocomplete#enable_neosnippet()
    endif

    if exists('g:vice.neocompletion.enable_tern')
        call vice#neocomplete#enable_tern()
    endif
endf

func! vice#neocomplete#enable_clang_complete()
    call vice#Extend({
        \ 'ft_addons': {
            \ 'c$\|cpp': [
                \ 'github:Rip-Rip/clang_complete',
            \ ],
        \ },
    \ })

    if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
    endif

    let g:neocomplete#force_overwrite_completefunc = 1
    let g:neocomplete#force_omni_input_patterns.c      = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
    let g:neocomplete#force_omni_input_patterns.cpp    = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    let g:neocomplete#force_omni_input_patterns.objc   = '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
    let g:neocomplete#force_omni_input_patterns.objcpp = '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'

    let g:clang_complete_auto = 0
    let g:clang_auto_select = 0
    let g:clang_auto_user_options = "path, .clang_complete"
    let g:clang_complete_copen = 0
    let g:clang_complete_macros = 1
    let g:clang_complete_patterns = 0
    let g:clang_hl_errors = 1
    let g:clang_periodic_quickfix = 0
    let g:clang_snippets = 0
    let g:clang_sort_algo = "priority"
    let g:clang_use_library = 1
    let g:clang_user_options = ""

    if has('mac')
        let g:clang_library_path = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib"
    endif
endf

func! vice#neocomplete#enable_jedi()
    call vice#ForceActivateAddon('github:davidhalter/jedi-vim')
    autocmd FileType python let b:did_ftplugin = 1
    autocmd FileType python setlocal completeopt-=preview

    let g:jedi#auto_initialization = 1
    let g:jedi#popup_on_dot = 0
    let g:jedi#popup_select_first = 0
    let g:jedi#show_call_signatures = 1
    let g:jedi#use_tabs_not_buffers = 0
    let g:jedi#use_splits_not_buffers = "right"
    let g:jedi#documentation_command = "<leader>d"
    let g:jedi#goto_assignments_command = "gd"
    let g:jedi#goto_definitions_command = "gD"
    let g:jedi#completions_command = ""
    let g:jedi#usages_command = "<leader>ju"
    let g:jedi#rename_command = "<leader>jr"

    " au FileType python setlocal omnifunc=jedi#completions
    let g:neocomplete#force_omni_input_patterns['python'] = '[^. \t]\.\w*'
    let g:neocomplete#sources#omni#functions['python'] = 'jedi#completions'
endf

func! vice#neocomplete#enable_necoghc()
    call vice#Extend({
        \ 'ft_addons': {
            \ 'haskell': [
                \ 'github:eagletmt/neco-ghc',
            \ ],
        \ },
    \ })
    au FileType haskell setlocal omnifunc=necoghc#omnifunc
endf

func! vice#neocomplete#enable_neosnippet()
    call vice#Extend({
        \ 'addons': [
            \ 'github:Shougo/neosnippet',
        \ ],
    \ })

    imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" :
endf

func! vice#neocomplete#enable_tern()
    call vice#ForceActivateAddon('github:marijnh/tern_for_vim')
    au FileType javascript call tern#Enable()
    let g:tern_show_argument_hints = 1
    let g:neocomplete#force_omni_input_patterns.javascript = '[^. \t]\.\w*'
endf

func! vice#neocomplete#auto_close_popup()
    call neocomplete#smart_close_popup()
    " If delimitMate_expand_cr is set, call manually
    if exists('g:delimitMate_expand_cr') && eval('g:delimitMate_expand_cr')
        if delimitMate#WithinEmptyPair()
            call delimitMate#ExpandReturn()
            return "\<Esc>a\<CR>\<Esc>zvO"
        endif
    endif
    return "\<CR>"
endf
