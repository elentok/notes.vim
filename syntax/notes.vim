" Vim syntax file
" Language: Notes
" Maintainer: David Elentok
" Filenames: *.notes


if exists("b:current_syntax")
  finish
endif

hi def link notesTask Statement
hi def link notesCompleteTask Comment
hi def link notesContext Question
hi def link notesLine Function
hi def link notesCommand Type
hi def link notesLink PreProc

syn match notesTask "^\s*☐"
syn match notesCompleteTask "✔.*"
syn match notesContext "@[^ ]*"
syn match notesLine "^----*"
syn match notesLink "\vhttps?:[^ ]+"
syn match notesLink "\v\<[^\>]+\>"
syn match notesCommand "\v`[^\>]+`"

syn match notesHeader3 "^###.*$"
syn match notesHeader2 "^##.*$"
syn match notesHeader1 "^#.*$"

hi def link notesHeader1 Function
hi def link notesHeader2 Directory
hi def link notesHeader3 Directory
