if exists("g:loaded_vim_smart_insert_tab") || &cp || v:version < 700
    finish
endif
let g:loaded_vim_smart_insert_tab = 1

" returns 0 if it is empty line
function! s:GetCursorPosition()
    return min([
\     col('.'),
\     strwidth(getline('.'))
\     ])
endfunction

function! SmartInsertTab()
    let line = getline('.')
    let neededIndent = cindent('.')
    let cursorPos = s:GetCursorPosition()

    let haveSymbolsBeforeCursor = 
\       cursorPos != 0
\    && match(line[:cursorPos - 2], '\v\S') > -1

    if (cursorPos >= neededIndent || indent('.') >= neededIndent || haveSymbolsBeforeCursor)
        " do nothing, default <Tab> char insert
        return "\<Tab>"
    else
        " process plugin work
        return "\<C-f>"
    endif
endfunction
