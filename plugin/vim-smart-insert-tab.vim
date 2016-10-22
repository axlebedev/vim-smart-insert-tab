if exists("g:loaded_vim_smart_insert_tab") || &cp || v:version < 700
    finish
endif
let g:loaded_vim_smart_insert_tab = 1

" col('.') equal 1 in following cases:
" - cursor stands at beginning of line
"   (our func returns 0)
" - cursor stands between first and second char in line 
"   (our func returns 0, it will be a bug)
" - cursor stands on recently created line (with `cc` or `O`)
"   (our func returns 1)
function! s:GetCursorPosition()
    let pos = col('.')
    if (pos == 1)
        let pos = 0
    endif
    return pos
endfunction

" e.g.: MakeCmdString('01', 3) => '010101'
function! s:MakeCmdString(cmd, count)
    let list = []
    let i = 0
    while (i < a:count)
        let list = add(list, a:cmd)
        let i = i + 1
    endwhile
    let res = join(list, '')
    return res
endfunction

function! SmartInsertTab()
    let line = getline('.')
    let neededIndent = cindent('.')
    let cursorPos = s:GetCursorPosition()

    let haveSymbolsBeforeCursor = 
\       cursorPos != 0 && match(line[:cursorPos - 1], '\v\S') > -1

    if (cursorPos >= neededIndent || indent('.') >= neededIndent || haveSymbolsBeforeCursor)
        " do nothing, default <Tab> char insert
        call feedkeys("\<Tab>", 'n')
    else
        " process plugin work
        let firstNonWhitespacePos = match(line, '\v\S')
        if (firstNonWhitespacePos > -1) " if not whitespace line
            " in this case - go to beginning of line and remove all existing
            " starting spaces
            call feedkeys( "\<Home>", 'n')
            while (match(getline('.')[0], '\v\S') == -1)
                call feedkeys( "\<Del>", 'n')
            endwhile
        endif

        let numOfTabs = neededIndent / &tabstop
        call feedkeys(s:MakeCmdString("\<Tab>", numOfTabs), 'n')
    endif

    return ''
endfunction
