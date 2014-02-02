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

function! Notes_FoldMethod(lnum)
  let line=getline(a:lnum)
  let level = strlen(matchstr(line, '\v#+'))
  if level > 0
    return ">" . level
  else
    return "="
  endif
endfunc

function! Notes_ShowTodos()
  exec "!"
endfunc
