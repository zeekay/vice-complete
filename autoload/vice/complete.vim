func! vice#complete#jedi_show_documentation()
    call jedi#show_documentation()
    nnoremap <buffer> K <c-u>
endf

func! vice#complete#enable_clang_complete()
    " I tend to switch back and forth between:
    "   - github:Shougo/deoplete-clangx
    "   - github:justmao945/vim-clang
    "   - github:xavierd/clang_complete
    "   - github:ycm-core/YouCompleteMe

    call vice#Extend({
        \ 'ft_addons': {
            \ 'c$\|cpp': [
                \ 'github:ycm-core/YouCompleteMe',
            \ ],
        \ },
    \ })

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
        let brew_path  = '/usr/local/lib/libclang.dylib'
        let xcode_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'

        if !exists('g:clang_library_path')
            let g:clang_library_path = ''
        endif

        " Bail out if it's already been set by a user
        if !empty(g:clang_library_path)
            return
        endif

        " Try to guess libclang path
        if filereadable(brew_path.'/libclang.dylib')
            let g:clang_library_path = brew_path
            let g:clang_use_library = 1
            return
        endif

        if filereadable(xcode_path.'/libclang.dylib')
            let g:clang_library_path = xcode_path
            let g:clang_use_library = 1
        endif
    endif
endf
