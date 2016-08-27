function! SmartInsertTab()
    let curLine = getline('.')
    let curIndent = cindent('.')
    let whitespaceLineRegex =  '\v^\s{0,'.(curIndent - 1).'}$'

    if (match(curLine, whitespaceLineRegex) > -1)
        " leave one character to make vim not clear whitespace line again...
        normal! ccx
        " ...ok, now we can remove it...
        normal! x
        " ...and start insert mode
        startinsert!
    else
        " 'feedkeys' instead of 'normal' because we want to stay in insert mode
        call feedkeys("a\<Tab>", 'n')
    endif
endfunction
