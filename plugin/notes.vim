if !exists("g:notes_open_command")
  let g:notes_open_command = "open"
endif

if !exists("g:notes_browse_command")
  let g:notes_browse_command = "open"
endif

function! Notes_ToggleComplete()
  let line = getline('.')
  if line =~ "DONE"
    s/DONE/TODO/
    s/ *(AT:.*$//
  elseif line =~ "TODO"
    s/TODO/DONE/
    let text = " (AT: " . strftime("%Y-%m-%d %H:%M") .")"
    exec "normal A" . text
    normal _
  endif
endfunc

function! Notes_ToggleCancel()
  let line = getline('.')
  if line =~ "CANCELLED"
    s/CANCELLED/TODO/
    s/ *(AT:.*$//
  elseif line =~ "TODO"
    s/TODO/CANCELLED/
    let text = " (AT: " . strftime("%Y-%m-%d %H:%M") .")"
    exec "normal A" . text
    normal _
  endif
endfunc

function! Notes_FoldExpr(lnum)
  let line=getline(a:lnum)
  let level = strlen(matchstr(line, '\v^#+'))
  if level > 0
    return ">" . level
  else
    return "="
  endif
endfunc

function! Notes_ShowTodos()
  vimgrep '\v(^#|TODO)' %
  copen
endfunc

func! Notes_NavigateToUrl()
  let url = Notes_GetUrlInLine()
  if url != ''
    call system(g:notes_browse_command . ' "' . url . '"')
  endif
endfunc

func! Notes_Copy()
  let url = Notes_GetUrlInLine()
  if url != ''
    let @*= url
  else
    let @*= getline('.')
  endif
endfunc

func! Notes_GetUrlInLine()
  let url = matchstr(getline('.'), '\vhttps?[^ )\]]+')
  if url == ''
    let url = matchstr(getline('.'), '\v\<(.+)\>')
    if url != ''
      let url = 'http://' . strpart(url, 1, strlen(url) - 2)
    endif
  endif
  return url
endfunc
