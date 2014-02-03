if !exists("g:notes_open_command")
  let g:notes_open_command = "open"
endif

if !exists("g:notes_browse_command")
  let g:notes_browse_command = "open"
endif

if !exists("g:notes_execute_command")
  let g:notes_execute_command = 'tmux new-window "{command}; zsh"'
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

func! Notes_ExecuteLine()
  if Notes_ExecuteCommand() == 0
    call Notes_NavigateToUrl()
  endif
endfunc

func! Notes_ExecuteCommand()
  let cmd = Notes_GetCommandInLine()
  if cmd != ''
    let cmd = substitute(g:notes_execute_command, "{command}", cmd, "")
    call system(cmd)
    return 1
  else
    return 0
  end
endfunc

func! Notes_NavigateToUrl()
  let url = Notes_GetUrlInLine()
  if url != ''
    call system(g:notes_browse_command . ' "' . url . '"')
    return 1
  else
    return 0
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

func! Notes_GetCommandInLine()
  let cmd = matchstr(getline('.'), '\v`(.+)`')
  if cmd != ''
    let cmd = strpart(cmd, 1, strlen(cmd) - 2)
  end
  return cmd
endfunc

func! Notes_GetUrlInLine()
  let url = matchstr(getline('.'), '\v\<(.+)\>')
  if url != ''
    let url = strpart(url, 1, strlen(url) - 2)
    if ! (url =~ '://')
      let url = 'http://' . url
    endif
  else
    let url = matchstr(getline('.'), '\vhttps?[^ )\]]+')
  endif
  return url
endfunc
