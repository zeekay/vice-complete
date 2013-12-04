call vice#Extend({
    \ 'addons': [
        \ 'github:Shougo/neocomplete.vim',
    \ ]
\ })

" neocomplcache {{{
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

    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_prefetch = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#auto_completion_start_length = 3
    let g:neocomplete#sources#buffer#cache_limit_size = 500000

    " <CR> closes popup
    inoremap <expr><CR> vice#neocompletion#AutoClosePopup()

    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><space> pumvisible() ? neocomplete#smart_close_popup()."\<space>" : "\<space>"

    " we don't want the completion menu to auto pop-up when we are in text files
    let g:neocomplete#lock_buffer_name_pattern = '\v(\.md|\.txt|\.git\/COMMIT_EDITMSG)'

    " Define keyword.
    " let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Enable heavy omni completion, which require computational power and may stall the vim.
    " let g:neocomplete#sources#omni#input_patterns.c = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)'
    " let g:neocomplete#sources#omni#input_patterns.coffee = '[^. \t]\.\%(\h\w*\)\?'
    " let g:neocomplete#sources#omni#input_patterns.cpp = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    " let g:neocomplete#sources#omni#input_patterns.go = '\h\w*\%.'
    " let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    " let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

    let g:neocomplete#force_overwrite_completefunc = 1
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

" " clang_clomplete {{{
"     if exists('g:vice.neocompletion.enable_clang_complete')
"         call vice#Extend({
"             \ 'ft_addons': {
"                 \ 'c$\|cpp': [
"                     \ 'github:Rip-Rip/clang_complete',
"                 \ ],
"             \ },
"         \ })
"         let g:clang_complete_auto = 1
"         let g:clang_auto_select = 1
"         let g:clang_auto_user_options = "path, .clang_complete"
"         let g:clang_complete_copen = 0
"         let g:clang_complete_macros = 1
"         let g:clang_complete_patterns = 0
"         let g:clang_hl_errors = 1
"         let g:clang_periodic_quickfix = 0
"         let g:clang_snippets = 0
"         let g:clang_sort_algo = "priority"
"         let g:clang_use_library = 1
"         let g:clang_user_options = ""
"         if has('mac')
"             let g:clang_library_path = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib"
"         endif
"     endif
" " }}}

" " jedi {{{
"     if exists('g:vice.neocompletion.enable_jedi')
"         call vice#Extend({
"             \ 'ft_addons': {
"                 \ 'python': [
"                     \ 'github:davidhalter/jedi-vim',
"                 \ ],
"             \ },
"         \ })
"         au FileType python let b:did_ftplugin = 1
"         let g:neocomplete#force_omni_input_patterns['python'] = '[^. \t]\.\w*'
"         let g:neocomplete#sources#omni#functions['python'] = 'jedi#complete'
"         set ofu=syntaxcomplete#Complete
"         let g:jedi#popup_on_dot = 0
"     endif
" " }}}

" " necoghc {{{
"     if exists('g:vice.neocompletion.enable_necoghc')
"         call vice#Extend({
"             \ 'ft_addons': {
"                 \ 'haskell': [
"                     \ 'github:ujihisa/neco-ghc',
"                 \ ],
"             \ },
"         \ })
"         au FileType haskell setl omnifunc=necoghc#omnifunc
"     endif
" " }}}
