if version < 702
    echoerr 'vice-complete requires vim 7.2 or newer'
    finish
endif

if !exists('g:vice.complete')
    let g:vice.complete = {}
endif

let g:vice.complete.features = [
    \ 'clang_complete',
    \ 'jedi',
    \ 'necoghc',
    \ 'neosnippet',
    \ 'racer',
    \ 'tern',
    \ 'typescript'
\ ]

" Default all features to off
for feature in g:vice.complete.features
    if !exists('g:vice.complete.enable_'.feature)
        exe 'let g:vice.complete.enable_'.feature.' = 0'
    endif
endfor

" Enable complete configurations for given mode.
func! s:enable_mode(mode)
    exe 'call vice#'.a:mode.'#enable()'

    for feature in g:vice.complete.features
        if eval('g:vice.complete.enable_'.feature)
            exe 'call vice#'.a:mode.'#enable_'.feature.'()'
        endif
    endfor
endf

if exists('g:vice.complete.plugin')
    call s:enable_mode(g:vice.complete.plugin)
    finish
endif

" Has neovim or vim 8+
if has('nvim') || version >= 800 && has('python3')
    call s:enable_mode('deoplete')
    finish
endif

" Use lua-powered neocomplete
if has('lua')
    call s:enable_mode('neocomplete')
    finish
endif

" Fallback to neocoplcache
call s:enable_mode('neocomplcache')
