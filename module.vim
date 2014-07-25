if version < 702
    echoerr 'vice-neocompletion requires vim 7.2 or newer'
    finish
endif

if !exists('g:vice.neocompletion')
    let g:vice.neocompletion = {}
endif

let g:vice.neocompletion.features = ['necoghc', 'jedi', 'tern', 'neosnippet', 'clang_complete']

" Default all features to off
for feature in g:vice.neocompletion.features
    if !exists('g:vice.neocompletion.enable_'.feature)
        exe 'let g:vice.neocompletion.enable_'.feature.' = 0'
    endif
endfor

" Enable neocompletion configurations for given mode.
func! s:enable_mode(mode)
    exe 'call vice#'.a:mode.'#enable()'

    for feature in g:vice.neocompletion.features
        if eval('g:vice.neocompletion.enable_'.feature)
            exe 'call vice#'.a:mode.'#enable_'.feature.'()'
        endif
    endfor
endf

" Use newer neocomplete if lua is available.
if has('lua')
    call s:enable_mode('neocomplete')
else
    call s:enable_mode('neocomplcache')
endif
