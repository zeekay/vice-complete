" Close popup and save indent. Supports delimitmate, if it's installed.
func! vice#neocompletion#AutoClosePopup()
    call neocomplcache#smart_close_popup()
    " If delimitMate_expand_cr is set, call manually
    if exists('g:delimitMate_expand_cr') && eval('g:delimitMate_expand_cr')
        if delimitMate#WithinEmptyPair()
            call delimitMate#FlushBuffer()
            return "\<Esc>a\<CR>\<Esc>zvO"
        endif
    endif
    return "\<CR>"
endf
