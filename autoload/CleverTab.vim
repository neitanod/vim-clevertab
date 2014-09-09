"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! CleverTab#Start()

  augroup CleverTabAu
    autocmd CursorMovedI * if pumvisible() == 0|pclose|autocmd! CleverTabAu CursorMovedI *|autocmd! CleverTabAu InsertLeave *|endif
    autocmd InsertLeave * if pumvisible() == 0|pclose|autocmd! CleverTabAu CursorMovedI *|autocmd! CleverTabAu InsertLeave *|endif
  augroup END

  if !exists("g:CleverTab#next_step_direction")
    let g:CleverTab#next_step_direction="P"
  endif
    echom virtcol('.')
  let g:CleverTab#last_cursor_col=virtcol('.')
  let g:CleverTab#cursor_moved=0
  let g:CleverTab#eat_next=0
  let g:CleverTab#stop=0
  return ""
endfunction

function! CleverTab#Complete(type)
    "echom "type: " . a:type
    let g:CleverTab#cursor_moved=g:CleverTab#last_cursor_col!=virtcol('.')
    if a:type == 'tab'
        if strpart( getline('.'), 0, col('.')-1 ) !~ '\k' " =~ '^\s*$'
            let g:CleverTab#stop=1
            echom "Regular Tab"
            return "\<TAB>"
        endif
    elseif a:type == 'omni' && !pumvisible() && !g:CleverTab#cursor_moved && !g:CleverTab#stop
        " if !&omnifunc
            let g:CleverTab#next_step_direction="N"
            echom "Omni Complete"
            let g:CleverTab#eat_next=1
            return "\<C-X>\<C-O>"
        " endif
    elseif a:type == 'keyword' && !pumvisible() && !g:CleverTab#cursor_moved && !g:CleverTab#stop
        let g:CleverTab#next_step_direction="P"
        echom "Keyword Complete"
        let g:CleverTab#eat_next=1
        return "\<C-X>\<C-P>"
    elseif a:type == 'ultisnips' && !pumvisible() && !g:CleverTab#cursor_moved && !g:CleverTab#stop
      let g:ulti_x = UltiSnips#ExpandSnippet()
      if g:ulti_expand_res
        let g:CleverTab#stop=1
        echom "Ultisnips"
        return g:ulti_x
      endif
        return ""
    elseif a:type == "next"
      if g:CleverTab#stop || g:CleverTab#eat_next==1
        let g:CleverTab#stop=0
        let g:CleverTab#eat_next=0
        return ""
      endif
      if g:CleverTab#next_step_direction=="P"
        return "\<C-P>"
      else 
        return "\<C-N>"
      endif
    elseif a:type == "prev"
      if g:CleverTab#next_step_direction=="P"
        return "\<C-N>"
      else 
        return "\<C-P>"
      endif
    endif
    return ""
endfunction

function! CleverTab#OmniFirst()
  inoremap <silent><tab> <c-r>=CleverTab#Start()<cr><c-r>=CleverTab#Complete('tab')<cr><c-r>=CleverTab#Complete('ultisnips')<cr><c-r>=CleverTab#Complete('omni')<cr><c-r>=CleverTab#Complete('keyword')<cr><c-r>=CleverTab#Complete('next')<cr>
  inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>
endfunction

function! CleverTab#KeywordFirst()
  inoremap <silent><tab> <c-r>=CleverTab#Start()<cr><c-r>=CleverTab#Complete('tab')<cr><c-r>=CleverTab#Complete('ultisnips')<cr><c-r>=CleverTab#Complete('keyword')<cr><c-r>=CleverTab#Complete('omni')<cr><c-r>=CleverTab#Complete('next')<cr>
  inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>
endfunction
