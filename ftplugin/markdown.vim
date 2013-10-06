" Vim filetype plugin
" Language:		Markdown
" Maintainer:		Tim Pope <vimNOSPAM@tpope.org>

if exists("b:did_ftplugin")
  finish
endif

runtime! ftplugin/html.vim ftplugin/html_*.vim ftplugin/html/*.vim

setlocal comments=fb:*,fb:-,fb:+,n:> commentstring=>\ %s
setlocal formatoptions+=tcqln formatoptions-=r formatoptions-=o
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\\+

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= "|setl cms< com< fo< flp<"
else
  let b:undo_ftplugin = "setl cms< com< fo< flp<"
endif

" Markdown auto lists
function! AutoMDList()
  let line=getline('.')
  let umatches=matchstr(line, '^-')
  let omatches=matchstr(line, '^\d\+\.')
  if empty(umatches) && empty(omatches)
    exec ':normal! o ' | exec ':startinsert!' | call feedkeys("\<right>\<bs>")
  elseif empty(omatches)
    if !empty(matchstr(line, '^-\s\?$'))
      exec ':normal! cc' | exec ':normal! o' | exec ':startinsert!'
    else
      exec ':normal! o- ' | exec ':startinsert!'
    endif
  elseif empty(umatches)
    if !empty(matchstr(line, '^\d\+\.\s\?$'))
      exec ':normal! cc' | exec ':normal! o' | exec ':startinsert!'
    else
      let l:nln=omatches + 1
      exec ':normal! o' . l:nln . '. ' | exec ':startinsert!'
    endif
  endif

  return
endf

au BufEnter *.md inoremap <buffer> <CR> <C-o>:call AutoMDList()<CR>

" vim:set sw=2:
