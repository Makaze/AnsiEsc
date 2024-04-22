# Improved AnsiEsc.vim

Files with ANSI escape sequences look good when dumped onto a terminal
that accepts them, but have been a distracting clutter when edited via
vim. The AnsiEsc.vim file, when sourced, will conceal Ansi escape
sequences but will cause subsequent text to be colored as the escape
sequence specifies.

This is a [Vim script №302: AnsiEsc.vim](http://www.vim.org/scripts/script.php?script_id=302)
updated to [latest author's version](http://www.drchip.org/astronaut/vim/index.html#ANSIESC)
with several fixes/improvements.

Now with custom colors!

## Changing Colors

```vim
" Returns the #rrggbb hex value for a HL group.
"
" @function GetHLHex
" @description Returns the #rrggbb hex value for a HL group.
" @param group The highlight group to get. e.g. 'Comment'
" @param ground The value to get ('fg' or 'bg').
" @return The #rrggbb color value.
function! GetHLHex(group, ground)
    " Get the syntax ID of the highlight group
    let syn_id = synIDtrans(hlID(a:group))

    " Get the RGB values of the foreground color in GUI mode
    let hex_color = synIDattr(syn_id, a:ground . '#')

    " Return the hex color
    return hex_color
endfunction

let g:ansi_Black = '#1d2021'
let g:ansi_DarkRed = '#cc241d'
let g:ansi_DarkGreen = '#98971a'
let g:ansi_DarkYellow = '#d79921'
let g:ansi_DarkBlue = '#458588'
let g:ansi_DarkMagenta = '#b16286'
let g:ansi_DarkCyan = '#689d6a'
let g:ansi_LightGray = '#ebdbb2'
let g:ansi_DarkGray = '#a89984'
```

## Changes

* updated to latest author's version: **13i** (Apr 02, 2015)
* add support for simple ANSI sequences like "bold" (without defining color)
* add support for 16-color 'light' escape sequences (by Andy Berdan, merged from https://github.com/berdandy/AnsiEsc.vim)
* disable `\swp` and `\rwp` maps if `g:no_plugin_maps` or `g:no_cecutil_maps` exists
* disable DrChip/AnsiEsc menu if `g:no_drchip_menu` or `g:no_ansiesc_menu` exists
* add support for simple ANSI sequences like disable bold/italic/etc.
* minor fixes
