" Hereinafter: 'Symbol' is read as 'non-whitespace symbol'
if exists("g:loaded_vim_smart_insert_tab") || &cp || v:version < 700
    finish
endif
let g:loaded_vim_smart_insert_tab = 1

" cindent() doesn't work correctly always
function! s:GetActualCIndent()
    let pos = col('.')
    normal! ox
    let res = indent('.')
    execute 'normal! "_ddk'
    call cursor('.', pos)
    return res
endfunction

function! s:GetCursorPosition()
    " cursorPos equal 1 in following cases:
    " - cursor stands at beginning of line
    " - cursor stands between first and second char in line -
    " - cursor stands on recently created line (with `cc` or `O`)
    " OK, leave a bug with case 2...
    let pos = col('.')
    if (pos == 1)
        let pos = 0
    endif
    return pos
endfunction

function! s:GetUndojoinStr() 
    let undojoinStr = 'undojoin|'
    try 
        execute 'undojoin'
    catch
        let undojoinStr = ''
    endtry
    return undojoinStr
endfunction

function! SmartInsertTab()
    echom 's:GetUndojoinStr()='.s:GetUndojoinStr()

    let line = getline('.')
    let neededIndent = s:GetActualCIndent()
    let cursorPos = s:GetCursorPosition()

    let haveSymbolsBeforeCursor = 
\       cursorPos != 0 && match(line[:cursorPos - 1], '\v\S') > -1

    if (cursorPos >= neededIndent || indent('.') >= neededIndent || haveSymbolsBeforeCursor)
        let insCmd = cursorPos == 0 ? 'i' : 'a'
        execute s:GetUndojoinStr()."normal! ".insCmd."\<Tab>"
        normal! l
        execute s:GetUndojoinStr().'startinsert'.(cursorPos == len(line) ? '!' : '')
    else
        let isWhitespaceLine = match(line, '\v\S') == -1
        if (!isWhitespaceLine) " if not whitespace line
            execute s:GetUndojoinStr()."normal! ==\<esc>^"
            startinsert
        else
            let numOfTabs = neededIndent / &tabstop
            execute s:GetUndojoinStr()."normal! \"_ddO\<esc>".numOfTabs."a\<Tab>"
            startinsert!
        endif
    endif
endfunction
