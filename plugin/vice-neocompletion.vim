if version < 702
    echoerr 'vice-neocompletion requires vim 7.2 or newer'
    finish
endif

if exists('g:vice.neocompletion.loaded')
    finish
else
    let g:vice.neocompletion = {'loaded': 1}
endif

call vice#Extend({
    \ 'addons': [
        \ 'github:Shougo/neocomplcache',
        \ 'github:Shougo/neosnippet',
    \ ],
    \ 'ft_addons': {
        \ 'c$\|cpp': [
            \ 'github:Rip-Rip/clang_complete',
            \ 'github:osyo-manga/neocomplcache-clang-complete',
            \ ],
        \ 'coffee\|javascript': [
            \ 'github:teramako/jscomplete-vim',
            \ ],
        \ 'haskell': [
            \ 'github:ujihisa/neco-ghc',
        \ ],
    \ },
\ })

au FileType c setl omnifunc=ccomplete#Complete
au FileType coffee,javascript setl omnifunc=jscomplete#CompleteJS
au FileType css setl omnifunc=csscomplete#CompleteCSS
au FileType haskell setl omnifunc=necoghc#omnifunc
au FileType php setl omnifunc=phpcomplete#CompletePHP
au FileType python setl omnifunc=pythoncomplete#Complete
au FileType ruby,eruby setl omnifunc=rubycomplete#Complete
au FileType xhtml,html setl omnifunc=htmlcomplete#CompleteTags
au FileType xml setl omnifunc=xmlcomplete#CompleteTags

" jscomplete-vim {{{
let g:jscomplete_use = ['dom', 'moz', 'es6th']
" }}}

" neocomplcache {{{
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_min_syntax_length = 3
    let g:neocomplcache_auto_completion_start_length = 3
    let g:neocomplcache_source_disable = {'include_complete' : 1, 'filename_complete' : 0, 'snippets_complete': 1}
    let g:neocomplcache_snippets_disable_runtime_snippets = 1


    " Define keyword.
    if !exists('g:neocomplcache_keyword_patterns')
      let g:neocomplcache_keyword_patterns = {}
    endif

    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
    inoremap <expr><CR> vice#neocompletion#AutoClosePopup()

    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><space> pumvisible() ? neocomplcache#smart_close_popup()."\<space>" : "\<space>"

    " we don't want the completion menu to auto pop-up when we are in text files
    let g:neocomplcache_lock_buffer_name_pattern = '\v(\.md|\.txt)'

    " Enable heavy omni completion.
    if !exists('g:neocomplcache_omni_patterns')
      let g:neocomplcache_omni_patterns = {}
    endif

    let g:neocomplcache_omni_patterns.c = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_omni_patterns.coffee = '[^. \t]\.\%(\h\w*\)\?'
    let g:neocomplcache_omni_patterns.cpp = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplcache_omni_patterns.go = '\h\w*\%.'
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
" }}}

" necoghc {{{
    au FileType haskell setl omnifunc=necoghc#omnifunc
" }}}

" clang_clomplete {{{
    let g:neocomplcache_force_overwrite_completefunc = 1
    let g:clang_complete_auto = 1
    let g:clang_auto_select = 1
    let g:clang_auto_user_options = "path, .clang_complete"
    let g:clang_complete_copen = 0
    let g:clang_complete_macros = 1
    let g:clang_complete_patterns = 0
    " let g:clang_exec = "clang"
    let g:clang_hl_errors = 1
    " let g:clang_library_path = "/usr/local/lib"
    let g:clang_periodic_quickfix = 0
    let g:clang_snippets = 0
    let g:clang_sort_algo = "priority"
    let g:clang_use_library = 1
    let g:clang_user_options = ""
" }}}
