if exists("g:loaded_vim_smart_insert_tab") || &cp || v:version < 700
    finish
endif
let g:loaded_vim_smart_insert_tab = 1

" col('.') equal 1 in following cases:
" - cursor stands at beginning of line
"   (this func returns 0)
" - cursor stands between first and second char in line 
"   (this func returns 0, it's a bug)
" - cursor stands on recently created line (with `cc` or `O`)
"   (this func returns 1)
function! s:GetCursorPosition()
    let pos = col('.')
    if (pos == 1)
        return 0
    endif
    return pos
endfunction

function! SmartInsertTab()
    let line = getline('.')
    let neededIndent = cindent('.')
    let cursorPos = s:GetCursorPosition()

    let haveSymbolsBeforeCursor = 
\       cursorPos != 0 && match(line[:cursorPos - 1], '\v\S') > -1

    if (cursorPos >= neededIndent || indent('.') >= neededIndent || haveSymbolsBeforeCursor)
        " do nothing, default <Tab> char insert
        return "\<Tab>"
    else
        " process plugin work
        return "\<C-f>"
    endif
endfunction
