if version < 702
    echoerr 'vice-neocompletion requires vim 7.2 or newer'
    finish
endif

if !exists('g:vice.neocompletion')
    let g:vice.neocompletion = {}
endif

call vice#Extend({
    \ 'addons': [
        \ 'github:Shougo/neocomplcache.vim',
    \ ]
\ })

" neocomplcache {{{
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

    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_prefetch = 1
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_min_syntax_length = 3
    let g:neocomplcache_auto_completion_start_length = 3
    let g:neocomplcache_snippets_disable_runtime_snippets = 1
    let g:neocomplcache_caching_limit_file_size = 500000

    " <CR> closes popup
    inoremap <expr><CR> vice#neocompletion#AutoClosePopup()

    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

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
    let g:neocomplcache_omni_patterns.go = '\h\w*\%.'
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

    let g:neocomplcache_force_overwrite_completefunc = 1
" }}}

" neosnippet {{{
    if exists('g:vice.neocompletion.enable_neosnippet')
        call vice#Extend({
            \ 'addons': [
                \ 'github:Shougo/neosnippet',
            \ ],
        \ })

        imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
        smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" :
    endif
" }}}

" clang_clomplete {{{
    if exists('g:vice.neocompletion.enable_clang_complete')
        call vice#Extend({
            \ 'ft_addons': {
                \ 'c$\|cpp': [
                    \ 'github:Rip-Rip/clang_complete',
                \ ],
            \ },
        \ })
        let g:clang_complete_auto = 1
        let g:clang_auto_select = 1
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
    endif
" }}}

" jedi {{{
    if exists('g:vice.neocompletion.enable_jedi')
        call vice#Extend({
            \ 'ft_addons': {
                \ 'python': [
                    \ 'github:davidhalter/jedi-vim',
                \ ],
            \ },
        \ })
        au FileType python let b:did_ftplugin = 1
        let g:neocomplcache_force_omni_patterns['python'] = '[^. \t]\.\w*'
        let g:neocomplcache_omni_functions['python'] = 'jedi#complete'
        set ofu=syntaxcomplete#Complete
        let g:jedi#popup_on_dot = 0
    endif
" }}}

" jscomplete-vim {{{
    if exists('g:vice.neocompletion.enable_jscomplete')
        call vice#Extend({
            \ 'ft_addons': {
                \ 'coffee\|javascript': [
                    \ 'github:teramako/jscomplete-vim',
                \ ],
            \ }
        \})
        let g:jscomplete_use = ['dom', 'moz', 'es6th']
        au FileType coffee,javascript setl omnifunc=jscomplete#CompleteJS
    endif
" }}}

" necoghc {{{
    if exists('g:vice.neocompletion.enable_necoghc')
        call vice#Extend({
            \ 'ft_addons': {
                \ 'haskell': [
                    \ 'github:ujihisa/neco-ghc',
                \ ],
            \ },
        \ })
        au FileType haskell setl omnifunc=necoghc#omnifunc
    endif
" }}}
