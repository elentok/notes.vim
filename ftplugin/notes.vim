"Vim filetype plugin
" Language: Notes
" Maintainer: David Elentok

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

nnoremap <buffer> <leader>nc :call Notes_ToggleCancel()<cr>
nnoremap <buffer> <leader>nt :call Notes_ShowTodos()<cr>
nnoremap <buffer> <leader>nn :call Notes_ExecuteLine()<cr>

" better mapping for Notes_Execute
nnoremap <buffer> ✠ :call Notes_ExecuteLine()<cr>
nnoremap <buffer> Ω :call Notes_ToggleComplete()<cr>

inoremap <buffer> Ω ☐ 

" when pressing enter within a task it creates another task
setlocal comments+=n:☐
setlocal foldexpr=Notes_FoldExpr(v:lnum) foldtext=Notes_FoldText(v:foldstart) foldmethod=expr
