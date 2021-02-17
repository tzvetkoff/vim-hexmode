"
" HexMode
"

" Prevent from loading twice. {{{
if exists("g:hexmode_loaded")
  finish
endif
let g:hexmode_loaded = 1
" }}}

" Configuration. {{{

" }}}

" Toggle function. {{{
function! ToggleHexMode()
  " Save states
  let l:modified = &modified
  let l:readonly = &readonly
  let l:modifiable = &modifiable

  " Set new states
  let &readonly = 0
  let &modifiable = 1

  if !exists("b:hexmode") || !b:hexmode
    " Save previous options
    let b:hexmode_prev_filetype = &filetype
    let b:hexmode_prev_binary = &binary

    " Set new options
    setlocal binary
    silent edit
    let &filetype = "xxd"

    " Switch to hex mode
    let b:hexmode = 1
    %!xxd
  else
    " Restore previous options
    if b:hexmode_prev_binary
      setlocal binary
    else
      setlocal nobinary
    endif
    let &filetype = b:hexmode_prev_filetype

    " Return back to normal mode
    let b:hexmode = 0
    %!xxd -r
  endif

  " Restore states
  let &modified = l:modified
  let &readonly = l:readonly
  let &modifiable = l:modifiable
endfunction
" }}}

" HexMode command. {{{
command HexMode call ToggleHexMode()
cabbrev hex HexMode
" }}}

" Keymap. {{{
if exists("g:HexModeTrigger")
  execute "nnoremap " . g:HexModeTrigger . " :HexMode<CR>"
  execute "inoremap " . g:HexModeTrigger . " <Esc>:HexMode<CR>"
  execute "vnoremap " . g:HexModeTrigger . " :<C-U>HexMode<CR>"
else
  nnoremap <C-H> :HexMode<CR>
  inoremap <C-H> <Esc>:HexMode<CR>
  vnoremap <C-H> :<C-U>HexMode<CR>
endif
" }}}

" ----------------------------------------------------------
" vim:fen:fdm=marker:fmr={{{,}}}:fdl=0:fdc=1:ts=2:sts=2:sw=2
