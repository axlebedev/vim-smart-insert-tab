function! SmartInsertTab()
    let curLine = getline('.')
;
    let curPos = col('.')
    let lineBeforeCur = curLine[0:curPos - 1]
    let lineAfterCur = curLine[curPos:]

    " When insert-mode cursor stands between first and second char in line -
    " curPos() equal '1' in both cases.
    " OK, leave a bug...
    if (curPos == 1)
        let lineBeforeCur = ''
        let lineAfterCur = curLine
    endif

    if (curPos <= indent('.') && indent('.') < cindent('.'))
        " trim spaces at lineAfterCur begin
        let lineAfterCur = lineAfterCur[match(lineAfterCur, '\v\S'):]
        execute 'normal! cc'.lineAfterCur."\<esc>^"
        startinsert
    else
        let insCmd = curPos == 1 ? 'i' : 'a'
        execute "normal! ".insCmd."\<Tab>"
        normal! l
        startinsert
    endif
endfunction
