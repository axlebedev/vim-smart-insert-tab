" cindent() doesn't work correctly always
function! s:GetActualCIndent() 
    normal! Ox
    let res = indent('.')
    normal! dd
    return res
endfunction

function! SmartInsertTab()
    let curLine = getline('.')
    let curPos = col('.')
    let curIndent = indent('.')
    let lineBeforeCur = curLine[0:curPos - 1]
    let lineAfterCur = curLine[curPos:]

    " When insert-mode cursor stands between first and second char in line -
    " curPos() equal '1' in both cases.
    " OK, leave a bug...
    if (curPos == 1)
        let lineBeforeCur = ''
        let lineAfterCur = curLine
    endif

    " indent an empty line
    if (len(curLine) == 0) 
        " leave one character to make vim not clear whitespace line again...
        normal! ccx
        " ...ok, now we can remove it...
        normal! x
        " ...and start insert mode
        startinsert!

    " indent a line with content, if cursor stays before content
    elseif (curPos <= curIndent && curIndent < s:GetActualCIndent())
        " trim spaces at lineAfterCur begin
        let lineAfterCur = lineAfterCur[match(lineAfterCur, '\v\S'):]
        execute 'normal! cc'.lineAfterCur."\<esc>^"
        startinsert

    " simply insert tab
    else
        let insCmd = curPos <= curIndent ? 'i' : 'a'
        execute "normal! ".insCmd."\<Tab>"
        normal! l
        if (curPos < len(curLine))
            startinsert
        else
            startinsert!
        endif
    endif
endfunction
