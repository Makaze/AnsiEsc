" AnsiEscPlugin.vim
"   Original Author: Charles E. Campbell
"   New Author: Makaze
"   Date:   Apr 19, 2024
"   Version: 1.4.0
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_AnsiEscPlugin")
 finish
endif
let g:loaded_AnsiEscPlugin = "v1.4.0"
let s:keepcpo              = &cpo
set cpo&vim

" ---------------------------------------------------------------------
"  Public Interface: {{{1
com! -bang -nargs=0 AnsiEsc	:call AnsiEsc#AnsiEsc(<bang>0)

au BufReadPost * :call AnsiEsc#BufReadPost()

" DrChip Menu Support: {{{2
if !exists('g:no_drchip_menu') && !exists('g:no_ansiesc_menu')
 if has("gui_running") && has("menu") && &go =~ 'm'
  if !exists("g:DrChipTopLvlMenu")
   let g:DrChipTopLvlMenu= "DrChip."
  endif
  exe 'menu '.g:DrChipTopLvlMenu.'AnsiEsc.Start<tab>:AnsiEsc		:AnsiEsc<cr>'
 endif
endif

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
