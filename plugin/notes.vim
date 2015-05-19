if !exists("g:notes_open_command")
  let g:notes_open_command = "open"
endif

if !exists("g:notes_browse_command")
  let g:notes_browse_command = "open"
endif

if !exists("g:notes_execute_command")
  let g:notes_execute_command = 'tmux new-window "{command}; zsh"'
endif

if !exists("g:notes_header_fold_length")
  let g:notes_header_fold_length = [0, 80, 70, 60, 60, 60, 60]
endif


function! Notes_ToggleComplete()
  let line = getline('.')
  if line =~ "^ *✔"
    s/^\( *\)✔/\1☐/
    s/ *(at: .*$//
  elseif line =~ "^ *☐"
    s/^\( *\)☐/\1✔/
    let text = " (at: " . strftime("%Y-%m-%d %H:%M") .")"
    exec "normal A" . text
    normal _
  endif
endfunc

function! Notes_ToggleCancel()
  let line = getline('.')
  if line =~ "^ *✘"
    s/^\( *\)✘/\1☐/
    s/ *(at: .*$//
  elseif line =~ "^ *☐"
    s/^\( *\)☐/\1✘/
    let text = " (at: " . strftime("%Y-%m-%d %H:%M") .")"
    exec "normal A" . text
    normal _
  endif
endfunc

function! Notes_FoldExpr(lnum)
  let line = getline(a:lnum)
  let expr = Notes_HeadersFoldExpr(a:lnum, line)
  if expr == '='
    let expr = Notes_IndentFoldExpr(a:lnum, line)
  endif
  return expr
endfunc

function! Notes_HeadersFoldExpr(lnum, line)
  let level = strlen(matchstr(a:line, '\v^#+'))
  if level > 0
    return ">" . level
  else
    return "="
  endif
endfunc

" IndentFoldExpr {{{1
function! Notes_IndentFoldExpr(lnum, line)
  if a:line =~ '\v^ *$'
    return '='
  endif

  let expr = '='
  let level = strlen(matchstr(a:line, '\v^ *'))

  let next_lnum = GetNextNonEmptyLine(a:lnum)
  if next_lnum != -1
    let next_line = getline(next_lnum)
    let next_level = strlen(matchstr(next_line, '\v^ *'))
    if next_level > level
      let expr = 'a' . (next_level - level) / &tabstop
    elseif level > next_level
      let expr = 's' . (level - next_level) / &tabstop
    endif
  endif
  return expr
endfunc

function! GetNextNonEmptyLine(lnum)
  let lnum = a:lnum
  while lnum < line('$')
    let lnum = lnum + 1
    let line = getline(lnum)
    if line !~ '\v^ *$'
      return lnum
    endif
  endwhile
  return -1
endfunc

function! Notes_FoldText(foldstart)
  let line = getline(a:foldstart)
  let level = strlen(matchstr(line, '\v^#+'))
  if level > 0
    let length = g:notes_header_fold_length[level] - 1 - strlen(line)
    if length > 0
      let line = line . ' ' . repeat('-', length)
    endif
  endif
  return line
endfunc

function! Notes_ShowTodos()
  vimgrep '\v(^#[^#]|☐)' %
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
