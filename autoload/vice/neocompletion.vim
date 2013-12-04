" Close popup and save indent. Supports delimitmate, if it's installed.
func! vice#neocomplcache#AutoClosePopup()
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

func! vice#neocomplete#AutoClosePopup()
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
