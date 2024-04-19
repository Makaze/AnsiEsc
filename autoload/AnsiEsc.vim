" AnsiEsc.vim: Uses vim 7.0 syntax highlighting
" Language:		Text with ansi escape sequences
" Maintainer:	Charles E. Campbell <NdrOchipS@PcampbellAfamily.Mbiz>
" Version:		13i	ASTRO-ONLY
" Date:		Apr 02, 2015
"
" Usage: :AnsiEsc  (toggles)
" Note:   This plugin requires +conceal
"
" GetLatestVimScripts: 302 1 :AutoInstall: AnsiEsc.vim
"redraw!|call DechoSep()|call inputsave()|call input("Press <cr> to continue")|call inputrestore()
" ---------------------------------------------------------------------
"DechoRemOn
"  Load Once: {{{1
if exists("g:loaded_AnsiEsc")
 finish
endif
let g:loaded_AnsiEsc = "v13i"
if v:version < 700
 echohl WarningMsg
 echo "***warning*** this version of AnsiEsc needs vim 7.0"
 echohl Normal
 finish
endif
let s:keepcpo= &cpo
set cpo&vim

" ---------------------------------------------------------------------
" AnsiEsc#AnsiEsc: toggles ansi-escape code visualization {{{2
fun! AnsiEsc#AnsiEsc(rebuild)
"  call Dfunc("AnsiEsc#AnsiEsc(rebuild=".a:rebuild.")")
  if a:rebuild
"   call Decho("rebuilding AnsiEsc tables")
   call AnsiEsc#AnsiEsc(0)
   call AnsiEsc#AnsiEsc(0)
"   call Dret("AnsiEsc#AnsiEsc")
   return
  endif
  let bn= bufnr("%")
  if !exists("s:AnsiEsc_enabled_{bn}")
   let s:AnsiEsc_enabled_{bn}= 0
  endif
  if s:AnsiEsc_enabled_{bn}
   " disable AnsiEsc highlighting
"   call Decho("disable AnsiEsc highlighting: s:AnsiEsc_ft_".bn."<".s:AnsiEsc_ft_{bn}."> bn#".bn)
   if exists("g:colors_name")|let colorname= g:colors_name|endif
   if exists("s:conckeep_{bufnr('%')}")|let &l:conc= s:conckeep_{bufnr('%')}|unlet s:conckeep_{bufnr('%')}|endif
   if exists("s:colekeep_{bufnr('%')}")|let &l:cole= s:colekeep_{bufnr('%')}|unlet s:colekeep_{bufnr('%')}|endif
   if exists("s:cocukeep_{bufnr('%')}")|let &l:cocu= s:cocukeep_{bufnr('%')}|unlet s:cocukeep_{bufnr('%')}|endif
   hi! link ansiStop NONE
   syn clear
   hi  clear
   syn reset
   exe "set ft=".s:AnsiEsc_ft_{bn}
   if exists("colorname")|exe "colors ".colorname|endif
   let s:AnsiEsc_enabled_{bn}= 0
   if !exists('g:no_drchip_menu') && !exists('g:no_ansiesc_menu')
    if has("gui_running") && has("menu") && &go =~# 'm'
     " menu support
     exe 'silent! unmenu '.g:DrChipTopLvlMenu.'AnsiEsc'
     exe 'menu '.g:DrChipTopLvlMenu.'AnsiEsc.Start<tab>:AnsiEsc		:AnsiEsc<cr>'
    endif
   endif
   if !has('conceal')
    let &l:hl= s:hlkeep_{bufnr("%")}
   endif
"   call Dret("AnsiEsc#AnsiEsc")
   return
  else
   let s:AnsiEsc_ft_{bn}      = &ft
   let s:AnsiEsc_enabled_{bn} = 1
"   call Decho("enable AnsiEsc highlighting: s:AnsiEsc_ft_".bn."<".s:AnsiEsc_ft_{bn}."> bn#".bn)
   if !exists('g:no_drchip_menu') && !exists('g:no_ansiesc_menu')
    if has("gui_running") && has("menu") && &go =~# 'm'
     " menu support
     exe 'sil! unmenu '.g:DrChipTopLvlMenu.'AnsiEsc'
     exe 'menu '.g:DrChipTopLvlMenu.'AnsiEsc.Stop<tab>:AnsiEsc		:AnsiEsc<cr>'
    endif
   endif

   " -----------------
   "  Conceal Support: {{{2
   " -----------------
   if has("conceal")
    if v:version < 703
     if &l:conc != 3
      let s:conckeep_{bufnr('%')}= &cole
      setlocal conc=3
"      call Decho("l:conc=".&l:conc)
     endif
    else
     if &l:cole != 3 || &l:cocu != "nv"
      let s:colekeep_{bufnr('%')}= &l:cole
      let s:cocukeep_{bufnr('%')}= &l:cocu
      setlocal cole=3 cocu=nv
