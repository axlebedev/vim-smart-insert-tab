if exists("g:loaded_vim_smart_insert_tab") || &cp || v:version < 700
    finish
endif
let g:loaded_vim_smart_insert_tab = 1

let s:undefined = 'undefined'
let s:smartInsertTabFallback = get(g:, 'smartInsertTabFallback', s:undefined)
let s:smartInsertBackspaceFallback = get(g:, 'smartInsertBackspaceFallback', s:undefined)

" returns 0 if it is empty line
function! s:GetCursorPosition()
    if (strwidth(getline('.')) == 0)
        return 0
    endif

    return col('.')
endfunction

function! s:GetCurrentLineIsWhitespace()
    return getline('.') =~ '\v^\s+$'
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

let s:emptyArrayLengthCache = s:undefined
let s:emptyArrayCache = s:undefined

function! s:GetEmptyArray(length) abort
    if (a:length == s:emptyArrayLengthCache)
        return s:emptyArrayCache
    endif

    let result = []
    let i = 0
    while i < a:length
        call add(result, '')
        let i = i + 1
    endwhile

    let s:emptyArrayLengthCache = a:length
    let s:emptyArrayCache = result
    return result
endfunction

function! SmartInsertTab()
    let line = getline('.')
    let neededIndent = cindent('.')
    let cursorPos = s:GetCursorPosition()

    if (cursorPos < neededIndent && indent('.') < neededIndent && !s:GetHaveSymbolsBeforeCursor())
        " process plugin work
        undojoin | call setline(line('.'), '')
        undojoin | call feedkeys(join(s:GetEmptyArray(neededIndent + 1), ' '), 'n')

        return ""
    endif

    if (s:smartInsertTabFallback != s:undefined)
        return function(s:smartInsertTabFallback)()
    endif

    " do nothing, default <Tab> char insert
    return "\<Tab>"
endfunction

function! SmartInsertBackspace()
    let line = getline('.')
    let cursorPos = s:GetCursorPosition()

    if (s:GetCurrentLineIsWhitespace())
        if (cursorPos > line->len()) " if cursor is at last column of line
            undojoin
            return "\<C-o>0d$"
        endif
        " process plugin work
        undojoin
        return "\<C-o>d0"
    elseif (!s:GetHaveSymbolsAfterCursor() && s:GetSymbolUnderCursor() =~ '\s')
        " process plugin work
        undojoin
        return "\<C-o>diw"
    endif

    if (s:smartInsertBackspaceFallback != s:undefined)
        return function(s:smartInsertBackspaceFallback)()
    endif

    " do nothing, default <BS> char insert
    return "\<BS>"
endfunction
