"Vim filetype plugin
" Language: Notes
" Maintainer: David Elentok

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

nnoremap <buffer> <C-M> :call Notes_ToggleComplete()<cr>
nnoremap <buffer> <leader>nt :call Notes_ToggleComplete()<cr>
nnoremap <buffer> <leader>nc :call Notes_ToggleCancel()<cr>

" when pressing enter within a task it creates another task
setlocal comments+=n:☐
setlocal foldexpr=Notes_FoldMethod(v:lnum) foldmethod=expr
