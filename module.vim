if version < 702
    echoerr 'vice-neocompletion requires vim 7.2 or newer'
    finish
endif

if !exists('g:vice.neocompletion')
    let g:vice.neocompletion = {}
endif

" Disable auto complete
if exists('g:vice.neocompletion.disable_auto_complete')
    let g:neocomplcache_disable_auto_complete = 1
    let g:neocomplete#disable_auto_complete = 1
    finish
endif

if has('lua')
    " use newer neocomplete.vim if compiled with lua support
    call vice#neocomplete#enable()
else
    " use older neocomplcache settings
    call vice#neocomplcache#enable()
endif
