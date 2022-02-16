if exists("g:loaded_vim_smart_insert_tab") || &cp || v:version < 700
    finish
endif
let g:loaded_vim_smart_insert_tab = 1

let s:smartInsertTabFallback = get(g:, 'smartInsertTabFallback', 'undefined')
let s:smartInsertTabBackspaceFallback = get(g:, 'smartInsertTabBackspaceFallback', 'undefined')

" returns 0 if it is empty line
function! s:GetCursorPosition()
    return min([
\     col('.'),
\     strwidth(getline('.'))
\     ])
endfunction

function! s:GetSymbolUnderCursor()
    return matchstr(getline('.'), '\%'.(col('.') - 1).'c.')
endfunction

function! s:GetHaveSymbolsBeforeCursor()
    return getline('.')[0:col('.') - 2] =~ '\S'
endfunction

function! s:GetHaveSymbolsAfterCursor()
    return getline('.')[col('.'):] =~ '\S'
endfunction


function! SmartInsertTab()
    let line = getline('.')
    let neededIndent = cindent('.')
    let cursorPos = s:GetCursorPosition()

    if (cursorPos < neededIndent && indent('.') < neededIndent && !s:GetHaveSymbolsBeforeCursor())
        " process plugin work
        return "\<C-f>"
    endif

    if (s:smartInsertTabFallback != 'undefined')
        return function(s:smartInsertTabFallback)()
    endif

    " do nothing, default <Tab> char insert
    return "\<Tab>"
endfunction

function! SmartInsertBackspace()
    let line = getline('.')
    let cursorPos = s:GetCursorPosition()

    if (!s:GetHaveSymbolsAfterCursor() && s:GetSymbolUnderCursor() =~ '\s')
        " process plugin work
        return "\<C-o>diw"
    endif

    if (s:smartInsertTabBackspaceFallback != 'undefined')
        return function(s:smartInsertTabBackspaceFallback)()
    endif

    " do nothing, default <BS> char insert
    return "\<BS>"
endfunction
