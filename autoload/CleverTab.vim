"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! CleverTab#Complete(type)
  "echom "type: " . a:type

  if a:type == 'start'
    if has("autocmd")
      augroup CleverTabAu
        autocmd CursorMovedI *  if pumvisible() == 0 && g:CleverTab#autocmd_set|let g:CleverTab#autocmd_set = 0|pclose|call CleverTab#ClearAutocmds()|endif
        autocmd InsertLeave *  if pumvisible() == 0 && g:CleverTab#autocmd_set|let g:CleverTab#autocmd_set = 0|pclose|call CleverTab#ClearAutocmds()|endif
      augroup END
    endif
    if !exists("g:CleverTab#next_step_direction")
      let g:CleverTab#next_step_direction="0"
    endif
    let g:CleverTab#last_cursor_col=virtcol('.')
    let g:CleverTab#cursor_moved=0
    let g:CleverTab#eat_next=0
    let g:CleverTab#autocmd_set=1
    let g:CleverTab#stop=0
    return ""
  endif
  let g:CleverTab#cursor_moved=g:CleverTab#last_cursor_col!=virtcol('.')
  if a:type == 'tab'
    let g:CleverTab#next_step_direction="0"
    if strpart( getline('.'), 0, col('.')-1 ) !~ '\k' " =~ '^\s*$'
      let g:CleverTab#stop=1
      echom "Regular Tab"
      return "\<TAB>"
    endif
  elseif a:type == 'omni' && !pumvisible() && !g:CleverTab#cursor_moved && !g:CleverTab#stop
    if !&omnifunc
      let g:CleverTab#next_step_direction="N"
      echom "Omni Complete"
      let g:CleverTab#eat_next=1
      return "\<C-X>\<C-O>"
    endif
  elseif a:type == 'keyword' && !pumvisible() && !g:CleverTab#cursor_moved && !g:CleverTab#stop
    let g:CleverTab#next_step_direction="P"
    echom "Keyword Complete"
    let g:CleverTab#eat_next=1
    return "\<C-P>"
  elseif a:type == 'neocomplete' && !pumvisible() && !g:CleverTab#cursor_moved && !g:CleverTab#stop
    let g:CleverTab#next_step_direction="N"
    echom "NeoComplete"
    let g:CleverTab#eat_next=1
    return neocomplete#start_manual_complete()
  elseif a:type == 'ultisnips' && !g:CleverTab#cursor_moved && !g:CleverTab#stop
    let g:CleverTab#next_step_direction="0"
    let g:ulti_x = UltiSnips#ExpandSnippet()
    if g:ulti_expand_res
      let g:CleverTab#stop=1
      echom "Ultisnips"
      return g:ulti_x
    endif
    return ""
  elseif a:type == "forcedtab" && !g:CleverTab#stop
    let g:CleverTab#next_step_direction="0"
    let g:CleverTab#stop=1
    return "\<Tab>"
  elseif a:type == "stop" || a:type == "next"
    if g:CleverTab#stop || g:CleverTab#eat_next==1
      let g:CleverTab#stop=0
      let g:CleverTab#eat_next=0
      return ""
    endif
    if g:CleverTab#next_step_direction=="P"
      return "\<C-P>"
    elseif g:CleverTab#next_step_direction=="N"
      return "\<C-N>"
    endif
  elseif a:type == "prev"
    if g:CleverTab#next_step_direction=="P"
      return "\<C-N>"
    elseif g:CleverTab#next_step_direction=="N"
      return "\<C-P>"
    endif
  endif
  return ""
endfunction

function! CleverTab#OmniFirst()
  inoremap <silent><tab> <c-r>=CleverTab#Complete('start')<cr>
                        \<c-r>=CleverTab#Complete('tab')<cr>
                        \<c-r>=CleverTab#Complete('ultisnips')<cr>
                        \<c-r>=CleverTab#Complete('omni')<cr>
                        \<c-r>=CleverTab#Complete('keyword')<cr>
                        \<c-r>=CleverTab#Complete('stop')<cr>
  inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>
endfunction

function! CleverTab#KeywordFirst()
  inoremap <silent><tab> <c-r>=CleverTab#Complete('start')<cr>
                        \<c-r>=CleverTab#Complete('tab')<cr>
                        \<c-r>=CleverTab#Complete('ultisnips')<cr>
                        \<c-r>=CleverTab#Complete('keyword')<cr>
                        \<c-r>=CleverTab#Complete('neocomplete')<cr>
                        \<c-r>=CleverTab#Complete('omni')<cr>
                        \<c-r>=CleverTab#Complete('stop')<cr>
  inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>
endfunction

function! CleverTab#NeoCompleteFirst()
  inoremap <silent><tab> <c-r>=CleverTab#Complete('start')<cr>
                        \<c-r>=CleverTab#Complete('tab')<cr>
                        \<c-r>=CleverTab#Complete('ultisnips')<cr>
                        \<c-r>=CleverTab#Complete('neocomplete')<cr>
                        \<c-r>=CleverTab#Complete('keyword')<cr>
                        \<c-r>=CleverTab#Complete('omni')<cr>
                        \<c-r>=CleverTab#Complete('stop')<cr>
  inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>
endfunction

function! CleverTab#ClearAutocmds()
  autocmd! CleverTabAu InsertLeave *
  autocmd! CleverTabAu CursorMovedI *
endfunction
