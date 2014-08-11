func! vice#neocompletion#jedi_show_documentation()
    call jedi#show_documentation()
    nnoremap <buffer> K <c-u>
endf
