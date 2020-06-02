" Enable deoplete
func! vice#deoplete#enable()
    call vice#Extend({
        \ 'addons': [
            \ 'roxma/nvim-yarp',
            \ 'roxma/vim-hug-neovim-rpc',
        \ ]
    \ })

    call vice#ForceActivateAddon('github:Shougo/deoplete.nvim')
    call deoplete#custom#option('smart_case', v:true)

    if !exists('g:deoplete#keyword_patterns')
      let g:deoplete#keyword_patterns = {}
    endif

    if !exists('g:deoplete#sources#omni#functions')
        let g:deoplete#sources#omni#functions = {}
    endif

    if !exists('g:deoplete#sources#omni#input_patterns')
      let g:deoplete#sources#omni#input_patterns = {}
    endif

    if !exists('g:deoplete#force_omni_input_patterns')
      let g:deoplete#force_omni_input_patterns = {}
    endif

    let g:deoplete#auto_completion_start_length      = 3
    let g:deoplete#enable_at_startup                 = 1
    let g:deoplete#enable_prefetch                   = 1
    let g:deoplete#sources#buffer#cache_limit_size   = 500000
    let g:deoplete#sources#syntax#min_keyword_length = 3
    let g:deoplete#skip_auto_completion_time         = "1.0"

    " <CR> closes popup
    inoremap <expr><CR> vice#deoplete#smart_cr()

    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

    " Make arrow keys work properly in popup
    inoremap <expr><Up> pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr><Down> pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr><Left> deoplete#cancel_popup() . "\<Left>"
    inoremap <expr><Right> deoplete#cancel_popup() . "\<Right>"

    inoremap <expr>OA pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr>OB pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr>OD deoplete#cancel_popup() . "\<Left>"
    inoremap <expr>OC deoplete#cancel_popup() . "\<Right>"

    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"
    inoremap <expr><space> vice#deoplete#smart_space()

    " we don't want the completion menu to auto pop-up when we are in text files
    let g:deoplete#lock_buffer_name_pattern = '\v(\.md|\.txt|\.git\/COMMIT_EDITMSG)'

    " Define keyword.
    let g:deoplete#keyword_patterns.default = '\h\w*'
    let g:deoplete#keyword_patterns.html    = '</\?\%([[:alnum:]_:-]\+\s*\)\?\%(/\?>\)\?\|&\h\%(\w*;\)\?\|\h[[:alnum:]_:-]*'

    " Enable heavy omni completion, which require computational power and may stall the vim.
    let g:deoplete#sources#omni#input_patterns.c          = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)'
    let g:deoplete#sources#omni#input_patterns.coffee     = '\h\w*\|[^. \t]\.\w*'
    let g:deoplete#sources#omni#input_patterns.cpp        = '\h\w\w*\|[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:deoplete#sources#omni#input_patterns.javascript = '\h\w*\|[^. \t]\.\w*'
    let g:deoplete#sources#omni#input_patterns.perl       = '\h\w*->\h\w*\|\h\w*::'
    let g:deoplete#sources#omni#input_patterns.php        = '[^. \t]->\h\w*\|\h\w*::'
    let g:deoplete#sources#omni#input_patterns.ruby       = '[^. *\t]\.\h\w*\|\h\w*::'
endf

" Closes popup even when delimitemate is used.
func! vice#deoplete#smart_cr()
    if pumvisible()
        call deoplete#smart_close_popup()
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
func! vice#deoplete#smart_space()
    if pumvisible()
        call deoplete#smart_close_popup()
    endif
    return "\<space>"
endf

" Configures C-langs to use clang_complete for completion.
func! vice#deoplete#enable_clang_complete()
    let g:deoplete#force_overwrite_completefunc = 1
	let g:deoplete#force_omni_input_patterns.c =
	      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
	let g:deoplete#force_omni_input_patterns.cpp =
	      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
	let g:deoplete#force_omni_input_patterns.objc =
	      \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
	let g:deoplete#force_omni_input_patterns.objcpp =
	      \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'

    call vice#complete#enable_clang_complete()
endf

" Configures Python completion to use jedi.
func! vice#deoplete#enable_jedi()
    au FileType python call vice#ForceActivateAddon('github:zchee/deoplete-jedi')
    au FileType python let b:did_ftplugin = 1
    au FileType python setl completeopt-=preview
    au FileType python setl omnifunc=jedi#completions
    au FileType python nnoremap <buffer> <leader>d :call vice#neocompletion#jedi_show_documentation()<cr>

    " Needed for deoplete/neocomplcache
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

	let g:deoplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
endf

" Configures Haskell completion to use necoghc.
func! vice#deoplete#enable_necoghc()
    au FileType haskell call vice#ForceActivateAddon('github:eagletmt/neco-ghc')
    au FileType haskell setl omnifunc=necoghc#omnifunc

    let g:necoghc_enable_detailed_browse = 1
endf

" Configures C++ completion
func! vice#deoplete#enable_cpp()
    au FileType cpp call vice#ForceActivateAddon('bbchung/Clamp')
endf

" Configures neosnippet.
func! vice#deoplete#enable_neosnippet()
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
func! vice#deoplete#enable_tern()
    au FileType javascript call vice#ForceActivateAddon('github:marijnh/tern_for_vim')

    " JavaScript
    let g:deoplete#sources#omni#functions.javascript = 'tern#Complete'
    let g:deoplete#sources#omni#input_patterns.javascript = '\h\w*\|[^. \t]\.\w*'

    " CoffeeScript (someday)
    " let g:deoplete#sources#omni#functions.coffee = 'tern#Complete'
    " let g:deoplete#sources#omni#input_patterns.coffee = '\h\w*\|[^. \t]\.\w*'
    " au FileType coffee call tern#Enable()
    au FileType coffee     setl omnifunc=javascriptcomplete#CompleteJS

    let g:tern_show_signature_in_pum = 1
    let g:tern_map_keys = 0
endf

" Enable Racer for rust completion
func! vice#deoplete#enable_racer()
    au FileType rust call vice#ForceActivateAddon('github:racer-rust/vim-racer')
    let g:deoplete#sources#omni#functions.rust = 'racer#Complete'
    let g:deoplete#force_omni_input_patterns.rust = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
endf

func! vice#deoplete#enable_typescript()
    if has('nvim')
        au FileType typescript call vice#ForceActivateAddon('github:mhartington/nvim-typescript')
        au FileType typescript setl omnifunc=TSComplete
    else
        au FileType typescript call vice#ForceActivateAddon('github:Quramy/tsuquyomi')
        if has('balloon_eval')
            set ballooneval
            autocmd FileType typescript setlocal balloonexpr=tsuquyomi#balloonexpr()
        endif
        au FileType typescript nmap <buffer> <Leader>h : <C-u>echo tsuquyomi#hint()<CR>
        au FileType typescript setl omnifunc=tsuquyomi#complete
    endif
endf
