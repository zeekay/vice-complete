" Enable neocomplete
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

    let g:neocomplete#auto_completion_start_length      = 3
    let g:neocomplete#enable_at_startup                 = 1
    let g:neocomplete#enable_prefetch                   = 1
    let g:neocomplete#enable_smart_case                 = 1
    let g:neocomplete#sources#buffer#cache_limit_size   = 500000
    let g:neocomplete#sources#syntax#min_keyword_length = 3

    " <CR> closes popup
    inoremap <expr><CR> vice#neocomplete#smart_cr()

    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

    " Make arrow keys work properly in popup
    inoremap <expr><Up> pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr><Down> pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr><Left> neocomplete#cancel_popup() . "\<Left>"
    inoremap <expr><Right> neocomplete#cancel_popup() . "\<Right>"

    inoremap <expr>OA pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr>OB pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr>OD neocomplete#cancel_popup() . "\<Left>"
    inoremap <expr>OC neocomplete#cancel_popup() . "\<Right>"

    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><space> vice#neocomplete#smart_space()

    " we don't want the completion menu to auto pop-up when we are in text files
    let g:neocomplete#lock_buffer_name_pattern = '\v(\.md|\.txt|\.git\/COMMIT_EDITMSG)'

    " Define keyword.
    let g:neocomplete#keyword_patterns.default = '\h\w*'
    let g:neocomplete#keyword_patterns.html    = '</\?\%([[:alnum:]_:-]\+\s*\)\?\%(/\?>\)\?\|&\h\%(\w*;\)\?\|\h[[:alnum:]_:-]*'

    " Enable heavy omni completion, which require computational power and may stall the vim.
    let g:neocomplete#sources#omni#input_patterns.c          = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.coffee     = '\h\w*\|[^. \t]\.\w*'
    let g:neocomplete#sources#omni#input_patterns.cpp        = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.javascript = '\h\w*\|[^. \t]\.\w*'
    let g:neocomplete#sources#omni#input_patterns.perl       = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.php        = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.ruby       = '[^. *\t]\.\h\w*\|\h\w*::'

endf

" Closes popup even when delimitemate is used.
func! vice#neocomplete#smart_cr()
    if pumvisible()
        call neocomplete#smart_close_popup()
    endif

    " If delimitMate_expand_cr is set, call manually
    if exists('g:delimitMate_expand_cr') && eval('g:delimitMate_expand_cr')
        if delimitMate#WithinEmptyPair()
            call delimitMate#ExpandReturn()
            return "\<Esc>a\<CR>\<Esc>zvO"
        endif
    endif
    return "\<CR>"
endf

" Closes popup even when delimitemate is used.
func! vice#neocomplete#smart_space()
    if pumvisible()
        call neocomplete#smart_close_popup()
    endif
    return "\<space>"
endf

" Configures C-langs to use clang_complete for completion.
func! vice#neocomplete#enable_clang_complete()
    call vice#Extend({
        \ 'ft_addons': {
            \ 'c$\|cpp': [
                \ 'github:Rip-Rip/clang_complete',
            \ ],
        \ },
    \ })

    let g:neocomplete#force_overwrite_completefunc = 1
	let g:neocomplete#force_omni_input_patterns.c =
	      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
	let g:neocomplete#force_omni_input_patterns.cpp =
	      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
	let g:neocomplete#force_omni_input_patterns.objc =
	      \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
	let g:neocomplete#force_omni_input_patterns.objcpp =
	      \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'

    let g:clang_complete_auto     = 0
    let g:clang_auto_select       = 0
    let g:clang_auto_user_options = 'path, .clang_complete'
    let g:clang_complete_copen    = 0
    let g:clang_complete_macros   = 1
    let g:clang_complete_patterns = 0
    let g:clang_hl_errors         = 1
    let g:clang_periodic_quickfix = 0
    let g:clang_snippets          = 0
    let g:clang_sort_algo         = 'priority'
    let g:clang_user_options      = ''

    if has('mac')
        let g:clang_use_library       = 1
        let g:clang_library_path = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib"
    endif
endf

" Configures Python completion to use jedi.
func! vice#neocomplete#enable_jedi()
    au FileType python call vice#ForceActivateAddon('github:davidhalter/jedi-vim')


    au FileType python let b:did_ftplugin = 1
    au FileType python setl completeopt-=preview
    au FileType python setl omnifunc=jedi#completions
    au FileType python nnoremap <buffer> <leader>d :call vice#neocompletion#jedi_show_documentation()<cr>

    " Needed for neocomplete/neocomplcache
	let g:jedi#auto_vim_configuration   = 0
	let g:jedi#completions_enabled      = 0
    let g:jedi#completions_command      = ''

    " Call signatures
    au FileType python setl noshowmode  " Not sure this can even be set local?
    let g:jedi#show_call_signatures     = 2

    let g:jedi#auto_initialization      = 1
    let g:jedi#documentation_command    = '<leader>d'
    let g:jedi#goto_assignments_command = 'gd'
    let g:jedi#goto_definitions_command = 'gD'
    let g:jedi#popup_on_dot             = 0
    let g:jedi#popup_select_first       = 0
    let g:jedi#rename_command           = '<leader>jr'
    let g:jedi#usages_command           = '<leader>ju'
    let g:jedi#use_splits_not_buffers   = 'right'
    let g:jedi#use_tabs_not_buffers     = 0

	let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
endf

" Configures Haskell completion to use necoghc.
func! vice#neocomplete#enable_necoghc()
    au FileType haskell call vice#ForceActivateAddon('github:eagletmt/neco-ghc')
    au FileType haskell setl omnifunc=necoghc#omnifunc

    let g:necoghc_enable_detailed_browse = 1
endf

" Configures neosnippet.
func! vice#neocomplete#enable_neosnippet()
    call vice#Extend({
        \ 'addons': [
            \ 'github:Shougo/neosnippet',
        \ ],
    \ })

    imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" :
endf

" Configures CoffeeScript/JavaScript to use tern for completion. CoffeeScript
" support requires https://github.com/othree/tern-coffee to be installed.
func! vice#neocomplete#enable_tern()
    au FileType coffee,javascript call vice#ForceActivateAddon('github:marijnh/tern_for_vim')

    " JavaScript
    let g:neocomplete#sources#omni#functions.javascript = 'tern#Complete'
    let g:neocomplete#sources#omni#input_patterns.javascript = '\h\w*\|[^. \t]\.\w*'

    " CoffeeScript
    let g:neocomplete#sources#omni#functions.coffee = 'tern#Complete'
    let g:neocomplete#sources#omni#input_patterns.coffee = '\h\w*\|[^. \t]\.\w*'
    au FileType coffee call tern#Enable()

    let g:tern_show_signature_in_pum = 1
    let g:tern_map_keys = 0
endf

" Enable Racer for rust completion
func! vice#neocomplete#enable_racer()
    au FileType rust call vice#ForceActivateAddon('github:zeekay/vim-racer')
    let g:neocomplete#sources#omni#functions.rust = 'racer#Complete'
    let g:neocomplete#force_omni_input_patterns.rust = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
endf