"      call Decho("l:cole=".&l:cole." l:cocu=".&l:cocu)
     endif
    endif
   endif
  endif

  syn clear

  if has("conceal")
   syn match ansiConceal		contained conceal	"\e\[\(\d*;\)*\d*[A-Za-z]"
  else
   syn match ansiConceal		contained		"\e\[\(\d*;\)*\d*[A-Za-z]"
  endif

  " suppress escaped sequences that we don't handle (which may or may not be ansi-compliant)
  if has("conceal")
   syn match ansiSuppress	conceal	'\e\[[0-9;]*[A-Za-z]'
   syn match ansiSuppress	conceal	'\e\[?\d*[A-Za-z]'
   syn match ansiSuppress	conceal	'\b'
  else
   syn match ansiSuppress		'\e\[[0-9;]*[A-Za-z]'
   syn match ansiSuppress		'\e\[?\d*[A-Za-z]'
   syn match ansiSuppress		'\b'
  endif

  " ------------------------------
  " Ansi Escape Sequence Handling: {{{2
  " ------------------------------
  syn region ansiNone		start="\e\[[01;]m"           skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiNone		start="\e\[m"                skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiNone		start="\e\[\%(0;\)\=39;49m"  skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiNone		start="\e\[\%(0;\)\=49;39m"  skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiNone		start="\e\[\%(0;\)\=39m"     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiNone		start="\e\[\%(0;\)\=49m"     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiNone		start="\e\[\%(0;\)\=22m"     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  " disable bold/italic/etc. - no way to disable one attribute, so disable them all
  syn region ansiNone		start="\e\[\%(0;\)\=23m"     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiNone		start="\e\[\%(0;\)\=24m"     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiNone		start="\e\[\%(0;\)\=27m"     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiNone		start="\e\[\%(0;\)\=29m"     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal

  syn region ansiBlack		start="\e\[;\=0\{0,2};\=30m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRed		start="\e\[;\=0\{0,2};\=31m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGreen		start="\e\[;\=0\{0,2};\=32m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiYellow		start="\e\[;\=0\{0,2};\=33m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlue		start="\e\[;\=0\{0,2};\=34m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiMagenta	start="\e\[;\=0\{0,2};\=35m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiCyan		start="\e\[;\=0\{0,2};\=36m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiWhite		start="\e\[;\=0\{0,2};\=37m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGray		start="\e\[;\=0\{0,2};\=90m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  " set default ansi to white
  syn region ansiWhite		start="\e\[;\=0\{0,2};\=39m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal

  syn region ansiBold     	start="\e\[;\=0\{0,2};\=1m"                      skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldBlack	start="\e\[;\=0\{0,2};\=\%(1;30\|30;0\{0,2}1\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  " this is supposed to be bold-black, ie, dark grey, but it doesn't work well
  " on a lot of displays. We'll settle for non-bold white
  syn region ansiWhite	        start="\e\[;\=0\{0,2};\=90m"                     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldRed	start="\e\[;\=0\{0,2};\=\%(1;31\|31;0\{0,2}1\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldRed        start="\e\[;\=0\{0,2};\=91m"                     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldGreen	start="\e\[;\=0\{0,2};\=\%(1;32\|32;0\{0,2}1\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldGreen      start="\e\[;\=0\{0,2};\=92m"                     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldYellow	start="\e\[;\=0\{0,2};\=\%(1;33\|33;0\{0,2}1\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldYellow     start="\e\[;\=0\{0,2};\=93m"                     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldBlue	start="\e\[;\=0\{0,2};\=\%(1;34\|34;0\{0,2}1\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldBlue       start="\e\[;\=0\{0,2};\=94m"                     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldMagenta	start="\e\[;\=0\{0,2};\=\%(1;35\|35;0\{0,2}1\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldMagenta    start="\e\[;\=0\{0,2};\=95m"                     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldCyan	start="\e\[;\=0\{0,2};\=\%(1;36\|36;0\{0,2}1\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldCyan       start="\e\[;\=0\{0,2};\=96m"                     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldWhite	start="\e\[;\=0\{0,2};\=\%(1;37\|37;0\{0,2}1\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldWhite	start="\e\[;\=0\{0,2};\=\%(1;39\|39;0\{0,2}1\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldWhite      start="\e\[;\=0\{0,2};\=97m"                     skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBoldGray	start="\e\[;\=0\{0,2};\=\%(1;90\|90;0\{0,2}1\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal

  syn region ansiStandout     	        start="\e\[;\=0\{0,2};\=\%(1;\)\=3m"                      skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiStandoutBlack	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;30\|30;0\{0,2}3\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiStandoutRed	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;31\|31;0\{0,2}3\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiStandoutGreen	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;32\|32;0\{0,2}3\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiStandoutYellow	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;33\|33;0\{0,2}3\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiStandoutBlue	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;34\|34;0\{0,2}3\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiStandoutMagenta	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;35\|35;0\{0,2}3\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiStandoutCyan	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;36\|36;0\{0,2}3\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiStandoutWhite	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;37\|37;0\{0,2}3\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiStandoutGray	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(3;90\|90;0\{0,2}3\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal

  syn region ansiItalic     	start="\e\[;\=0\{0,2};\=\%(1;\)\=2m"                      skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiItalicBlack	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;30\|30;0\{0,2}2\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiItalicRed	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;31\|31;0\{0,2}2\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiItalicGreen	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;32\|32;0\{0,2}2\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiItalicYellow	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;33\|33;0\{0,2}2\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiItalicBlue	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;34\|34;0\{0,2}2\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiItalicMagenta	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;35\|35;0\{0,2}2\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiItalicCyan	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;36\|36;0\{0,2}2\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiItalicWhite	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;37\|37;0\{0,2}2\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiItalicGray	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(2;90\|90;0\{0,2}2\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal

  syn region ansiUnderline	        start="\e\[;\=0\{0,2};\=\%(1;\)\=4m"                      skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiUnderlineBlack	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;30\|30;0\{0,2}4\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiUnderlineRed	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;31\|31;0\{0,2}4\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiUnderlineGreen	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;32\|32;0\{0,2}4\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiUnderlineYellow	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;33\|33;0\{0,2}4\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiUnderlineBlue	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;34\|34;0\{0,2}4\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiUnderlineMagenta	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;35\|35;0\{0,2}4\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiUnderlineCyan	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;36\|36;0\{0,2}4\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiUnderlineWhite	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;37\|37;0\{0,2}4\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiUnderlineGray	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(4;90\|90;0\{0,2}4\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal

  syn region ansiBlink          start="\e\[;\=0\{0,2};\=\%(1;\)\=5m"                      skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlinkBlack	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;30\|30;0\{0,2}5\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlinkRed	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;31\|31;0\{0,2}5\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlinkGreen	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;32\|32;0\{0,2}5\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlinkYellow	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;33\|33;0\{0,2}5\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlinkBlue	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;34\|34;0\{0,2}5\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlinkMagenta	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;35\|35;0\{0,2}5\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlinkCyan	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;36\|36;0\{0,2}5\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlinkWhite	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;37\|37;0\{0,2}5\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlinkGray	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(5;90\|90;0\{0,2}5\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal

  syn region ansiRapidBlink	        start="\e\[;\=0\{0,2};\=\%(1;\)\=6m"                      skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRapidBlinkBlack	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;30\|30;0\{0,2}6\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRapidBlinkRed	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;31\|31;0\{0,2}6\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRapidBlinkGreen	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;32\|32;0\{0,2}6\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRapidBlinkYellow	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;33\|33;0\{0,2}6\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRapidBlinkBlue	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;34\|34;0\{0,2}6\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRapidBlinkMagenta	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;35\|35;0\{0,2}6\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRapidBlinkCyan	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;36\|36;0\{0,2}6\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRapidBlinkWhite	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;37\|37;0\{0,2}6\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRapidBlinkGray	        start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(6;90\|90;0\{0,2}6\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal

  syn region ansiRV	        start="\e\[;\=0\{0,2};\=\%(1;\)\=7m"                      skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRVBlack	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;30\|30;0\{0,2}7\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRVRed		start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;31\|31;0\{0,2}7\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRVGreen	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;32\|32;0\{0,2}7\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRVYellow	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;33\|33;0\{0,2}7\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRVBlue		start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;34\|34;0\{0,2}7\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRVMagenta	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;35\|35;0\{0,2}7\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRVCyan		start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;36\|36;0\{0,2}7\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRVWhite	start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;37\|37;0\{0,2}7\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRVGray		start="\e\[;\=0\{0,2};\=\%(1;\)\=\%(7;90\|90;0\{0,2}7\)m" skip='\e\[K' end="\e\["me=e-2 contains=ansiConceal

  if v:version >= 703
"   "-----------------------------------------
"   " handles implicit background highlighting
"   "-----------------------------------------
"   call Decho("installing implicit background highlighting")

   syn cluster AnsiDefaultBgGroup contains=ansiBgBoldDefault,ansiBgUnderlineDefault,ansiBgDefaultDefault,ansiBgBlackDefault,ansiBgRedDefault,ansiBgGreenDefault,ansiBgYellowDefault,ansiBgBlueDefault,ansiBgMagentaDefault,ansiBgCyanDefault,ansiBgWhiteDefault,ansiBgGrayDefault
   syn region ansiDefaultBg	concealends	matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(0\{0,2};\)\=49\%(0\{0,2};\)\=m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=@AnsiDefaultBgGroup,ansiConceal
   syn region ansiBgBoldDefault     contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiBgUnderlineDefault contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiBgDefaultDefault	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgBlackDefault	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgRedDefault	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgGreenDefault	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgYellowDefault	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgBlueDefault	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgMagentaDefault	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgCyanDefault	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgWhiteDefault	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgGrayDefault	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiBgBoldDefault        ansiBold
   hi link ansiBgUnderlineDefault   ansiUnderline
   hi link ansiBgDefaultDefault	ansiDefaultDefault
   hi link ansiBgBlackDefault	ansiBlackDefault
   hi link ansiBgRedDefault	ansiRedDefault
   hi link ansiBgGreenDefault	ansiGreenDefault
   hi link ansiBgYellowDefault	ansiYellowDefault
   hi link ansiBgBlueDefault	ansiBlueDefault
   hi link ansiBgMagentaDefault	ansiMagentaDefault
   hi link ansiBgCyanDefault	ansiCyanDefault
   hi link ansiBgWhiteDefault	ansiWhiteDefault
   hi link ansiBgGrayDefault	ansiGrayDefault

   syn cluster AnsiBlackBgGroup contains=ansiBgBoldBlack,ansiBgUnderlineBlack,ansiBgDefaultBlack,ansiBgBlackBlack,ansiBgRedBlack,ansiBgGreenBlack,ansiBgYellowBlack,ansiBgBlueBlack,ansiBgMagentaBlack,ansiBgCyanBlack,ansiBgWhiteBlack,ansiBgGrayBlack
   syn region ansiBlackBg	concealends	matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=40\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiBlackBgGroup,ansiConceal
   syn region ansiBgBoldBlack	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiBgUnderlineBlack	contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiBgDefaultBlack	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgBlackBlack	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgRedBlack	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgGreenBlack	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgYellowBlack	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgBlueBlack	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgMagentaBlack	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgCyanBlack	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgWhiteBlack	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgGrayBlack	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiBgBoldBlack          ansiBoldBlack
   hi link ansiBgUnderlineBlack     ansiUnderlineBlack
   hi link ansiBgDefaultBlack       ansiDefaultBlack
   hi link ansiBgBlackBlack	ansiBlackBlack
   hi link ansiBgRedBlack	ansiRedBlack
   hi link ansiBgGreenBlack	ansiGreenBlack
   hi link ansiBgYellowBlack	ansiYellowBlack
   hi link ansiBgBlueBlack	ansiBlueBlack
   hi link ansiBgMagentaBlack	ansiMagentaBlack
   hi link ansiBgCyanBlack	ansiCyanBlack
   hi link ansiBgWhiteBlack	ansiWhiteBlack
   hi link ansiBgGrayBlack	ansiGrayBlack

   syn cluster AnsiRedBgGroup contains=ansiBgBoldRed,ansiBgUnderlineRed,ansiBgDefaultRed,ansiBgBlackRed,ansiBgRedRed,ansiBgGreenRed,ansiBgYellowRed,ansiBgBlueRed,ansiBgMagentaRed,ansiBgCyanRed,ansiBgWhiteRed,ansiBgGrayRed
   syn region ansiRedBg		concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=41\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiRedBgGroup,ansiConceal
   syn region ansiBgBoldRed	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiBgUnderlineRed	contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiBgDefaultRed	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBgBlackRed	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgRedRed	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGreenRed	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgYellowRed	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlueRed	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgMagentaRed	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgCyanRed	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgWhiteRed	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGrayRed	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   hi link ansiBgBoldRed            ansiBoldRed
   hi link ansiBgUnderlineRed       ansiUnderlineRed
   hi link ansiBgDefaultRed         ansiDefaultRed
   hi link ansiBgBlackRed	ansiBlackRed
   hi link ansiBgRedRed		ansiRedRed
   hi link ansiBgGreenRed	ansiGreenRed
   hi link ansiBgYellowRed	ansiYellowRed
   hi link ansiBgBlueRed	ansiBlueRed
   hi link ansiBgMagentaRed	ansiMagentaRed
   hi link ansiBgCyanRed	ansiCyanRed
   hi link ansiBgWhiteRed	ansiWhiteRed
   hi link ansiBgGrayRed	ansiGrayRed

   syn cluster AnsiGreenBgGroup contains=ansiBgBoldGreen,ansiBgUnderlineGreen,ansiBgDefaultGreen,ansiBgBlackGreen,ansiBgRedGreen,ansiBgGreenGreen,ansiBgYellowGreen,ansiBgBlueGreen,ansiBgMagentaGreen,ansiBgCyanGreen,ansiBgWhiteGreen,ansiBgGrayGreen
   syn region ansiGreenBg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=42\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiGreenBgGroup,ansiConceal
   syn region ansiBgBoldGreen	contained	start="\e\[1m"  skip='\e\[K'  end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiBgUnderlineGreen	contained	start="\e\[4m"  skip='\e\[K'  end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiBgDefaultGreen	contained	start="\e\[39m" skip='\e\[K'  end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlackGreen	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgRedGreen	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGreenGreen	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgYellowGreen	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlueGreen	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgMagentaGreen	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgCyanGreen	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgWhiteGreen	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGrayGreen	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   hi link ansiBgBoldGreen          ansiBoldGreen
   hi link ansiBgUnderlineGreen     ansiUnderlineGreen
   hi link ansiBgDefaultGreen       ansiDefaultGreen
   hi link ansiBgBlackGreen	ansiBlackGreen
   hi link ansiBgGreenGreen	ansiGreenGreen
   hi link ansiBgRedGreen	ansiRedGreen
   hi link ansiBgYellowGreen	ansiYellowGreen
   hi link ansiBgBlueGreen	ansiBlueGreen
   hi link ansiBgMagentaGreen	ansiMagentaGreen
   hi link ansiBgCyanGreen	ansiCyanGreen
   hi link ansiBgWhiteGreen	ansiWhiteGreen
   hi link ansiBgGrayGreen	ansiGrayGreen

   syn cluster AnsiYellowBgGroup contains=ansiBgBoldYellow,ansiBgUnderlineYellow,ansiBgDefaultYellow,ansiBgBlackYellow,ansiBgRedYellow,ansiBgGreenYellow,ansiBgYellowYellow,ansiBgBlueYellow,ansiBgMagentaYellow,ansiBgCyanYellow,ansiBgWhiteYellow,ansiBgGrayYellow
   syn region ansiYellowBg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=43\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiYellowBgGroup,ansiConceal
   syn region ansiBgBoldYellow	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiBgUnderlineYellow	contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiBgDefaultYellow	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlackYellow	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgRedYellow	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGreenYellow	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgYellowYellow	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlueYellow	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgMagentaYellow	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgCyanYellow	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgWhiteYellow	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGrayYellow	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   hi link ansiBgBoldYellow         ansiBoldYellow
   hi link ansiBgUnderlineYellow    ansiUnderlineYellow
   hi link ansiBgDefaultYellow      ansiDefaultYellow
   hi link ansiBgBlackYellow	ansiBlackYellow
   hi link ansiBgRedYellow	ansiRedYellow
   hi link ansiBgGreenYellow	ansiGreenYellow
   hi link ansiBgYellowYellow	ansiYellowYellow
   hi link ansiBgBlueYellow	ansiBlueYellow
   hi link ansiBgMagentaYellow	ansiMagentaYellow
   hi link ansiBgCyanYellow	ansiCyanYellow
   hi link ansiBgWhiteYellow	ansiWhiteYellow
   hi link ansiBgGrayYellow	ansiGrayYellow

   syn cluster AnsiBlueBgGroup contains=ansiBgBoldBlue,ansiBgUnderlineBlue,ansiBgDefaultBlue,ansiBgBlackBlue,ansiBgRedBlue,ansiBgGreenBlue,ansiBgYellowBlue,ansiBgBlueBlue,ansiBgMagentaBlue,ansiBgCyanBlue,ansiBgWhiteBlue,ansiBgGrayBlue
   syn region ansiBlueBg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=44\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiBlueBgGroup,ansiConceal
   syn region ansiBgBoldBlue	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiBgUnderlineBlue	contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiBgDefaultBlue	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlackBlue	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgRedBlue	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGreenBlue	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgYellowBlue	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlueBlue	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgMagentaBlue	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgCyanBlue	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgWhiteBlue	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGrayBlue	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   hi link ansiBgBoldBlue           ansiBoldBlue
   hi link ansiBgUnderlineBlue      ansiUnderlineBlue
   hi link ansiBgDefaultBlue	ansiDefaultBlue
   hi link ansiBgBlackBlue	ansiBlackBlue
   hi link ansiBgRedBlue	ansiRedBlue
   hi link ansiBgGreenBlue	ansiGreenBlue
   hi link ansiBgYellowBlue	ansiYellowBlue
   hi link ansiBgBlueBlue	ansiBlueBlue
   hi link ansiBgMagentaBlue	ansiMagentaBlue
   hi link ansiBgCyanBlue	ansiCyanBlue
   hi link ansiBgWhiteBlue	ansiWhiteBlue
   hi link ansiBgGrayBlue	ansiGrayBlue

   syn cluster AnsiMagentaBgGroup contains=ansiBgBoldMagenta,ansiBgUnderlineMagenta,ansiBgDefaultMagenta,ansiBgBlackMagenta,ansiBgRedMagenta,ansiBgGreenMagenta,ansiBgYellowMagenta,ansiBgBlueMagenta,ansiBgMagentaMagenta,ansiBgCyanMagenta,ansiBgWhiteMagenta,ansiBgGrayMagenta
   syn region ansiMagentaBg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=45\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiMagentaBgGroup,ansiConceal
   syn region ansiBgBoldMagenta      contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiBgUnderlineMagenta contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiBgDefaultMagenta	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlackMagenta	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgRedMagenta	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGreenMagenta	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgYellowMagenta	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlueMagenta	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgMagentaMagenta	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgCyanMagenta	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgWhiteMagenta	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGrayMagenta	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   hi link ansiBgBoldMagenta        ansiBoldMagenta
   hi link ansiBgUnderlineMagenta   ansiUnderlineMagenta
   hi link ansiBgDefaultMagenta	ansiDefaultMagenta
   hi link ansiBgBlackMagenta	ansiBlackMagenta
   hi link ansiBgRedMagenta	ansiRedMagenta
   hi link ansiBgGreenMagenta	ansiGreenMagenta
   hi link ansiBgYellowMagenta	ansiYellowMagenta
   hi link ansiBgBlueMagenta	ansiBlueMagenta
   hi link ansiBgMagentaMagenta	ansiMagentaMagenta
   hi link ansiBgCyanMagenta	ansiCyanMagenta
   hi link ansiBgWhiteMagenta	ansiWhiteMagenta
   hi link ansiBgGrayMagenta	ansiGrayMagenta

   syn cluster AnsiCyanBgGroup contains=ansiBgBoldCyan,ansiBgUnderlineCyan,ansiBgDefaultCyan,ansiBgBlackCyan,ansiBgRedCyan,ansiBgGreenCyan,ansiBgYellowCyan,ansiBgBlueCyan,ansiBgMagentaCyan,ansiBgCyanCyan,ansiBgWhiteCyan,ansiBgGrayCyan
   syn region ansiCyanBg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=46\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiCyanBgGroup,ansiConceal
   syn region ansiBgBoldCyan        contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiBgUnderlineCyan   contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiBgDefaultCyan	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlackCyan	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgRedCyan	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGreenCyan	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgYellowCyan	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlueCyan	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgMagentaCyan	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgCyanCyan	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgWhiteCyan	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGrayCyan	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   hi link ansiBgBoldCyan           ansiBoldCyan
   hi link ansiBgUnderlineCyan      ansiUnderlineCyan
   hi link ansiBgDefaultCyan	ansiDefaultCyan
   hi link ansiBgBlackCyan	ansiBlackCyan
   hi link ansiBgRedCyan	ansiRedCyan
   hi link ansiBgGreenCyan	ansiGreenCyan
   hi link ansiBgYellowCyan	ansiYellowCyan
   hi link ansiBgBlueCyan	ansiBlueCyan
   hi link ansiBgMagentaCyan	ansiMagentaCyan
   hi link ansiBgCyanCyan	ansiCyanCyan
   hi link ansiBgWhiteCyan	ansiWhiteCyan
   hi link ansiBgGrayCyan	ansiGrayCyan

   syn cluster AnsiWhiteBgGroup contains=ansiBgBoldWhite,ansiBgUnderlineWhite,ansiBgDefaultWhite,ansiBgBlackWhite,ansiBgRedWhite,ansiBgGreenWhite,ansiBgYellowWhite,ansiBgBlueWhite,ansiBgMagentaWhite,ansiBgCyanWhite,ansiBgWhiteWhite,ansiBgGrayWhite
   syn region ansiWhiteBg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=47\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiWhiteBgGroup,ansiConceal
   syn region ansiBgBoldWhite       contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiBgUnderlineWhite  contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiBgDefaultWhite	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlackWhite	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgRedWhite	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGreenWhite	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgYellowWhite	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgBlueWhite	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgMagentaWhite	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgCyanWhite	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgWhiteWhite	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   syn region ansiBgGrayWhite	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3 contains=ansiConceal
   hi link ansiBgBoldWhite          ansiBoldWhite
   hi link ansiBgUnderlineWhite     ansiUnderlineWhite
   hi link ansiBgDefaultWhite	ansiDefaultWhite
   hi link ansiBgBlackWhite	ansiBlackWhite
   hi link ansiBgRedWhite	ansiRedWhite
   hi link ansiBgGreenWhite	ansiGreenWhite
   hi link ansiBgYellowWhite	ansiYellowWhite
   hi link ansiBgBlueWhite	ansiBlueWhite
   hi link ansiBgMagentaWhite	ansiMagentaWhite
   hi link ansiBgCyanWhite	ansiCyanWhite
   hi link ansiBgWhiteWhite	ansiWhiteWhite
   hi link ansiBgGrayWhite	ansiGrayWhite

   "-----------------------------------------
   " handles implicit foreground highlighting
   "-----------------------------------------
"   call Decho("installing implicit foreground highlighting")

   syn cluster AnsiDefaultFgGroup contains=ansiFgDefaultBold,ansiFgDefaultUnderline,ansiFgDefaultDefault,ansiFgDefaultBlack,ansiFgDefaultRed,ansiFgDefaultGreen,ansiFgDefaultYellow,ansiFgDefaultBlue,ansiFgDefaultMagenta,ansiFgDefaultCyan,ansiFgDefaultWhite
   syn region ansiDefaultFg		concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(0;\)\=39\%(;0\)\=m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=@AnsiDefaultFgGroup,ansiConceal
   syn region ansiFgDefaultBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiFgDefaultUnerline	contained	start="\e\[4m"  skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgDefaultDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgDefaultBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgDefaultRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgDefaultGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgDefaultYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgDefaultBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgDefaultMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgDefaultCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgDefaultWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiFgDefaultBold	ansiDefaultBold
   hi link ansiFgDefaultUnderline	ansiDefaultUnderline
   hi link ansiFgDefaultDefault	ansiDefaultDefault
   hi link ansiFgDefaultBlack	ansiDefaultBlack
   hi link ansiFgDefaultRed	ansiDefaultRed
   hi link ansiFgDefaultGreen	ansiDefaultGreen
   hi link ansiFgDefaultYellow	ansiDefaultYellow
   hi link ansiFgDefaultBlue	ansiDefaultBlue
   hi link ansiFgDefaultMagenta	ansiDefaultMagenta
   hi link ansiFgDefaultCyan	ansiDefaultCyan
   hi link ansiFgDefaultWhite	ansiDefaultWhite

   syn cluster AnsiBlackFgGroup contains=ansiFgBlackBold,ansiFgBlackUnderline,ansiFgBlackDefault,ansiFgBlackBlack,ansiFgBlackRed,ansiFgBlackGreen,ansiFgBlackYellow,ansiFgBlackBlue,ansiFgBlackMagenta,ansiFgBlackCyan,ansiFgBlackWhite
   syn region ansiBlackFg	concealends	matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=30\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiBlackFgGroup,ansiConceal
   syn region ansiFgBlackBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiFgBlackUnerline	contained	start="\e\[4m"  skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiFgBlackDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiFgBlackBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiFgBlackRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiFgBlackGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiFgBlackYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiFgBlackBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiFgBlackMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiFgBlackCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiFgBlackWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   hi link ansiFgBlackBold	ansiBlackBold
   hi link ansiFgBlackUnderline	ansiBlackUnderline
   hi link ansiFgBlackDefault	ansiBlackDefault
   hi link ansiFgBlackBlack	ansiBlackBlack
   hi link ansiFgBlackRed	ansiBlackRed
   hi link ansiFgBlackGreen	ansiBlackGreen
   hi link ansiFgBlackYellow	ansiBlackYellow
   hi link ansiFgBlackBlue	ansiBlackBlue
   hi link ansiFgBlackMagenta	ansiBlackMagenta
   hi link ansiFgBlackCyan	ansiBlackCyan
   hi link ansiFgBlackWhite	ansiBlackWhite

   syn cluster AnsiRedFgGroup contains=ansiFgRedBold,ansiFgRedUnderline,ansiFgRedDefault,ansiFgRedBlack,ansiFgRedRed,ansiFgRedGreen,ansiFgRedYellow,ansiFgRedBlue,ansiFgRedMagenta,ansiFgRedCyan,ansiFgRedWhite
   syn region ansiRedFg		concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=31\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiRedFgGroup,ansiConceal
   syn region ansiFgRedBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiFgRedUnderline	contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiFgRedDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgRedBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgRedRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgRedGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgRedYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgRedBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgRedMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgRedCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgRedWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiFgRedBold	ansiRedBold
   hi link ansiFgRedUnderline	ansiRedUnderline
   hi link ansiFgRedDefault	ansiRedDefault
   hi link ansiFgRedBlack	ansiRedBlack
   hi link ansiFgRedRed		ansiRedRed
   hi link ansiFgRedGreen	ansiRedGreen
   hi link ansiFgRedYellow	ansiRedYellow
   hi link ansiFgRedBlue	ansiRedBlue
   hi link ansiFgRedMagenta	ansiRedMagenta
   hi link ansiFgRedCyan	ansiRedCyan
   hi link ansiFgRedWhite	ansiRedWhite

   syn cluster AnsiGreenFgGroup contains=ansiFgGreenBold,ansiFgGreenUnderline,ansiFgGreenDefault,ansiFgGreenBlack,ansiFgGreenRed,ansiFgGreenGreen,ansiFgGreenYellow,ansiFgGreenBlue,ansiFgGreenMagenta,ansiFgGreenCyan,ansiFgGreenWhite
   syn region ansiGreenFg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=32\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiGreenFgGroup,ansiConceal
   syn region ansiFgGreenBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiFgGreenUnderline	contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiFgGreenDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGreenBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGreenRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGreenGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGreenYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGreenBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGreenMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGreenCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGreenWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiFgGreenBold	ansiGreenBold
   hi link ansiFgGreenUnderline	ansiGreenUnderline
   hi link ansiFgGreenDefault	ansiGreenDefault
   hi link ansiFgGreenBlack	ansiGreenBlack
   hi link ansiFgGreenGreen	ansiGreenGreen
   hi link ansiFgGreenRed	ansiGreenRed
   hi link ansiFgGreenYellow	ansiGreenYellow
   hi link ansiFgGreenBlue	ansiGreenBlue
   hi link ansiFgGreenMagenta	ansiGreenMagenta
   hi link ansiFgGreenCyan	ansiGreenCyan
   hi link ansiFgGreenWhite	ansiGreenWhite

   syn cluster AnsiYellowFgGroup contains=ansiFgYellowBold,ansiFgYellowUnderline,ansiFgYellowDefault,ansiFgYellowBlack,ansiFgYellowRed,ansiFgYellowGreen,ansiFgYellowYellow,ansiFgYellowBlue,ansiFgYellowMagenta,ansiFgYellowCyan,ansiFgYellowWhite
   syn region ansiYellowFg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=33\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiYellowFgGroup,ansiConceal
   syn region ansiFgYellowBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiFgYellowUnderline	contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiFgYellowDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgYellowBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgYellowRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgYellowGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgYellowYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgYellowBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgYellowMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgYellowCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgYellowWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiFgYellowBold	ansiYellowBold
   hi link ansiFgYellowUnderline	ansiYellowUnderline
   hi link ansiFgYellowDefault	ansiYellowDefault
   hi link ansiFgYellowBlack	ansiYellowBlack
   hi link ansiFgYellowRed	ansiYellowRed
   hi link ansiFgYellowGreen	ansiYellowGreen
   hi link ansiFgYellowYellow	ansiYellowYellow
   hi link ansiFgYellowBlue	ansiYellowBlue
   hi link ansiFgYellowMagenta	ansiYellowMagenta
   hi link ansiFgYellowCyan	ansiYellowCyan
   hi link ansiFgYellowWhite	ansiYellowWhite

   syn cluster AnsiBlueFgGroup contains=ansiFgBlueBold,ansiFgBlueUnderline,ansiFgBlueDefault,ansiFgBlueBlack,ansiFgBlueRed,ansiFgBlueGreen,ansiFgBlueYellow,ansiFgBlueBlue,ansiFgBlueMagenta,ansiFgBlueCyan,ansiFgBlueWhite
   syn region ansiBlueFg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=34\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiBlueFgGroup,ansiConceal
   syn region ansiFgBlueBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiFgBlueUnderline	contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiFgBlueDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgBlueBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgBlueRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgBlueGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgBlueYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgBlueBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgBlueMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgBlueCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgBlueWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiFgBlueBold	ansiBlueBold
   hi link ansiFgBlueUnderline	ansiBlueUnderline
   hi link ansiFgBlueDefault	ansiBlueDefault
   hi link ansiFgBlueBlack	ansiBlueBlack
   hi link ansiFgBlueRed	ansiBlueRed
   hi link ansiFgBlueGreen	ansiBlueGreen
   hi link ansiFgBlueYellow	ansiBlueYellow
   hi link ansiFgBlueBlue	ansiBlueBlue
   hi link ansiFgBlueMagenta	ansiBlueMagenta
   hi link ansiFgBlueCyan	ansiBlueCyan
   hi link ansiFgBlueWhite	ansiBlueWhite

   syn cluster AnsiMagentaFgGroup contains=ansiFgMagentaBold,ansiFgMagentaUnderline,ansiFgMagentaDefault,ansiFgMagentaBlack,ansiFgMagentaRed,ansiFgMagentaGreen,ansiFgMagentaYellow,ansiFgMagentaBlue,ansiFgMagentaMagenta,ansiFgMagentaCyan,ansiFgMagentaWhite
   syn region ansiMagentaFg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=35\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiMagentaFgGroup,ansiConceal
   syn region ansiFgMagentaBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiFgMagentaUnderline contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiFgMagentaDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgMagentaBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgMagentaRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgMagentaGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgMagentaYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgMagentaBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgMagentaMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgMagentaCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgMagentaWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiFgMagentaBold	ansiMagentaBold
   hi link ansiFgMagentaUnderline	ansiMagentaUnderline
   hi link ansiFgMagentaDefault	ansiMagentaDefault
   hi link ansiFgMagentaBlack	ansiMagentaBlack
   hi link ansiFgMagentaRed	ansiMagentaRed
   hi link ansiFgMagentaGreen	ansiMagentaGreen
   hi link ansiFgMagentaYellow	ansiMagentaYellow
   hi link ansiFgMagentaBlue	ansiMagentaBlue
   hi link ansiFgMagentaMagenta	ansiMagentaMagenta
   hi link ansiFgMagentaCyan	ansiMagentaCyan
   hi link ansiFgMagentaWhite	ansiMagentaWhite

   syn cluster AnsiCyanFgGroup contains=ansiFgCyanBold,ansiFgCyanUnderline,ansiFgCyanDefault,ansiFgCyanBlack,ansiFgCyanRed,ansiFgCyanGreen,ansiFgCyanYellow,ansiFgCyanBlue,ansiFgCyanMagenta,ansiFgCyanCyan,ansiFgCyanWhite
   syn region ansiCyanFg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=36\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiCyanFgGroup,ansiConceal
   syn region ansiFgCyanBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiFgCyanUnderline contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiFgCyanDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgCyanBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgCyanRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgCyanGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgCyanYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgCyanBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgCyanMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgCyanCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgCyanWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiFgCyanBold	ansiCyanBold
   hi link ansiFgCyanUnderline	ansiCyanUnderline
   hi link ansiFgCyanDefault	ansiCyanDefault
   hi link ansiFgCyanBlack	ansiCyanBlack
   hi link ansiFgCyanRed	ansiCyanRed
   hi link ansiFgCyanGreen	ansiCyanGreen
   hi link ansiFgCyanYellow	ansiCyanYellow
   hi link ansiFgCyanBlue	ansiCyanBlue
   hi link ansiFgCyanMagenta	ansiCyanMagenta
   hi link ansiFgCyanCyan	ansiCyanCyan
   hi link ansiFgCyanWhite	ansiCyanWhite

   syn cluster AnsiWhiteFgGroup contains=ansiFgWhiteBold,ansiFgWhiteUnderline,ansiFgWhiteDefault,ansiFgWhiteBlack,ansiFgWhiteRed,ansiFgWhiteGreen,ansiFgWhiteYellow,ansiFgWhiteBlue,ansiFgWhiteMagenta,ansiFgWhiteCyan,ansiFgWhiteWhite
   syn region ansiWhiteFg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=37\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiWhiteFgGroup,ansiConceal
   syn region ansiFgWhiteBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiFgWhiteUnderline contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiFgWhiteDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgWhiteBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgWhiteRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgWhiteGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgWhiteYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgWhiteBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgWhiteMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgWhiteCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgWhiteWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiFgWhiteBold	ansiWhiteBold
   hi link ansiFgWhiteUnderline	ansiWhiteUnderline
   hi link ansiFgWhiteDefault	ansiWhiteDefault
   hi link ansiFgWhiteBlack	ansiWhiteBlack
   hi link ansiFgWhiteRed	ansiWhiteRed
   hi link ansiFgWhiteGreen	ansiWhiteGreen
   hi link ansiFgWhiteYellow	ansiWhiteYellow
   hi link ansiFgWhiteBlue	ansiWhiteBlue
   hi link ansiFgWhiteMagenta	ansiWhiteMagenta
   hi link ansiFgWhiteCyan	ansiWhiteCyan
   hi link ansiFgWhiteWhite	ansiWhiteWhite

   syn cluster AnsiGrayFgGroup contains=ansiFgGrayBold,ansiFgGrayUnderline,ansiFgGrayDefault,ansiFgGrayBlack,ansiFgGrayRed,ansiFgGrayGreen,ansiFgGrayYellow,ansiFgGrayBlue,ansiFgGrayMagenta,ansiFgGrayCyan,ansiFgGrayWhite
   syn region ansiGrayFg	concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=90\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[039m]"  contains=@AnsiGrayFgGroup,ansiConceal
   syn region ansiFgGrayBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiFgGrayUnderline contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiFgGrayDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGrayBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGrayRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGrayGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGrayYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGrayBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGrayMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGrayCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiFgGrayWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiFgGrayBold	ansiGrayBold
   hi link ansiFgGrayUnderline	ansiGrayUnderline
   hi link ansiFgGrayDefault	ansiGrayDefault
   hi link ansiFgGrayBlack	ansiGrayBlack
   hi link ansiFgGrayRed	ansiGrayRed
   hi link ansiFgGrayGreen	ansiGrayGreen
   hi link ansiFgGrayYellow	ansiGrayYellow
   hi link ansiFgGrayBlue	ansiGrayBlue
   hi link ansiFgGrayMagenta	ansiGrayMagenta
   hi link ansiFgGrayCyan	ansiGrayCyan
   hi link ansiFgGrayWhite	ansiGrayWhite

   syn cluster AnsiBoldGroup contains=ansiUnderlineBoldRegion,ansiDefaultBoldRegion,ansiBlackBoldRegion,ansiWhiteBoldRegion,ansiGrayBoldRegion,ansiRedBoldRegion,ansiGreenBoldRegion,ansiYellowBoldRegion,ansiBlueBoldRegion,ansiMagentaBoldRegion,ansiCyanBoldRegion
   syn region ansiBoldRegion        concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=1;\=m" skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(0*\|22\)\=m" contains=@AnsiBoldGroup,ansiConceal
   syn region ansiUnderlineBoldRegion contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiDefaultBoldRegion	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBlackBoldRegion	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiRedBoldRegion	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiGreenBoldRegion	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiYellowBoldRegion	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBlueBoldRegion	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiMagentaBoldRegion	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiCyanBoldRegion	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiWhiteBoldRegion	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiGrayBoldRegion	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiBoldRegion           ansiBold
   hi link ansiUnderlineBoldRegion	ansiBoldUnderline
   hi link ansiDefaultBoldRegion	ansiBoldDefault
   hi link ansiBlackBoldRegion	ansiBoldBlack
   hi link ansiRedBoldRegion	ansiBoldRed
   hi link ansiGreenBoldRegion	ansiBoldGreen
   hi link ansiYellowBoldRegion	ansiBoldYellow
   hi link ansiBlueBoldRegion	ansiBoldBlue
   hi link ansiMagentaBoldRegion	ansiBoldMagenta
   hi link ansiCyanBoldRegion	ansiBoldCyan
   hi link ansiWhiteBoldRegion	ansiBoldWhite
   hi link ansiGrayBoldRegion	ansiBoldGray

   syn cluster AnsiUnderlineGroup contains=ansiBoldUnderlineRegion,ansiDefaultUnderlineRegion,ansiBlackUnderlineRegion,ansiWhiteUnderlineRegion,ansiGrayUnderlineRegion,ansiRedUnderlineRegion,ansiGreenUnderlineRegion,ansiYellowUnderlineRegion,ansiBlueUnderlineRegion,ansiMagentaUnderlineRegion,ansiCyanUnderlineRegion
   syn region ansiUnderlineRegion       concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=4;\=m" skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(0*\|24\)\=m" contains=@AnsiUnderlineGroup,ansiConceal
   syn region ansiBoldUnderlineRegion	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiDefaultUnderlineRegion	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBlackUnderlineRegion	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiRedUnderlineRegion	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiGreenUnderlineRegion	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiYellowUnderlineRegion	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBlueUnderlineRegion	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiMagentaUnderlineRegion	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiCyanUnderlineRegion	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiWhiteUnderlineRegion	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiGrayUnderlineRegion	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiUnderlineRegion          ansiUnderline
   hi link ansiBoldUnderlineRegion      ansiBoldUnderline
   hi link ansiDefaultUnderlineRegion   ansiUnderlineDefault
   hi link ansiBlackUnderlineRegion	    ansiUnderlineBlack
   hi link ansiRedUnderlineRegion	    ansiUnderlineRed
   hi link ansiGreenUnderlineRegion	    ansiUnderlineGreen
   hi link ansiYellowUnderlineRegion    ansiUnderlineYellow
   hi link ansiBlueUnderlineRegion	    ansiUnderlineBlue
   hi link ansiMagentaUnderlineRegion   ansiUnderlineMagenta
   hi link ansiCyanUnderlineRegion	    ansiUnderlineCyan
   hi link ansiWhiteUnderlineRegion	    ansiUnderlineWhite
   hi link ansiGrayUnderlineRegion	    ansiUnderlineGray

   "-----------------------------------------
   " handles implicit reverse background highlighting
   "-----------------------------------------
"   call Decho("installing implicit reverse background highlighting")

   syn cluster AnsiReverseGroup contains=ansiUnderlineReverse,ansiBoldReverse,ansiDefaultReverse,ansiBlackReverse,ansiWhiteReverse,ansiGrayReverse,ansiRedReverse,ansiGreenReverse,ansiYellowReverse,ansiBlueReverse,ansiMagentaReverse,ansiCyanReverse,ansiDefaultReverseBg,ansiBlackReverseBg,ansiRedReverseBg,ansiGreenReverseBg,ansiYellowReverseBg,ansiBlueReverseBg,ansiMagentaReverseBg,ansiCyanReverseBg,ansiWhiteReverseBg,ansiDefaultReverseFg,ansiBlackReverseFg,ansiWhiteReverseFg,ansiGrayReverseFg,ansiRedReverseFg,ansiGreenReverseFg,ansiYellowReverseFg,ansiBlueReverseFg,ansiMagentaReverseFg,ansiCyanReverseFg,ansiReverseBoldRegion,ansiReverseUnderlineRegion
   syn region ansiReverseRegion        concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=7;\=m" skip='\e\[K' end="\ze\e\[\%(0\|27\)\=m" contains=@AnsiReverseGroup,ansiConceal
   syn region ansiUnderlineReverse	contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiBgBoldReverse	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiDefaultReverse	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBlackReverse	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiRedReverse	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiGreenReverse	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiYellowReverse	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBlueReverse	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiMagentaReverse	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiCyanReverse	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiWhiteReverse	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiGrayReverse	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseRegion        ansiReverse
   hi link ansiUnderlineReverse	ansiReverseUnderline
   hi link ansiBgBoldReverse	ansiReverseBold
   hi link ansiDefaultReverse	ansiReverseDefault
   hi link ansiBlackReverse	ansiReverseBlack
   hi link ansiRedReverse	ansiReverseRed
   hi link ansiGreenReverse	ansiReverseGreen
   hi link ansiYellowReverse	ansiReverseYellow
   hi link ansiBlueReverse	ansiReverseBlue
   hi link ansiMagentaReverse	ansiReverseMagenta
   hi link ansiCyanReverse	ansiReverseCyan
   hi link ansiWhiteReverse	ansiReverseWhite
   hi link ansiGrayReverse	ansiReverseGray

   syn cluster AnsiDefaultReverseBgGroup contains=ansiReverseBgBoldDefault,ansiReverseBgUnderlineDefault,ansiReverseBgDefaultDefault,ansiReverseBgBlackDefault,ansiReverseBgRedDefault,ansiReverseBgGreenDefault,ansiReverseBgYellowDefault,ansiReverseBgBlueDefault,ansiReverseBgMagentaDefault,ansiReverseBgCyanDefault,ansiReverseBgWhiteDefault,ansiReverseBgGrayDefault
   syn region ansiDefaultReverseBg      contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(0\{0,2};\)\=49\%(0\{0,2};\)\=m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=@AnsiDefaultBgGroup,ansiConceal
   syn region ansiReverseBgBoldDefault          contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgUnderlineDefault     contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgDefaultDefault	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlackDefault	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgRedDefault	contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGreenDefault	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgYellowDefault	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlueDefault	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgMagentaDefault	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgCyanDefault	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgWhiteDefault	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGrayDefault	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseBgBoldDefault             ansiReverseBold
   hi link ansiReverseBgUnderlineDefault        ansiReverseUnderline
   hi link ansiReverseBgDefaultDefault	ansiDefaultDefault
   hi link ansiReverseBgBlackDefault	ansiDefaultBlack
   hi link ansiReverseBgRedDefault	            ansiDefaultRed
   hi link ansiReverseBgGreenDefault	ansiDefaultGreen
   hi link ansiReverseBgYellowDefault	ansiDefaultYellow
   hi link ansiReverseBgBlueDefault	            ansiDefaultBlue
   hi link ansiReverseBgMagentaDefault	ansiDefaultMagenta
   hi link ansiReverseBgCyanDefault	            ansiDefaultCyan
   hi link ansiReverseBgWhiteDefault	ansiDefaultWhite
   hi link ansiReverseBgGrayDefault	            ansiDefaultGray

   syn cluster AnsiBlackReverseBgGroup contains=ansiReverseBgBoldBlack,ansiReverseBgUnderlineBlack,ansiReverseBgDefaultBlack,ansiReverseBgBlackBlack,ansiReverseBgRedBlack,ansiReverseBgGreenBlack,ansiReverseBgYellowBlack,ansiReverseBgBlueBlack,ansiReverseBgMagentaBlack,ansiReverseBgCyanBlack,ansiReverseBgWhiteBlack,ansiReverseBgGrayBlack
   syn region ansiBlackReverseBg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=40\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiBlackReverseBgGroup,ansiConceal
   syn region ansiReverseBgBoldBlack	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgUnderlineBlack	contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgDefaultBlack	contained	start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlackBlack	contained	start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgRedBlack	            contained	start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGreenBlack	contained	start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgYellowBlack	contained	start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlueBlack	contained	start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgMagentaBlack	contained	start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgCyanBlack	contained	start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgWhiteBlack	contained	start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGrayBlack	contained	start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseBgBoldBlack       ansiBlackBold
   hi link ansiReverseBgUnderlineBlack  ansiBlackUnderline
   hi link ansiReverseBgDefaultBlack    ansiDefaultBlack
   hi link ansiReverseBgBlackBlack	    ansiBlackBlack
   hi link ansiReverseBgRedBlack	    ansiBlackRed
   hi link ansiReverseBgGreenBlack	    ansiBlackGreen
   hi link ansiReverseBgYellowBlack	    ansiBlackYellow
   hi link ansiReverseBgBlueBlack	    ansiBlackBlue
   hi link ansiReverseBgMagentaBlack    ansiBlackMagenta
   hi link ansiReverseBgCyanBlack	    ansiBlackCyan
   hi link ansiReverseBgWhiteBlack	    ansiBlackWhite
   hi link ansiReverseBgGrayBlack	    ansiBlackGray

   syn cluster AnsiRedReverseBgGroup contains=ansiReverseBgBoldRed,ansiReverseBgUnderlineRed,ansiReverseBgDefaultRed,ansiReverseBgBlackRed,ansiReverseBgRedRed,ansiReverseBgGreenRed,ansiReverseBgYellowRed,ansiReverseBgBlueRed,ansiReverseBgMagentaRed,ansiReverseBgCyanRed,ansiReverseBgWhiteRed,ansiReverseBgGrayRed
   syn region ansiRedReverseBg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=41\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiRedReverseBgGroup,ansiConceal
   syn region ansiReverseBgBoldRed	    contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgUnderlineRed contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgDefaultRed   contained start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlackRed	    contained start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgRedRed	    contained start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGreenRed	    contained start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgYellowRed    contained start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlueRed	    contained start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgMagentaRed   contained start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgCyanRed	    contained start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgWhiteRed	    contained start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGrayRed	    contained start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseBgBoldRed     ansiRedBold
   hi link ansiReverseBgUnderlineRed ansiRedUnderline
   hi link ansiReverseBgDefaultRed	ansiRedDefault
   hi link ansiReverseBgBlackRed	ansiRedBlack
   hi link ansiReverseBgRedRed	ansiRedRed
   hi link ansiReverseBgGreenRed	ansiRedGreen
   hi link ansiReverseBgYellowRed	ansiRedYellow
   hi link ansiReverseBgBlueRed	ansiRedBlue
   hi link ansiReverseBgMagentaRed	ansiRedMagenta
   hi link ansiReverseBgCyanRed	ansiRedCyan
   hi link ansiReverseBgWhiteRed	ansiRedWhite
   hi link ansiReverseBgGrayRed	ansiRedGray

   syn cluster AnsiGreenReverseBgGroup contains=ansiReverseBgBoldGreen,ansiReverseBgUnderlineGreen,ansiReverseBgDefaultGreen,ansiReverseBgBlackGreen,ansiReverseBgRedGreen,ansiReverseBgGreenGreen,ansiReverseBgYellowGreen,ansiReverseBgBlueGreen,ansiReverseBgMagentaGreen,ansiReverseBgCyanGreen,ansiReverseBgWhiteGreen,ansiReverseBgGrayGreen
   syn region ansiGreenReverseBg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=42\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiGreenReverseBgGroup,ansiConceal
   syn region ansiReverseBgBoldGreen        contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgUnderlineGreen   contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgDefaultGreen     contained start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlackGreen       contained start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgRedGreen	        contained start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGreenGreen       contained start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgYellowGreen      contained start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlueGreen        contained start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgMagentaGreen     contained start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgCyanGreen        contained start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgWhiteGreen       contained start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGrayGreen       contained start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseBgBoldGreen   ansiGreenBold
   hi link ansiReverseBgUnderlineGreen ansiGreenUnderline
   hi link ansiReverseBgDefaultGreen ansiGreenDefault
   hi link ansiReverseBgBlackGreen	ansiGreenBlack
   hi link ansiReverseBgGreenGreen	ansiGreenGreen
   hi link ansiReverseBgGreenGreen	ansiGreenGreen
   hi link ansiReverseBgYellowGreen	ansiGreenYellow
   hi link ansiReverseBgBlueGreen	ansiGreenBlue
   hi link ansiReverseBgMagentaGreen ansiGreenMagenta
   hi link ansiReverseBgCyanGreen	ansiGreenCyan
   hi link ansiReverseBgWhiteGreen	ansiGreenWhite
   hi link ansiReverseBgGrayGreen	ansiGreenGray

   syn cluster AnsiYellowReverseBgGroup contains=ansiReverseFgBoldYellow,ansiReverseFgUnderlineYellow,ansiReverseFgDefaultYellow,ansiReverseFgBlackYellow,ansiReverseFgRedYellow,ansiReverseFgGreenYellow,ansiReverseFgYellowYellow,ansiReverseFgBlueYellow,ansiReverseFgMagentaYellow,ansiReverseFgCyanYellow,ansiReverseFgWhiteYellow,ansiReverseFgGrayYellow
   syn region ansiYellowReverseBg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=43\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]" contains=@AnsiYellowReverseBgGroup,ansiConceal
   syn region ansiReverseFgBoldYellow	contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseFgUnderlineYellow	contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseFgDefaultYellow	contained start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgBlackYellow	contained start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgRedYellow	contained start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgGreenYellow	contained start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgYellowYellow	contained start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgBlueYellow	contained start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgMagentaYellow	contained start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgCyanYellow	contained start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgWhiteYellow	contained start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgGrayYellow	contained start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseFgBoldYellow      ansiYellowBold
   hi link ansiReverseFgUnderlineYellow ansiYellowUnderline
   hi link ansiReverseFgDefaultYellow   ansiYellowDefault
   hi link ansiReverseFgBlackYellow	    ansiYellowBlack
   hi link ansiReverseFgYellowYellow    ansiYellowYellow
   hi link ansiReverseFgGreenYellow	    ansiYellowGreen
   hi link ansiReverseFgYellowYellow    ansiYellowYellow
   hi link ansiReverseFgBlueYellow	    ansiYellowBlue
   hi link ansiReverseFgMagentaYellow   ansiYellowMagenta
   hi link ansiReverseFgCyanYellow	    ansiYellowCyan
   hi link ansiReverseFgWhiteYellow	    ansiYellowWhite
   hi link ansiReverseFgGrayYellow	    ansiYellowGray

   syn cluster AnsiBlueReverseBgGroup contains=ansiReverseBgBoldBlue,ansiReverseBgUnderlineBlue,ansiReverseBgDefaultBlue,ansiReverseBgBlackBlue,ansiReverseBgRedBlue,ansiReverseBgGreenBlue,ansiReverseBgYellowBlue,ansiReverseBgBlueBlue,ansiReverseBgMagentaBlue,ansiReverseBgCyanBlue,ansiReverseBgWhiteBlue,ansiReverseBgGrayBlue
   syn region ansiBlueReverseBg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=44\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiBlueReverseBgGroup,ansiConceal
   syn region ansiReverseBgBoldBlue	        contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgUnderlineBlue    contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgDefaultBlue      contained start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlackBlue        contained start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgRedBlue          contained start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGreenBlue        contained start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgYellowBlue       contained start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlueBlue         contained start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgMagentaBlue      contained start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgCyanBlue         contained start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgWhiteBlue        contained start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGrayBlue        contained start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseBgBoldBlue    ansiBlueBold
   hi link ansiReverseBgUnderlineBlue ansiBlueUnderline
   hi link ansiReverseBgDefaultBlue	ansiBlueDefault
   hi link ansiReverseBgBlackBlue	ansiBlueBlack
   hi link ansiReverseBgBlueBlue	ansiBlueBlue
   hi link ansiReverseBgGreenBlue	ansiBlueGreen
   hi link ansiReverseBgYellowBlue	ansiBlueYellow
   hi link ansiReverseBgBlueBlue	ansiBlueBlue
   hi link ansiReverseBgMagentaBlue	ansiBlueMagenta
   hi link ansiReverseBgCyanBlue	ansiBlueCyan
   hi link ansiReverseBgWhiteBlue	ansiBlueWhite
   hi link ansiReverseBgGrayBlue	ansiBlueGray

   syn cluster AnsiMagentaReverseBgGroup contains=ansiReverseBgBoldMagenta,ansiReverseBgUnderlineMagenta,ansiReverseBgDefaultMagenta,ansiReverseBgBlackMagenta,ansiReverseBgRedMagenta,ansiReverseBgGreenMagenta,ansiReverseBgYellowMagenta,ansiReverseBgBlueMagenta,ansiReverseBgMagentaMagenta,ansiReverseBgCyanMagenta,ansiReverseBgWhiteMagenta,ansiReverseBgGrayMagenta
   syn region ansiMagentaReverseBg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=45\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiMagentaReverseBgGroup,ansiConceal
   syn region ansiReverseBgBoldMagenta          contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgUnderlineMagenta     contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgDefaultMagenta	contained start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlackMagenta	contained start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgRedMagenta	contained start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGreenMagenta	contained start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgYellowMagenta	contained start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlueMagenta	contained start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgMagentaMagenta	contained start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgCyanMagenta	contained start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgWhiteMagenta	contained start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGrayMagenta	contained start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseBgBoldMagenta         ansiMagentaBold
   hi link ansiReverseBgUnderlineMagenta    ansiMagentaUnderline
   hi link ansiReverseBgDefaultMagenta      ansiMagentaDefault
   hi link ansiReverseBgBlackMagenta        ansiMagentaBlack
   hi link ansiReverseBgMagentaMagenta      ansiMagentaMagenta
   hi link ansiReverseBgGreenMagenta        ansiMagentaGreen
   hi link ansiReverseBgYellowMagenta       ansiMagentaYellow
   hi link ansiReverseBgBlueMagenta         ansiMagentaBlue
   hi link ansiReverseBgMagentaMagenta      ansiMagentaMagenta
   hi link ansiReverseBgCyanMagenta         ansiMagentaCyan
   hi link ansiReverseBgWhiteMagenta        ansiMagentaWhite
   hi link ansiReverseBgGrayMagenta        ansiMagentaGray

   syn cluster AnsiCyanReverseBgGroup contains=ansiReverseBgBoldCyan,ansiReverseBgUnderlineCyan,ansiReverseBgDefaultCyan,ansiReverseBgBlackCyan,ansiReverseBgRedCyan,ansiReverseBgGreenCyan,ansiReverseBgYellowCyan,ansiReverseBgBlueCyan,ansiReverseBgMagentaCyan,ansiReverseBgCyanCyan,ansiReverseBgWhiteCyan,ansiReverseBgGrayCyan
   syn region ansiCyanReverseBg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=46\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiCyanReverseBgGroup,ansiConceal
   syn region ansiReverseBgBoldCyan         contained start="\e\[1m" skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgUnderlineCyan    contained start="\e\[4m" skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgDefaultCyan      contained start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlackCyan        contained start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgRedCyan          contained start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGreenCyan        contained start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgYellowCyan       contained start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlueCyan         contained start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgMagentaCyan      contained start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgCyanCyan         contained start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgWhiteCyan        contained start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGrayCyan        contained start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseBgBoldCyan    ansiCyanBold
   hi link ansiReverseBgUnderlineCyan ansiCyanUnderline
   hi link ansiReverseBgDefaultCyan	ansiCyanDefault
   hi link ansiReverseBgBlackCyan	ansiCyanBlack
   hi link ansiReverseBgCyanCyan	ansiCyanCyan
   hi link ansiReverseBgGreenCyan	ansiCyanGreen
   hi link ansiReverseBgYellowCyan	ansiCyanYellow
   hi link ansiReverseBgBlueCyan	ansiCyanBlue
   hi link ansiReverseBgMagentaCyan	ansiCyanMagenta
   hi link ansiReverseBgCyanCyan	ansiCyanCyan
   hi link ansiReverseBgWhiteCyan	ansiCyanWhite
   hi link ansiReverseBgGrayCyan	ansiCyanGray

   syn cluster AnsiWhiteReverseBgGroup contains=ansiReverseBgBoldWhite,ansiReverseBgUnderlineWhite,ansiReverseBgDefaultWhite,ansiReverseBgBlackWhite,ansiReverseBgRedWhite,ansiReverseBgGreenWhite,ansiReverseBgYellowWhite,ansiReverseBgBlueWhite,ansiReverseBgMagentaWhite,ansiReverseBgCyanWhite,ansiReverseBgWhiteWhite,ansiReverseBgGrayWhite
   syn region ansiWhiteReverseBg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=47\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=49m\|\ze\e\[[04m]"  contains=@AnsiWhiteReverseBgGroup,ansiConceal
   syn region ansiReverseBgBoldWhite        contained start="\e\[1m" skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgUnderlineWhite   contained start="\e\[4m" skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseBgDefaultWhite     contained start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlackWhite       contained start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgRedWhite         contained start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGreenWhite       contained start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgYellowWhite      contained start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgBlueWhite        contained start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgMagentaWhite     contained start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgCyanWhite        contained start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgWhiteWhite       contained start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiReverseBgGrayWhite       contained start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseBgBoldWhite   ansiWhiteBold
   hi link ansiReverseBgUnderlineWhite ansiWhiteUnderline
   hi link ansiReverseBgDefaultWhite ansiWhiteDefault
   hi link ansiReverseBgBlackWhite	ansiWhiteBlack
   hi link ansiReverseBgRedWhite    ansiWhiteRed
   hi link ansiReverseBgGreenWhite	ansiWhiteGreen
   hi link ansiReverseBgYellowWhite	ansiWhiteYellow
   hi link ansiReverseBgBlueWhite	ansiWhiteBlue
   hi link ansiReverseBgMagentaWhite ansiWhiteMagenta
   hi link ansiReverseBgCyanWhite	ansiWhiteCyan
   hi link ansiReverseBgWhiteWhite	ansiWhiteWhite
   hi link ansiReverseBgGrayWhite	ansiWhiteGray

   "-----------------------------------------
   " handles implicit reverse foreground highlighting
   "-----------------------------------------
"   call Decho("installing implicit reverse foreground highlighting")

   syn cluster AnsiDefaultReverseFgGroup contains=ansiReverseFgDefaultBold,ansiReverseFgDefaultUnderline,ansiReverseFgDefaultDefault,ansiReverseFgDefaultBlack,ansiReverseFgDefaultRed,ansiReverseFgDefaultGreen,ansiReverseFgDefaultYellow,ansiReverseFgDefaultBlue,ansiReverseFgDefaultMagenta,ansiReverseFgDefaultCyan,ansiReverseFgDefaultWhite
   syn region ansiDefaultReverseFg		contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=39\%(;1\)\=m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=@AnsiDefaultReverseFgGroup,ansiConceal
   syn region ansiReverseFgDefaultBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgDefaultUnerline	contained	start="\e\[4m"  skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgDefaultDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgDefaultBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgDefaultRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgDefaultGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgDefaultYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgDefaultBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgDefaultMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgDefaultCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgDefaultWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiDefaultReverseFg		ansiReverseDefault
   hi link ansiReverseFgDefaultBold      	 ansiBoldDefault
   hi link ansiReverseFgDefaultUnderline 	 ansiUnderlineDefault
   hi link ansiReverseFgDefaultDefault   	 ansiDefaultDefault
   hi link ansiReverseFgDefaultBlack     	 ansiBlackDefault
   hi link ansiReverseFgDefaultRed       	 ansiRedDefault
   hi link ansiReverseFgDefaultGreen     	 ansiGreenDefault
   hi link ansiReverseFgDefaultYellow    	 ansiYellowDefault
   hi link ansiReverseFgDefaultBlue      	 ansiBlueDefault
   hi link ansiReverseFgDefaultMagenta   	 ansiMagentaDefault
   hi link ansiReverseFgDefaultCyan      	 ansiCyanDefault
   hi link ansiReverseFgDefaultWhite     	 ansiWhiteDefault

   syn cluster AnsiBlackReverseFgGroup contains=ansiReverseFgBlackBold,ansiReverseFgBlackUnderline,ansiReverseFgBlackDefault,ansiReverseFgBlackBlack,ansiReverseFgBlackRed,ansiReverseFgBlackGreen,ansiReverseFgBlackYellow,ansiReverseFgBlackBlue,ansiReverseFgBlackMagenta,ansiReverseFgBlackCyan,ansiReverseFgBlackWhite
   syn region ansiBlackReverseFg	contained concealends	matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=30\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiBlackReverseFgGroup,ansiConceal
   syn region ansiReverseFgBlackBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiReverseFgBlackUnerline	contained	start="\e\[4m"  skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgBlackDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgBlackBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgBlackRed	            contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgBlackGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgBlackYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgBlackBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgBlackMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgBlackCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   syn region ansiReverseFgBlackWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3  contains=ansiConceal
   hi link ansiBlackReverseFg		ansiReverseBlack
   hi link ansiReverseFgBlackBold      	 ansiBoldBlack
   hi link ansiReverseFgBlackUnderline 	 ansiUnderlineBlack
   hi link ansiReverseFgBlackDefault   	 ansiDefaultBlack
   hi link ansiReverseFgBlackBlack     	 ansiBlackBlack
   hi link ansiReverseFgBlackRed       	 ansiRedBlack
   hi link ansiReverseFgBlackGreen     	 ansiGreenBlack
   hi link ansiReverseFgBlackYellow    	 ansiYellowBlack
   hi link ansiReverseFgBlackBlue      	 ansiBlueBlack
   hi link ansiReverseFgBlackMagenta   	 ansiMagentaBlack
   hi link ansiReverseFgBlackCyan      	 ansiCyanBlack
   hi link ansiReverseFgBlackWhite     	 ansiWhiteBlack

   syn cluster AnsiRedReverseFgGroup contains=ansiReverseFgRedBold,ansiReverseFgRedUnderline,ansiReverseFgRedDefault,ansiReverseFgRedBlack,ansiReverseFgRedRed,ansiReverseFgRedGreen,ansiReverseFgRedYellow,ansiReverseFgRedBlue,ansiReverseFgRedMagenta,ansiReverseFgRedCyan,ansiReverseFgRedWhite
   syn region ansiRedReverseFg		contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=31\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiRedReverseFgGroup,ansiConceal
   syn region ansiReverseFgRedBold      contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgRedUnderline contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgRedDefault   contained start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgRedBlack     contained start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgRedRed       contained start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgRedGreen     contained start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgRedYellow    contained start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgRedBlue      contained start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgRedMagenta   contained start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgRedCyan      contained start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgRedWhite     contained start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiRedReverseFg		ansiReverseRed
   hi link ansiReverseFgRedBold      	 ansiBoldRed
   hi link ansiReverseFgRedUnderline 	 ansiUnderlineRed
   hi link ansiReverseFgRedDefault   	 ansiDefaultRed
   hi link ansiReverseFgRedBlack     	 ansiBlackRed
   hi link ansiReverseFgRedRed       	 ansiRedRed
   hi link ansiReverseFgRedGreen     	 ansiGreenRed
   hi link ansiReverseFgRedYellow    	 ansiYellowRed
   hi link ansiReverseFgRedBlue      	 ansiBlueRed
   hi link ansiReverseFgRedMagenta   	 ansiMagentaRed
   hi link ansiReverseFgRedCyan      	 ansiCyanRed
   hi link ansiReverseFgRedWhite     	 ansiWhiteRed

   syn cluster AnsiGreenReverseFgGroup contains=ansiReverseFgGreenBold,ansiReverseFgGreenUnderline,ansiReverseFgGreenDefault,ansiReverseFgGreenBlack,ansiReverseFgGreenRed,ansiReverseFgGreenGreen,ansiReverseFgGreenYellow,ansiReverseFgGreenBlue,ansiReverseFgGreenMagenta,ansiReverseFgGreenCyan,ansiReverseFgGreenWhite
   syn region ansiGreenReverseFg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=32\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiGreenReverseFgGroup,ansiConceal
   syn region ansiReverseFgGreenBold      contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgGreenUnderline contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgGreenDefault   contained start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGreenBlack     contained start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGreenRed       contained start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGreenGreen     contained start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGreenYellow    contained start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGreenBlue      contained start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGreenMagenta   contained start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGreenCyan      contained start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGreenWhite     contained start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiGreenReverseFg		ansiReverseGreen
   hi link ansiReverseFgGreenBold      	 ansiBoldGreen
   hi link ansiReverseFgGreenUnderline 	 ansiUnderlineGreen
   hi link ansiReverseFgGreenDefault   	 ansiDefaultGreen
   hi link ansiReverseFgGreenBlack     	 ansiBlackGreen
   hi link ansiReverseFgGreenGreen     	 ansiGreenGreen
   hi link ansiReverseFgGreenRed       	 ansiRedGreen
   hi link ansiReverseFgGreenYellow    	 ansiYellowGreen
   hi link ansiReverseFgGreenBlue      	 ansiBlueGreen
   hi link ansiReverseFgGreenMagenta   	 ansiMagentaGreen
   hi link ansiReverseFgGreenCyan      	 ansiCyanGreen
   hi link ansiReverseFgGreenWhite     	 ansiWhiteGreen

   syn cluster AnsiYellowReverseFgGroup contains=ansiReverseFgYellowBold,ansiReverseFgYellowUnderline,ansiReverseFgYellowDefault,ansiReverseFgYellowBlack,ansiReverseFgYellowRed,ansiReverseFgYellowGreen,ansiReverseFgYellowYellow,ansiReverseFgYellowBlue,ansiReverseFgYellowMagenta,ansiReverseFgYellowCyan,ansiReverseFgYellowWhite
   syn region ansiYellowReverseFg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=33\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiYellowReverseFgGroup,ansiConceal
   syn region ansiReverseFgYellowBold	contained	start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgYellowUnderline	contained	start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgYellowDefault	contained	start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgYellowBlack	contained	start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgYellowRed	contained	start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgYellowGreen	contained	start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgYellowYellow	contained	start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgYellowBlue	contained	start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgYellowMagenta	contained	start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgYellowCyan	contained	start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgYellowWhite	contained	start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiYellowReverseFg		ansiReverseYellow
   hi link ansiReverseFgYellowBold      	 ansiBoldYellow
   hi link ansiReverseFgYellowUnderline 	 ansiUnderlineYellow
   hi link ansiReverseFgYellowDefault   	 ansiDefaultYellow
   hi link ansiReverseFgYellowBlack     	 ansiBlackYellow
   hi link ansiReverseFgYellowRed       	 ansiRedYellow
   hi link ansiReverseFgYellowGreen     	 ansiGreenYellow
   hi link ansiReverseFgYellowYellow    	 ansiYellowYellow
   hi link ansiReverseFgYellowBlue      	 ansiBlueYellow
   hi link ansiReverseFgYellowMagenta   	 ansiMagentaYellow
   hi link ansiReverseFgYellowCyan      	 ansiCyanYellow
   hi link ansiReverseFgYellowWhite     	 ansiWhiteYellow

   syn cluster AnsiBlueReverseFgGroup contains=ansiReverseFgBlueBold,ansiReverseFgBlueUnderline,ansiReverseFgBlueDefault,ansiReverseFgBlueBlack,ansiReverseFgBlueRed,ansiReverseFgBlueGreen,ansiReverseFgBlueYellow,ansiReverseFgBlueBlue,ansiReverseFgBlueMagenta,ansiReverseFgBlueCyan,ansiReverseFgBlueWhite
   syn region ansiBlueReverseFg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=34\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiBlueReverseFgGroup,ansiConceal
   syn region ansiReverseFgBlueBold      contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgBlueUnderline contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgBlueDefault   contained start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgBlueBlack     contained start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgBlueRed       contained start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgBlueGreen     contained start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgBlueYellow    contained start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgBlueBlue      contained start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgBlueMagenta   contained start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgBlueCyan      contained start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgBlueWhite     contained start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiBlueReverseFg		ansiReverseBlue
   hi link ansiReverseFgBlueBold      	 ansiBoldBlue
   hi link ansiReverseFgBlueUnderline 	 ansiUnderlineBlue
   hi link ansiReverseFgBlueDefault   	 ansiDefaultBlue
   hi link ansiReverseFgBlueBlack     	 ansiBlackBlue
   hi link ansiReverseFgBlueRed       	 ansiRedBlue
   hi link ansiReverseFgBlueGreen     	 ansiGreenBlue
   hi link ansiReverseFgBlueYellow    	 ansiYellowBlue
   hi link ansiReverseFgBlueBlue      	 ansiBlueBlue
   hi link ansiReverseFgBlueMagenta   	 ansiMagentaBlue
   hi link ansiReverseFgBlueCyan      	 ansiCyanBlue
   hi link ansiReverseFgBlueWhite     	 ansiWhiteBlue

   syn cluster AnsiMagentaReverseFgGroup contains=ansiReverseFgMagentaBold,ansiReverseFgMagentaUnderline,ansiReverseFgMagentaDefault,ansiReverseFgMagentaBlack,ansiReverseFgMagentaRed,ansiReverseFgMagentaGreen,ansiReverseFgMagentaYellow,ansiReverseFgMagentaBlue,ansiReverseFgMagentaMagenta,ansiReverseFgMagentaCyan,ansiReverseFgMagentaWhite
   syn region ansiMagentaReverseFg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=35\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiMagentaReverseFgGroup,ansiConceal
   syn region ansiReverseFgMagentaBold      contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgMagentaUnderline contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgMagentaDefault   contained start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgMagentaBlack     contained start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgMagentaRed       contained start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgMagentaGreen     contained start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgMagentaYellow    contained start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgMagentaBlue      contained start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgMagentaMagenta   contained start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgMagentaCyan      contained start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgMagentaWhite     contained start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiMagentaReverseFg		ansiReverseMagenta
   hi link ansiReverseFgMagentaBold      	 ansiBoldMagenta
   hi link ansiReverseFgMagentaUnderline 	 ansiUnderlineMagenta
   hi link ansiReverseFgMagentaDefault   	 ansiDefaultMagenta
   hi link ansiReverseFgMagentaBlack     	 ansiBlackMagenta
   hi link ansiReverseFgMagentaRed       	 ansiRedMagenta
   hi link ansiReverseFgMagentaGreen     	 ansiGreenMagenta
   hi link ansiReverseFgMagentaYellow    	 ansiYellowMagenta
   hi link ansiReverseFgMagentaBlue      	 ansiBlueMagenta
   hi link ansiReverseFgMagentaMagenta   	 ansiMagentaMagenta
   hi link ansiReverseFgMagentaCyan      	 ansiCyanMagenta
   hi link ansiReverseFgMagentaWhite     	 ansiWhiteMagenta

   syn cluster AnsiCyanReverseFgGroup contains=ansiReverseFgCyanBold,ansiReverseFgCyanUnderline,ansiReverseFgCyanDefault,ansiReverseFgCyanBlack,ansiReverseFgCyanRed,ansiReverseFgCyanGreen,ansiReverseFgCyanYellow,ansiReverseFgCyanBlue,ansiReverseFgCyanMagenta,ansiReverseFgCyanCyan,ansiReverseFgCyanWhite
   syn region ansiCyanReverseFg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=36\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiCyanReverseFgGroup,ansiConceal
   syn region ansiReverseFgCyanBold      contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgCyanUnderline contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgCyanDefault   contained start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgCyanBlack     contained start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgCyanRed       contained start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgCyanGreen     contained start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgCyanYellow    contained start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgCyanBlue      contained start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgCyanMagenta   contained start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgCyanCyan      contained start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgCyanWhite     contained start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiCyanReverseFg		ansiReverseCyan
   hi link ansiReverseFgCyanBold      	 ansiBoldCyan
   hi link ansiReverseFgCyanUnderline 	 ansiUnderlineCyan
   hi link ansiReverseFgCyanDefault   	 ansiDefaultCyan
   hi link ansiReverseFgCyanBlack     	 ansiBlackCyan
   hi link ansiReverseFgCyanRed       	 ansiRedCyan
   hi link ansiReverseFgCyanGreen     	 ansiGreenCyan
   hi link ansiReverseFgCyanYellow    	 ansiYellowCyan
   hi link ansiReverseFgCyanBlue      	 ansiBlueCyan
   hi link ansiReverseFgCyanMagenta   	 ansiMagentaCyan
   hi link ansiReverseFgCyanCyan      	 ansiCyanCyan
   hi link ansiReverseFgCyanWhite     	 ansiWhiteCyan

   syn cluster AnsiWhiteReverseFgGroup contains=ansiReverseFgWhiteBold,ansiReverseFgWhiteUnderline,ansiReverseFgWhiteDefault,ansiReverseFgWhiteBlack,ansiReverseFgWhiteRed,ansiReverseFgWhiteGreen,ansiReverseFgWhiteYellow,ansiReverseFgWhiteBlue,ansiReverseFgWhiteMagenta,ansiReverseFgWhiteCyan,ansiReverseFgWhiteWhite
   syn region ansiWhiteReverseFg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=37\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[03m]"  contains=@AnsiWhiteReverseFgGroup,ansiConceal
   syn region ansiReverseFgWhiteBold      contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgWhiteUnderline contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgWhiteDefault   contained start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgWhiteBlack     contained start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgWhiteRed       contained start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgWhiteGreen     contained start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgWhiteYellow    contained start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgWhiteBlue      contained start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgWhiteMagenta   contained start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgWhiteCyan      contained start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgWhiteWhite     contained start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiWhiteReverseFg		ansiReverseWhite
   hi link ansiReverseFgWhiteBold      	 ansiBoldWhite
   hi link ansiReverseFgWhiteUnderline 	 ansiUnderlineWhite
   hi link ansiReverseFgWhiteDefault   	 ansiDefaultWhite
   hi link ansiReverseFgWhiteBlack     	 ansiBlackWhite
   hi link ansiReverseFgWhiteRed       	 ansiRedWhite
   hi link ansiReverseFgWhiteGreen     	 ansiGreenWhite
   hi link ansiReverseFgWhiteYellow    	 ansiYellowWhite
   hi link ansiReverseFgWhiteBlue      	 ansiBlueWhite
   hi link ansiReverseFgWhiteMagenta   	 ansiMagentaWhite
   hi link ansiReverseFgWhiteCyan      	 ansiCyanWhite
   hi link ansiReverseFgWhiteWhite     	 ansiWhiteWhite

   syn cluster AnsiGrayReverseFgGroup contains=ansiReverseFgGrayBold,ansiReverseFgGrayUnderline,ansiReverseFgGrayDefault,ansiReverseFgGrayBlack,ansiReverseFgGrayRed,ansiReverseFgGrayGreen,ansiReverseFgGrayYellow,ansiReverseFgGrayBlue,ansiReverseFgGrayMagenta,ansiReverseFgGrayCyan,ansiReverseFgGrayWhite
   syn region ansiGrayReverseFg	contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=\%(1;\)\=90\%(;1\)\=m" skip='\e\[K' end="\e\[\%(0*;*\)\=39m\|\ze\e\[[039m]"  contains=@AnsiGrayReverseFgGroup,ansiConceal
   syn region ansiReverseFgGrayBold      contained start="\e\[1m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgGrayUnderline contained start="\e\[4m"  skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m" contains=ansiConceal
   syn region ansiReverseFgGrayDefault   contained start="\e\[49m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGrayBlack     contained start="\e\[40m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGrayRed       contained start="\e\[41m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGrayGreen     contained start="\e\[42m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGrayYellow    contained start="\e\[43m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGrayBlue      contained start="\e\[44m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGrayMagenta   contained start="\e\[45m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGrayCyan      contained start="\e\[46m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   syn region ansiReverseFgGrayWhite     contained start="\e\[47m" skip='\e\[K' end="\e\[[04m]"me=e-3 contains=ansiConceal
   hi link ansiGrayReverseFg		ansiReverseGray
   hi link ansiReverseFgGrayBold      	 ansiBoldGray
   hi link ansiReverseFgGrayUnderline 	 ansiUnderlineGray
   hi link ansiReverseFgGrayDefault   	 ansiDefaultGray
   hi link ansiReverseFgGrayBlack     	 ansiBlackGray
   hi link ansiReverseFgGrayRed       	 ansiRedGray
   hi link ansiReverseFgGrayGreen     	 ansiGreenGray
   hi link ansiReverseFgGrayYellow    	 ansiYellowGray
   hi link ansiReverseFgGrayBlue      	 ansiBlueGray
   hi link ansiReverseFgGrayMagenta   	 ansiMagentaGray
   hi link ansiReverseFgGrayCyan      	 ansiCyanGray
   hi link ansiReverseFgGrayWhite     	 ansiWhiteGray

   syn cluster AnsiReverseBoldGroup contains=ansiUnderlineReverseBoldRegion,ansiDefaultReverseBoldRegion,ansiBlackReverseBoldRegion,ansiWhiteReverseBoldRegion,ansiGrayReverseBoldRegion,ansiRedReverseBoldRegion,ansiGreenReverseBoldRegion,ansiYellowReverseBoldRegion,ansiBlueReverseBoldRegion,ansiMagentaReverseBoldRegion,ansiCyanReverseBoldRegion
   syn region ansiReverseBoldRegion     contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=1;\=m" end="\ze\e\[\%(0*;*\)\=\%(0*\|22\)\=m" contains=@AnsiBoldGroup,ansiConceal
   syn region ansiUnderlineReverseBoldRegion	contained start="\e\[4m" skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(24\|0*\)\=m"  contains=ansiConceal
   syn region ansiDefaultReverseBoldRegion	contained start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBlackReverseBoldRegion	contained start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiRedReverseBoldRegion	contained start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiGreenReverseBoldRegion	contained start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiYellowReverseBoldRegion	contained start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBlueReverseBoldRegion	contained start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiMagentaReverseBoldRegion	contained start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiCyanReverseBoldRegion	contained start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiWhiteReverseBoldRegion	contained start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiGrayReverseBoldRegion	contained start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseBoldRegion                ansiReverseBold
   hi link ansiUnderlineReverseBoldRegion	ansiReverseBoldUnderline
   hi link ansiDefaultReverseBoldRegion	ansiDefaultBold
   hi link ansiBlackReverseBoldRegion	ansiBlackBold
   hi link ansiRedReverseBoldRegion	            ansiRedBold
   hi link ansiGreenReverseBoldRegion	ansiGreenBold
   hi link ansiYellowReverseBoldRegion	ansiYellowBold
   hi link ansiBlueReverseBoldRegion	ansiBlueBold
   hi link ansiMagentaReverseBoldRegion	ansiMagentaBold
   hi link ansiCyanReverseBoldRegion	ansiCyanBold
   hi link ansiWhiteReverseBoldRegion	ansiWhiteBold
   hi link ansiGrayReverseBoldRegion	ansiGrayBold

   syn cluster AnsiReverseUnderlineGroup contains=ansiBoldReverseUnderlineRegion,ansiDefaultReverseUnderlineRegion,ansiBlackReverseUnderlineRegion,ansiWhiteReverseUnderlineRegion,ansiGrayReverseUnderlineRegion,ansiRedReverseUnderlineRegion,ansiGreenReverseUnderlineRegion,ansiYellowReverseUnderlineRegion,ansiBlueReverseUnderlineRegion,ansiMagentaReverseUnderlineRegion,ansiCyanReverseUnderlineRegion,ansiBgStop,ansiBoldStop
   syn region ansiReverseUnderlineRegion contained concealends matchgroup=ansiNone start="\e\[;\=0\{0,2};\=4;\=m" end="\ze\e\[\%(0*;*\)\=\%(0*\|24\)\=m" contains=@AnsiUnderlineGroup,ansiConceal
   syn region ansiBoldReverseUnderlineRegion	contained start="\e\[1m" skip='\e\[K' end="\ze\e\[\%(0*;*\)\=\%(22\|0*\)\=m"  contains=ansiConceal
   syn region ansiDefaultReverseUnderlineRegion	contained start="\e\[39m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBlackReverseUnderlineRegion	contained start="\e\[30m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiRedReverseUnderlineRegion	contained start="\e\[31m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiGreenReverseUnderlineRegion	contained start="\e\[32m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiYellowReverseUnderlineRegion	contained start="\e\[33m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiBlueReverseUnderlineRegion	contained start="\e\[34m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiMagentaReverseUnderlineRegion	contained start="\e\[35m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiCyanReverseUnderlineRegion	contained start="\e\[36m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiWhiteReverseUnderlineRegion	contained start="\e\[37m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   syn region ansiGrayReverseUnderlineRegion	contained start="\e\[90m" skip='\e\[K' end="\e\[[03m]"me=e-3  contains=ansiConceal
   hi link ansiReverseUnderlineRegion           ansiReverseUnderline
   hi link ansiBoldReverseUnderlineRegion       ansiReverseBoldUnderline
   hi link ansiDefaultReverseUnderlineRegion    ansiDefaultUnderline
   hi link ansiBlackReverseUnderlineRegion      ansiBlackUnderline
   hi link ansiRedReverseUnderlineRegion	ansiRedUnderline
   hi link ansiGreenReverseUnderlineRegion	ansiGreenUnderline
   hi link ansiYellowReverseUnderlineRegion     ansiYellowUnderline
   hi link ansiBlueReverseUnderlineRegion	ansiBlueUnderline
   hi link ansiMagentaReverseUnderlineRegion    ansiMagentaUnderline
   hi link ansiCyanReverseUnderlineRegion	ansiCyanUnderline
   hi link ansiWhiteReverseUnderlineRegion	ansiWhiteUnderline
   hi link ansiGrayReverseUnderlineRegion	ansiGrayUnderline
  endif

  if has("conceal")
   syn match ansiStop		conceal "\e\[;\=0\{0,2}m"
   syn match ansiStop		conceal "\e\[K"
   syn match ansiStop		conceal "\e\[H"
   syn match ansiStop		conceal "\e\[2J"
  else
   syn match ansiStop		"\e\[;\=0\{0,2}m"
   syn match ansiStop		"\e\[K"
   syn match ansiStop		"\e\[H"
   syn match ansiStop		"\e\[2J"
  endif

  " ---------------------------------------------------------------------
  " Some Color Combinations: - can't do 'em all, the qty of highlighting groups is limited! {{{2
  " ---------------------------------------------------------------------
  syn region ansiBlackDefault	start="\e\[0\{0,2};\=\(30;49\|49;30\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRedDefault	start="\e\[0\{0,2};\=\(31;49\|49;31\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGreenDefault	start="\e\[0\{0,2};\=\(32;49\|49;32\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiYellowDefault	start="\e\[0\{0,2};\=\(33;49\|49;33\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlueDefault	start="\e\[0\{0,2};\=\(34;49\|49;34\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiMagentaDefault	start="\e\[0\{0,2};\=\(35;49\|49;35\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiCyanDefault	start="\e\[0\{0,2};\=\(36;49\|49;36\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiWhiteDefault	start="\e\[0\{0,2};\=\(37;49\|49;37\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiDefaultDefault	start="\e\[0\{0,2};\=\(39;49\|49;39\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGrayDefault	start="\e\[0\{0,2};\=\(90;49\|49;90\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal

  syn region ansiBlackBlack	start="\e\[0\{0,2};\=\(30;40\|40;30\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRedBlack	start="\e\[0\{0,2};\=\(31;40\|40;31\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGreenBlack	start="\e\[0\{0,2};\=\(32;40\|40;32\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiYellowBlack	start="\e\[0\{0,2};\=\(33;40\|40;33\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlueBlack	start="\e\[0\{0,2};\=\(34;40\|40;34\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiMagentaBlack	start="\e\[0\{0,2};\=\(35;40\|40;35\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiCyanBlack	start="\e\[0\{0,2};\=\(36;40\|40;36\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiWhiteBlack	start="\e\[0\{0,2};\=\(37;40\|40;37\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiDefaultBlack	start="\e\[0\{0,2};\=\(39;40\|40;39\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGrayBlack	start="\e\[0\{0,2};\=\(90;40\|40;90\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal

  syn region ansiBlackRed	start="\e\[0\{0,2};\=\(30;41\|41;30\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRedRed		start="\e\[0\{0,2};\=\(31;41\|41;31\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGreenRed	start="\e\[0\{0,2};\=\(32;41\|41;32\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiYellowRed	start="\e\[0\{0,2};\=\(33;41\|41;33\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlueRed	start="\e\[0\{0,2};\=\(34;41\|41;34\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiMagentaRed	start="\e\[0\{0,2};\=\(35;41\|41;35\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiCyanRed	start="\e\[0\{0,2};\=\(36;41\|41;36\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiWhiteRed	start="\e\[0\{0,2};\=\(37;41\|41;37\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiDefaultRed	start="\e\[0\{0,2};\=\(39;41\|41;39\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGrayRed	start="\e\[0\{0,2};\=\(90;41\|41;90\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal

  syn region ansiBlackGreen	start="\e\[0\{0,2};\=\(30;42\|42;30\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRedGreen	start="\e\[0\{0,2};\=\(31;42\|42;31\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGreenGreen	start="\e\[0\{0,2};\=\(32;42\|42;32\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiYellowGreen	start="\e\[0\{0,2};\=\(33;42\|42;33\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlueGreen	start="\e\[0\{0,2};\=\(34;42\|42;34\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiMagentaGreen	start="\e\[0\{0,2};\=\(35;42\|42;35\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiCyanGreen	start="\e\[0\{0,2};\=\(36;42\|42;36\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiWhiteGreen	start="\e\[0\{0,2};\=\(37;42\|42;37\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiDefaultGreen	start="\e\[0\{0,2};\=\(39;42\|42;39\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGrayGreen	start="\e\[0\{0,2};\=\(90;42\|42;90\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal

  syn region ansiBlackYellow	start="\e\[0\{0,2};\=\(30;43\|43;30\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRedYellow	start="\e\[0\{0,2};\=\(31;43\|43;31\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGreenYellow	start="\e\[0\{0,2};\=\(32;43\|43;32\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiYellowYellow	start="\e\[0\{0,2};\=\(33;43\|43;33\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlueYellow	start="\e\[0\{0,2};\=\(34;43\|43;34\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiMagentaYellow	start="\e\[0\{0,2};\=\(35;43\|43;35\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiCyanYellow	start="\e\[0\{0,2};\=\(36;43\|43;36\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiWhiteYellow	start="\e\[0\{0,2};\=\(37;43\|43;37\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiDefaultYellow	start="\e\[0\{0,2};\=\(39;43\|43;39\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGrayYellow	start="\e\[0\{0,2};\=\(90;43\|43;90\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal

  syn region ansiBlackBlue	start="\e\[0\{0,2};\=\(30;44\|44;30\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRedBlue	start="\e\[0\{0,2};\=\(31;44\|44;31\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGreenBlue	start="\e\[0\{0,2};\=\(32;44\|44;32\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiYellowBlue	start="\e\[0\{0,2};\=\(33;44\|44;33\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlueBlue	start="\e\[0\{0,2};\=\(34;44\|44;34\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiMagentaBlue	start="\e\[0\{0,2};\=\(35;44\|44;35\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiCyanBlue	start="\e\[0\{0,2};\=\(36;44\|44;36\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiWhiteBlue	start="\e\[0\{0,2};\=\(37;44\|44;37\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiDefaultBlue	start="\e\[0\{0,2};\=\(39;44\|44;39\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGrayBlue	start="\e\[0\{0,2};\=\(90;44\|44;90\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal

  syn region ansiBlackMagenta	start="\e\[0\{0,2};\=\(30;45\|45;30\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRedMagenta	start="\e\[0\{0,2};\=\(31;45\|45;31\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGreenMagenta	start="\e\[0\{0,2};\=\(32;45\|45;32\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiYellowMagenta	start="\e\[0\{0,2};\=\(33;45\|45;33\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlueMagenta	start="\e\[0\{0,2};\=\(34;45\|45;34\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiMagentaMagenta	start="\e\[0\{0,2};\=\(35;45\|45;35\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiCyanMagenta	start="\e\[0\{0,2};\=\(36;45\|45;36\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiWhiteMagenta	start="\e\[0\{0,2};\=\(37;45\|45;37\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiDefaultMagenta	start="\e\[0\{0,2};\=\(39;45\|45;39\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGrayMagenta	start="\e\[0\{0,2};\=\(90;45\|45;90\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal

  syn region ansiBlackCyan	start="\e\[0\{0,2};\=\(30;46\|46;30\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRedCyan	start="\e\[0\{0,2};\=\(31;46\|46;31\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGreenCyan	start="\e\[0\{0,2};\=\(32;46\|46;32\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiYellowCyan	start="\e\[0\{0,2};\=\(33;46\|46;33\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlueCyan	start="\e\[0\{0,2};\=\(34;46\|46;34\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiMagentaCyan	start="\e\[0\{0,2};\=\(35;46\|46;35\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiCyanCyan	start="\e\[0\{0,2};\=\(36;46\|46;36\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiWhiteCyan	start="\e\[0\{0,2};\=\(37;46\|46;37\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiDefaultCyan	start="\e\[0\{0,2};\=\(39;46\|46;39\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGrayCyan	start="\e\[0\{0,2};\=\(90;46\|46;90\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal

  syn region ansiBlackWhite	start="\e\[0\{0,2};\=\(30;47\|47;30\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiRedWhite	start="\e\[0\{0,2};\=\(31;47\|47;31\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGreenWhite	start="\e\[0\{0,2};\=\(32;47\|47;32\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiYellowWhite	start="\e\[0\{0,2};\=\(33;47\|47;33\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiBlueWhite	start="\e\[0\{0,2};\=\(34;47\|47;34\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiMagentaWhite	start="\e\[0\{0,2};\=\(35;47\|47;35\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiCyanWhite	start="\e\[0\{0,2};\=\(36;47\|47;36\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiWhiteWhite	start="\e\[0\{0,2};\=\(37;47\|47;37\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiDefaultWhite	start="\e\[0\{0,2};\=\(39;47\|47;39\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal
  syn region ansiGrayWhite	start="\e\[0\{0,2};\=\(90;47\|47;90\)m" skip="\e\[K" end="\e\["me=e-2 contains=ansiConceal

  syn match ansiExtended	"\e\[;\=\(0;\)\=[34]8;\(\d*;\)*\d*m"   contains=ansiConceal

  " -------------
  " Highlighting: {{{2
  " -------------
  if !has("conceal")
   " --------------
   " ansiesc_ignore: {{{3
   " --------------
   hi def link ansiConceal	Ignore
   hi def link ansiSuppress	Ignore
   hi def link ansiIgnore	ansiStop
   hi def link ansiStop		Ignore
   hi def link ansiExtended	Ignore
   let s:hlkeep_{bufnr("%")}= &l:hl
   exe "setlocal hl=".substitute(&hl,'8:[^,]\{-},','8:Ignore,',"")
  endif

  " handle 3 or more element ansi escape sequences by building syntax and highlighting rules
  " specific to the current file
  call s:MultiElementHandler()

  hi ansiNone	cterm=NONE gui=NONE

  if &t_Co == 8 || &t_Co == 256
   " ---------------------
   " eight-color handling: {{{3
   " ---------------------
"   call Decho("set up 8-color highlighting groups")
   execute 'hi ansiBlack             ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiRed               ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=NONE         gui=NONE'
   execute 'hi ansiGreen             ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiYellow            ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=NONE         gui=NONE'
   execute 'hi ansiBlue              ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiMagenta           ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=NONE         gui=NONE'
   execute 'hi ansiCyan              ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiWhite             ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiGray              ctermfg=7       guifg=' . g:ansi_DarkGray . '                                         cterm=NONE         gui=NONE'

   execute 'hi ansiDefaultBg         ctermbg=NONE       guibg=NONE                                         cterm=NONE         gui=NONE'
   execute 'hi ansiBlackBg           ctermbg=0      guibg=' . g:ansi_Black . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiRedBg             ctermbg=1        guibg=' . g:ansi_DarkRed . '                                          cterm=NONE         gui=NONE'
   execute 'hi ansiGreenBg           ctermbg=2      guibg=' . g:ansi_DarkGreen . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiYellowBg          ctermbg=3     guibg=' . g:ansi_DarkYellow . '                                       cterm=NONE         gui=NONE'
   execute 'hi ansiBlueBg            ctermbg=4       guibg=' . g:ansi_DarkBlue . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaBg         ctermbg=5    guibg=' . g:ansi_DarkMagenta . '                                      cterm=NONE         gui=NONE'
   execute 'hi ansiCyanBg            ctermbg=6       guibg=' . g:ansi_DarkCyan . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteBg           ctermbg=15      guibg=' . g:ansi_LightGray . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiGrayBg            ctermbg=7       guibg=' . g:ansi_DarkGray . '                                         cterm=NONE         gui=NONE'

   execute 'hi ansiBlackFg           ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiRedFg             ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=NONE         gui=NONE'
   execute 'hi ansiGreenFg           ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiYellowFg          ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=NONE         gui=NONE'
   execute 'hi ansiBlueFg            ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaFg         ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=NONE         gui=NONE'
   execute 'hi ansiCyanFg            ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteFg           ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiGrayFg            ctermfg=7       guifg=' . g:ansi_DarkGray . '                                         cterm=NONE         gui=NONE'

   execute 'hi ansiDefaultReverseBg         ctermbg=NONE       guibg=NONE                                         cterm=reverse         gui=reverse'
   execute 'hi ansiBlackReverseBg           ctermbg=0      guibg=' . g:ansi_Black . '                                        cterm=reverse         gui=reverse'
   execute 'hi ansiRedReverseBg             ctermbg=1        guibg=' . g:ansi_DarkRed . '                                          cterm=reverse         gui=reverse'
   execute 'hi ansiGreenReverseBg           ctermbg=2      guibg=' . g:ansi_DarkGreen . '                                        cterm=reverse         gui=reverse'
   execute 'hi ansiYellowReverseBg          ctermbg=3     guibg=' . g:ansi_DarkYellow . '                                       cterm=reverse         gui=reverse'
   execute 'hi ansiBlueReverseBg            ctermbg=4       guibg=' . g:ansi_DarkBlue . '                                         cterm=reverse         gui=reverse'
   execute 'hi ansiMagentaReverseBg         ctermbg=5    guibg=' . g:ansi_DarkMagenta . '                                      cterm=reverse         gui=reverse'
   execute 'hi ansiCyanReverseBg            ctermbg=6       guibg=' . g:ansi_DarkCyan . '                                         cterm=reverse         gui=reverse'
   execute 'hi ansiWhiteReverseBg           ctermbg=15      guibg=' . g:ansi_LightGray . '                                        cterm=reverse         gui=reverse'

   execute 'hi ansiBold                                                                                    cterm=bold         gui=bold'
   execute 'hi ansiBoldUnderline                                                                           cterm=bold,underline gui=bold,underline'
   execute 'hi ansiBoldBlack         ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=bold         gui=bold'
   execute 'hi ansiBoldRed           ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=bold         gui=bold'
   execute 'hi ansiBoldGreen         ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=bold         gui=bold'
   execute 'hi ansiBoldYellow        ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=bold         gui=bold'
   execute 'hi ansiBoldBlue          ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=bold         gui=bold'
   execute 'hi ansiBoldMagenta       ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=bold         gui=bold'
   execute 'hi ansiBoldCyan          ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=bold         gui=bold'
   execute 'hi ansiBoldWhite         ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=bold         gui=bold'
   execute 'hi ansiBoldGray          ctermbg=7       guibg=' . g:ansi_DarkGray . '                                         cterm=bold         gui=bold'

   execute 'hi ansiBlackBold         ctermbg=0      guibg=' . g:ansi_Black . '                                        cterm=bold         gui=bold'
   execute 'hi ansiRedBold           ctermbg=1        guibg=' . g:ansi_DarkRed . '                                          cterm=bold         gui=bold'
   execute 'hi ansiGreenBold         ctermbg=2      guibg=' . g:ansi_DarkGreen . '                                        cterm=bold         gui=bold'
   execute 'hi ansiYellowBold        ctermbg=3     guibg=' . g:ansi_DarkYellow . '                                       cterm=bold         gui=bold'
   execute 'hi ansiBlueBold          ctermbg=4       guibg=' . g:ansi_DarkBlue . '                                         cterm=bold         gui=bold'
   execute 'hi ansiMagentaBold       ctermbg=5    guibg=' . g:ansi_DarkMagenta . '                                      cterm=bold         gui=bold'
   execute 'hi ansiCyanBold          ctermbg=6       guibg=' . g:ansi_DarkCyan . '                                         cterm=bold         gui=bold'
   execute 'hi ansiWhiteBold         ctermbg=15      guibg=' . g:ansi_LightGray . '                                        cterm=bold         gui=bold'

   execute 'hi ansiReverse                                                                                 cterm=reverse      gui=reverse'
   execute 'hi ansiReverseUnderline                                                                        cterm=reverse,underline gui=reverse,underline'
   execute 'hi ansiReverseBold                                                                             cterm=reverse,bold gui=reverse,bold'
   execute 'hi ansiReverseBoldUnderline                                                                    cterm=reverse,bold,underline gui=reverse,bold,underline'
   execute 'hi ansiReverseBlack      ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=reverse         gui=reverse'
   execute 'hi ansiReverseRed        ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=reverse         gui=reverse'
   execute 'hi ansiReverseGreen      ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=reverse         gui=reverse'
   execute 'hi ansiReverseYellow     ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=reverse         gui=reverse'
   execute 'hi ansiReverseBlue       ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=reverse         gui=reverse'
   execute 'hi ansiReverseMagenta    ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=reverse         gui=reverse'
   execute 'hi ansiReverseCyan       ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=reverse         gui=reverse'
   execute 'hi ansiReverseWhite      ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=reverse         gui=reverse'
   execute 'hi ansiReverseGray       ctermfg=7       guifg=' . g:ansi_DarkGray . '                                         cterm=reverse         gui=reverse'

   execute 'hi ansiStandout                                                                                cterm=standout     gui=standout'
   execute 'hi ansiStandoutBlack     ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=standout     gui=standout'
   execute 'hi ansiStandoutRed       ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=standout     gui=standout'
   execute 'hi ansiStandoutGreen     ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=standout     gui=standout'
   execute 'hi ansiStandoutYellow    ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=standout     gui=standout'
   execute 'hi ansiStandoutBlue      ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=standout     gui=standout'
   execute 'hi ansiStandoutMagenta   ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=standout     gui=standout'
   execute 'hi ansiStandoutCyan      ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=standout     gui=standout'
   execute 'hi ansiStandoutWhite     ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=standout     gui=standout'
   execute 'hi ansiStandoutGray      ctermfg=7       guifg=' . g:ansi_DarkGray . '                                         cterm=standout     gui=standout'

   execute 'hi ansiItalic                                                                                  cterm=italic       gui=italic'
   execute 'hi ansiItalicBlack       ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=italic       gui=italic'
   execute 'hi ansiItalicRed         ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=italic       gui=italic'
   execute 'hi ansiItalicGreen       ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=italic       gui=italic'
   execute 'hi ansiItalicYellow      ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=italic       gui=italic'
   execute 'hi ansiItalicBlue        ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=italic       gui=italic'
   execute 'hi ansiItalicMagenta     ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=italic       gui=italic'
   execute 'hi ansiItalicCyan        ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=italic       gui=italic'
   execute 'hi ansiItalicWhite       ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=italic       gui=italic'
   execute 'hi ansiItalicGray        ctermfg=7       guifg=' . g:ansi_DarkGray . '                                         cterm=italic       gui=italic'

   execute 'hi ansiUnderline                                                                               cterm=underline    gui=underline'
   execute 'hi ansiUnderlineBlack    ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=underline    gui=underline'
   execute 'hi ansiUnderlineRed      ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=underline    gui=underline'
   execute 'hi ansiUnderlineGreen    ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=underline    gui=underline'
   execute 'hi ansiUnderlineYellow   ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=underline    gui=underline'
   execute 'hi ansiUnderlineBlue     ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=underline    gui=underline'
   execute 'hi ansiUnderlineMagenta  ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=underline    gui=underline'
   execute 'hi ansiUnderlineCyan     ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=underline    gui=underline'
   execute 'hi ansiUnderlineWhite    ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=underline    gui=underline'
   execute 'hi ansiUnderlineGray     ctermfg=7       guifg=' . g:ansi_DarkGray . '                                         cterm=underline    gui=underline'

   execute 'hi ansiBlackUnderline    ctermbg=0      guibg=' . g:ansi_Black . '                                        cterm=underline    gui=underline'
   execute 'hi ansiRedUnderline      ctermbg=1        guibg=' . g:ansi_DarkRed . '                                          cterm=underline    gui=underline'
   execute 'hi ansiGreenUnderline    ctermbg=2      guibg=' . g:ansi_DarkGreen . '                                        cterm=underline    gui=underline'
   execute 'hi ansiYellowUnderline   ctermbg=3     guibg=' . g:ansi_DarkYellow . '                                       cterm=underline    gui=underline'
   execute 'hi ansiBlueUnderline     ctermbg=4       guibg=' . g:ansi_DarkBlue . '                                         cterm=underline    gui=underline'
   execute 'hi ansiMagentaUnderline  ctermbg=5    guibg=' . g:ansi_DarkMagenta . '                                      cterm=underline    gui=underline'
   execute 'hi ansiCyanUnderline     ctermbg=6       guibg=' . g:ansi_DarkCyan . '                                         cterm=underline    gui=underline'
   execute 'hi ansiWhiteUnderline    ctermbg=15      guibg=' . g:ansi_LightGray . '                                        cterm=underline    gui=underline'

   execute 'hi ansiBlink                                                                                   cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkBlack        ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkRed          ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkGreen        ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkYellow       ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkBlue         ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkMagenta      ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkCyan         ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkWhite        ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkGray         ctermfg=7       guifg=' . g:ansi_DarkGray . '                                         cterm=standout     gui=undercurl'

   execute 'hi ansiRapidBlink                                                                              cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkBlack   ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkRed     ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkGreen   ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkYellow  ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkBlue    ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkMagenta ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkCyan    ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkWhite   ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkGray    ctermfg=7       guifg=' . g:ansi_DarkGray . '                                         cterm=standout     gui=undercurl'

   execute 'hi ansiRV                                                                                      cterm=reverse      gui=reverse'
   execute 'hi ansiRVBlack           ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=reverse      gui=reverse'
   execute 'hi ansiRVRed             ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=reverse      gui=reverse'
   execute 'hi ansiRVGreen           ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=reverse      gui=reverse'
   execute 'hi ansiRVYellow          ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=reverse      gui=reverse'
   execute 'hi ansiRVBlue            ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=reverse      gui=reverse'
   execute 'hi ansiRVMagenta         ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=reverse      gui=reverse'
   execute 'hi ansiRVCyan            ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=reverse      gui=reverse'
   execute 'hi ansiRVWhite           ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=reverse      gui=reverse'
   execute 'hi ansiRVGray            ctermfg=7       guifg=' . g:ansi_DarkGray . '                                         cterm=reverse      gui=reverse'

   execute 'hi ansiBoldDefault         ctermfg=NONE           ctermbg=NONE      guifg=NONE           guibg=NONE    cterm=bold         gui=bold'
   execute 'hi ansiUnderlineDefault    ctermfg=NONE           ctermbg=NONE      guifg=NONE           guibg=NONE    cterm=underline    gui=underline'
   execute 'hi ansiBlackDefault        ctermfg=0          ctermbg=NONE      guifg=' . g:ansi_Black . '          guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiRedDefault          ctermfg=1        ctermbg=NONE      guifg=' . g:ansi_DarkRed . '        guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiGreenDefault        ctermfg=2      ctermbg=NONE      guifg=' . g:ansi_DarkGreen . '      guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiYellowDefault       ctermfg=3     ctermbg=NONE      guifg=' . g:ansi_DarkYellow . '     guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiBlueDefault         ctermfg=4       ctermbg=NONE      guifg=' . g:ansi_DarkBlue . '       guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaDefault      ctermfg=5    ctermbg=NONE      guifg=' . g:ansi_DarkMagenta . '    guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiCyanDefault         ctermfg=6       ctermbg=NONE      guifg=' . g:ansi_DarkCyan . '       guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteDefault        ctermfg=15      ctermbg=NONE      guifg=' . g:ansi_LightGray . '      guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiGrayDefault         ctermfg=7      ctermbg=NONE      guifg=' . g:ansi_DarkGray . '      guibg=NONE    cterm=NONE         gui=NONE'

   execute 'hi ansiDefaultDefault      ctermfg=NONE      ctermbg=NONE       guifg=NONE       guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultBlack        ctermfg=NONE      ctermbg=0      guifg=NONE       guibg=' . g:ansi_Black . '   cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultRed          ctermfg=NONE        ctermbg=1      guifg=NONE        guibg=' . g:ansi_DarkRed . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultGreen        ctermfg=NONE      ctermbg=2      guifg=NONE      guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultYellow       ctermfg=NONE     ctermbg=3      guifg=NONE     guibg=' . g:ansi_DarkYellow . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultBlue         ctermfg=NONE       ctermbg=4      guifg=NONE       guibg=' . g:ansi_DarkBlue . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultMagenta      ctermfg=NONE    ctermbg=5      guifg=NONE    guibg=' . g:ansi_DarkMagenta . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultCyan         ctermfg=NONE       ctermbg=6      guifg=NONE       guibg=' . g:ansi_DarkCyan . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultWhite        ctermfg=NONE      ctermbg=15      guifg=NONE      guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultGray         ctermfg=NONE      ctermbg=7      guifg=NONE      guibg=' . g:ansi_DarkGray . '    cterm=NONE         gui=NONE'

   execute 'hi ansiBlackBlack        ctermfg=0      ctermbg=0      guifg=' . g:ansi_Black . '      guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiRedBlack          ctermfg=1        ctermbg=0      guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGreenBlack        ctermfg=2      ctermbg=0      guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiYellowBlack       ctermfg=3     ctermbg=0      guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiBlueBlack         ctermfg=4       ctermbg=0      guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaBlack      ctermfg=5    ctermbg=0      guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiCyanBlack         ctermfg=6       ctermbg=0      guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteBlack        ctermfg=15      ctermbg=0      guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGrayBlack         ctermfg=7       ctermbg=0      guifg=' . g:ansi_DarkGray . '       guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'

   execute 'hi ansiBlackRed          ctermfg=0      ctermbg=1        guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiRedRed            ctermfg=1        ctermbg=1        guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiGreenRed          ctermfg=2      ctermbg=1        guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiYellowRed         ctermfg=3     ctermbg=1        guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiBlueRed           ctermfg=4       ctermbg=1        guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaRed        ctermfg=5    ctermbg=1        guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiCyanRed           ctermfg=6       ctermbg=1        guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteRed          ctermfg=15      ctermbg=1        guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiGrayRed           ctermfg=7       ctermbg=1        guifg=' . g:ansi_DarkGray . '       guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'

   execute 'hi ansiBlackGreen        ctermfg=0      ctermbg=2      guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiRedGreen          ctermfg=1        ctermbg=2      guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGreenGreen        ctermfg=2      ctermbg=2      guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiYellowGreen       ctermfg=3     ctermbg=2      guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiBlueGreen         ctermfg=4       ctermbg=2      guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaGreen      ctermfg=5    ctermbg=2      guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiCyanGreen         ctermfg=6       ctermbg=2      guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteGreen        ctermfg=15      ctermbg=2      guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGrayGreen         ctermfg=7       ctermbg=2      guifg=' . g:ansi_DarkGray . '       guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'

   execute 'hi ansiBlackYellow       ctermfg=0      ctermbg=3     guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiRedYellow         ctermfg=1        ctermbg=3     guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiGreenYellow       ctermfg=2      ctermbg=3     guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiYellowYellow      ctermfg=3     ctermbg=3     guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiBlueYellow        ctermfg=4       ctermbg=3     guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaYellow     ctermfg=5    ctermbg=3     guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiCyanYellow        ctermfg=6       ctermbg=3     guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteYellow       ctermfg=15      ctermbg=3     guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiGrayYellow        ctermfg=7       ctermbg=3     guifg=' . g:ansi_DarkGray . '       guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'

   execute 'hi ansiBlackBlue         ctermfg=0      ctermbg=4       guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiRedBlue           ctermfg=1        ctermbg=4       guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiGreenBlue         ctermfg=2      ctermbg=4       guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiYellowBlue        ctermfg=3     ctermbg=4       guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiBlueBlue          ctermfg=4       ctermbg=4       guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaBlue       ctermfg=5    ctermbg=4       guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiCyanBlue          ctermfg=6       ctermbg=4       guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteBlue         ctermfg=15      ctermbg=4       guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiGrayBlue          ctermfg=7       ctermbg=4       guifg=' . g:ansi_DarkGray . '       guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'

   execute 'hi ansiBlackMagenta      ctermfg=0      ctermbg=5    guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiRedMagenta        ctermfg=1        ctermbg=5    guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiGreenMagenta      ctermfg=2      ctermbg=5    guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiYellowMagenta     ctermfg=3     ctermbg=5    guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiBlueMagenta       ctermfg=4       ctermbg=5    guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaMagenta    ctermfg=5    ctermbg=5    guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiCyanMagenta       ctermfg=6       ctermbg=5    guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteMagenta      ctermfg=15      ctermbg=5    guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiGrayMagenta       ctermfg=7       ctermbg=5    guifg=' . g:ansi_DarkGray . '       guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'

   execute 'hi ansiBlackCyan         ctermfg=0      ctermbg=6       guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiRedCyan           ctermfg=1        ctermbg=6       guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiGreenCyan         ctermfg=2      ctermbg=6       guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiYellowCyan        ctermfg=3     ctermbg=6       guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiBlueCyan          ctermfg=4       ctermbg=6       guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaCyan       ctermfg=5    ctermbg=6       guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiCyanCyan          ctermfg=6       ctermbg=6       guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteCyan         ctermfg=15      ctermbg=6       guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiGrayCyan          ctermfg=7       ctermbg=6       guifg=' . g:ansi_DarkGray . '       guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'

   execute 'hi ansiBlackWhite        ctermfg=0      ctermbg=15      guifg=' . g:ansi_Black . '      guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiRedWhite          ctermfg=1        ctermbg=15      guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGreenWhite        ctermfg=2      ctermbg=15      guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiYellowWhite       ctermfg=3     ctermbg=15      guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiBlueWhite         ctermfg=4       ctermbg=15      guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaWhite      ctermfg=5    ctermbg=15      guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiCyanWhite         ctermfg=6       ctermbg=15      guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteWhite        ctermfg=15      ctermbg=15      guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGrayWhite         ctermfg=7       ctermbg=15      guifg=' . g:ansi_DarkGray . '       guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'

   execute 'hi ansiBlackGray         ctermfg=0      ctermbg=7       guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkGray . '     cterm=NONE         gui=NONE'
   execute 'hi ansiRedGray           ctermfg=1        ctermbg=7       guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkGray . '     cterm=NONE         gui=NONE'
   execute 'hi ansiGreenGray         ctermfg=2      ctermbg=7       guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkGray . '     cterm=NONE         gui=NONE'
   execute 'hi ansiYellowGray        ctermfg=3     ctermbg=7       guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkGray . '     cterm=NONE         gui=NONE'
   execute 'hi ansiBlueGray          ctermfg=4       ctermbg=7       guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkGray . '     cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaGray       ctermfg=5    ctermbg=7       guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkGray . '     cterm=NONE         gui=NONE'
   execute 'hi ansiCyanGray          ctermfg=6       ctermbg=7       guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkGray . '     cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteGray         ctermfg=15      ctermbg=7       guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkGray . '     cterm=NONE         gui=NONE'
   execute 'hi ansiGrayGray          ctermfg=7       ctermbg=7       guifg=' . g:ansi_DarkGray . '       guibg=' . g:ansi_DarkGray . '     cterm=NONE         gui=NONE'

   if v:version >= 700 && exists("+t_Co") && &t_Co == 256 && exists("g:ansiesc_256color")
    " ---------------------------
    " handle 256-color terminals: {{{3
    " ---------------------------
"    call Decho("set up 256-color highlighting groups")
    let icolor= 1
    while icolor < 256
     let jcolor= 1
     exe "hi ansiHL_".icolor."_0 ctermfg=".icolor
     exe "hi ansiHL_0_".icolor." ctermbg=".icolor
"     call Decho("exe hi ansiHL_".icolor." ctermfg=".icolor)
     while jcolor < 256
      exe "hi ansiHL_".icolor."_".jcolor." ctermfg=".icolor." ctermbg=".jcolor
"      call Decho("exe hi ansiHL_".icolor."_".jcolor." ctermfg=".icolor." ctermbg=".jcolor)
      let jcolor= jcolor + 1
     endwhile
     let icolor= icolor + 1
    endwhile
   endif

  else
   " ----------------------------------
   " not 8 or 256 color terminals (gui): {{{3
   " ----------------------------------
"   call Decho("set up gui highlighting groups")
   execute 'hi ansiBlack             ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiRed               ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=NONE         gui=NONE'
   execute 'hi ansiGreen             ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiYellow            ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=NONE         gui=NONE'
   execute 'hi ansiBlue              ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiMagenta           ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=NONE         gui=NONE'
   execute 'hi ansiCyan              ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiWhite             ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiGray              ctermfg=7       guifg=' . g:ansi_DarkGray . '                                         cterm=NONE         gui=NONE'

   execute 'hi ansiBlackFg           ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiRedFg             ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=NONE         gui=NONE'
   execute 'hi ansiGreenFg           ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiYellowFg          ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=NONE         gui=NONE'
   execute 'hi ansiBlueFg            ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaFg         ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=NONE         gui=NONE'
   execute 'hi ansiCyanFg            ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteFg           ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiGrayFg            ctermfg=7       guifg=' . g:ansi_DarkGray . '                                         cterm=NONE         gui=NONE'

   execute 'hi ansiDefaultBg         ctermbg=NONE       guibg=NONE                                         cterm=NONE         gui=NONE'
   execute 'hi ansiBlackBg           ctermbg=0      guibg=' . g:ansi_Black . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiRedBg             ctermbg=1        guibg=' . g:ansi_DarkRed . '                                          cterm=NONE         gui=NONE'
   execute 'hi ansiGreenBg           ctermbg=2      guibg=' . g:ansi_DarkGreen . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiYellowBg          ctermbg=3     guibg=' . g:ansi_DarkYellow . '                                       cterm=NONE         gui=NONE'
   execute 'hi ansiBlueBg            ctermbg=4       guibg=' . g:ansi_DarkBlue . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaBg         ctermbg=5    guibg=' . g:ansi_DarkMagenta . '                                      cterm=NONE         gui=NONE'
   execute 'hi ansiCyanBg            ctermbg=6       guibg=' . g:ansi_DarkCyan . '                                         cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteBg           ctermbg=15      guibg=' . g:ansi_LightGray . '                                        cterm=NONE         gui=NONE'
   execute 'hi ansiGrayBg            ctermbg=7       guibg=' . g:ansi_DarkGray . '                                         cterm=NONE         gui=NONE'

   execute 'hi ansiDefaultReverseBg         ctermbg=NONE       guibg=NONE                                         cterm=reverse         gui=reverse'
   execute 'hi ansiBlackReverseBg           ctermbg=0      guibg=' . g:ansi_Black . '                                        cterm=reverse         gui=reverse'
   execute 'hi ansiRedReverseBg             ctermbg=1        guibg=' . g:ansi_DarkRed . '                                          cterm=reverse         gui=reverse'
   execute 'hi ansiGreenReverseBg           ctermbg=2      guibg=' . g:ansi_DarkGreen . '                                        cterm=reverse         gui=reverse'
   execute 'hi ansiYellowReverseBg          ctermbg=3     guibg=' . g:ansi_DarkYellow . '                                       cterm=reverse         gui=reverse'
   execute 'hi ansiBlueReverseBg            ctermbg=4       guibg=' . g:ansi_DarkBlue . '                                         cterm=reverse         gui=reverse'
   execute 'hi ansiMagentaReverseBg         ctermbg=5    guibg=' . g:ansi_DarkMagenta . '                                      cterm=reverse         gui=reverse'
   execute 'hi ansiCyanReverseBg            ctermbg=6       guibg=' . g:ansi_DarkCyan . '                                         cterm=reverse         gui=reverse'
   execute 'hi ansiWhiteReverseBg           ctermbg=15      guibg=' . g:ansi_LightGray . '                                        cterm=reverse         gui=reverse'
   execute 'hi ansiGrayReverseBg            ctermbg=7      guibg=' . g:ansi_DarkGray . '                                        cterm=reverse         gui=reverse'

   execute 'hi ansiBold                                                                                    cterm=bold         gui=bold'
   execute 'hi ansiBoldUnderline                                                                           cterm=bold,underline gui=bold,underline'
   execute 'hi ansiBoldBlack         ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=bold         gui=bold'
   execute 'hi ansiBoldRed           ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=bold         gui=bold'
   execute 'hi ansiBoldGreen         ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=bold         gui=bold'
   execute 'hi ansiBoldYellow        ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=bold         gui=bold'
   execute 'hi ansiBoldBlue          ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=bold         gui=bold'
   execute 'hi ansiBoldMagenta       ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=bold         gui=bold'
   execute 'hi ansiBoldCyan          ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=bold         gui=bold'
   execute 'hi ansiBoldWhite         ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=bold         gui=bold'
   execute 'hi ansiBoldGray          ctermfg=7      guifg=' . g:ansi_DarkGray . '                                        cterm=bold         gui=bold'

   execute 'hi ansiBlackBold         ctermbg=0      guibg=' . g:ansi_Black . '                                        cterm=bold         gui=bold'
   execute 'hi ansiRedBold           ctermbg=1        guibg=' . g:ansi_DarkRed . '                                          cterm=bold         gui=bold'
   execute 'hi ansiGreenBold         ctermbg=2      guibg=' . g:ansi_DarkGreen . '                                        cterm=bold         gui=bold'
   execute 'hi ansiYellowBold        ctermbg=3     guibg=' . g:ansi_DarkYellow . '                                       cterm=bold         gui=bold'
   execute 'hi ansiBlueBold          ctermbg=4       guibg=' . g:ansi_DarkBlue . '                                         cterm=bold         gui=bold'
   execute 'hi ansiMagentaBold       ctermbg=5    guibg=' . g:ansi_DarkMagenta . '                                      cterm=bold         gui=bold'
   execute 'hi ansiCyanBold          ctermbg=6       guibg=' . g:ansi_DarkCyan . '                                         cterm=bold         gui=bold'
   execute 'hi ansiWhiteBold         ctermbg=15      guibg=' . g:ansi_LightGray . '                                        cterm=bold         gui=bold'
   execute 'hi ansiGrayBold          ctermbg=7      guibg=' . g:ansi_DarkGray . '                                        cterm=bold         gui=bold'

   execute 'hi ansiReverse                                                                                 cterm=reverse      gui=reverse'
   execute 'hi ansiReverseUnderline                                                                        cterm=reverse,underline gui=reverse,underline'
   execute 'hi ansiReverseBold                                                                             cterm=reverse,bold gui=reverse,bold'
   execute 'hi ansiReverseBoldUnderline                                                                    cterm=reverse,bold,underline gui=reverse,bold,underline'
   execute 'hi ansiReverseBlack      ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=reverse         gui=reverse'
   execute 'hi ansiReverseRed        ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=reverse         gui=reverse'
   execute 'hi ansiReverseGreen      ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=reverse         gui=reverse'
   execute 'hi ansiReverseYellow     ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=reverse         gui=reverse'
   execute 'hi ansiReverseBlue       ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=reverse         gui=reverse'
   execute 'hi ansiReverseMagenta    ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=reverse         gui=reverse'
   execute 'hi ansiReverseCyan       ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=reverse         gui=reverse'
   execute 'hi ansiReverseWhite      ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=reverse         gui=reverse'
   execute 'hi ansiReverseGray       ctermfg=7      guifg=' . g:ansi_DarkGray . '                                        cterm=reverse         gui=reverse'

   execute 'hi ansiStandout                                                                                cterm=standout     gui=standout'
   execute 'hi ansiStandoutBlack     ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=standout     gui=standout'
   execute 'hi ansiStandoutRed       ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=standout     gui=standout'
   execute 'hi ansiStandoutGreen     ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=standout     gui=standout'
   execute 'hi ansiStandoutYellow    ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=standout     gui=standout'
   execute 'hi ansiStandoutBlue      ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=standout     gui=standout'
   execute 'hi ansiStandoutMagenta   ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=standout     gui=standout'
   execute 'hi ansiStandoutCyan      ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=standout     gui=standout'
   execute 'hi ansiStandoutWhite     ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=standout     gui=standout'
   execute 'hi ansiStandoutGray      ctermfg=7      guifg=' . g:ansi_DarkGray . '                                        cterm=standout     gui=standout'

   execute 'hi ansiItalic                                                                                  cterm=italic       gui=italic'
   execute 'hi ansiItalicBlack       ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=italic       gui=italic'
   execute 'hi ansiItalicRed         ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=italic       gui=italic'
   execute 'hi ansiItalicGreen       ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=italic       gui=italic'
   execute 'hi ansiItalicYellow      ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=italic       gui=italic'
   execute 'hi ansiItalicBlue        ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=italic       gui=italic'
   execute 'hi ansiItalicMagenta     ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=italic       gui=italic'
   execute 'hi ansiItalicCyan        ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=italic       gui=italic'
   execute 'hi ansiItalicWhite       ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=italic       gui=italic'
   execute 'hi ansiItalicGray        ctermfg=7      guifg=' . g:ansi_DarkGray . '                                        cterm=italic       gui=italic'

   execute 'hi ansiUnderline                                                                               cterm=underline    gui=underline'
   execute 'hi ansiUnderlineBlack    ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=underline    gui=underline'
   execute 'hi ansiUnderlineRed      ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=underline    gui=underline'
   execute 'hi ansiUnderlineGreen    ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=underline    gui=underline'
   execute 'hi ansiUnderlineYellow   ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=underline    gui=underline'
   execute 'hi ansiUnderlineBlue     ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=underline    gui=underline'
   execute 'hi ansiUnderlineMagenta  ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=underline    gui=underline'
   execute 'hi ansiUnderlineCyan     ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=underline    gui=underline'
   execute 'hi ansiUnderlineWhite    ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=underline    gui=underline'
   execute 'hi ansiUnderlineGray     ctermfg=7      guifg=' . g:ansi_DarkGray . '                                        cterm=underline    gui=underline'

   execute 'hi ansiBlackUnderline    ctermbg=0      guibg=' . g:ansi_Black . '                                        cterm=underline    gui=underline'
   execute 'hi ansiRedUnderline      ctermbg=1        guibg=' . g:ansi_DarkRed . '                                          cterm=underline    gui=underline'
   execute 'hi ansiGreenUnderline    ctermbg=2      guibg=' . g:ansi_DarkGreen . '                                        cterm=underline    gui=underline'
   execute 'hi ansiYellowUnderline   ctermbg=3     guibg=' . g:ansi_DarkYellow . '                                       cterm=underline    gui=underline'
   execute 'hi ansiBlueUnderline     ctermbg=4       guibg=' . g:ansi_DarkBlue . '                                         cterm=underline    gui=underline'
   execute 'hi ansiMagentaUnderline  ctermbg=5    guibg=' . g:ansi_DarkMagenta . '                                      cterm=underline    gui=underline'
   execute 'hi ansiCyanUnderline     ctermbg=6       guibg=' . g:ansi_DarkCyan . '                                         cterm=underline    gui=underline'
   execute 'hi ansiWhiteUnderline    ctermbg=15      guibg=' . g:ansi_LightGray . '                                        cterm=underline    gui=underline'
   execute 'hi ansiGrayUnderline     ctermbg=7      guibg=' . g:ansi_DarkGray . '                                        cterm=underline    gui=underline'

   execute 'hi ansiBlink                                                                                   cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkBlack        ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkRed          ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkGreen        ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkYellow       ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkBlue         ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkMagenta      ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkCyan         ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkWhite        ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiBlinkGray         ctermfg=7      guifg=' . g:ansi_DarkGray . '                                        cterm=standout     gui=undercurl'

   execute 'hi ansiRapidBlink                                                                              cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkBlack   ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkRed     ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkGreen   ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkYellow  ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkBlue    ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkMagenta ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkCyan    ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkWhite   ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=standout     gui=undercurl'
   execute 'hi ansiRapidBlinkGray    ctermfg=7      guifg=' . g:ansi_DarkGray . '                                        cterm=standout     gui=undercurl'

   execute 'hi ansiRV                                                                                      cterm=reverse      gui=reverse'
   execute 'hi ansiRVBlack           ctermfg=0      guifg=' . g:ansi_Black . '                                        cterm=reverse      gui=reverse'
   execute 'hi ansiRVRed             ctermfg=1        guifg=' . g:ansi_DarkRed . '                                          cterm=reverse      gui=reverse'
   execute 'hi ansiRVGreen           ctermfg=2      guifg=' . g:ansi_DarkGreen . '                                        cterm=reverse      gui=reverse'
   execute 'hi ansiRVYellow          ctermfg=3     guifg=' . g:ansi_DarkYellow . '                                       cterm=reverse      gui=reverse'
   execute 'hi ansiRVBlue            ctermfg=4       guifg=' . g:ansi_DarkBlue . '                                         cterm=reverse      gui=reverse'
   execute 'hi ansiRVMagenta         ctermfg=5    guifg=' . g:ansi_DarkMagenta . '                                      cterm=reverse      gui=reverse'
   execute 'hi ansiRVCyan            ctermfg=6       guifg=' . g:ansi_DarkCyan . '                                         cterm=reverse      gui=reverse'
   execute 'hi ansiRVWhite           ctermfg=15      guifg=' . g:ansi_LightGray . '                                        cterm=reverse      gui=reverse'
   execute 'hi ansiRVGray            ctermfg=7      guifg=' . g:ansi_DarkGray . '                                        cterm=reverse      gui=reverse'

   execute 'hi ansiBoldDefault         ctermfg=NONE           ctermbg=NONE      guifg=NONE           guibg=NONE    cterm=bold         gui=bold'
   execute 'hi ansiUnderlineDefault    ctermfg=NONE           ctermbg=NONE      guifg=NONE           guibg=NONE    cterm=underline    gui=underline'
   execute 'hi ansiBlackDefault        ctermfg=0          ctermbg=NONE      guifg=' . g:ansi_Black . '          guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiRedDefault          ctermfg=1        ctermbg=NONE      guifg=' . g:ansi_DarkRed . '        guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiGreenDefault        ctermfg=2      ctermbg=NONE      guifg=' . g:ansi_DarkGreen . '      guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiYellowDefault       ctermfg=3     ctermbg=NONE      guifg=' . g:ansi_DarkYellow . '     guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiBlueDefault         ctermfg=4       ctermbg=NONE      guifg=' . g:ansi_DarkBlue . '       guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaDefault      ctermfg=5    ctermbg=NONE      guifg=' . g:ansi_DarkMagenta . '    guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiCyanDefault         ctermfg=6       ctermbg=NONE      guifg=' . g:ansi_DarkCyan . '       guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteDefault        ctermfg=15      ctermbg=NONE      guifg=' . g:ansi_LightGray . '      guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiGrayDefault         ctermfg=7       ctermbg=NONE      guifg=' . g:ansi_DarkGray . '       guibg=NONE    cterm=NONE         gui=NONE'

   execute 'hi ansiDefaultDefault      ctermfg=NONE      ctermbg=NONE       guifg=NONE       guibg=NONE    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultBlack        ctermfg=NONE      ctermbg=0      guifg=NONE       guibg=' . g:ansi_Black . '   cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultRed          ctermfg=NONE        ctermbg=1      guifg=NONE        guibg=' . g:ansi_DarkRed . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultGreen        ctermfg=NONE      ctermbg=2      guifg=NONE      guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultYellow       ctermfg=NONE     ctermbg=3      guifg=NONE     guibg=' . g:ansi_DarkYellow . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultBlue         ctermfg=NONE       ctermbg=4      guifg=NONE       guibg=' . g:ansi_DarkBlue . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultMagenta      ctermfg=NONE    ctermbg=5      guifg=NONE    guibg=' . g:ansi_DarkMagenta . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultCyan         ctermfg=NONE       ctermbg=6      guifg=NONE       guibg=' . g:ansi_DarkCyan . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultWhite        ctermfg=NONE      ctermbg=15      guifg=NONE      guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiDefaultGray         ctermfg=NONE      ctermbg=7       guifg=NONE      guibg=' . g:ansi_DarkGray . '     cterm=NONE         gui=NONE'
 
   execute 'hi ansiBlackBlack        ctermfg=0      ctermbg=0      guifg=' . g:ansi_Black . '      guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiRedBlack          ctermfg=1        ctermbg=0      guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGreenBlack        ctermfg=2      ctermbg=0      guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiYellowBlack       ctermfg=3     ctermbg=0      guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiBlueBlack         ctermfg=4       ctermbg=0      guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaBlack      ctermfg=5    ctermbg=0      guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiCyanBlack         ctermfg=6       ctermbg=0      guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteBlack        ctermfg=15      ctermbg=0      guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGrayBlack         ctermfg=7      ctermbg=0      guifg=' . g:ansi_DarkGray . '      guibg=' . g:ansi_Black . '    cterm=NONE         gui=NONE'

   execute 'hi ansiBlackRed          ctermfg=0      ctermbg=1        guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiRedRed            ctermfg=1        ctermbg=1        guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiGreenRed          ctermfg=2      ctermbg=1        guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiYellowRed         ctermfg=3     ctermbg=1        guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiBlueRed           ctermfg=4       ctermbg=1        guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaRed        ctermfg=5    ctermbg=1        guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiCyanRed           ctermfg=6       ctermbg=1        guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteRed          ctermfg=15      ctermbg=1        guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'
   execute 'hi ansiGrayRed           ctermfg=7      ctermbg=1        guifg=' . g:ansi_DarkGray . '      guibg=' . g:ansi_DarkRed . '      cterm=NONE         gui=NONE'

   execute 'hi ansiBlackGreen        ctermfg=0      ctermbg=2      guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiRedGreen          ctermfg=1        ctermbg=2      guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGreenGreen        ctermfg=2      ctermbg=2      guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiYellowGreen       ctermfg=3     ctermbg=2      guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiBlueGreen         ctermfg=4       ctermbg=2      guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaGreen      ctermfg=5    ctermbg=2      guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiCyanGreen         ctermfg=6       ctermbg=2      guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteGreen        ctermfg=15      ctermbg=2      guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGrayGreen         ctermfg=7      ctermbg=2      guifg=' . g:ansi_DarkGray . '      guibg=' . g:ansi_DarkGreen . '    cterm=NONE         gui=NONE'

   execute 'hi ansiBlackYellow       ctermfg=0      ctermbg=3     guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiRedYellow         ctermfg=1        ctermbg=3     guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiGreenYellow       ctermfg=2      ctermbg=3     guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiYellowYellow      ctermfg=3     ctermbg=3     guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiBlueYellow        ctermfg=4       ctermbg=3     guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaYellow     ctermfg=5    ctermbg=3     guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiCyanYellow        ctermfg=6       ctermbg=3     guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteYellow       ctermfg=15      ctermbg=3     guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'
   execute 'hi ansiGrayYellow        ctermfg=7      ctermbg=3     guifg=' . g:ansi_DarkGray . '      guibg=' . g:ansi_DarkYellow . '   cterm=NONE         gui=NONE'

   execute 'hi ansiBlackBlue         ctermfg=0      ctermbg=4       guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiRedBlue           ctermfg=1        ctermbg=4       guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiGreenBlue         ctermfg=2      ctermbg=4       guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiYellowBlue        ctermfg=3     ctermbg=4       guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiBlueBlue          ctermfg=4       ctermbg=4       guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaBlue       ctermfg=5    ctermbg=4       guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiCyanBlue          ctermfg=6       ctermbg=4       guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteBlue         ctermfg=15      ctermbg=4       guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'
   execute 'hi ansiGrayBlue          ctermfg=7      ctermbg=4       guifg=' . g:ansi_DarkGray . '      guibg=' . g:ansi_DarkBlue . '     cterm=NONE         gui=NONE'

   execute 'hi ansiBlackMagenta      ctermfg=0      ctermbg=5    guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiRedMagenta        ctermfg=1        ctermbg=5    guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiGreenMagenta      ctermfg=2      ctermbg=5    guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiYellowMagenta     ctermfg=3     ctermbg=5    guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiBlueMagenta       ctermfg=4       ctermbg=5    guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaMagenta    ctermfg=5    ctermbg=5    guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiCyanMagenta       ctermfg=6       ctermbg=5    guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteMagenta      ctermfg=15      ctermbg=5    guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'
   execute 'hi ansiGrayMagenta       ctermfg=7      ctermbg=5    guifg=' . g:ansi_DarkGray . '      guibg=' . g:ansi_DarkMagenta . '  cterm=NONE         gui=NONE'

   execute 'hi ansiBlackCyan         ctermfg=0      ctermbg=6       guifg=' . g:ansi_Black . '      guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiRedCyan           ctermfg=1        ctermbg=6       guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiGreenCyan         ctermfg=2      ctermbg=6       guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiYellowCyan        ctermfg=3     ctermbg=6       guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiBlueCyan          ctermfg=4       ctermbg=6       guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaCyan       ctermfg=5    ctermbg=6       guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiCyanCyan          ctermfg=6       ctermbg=6       guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteCyan         ctermfg=15      ctermbg=6       guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'
   execute 'hi ansiGrayCyan          ctermfg=7      ctermbg=6       guifg=' . g:ansi_DarkGray . '      guibg=' . g:ansi_DarkCyan . '     cterm=NONE         gui=NONE'

   execute 'hi ansiBlackWhite        ctermfg=0      ctermbg=15      guifg=' . g:ansi_Black . '      guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiRedWhite          ctermfg=1        ctermbg=15      guifg=' . g:ansi_DarkRed . '        guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGreenWhite        ctermfg=2      ctermbg=15      guifg=' . g:ansi_DarkGreen . '      guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiYellowWhite       ctermfg=3     ctermbg=15      guifg=' . g:ansi_DarkYellow . '     guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiBlueWhite         ctermfg=4       ctermbg=15      guifg=' . g:ansi_DarkBlue . '       guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiMagentaWhite      ctermfg=5    ctermbg=15      guifg=' . g:ansi_DarkMagenta . '    guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiCyanWhite         ctermfg=6       ctermbg=15      guifg=' . g:ansi_DarkCyan . '       guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiWhiteWhite        ctermfg=15      ctermbg=15      guifg=' . g:ansi_LightGray . '      guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
   execute 'hi ansiGrayWhite         ctermfg=7      ctermbg=15      guifg=' . g:ansi_DarkGray . '      guibg=' . g:ansi_LightGray . '    cterm=NONE         gui=NONE'
  endif
"  call Dret("AnsiEsc#AnsiEsc")
endfun

" ---------------------------------------------------------------------
" s:MultiElementHandler: builds custom syntax highlighting for three or more element ansi escape sequences {{{2
fun! s:MultiElementHandler()
"  call Dfunc("s:MultiElementHandler()")
  let curwp= SaveWinPosn(0)
  keepj 1
  keepj norm! 0
  let mehcnt = 0
  let mehrules     = []
  while search('\e\[;\=\d\+;\d\+;\d\+\(;\d\+\)*m','cW')
   let curcol  = col(".")+1
   call search('m','cW')
   let mcol    = col(".")
   let ansiesc = strpart(getline("."),curcol,mcol - curcol)
   let aecodes = split(ansiesc,'[;m]')
"   call Decho("ansiesc<".ansiesc."> aecodes=".string(aecodes))
   let skip         = 0
   let mod          = "NONE,"
   let fg           = ""
   let bg           = ""

   " if the ansiesc is
   if index(mehrules,ansiesc) == -1
    let mehrules+= [ansiesc]

    for code in aecodes

     " handle multi-code sequences (38;5;color  and 48;5;color)
     if skip == 38 && code == 5
      " handling <esc>[38;5
      let skip= 385
"      call Decho(" 1: building code=".code." skip=".skip.": mod<".mod."> fg<".fg."> bg<".bg.">")
      continue
     elseif skip == 385
      " handling <esc>[38;5;...
      if has("gui") && has("gui_running")
       let fg= s:Ansi2Gui(code)
      else
       let fg= code
      endif
      let skip= 0
"      call Decho(" 2: building code=".code." skip=".skip.": mod<".mod."> fg<".fg."> bg<".bg.">")
      continue

     elseif skip == 48 && code == 5
      " handling <esc>[48;5
      let skip= 485
"      call Decho(" 3: building code=".code." skip=".skip.": mod<".mod."> fg<".fg."> bg<".bg.">")
      continue
     elseif skip == 485
      " handling <esc>[48;5;...
      if has("gui") && has("gui_running")
       let bg= s:Ansi2Gui(code)
      else
       let bg= code
      endif
      let skip= 0
"      call Decho(" 4: building code=".code." skip=".skip.": mod<".mod."> fg<".fg."> bg<".bg.">")
      continue

     else
      let skip= 0
     endif

     " handle single-code sequences
     if code == 1
      let mod=mod."bold,"
     elseif code == 2
      let mod=mod."italic,"
     elseif code == 3
      let mod=mod."standout,"
     elseif code == 4
      let mod=mod."underline,"
     elseif code == 5 || code == 6
      let mod=mod."undercurl,"
     elseif code == 7
      let mod=mod."reverse,"

     elseif code == 30
      let fg= "black"
     elseif code == 31
      let fg= "red"
     elseif code == 32
      let fg= "green"
     elseif code == 33
      let fg= "yellow"
     elseif code == 34
      let fg= "blue"
     elseif code == 35
      let fg= "magenta"
     elseif code == 36
      let fg= "cyan"
     elseif code == 37
      let fg= "white"

     elseif code == 40
      let bg= "black"
     elseif code == 41
      let bg= "red"
     elseif code == 42
      let bg= "green"
     elseif code == 43
      let bg= "yellow"
     elseif code == 44
      let bg= "blue"
     elseif code == 45
      let bg= "magenta"
     elseif code == 46
      let bg= "cyan"
     elseif code == 47
      let bg= "white"

     elseif code == 38
      let skip= 38

     elseif code == 48
      let skip= 48
     endif

"     call Decho(" 5: building code=".code." skip=".skip.": mod<".mod."> fg<".fg."> bg<".bg.">")
    endfor

    " fixups
    let mod= substitute(mod,',$','','')

    " build syntax-recognition rule
    let mehcnt  = mehcnt + 1
    let synrule = "syn region ansiMEH".mehcnt
    let synrule = synrule.' start="\e\['.ansiesc.'"'
    let synrule = synrule.' end="\e\["me=e-2'
    let synrule = synrule." contains=ansiConceal"
"    call Decho(" exe synrule: ".synrule)
    exe synrule

    " build highlighting rule
    let hirule= "hi ansiMEH".mehcnt
    if has("gui") && has("gui_running")
     let hirule=hirule." gui=".mod
     if fg != ""| let hirule=hirule." guifg=".fg| endif
     if bg != ""| let hirule=hirule." guibg=".bg| endif
    else
     let hirule=hirule." cterm=".mod
     if fg != ""| let hirule=hirule." ctermfg=".fg| endif
     if bg != ""| let hirule=hirule." ctermbg=".bg| endif
    endif
"    call Decho(" exe hirule: ".hirule)
    exe hirule
   endif

  endwhile

  call RestoreWinPosn(curwp)
"  call Dret("s:MultiElementHandler")
endfun

" ---------------------------------------------------------------------
" s:Ansi2Gui: converts an ansi-escape sequence (for 256-color xterms) {{{2
"           to an equivalent gui color
"           colors   0- 15:
"           colors  16-231:  6x6x6 color cube, code= 16+r*36+g*6+b  with r,g,b each in [0,5]
"           colors 232-255:  grayscale ramp,   code= 10*gray + 8    with gray in [0,23] (black,white left out)
fun! s:Ansi2Gui(code)
"  call Dfunc("s:Ansi2Gui(code=)".a:code)
  let guicolor= a:code
  if a:code < 16
   let code2rgb = [ "black", "red3", "green3", "yellow3", "blue3", "magenta3", "cyan3", "gray70", "gray40", "red", "green", "yellow", "royalblue3", "magenta", "cyan", "white"]
   let guicolor = code2rgb[a:code]
  elseif a:code >= 232
   let code     = a:code - 232
   let code     = 10*code + 8
   let guicolor = printf("#%02x%02x%02x",code,code,code)
  else
   let code     = a:code - 16
   let code2rgb = [43,85,128,170,213,255]
   let r        = code2rgb[code/36]
   let g        = code2rgb[(code%36)/6]
   let b        = code2rgb[code%6]
   let guicolor = printf("#%02x%02x%02x",r,g,b)
  endif
"  call Dret("s:Ansi2Gui ".guicolor)
  return guicolor
endfun

" ---------------------------------------------------------------------
" AnsiEsc#BufReadPost: updates ansi-escape code visualization if it was alredy
" on for the buffer{{{2
fun! AnsiEsc#BufReadPost()
  let bn= bufnr("%")
  if exists("s:AnsiEsc_enabled_{bn}") && s:AnsiEsc_enabled_{bn}
   call AnsiEsc#AnsiEsc(1)
  endif
endfun

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo

" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: ts=12 fdm=marker
