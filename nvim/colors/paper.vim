" Name:         Paper
" Description:  A light theme based on the color of paper notebooks.
" Author:       Yorick Peterse <yorick@yorickpeterse.com>
" Maintainer:   Yorick Peterse <yorick@yorickpeterse.com>
" Website:      https://gitlab.com/yorickpeterse/paper.vim
" License:      MPL 2.0

set background=light

hi clear

if exists('g:syntax_on')
  syntax reset
endif

let g:colors_name = 'paper'

" Function for creating a highlight group
"
" We use this function so we can use variables in our highlight groups, instead
" of having to repeat the same color codes in a bunch of places.
function! s:Hi(group, fg_name, bg_name, gui, ...)
  if a:fg_name == 'NONE'
    let fg = a:fg_name
  else
    let fg = s:colors[a:fg_name]
  endif

  if a:bg_name == 'NONE'
    let bg = a:bg_name
  else
    let bg = s:colors[a:bg_name]
  endif

  if empty(a:gui)
    let style = 'NONE'
  else
    let style = a:gui
  endif

  if a:0 == 1 && !empty(a:1)
    let sp = s:colors[a:1]
  else
    let sp = 'NONE'
  endif

  exe 'hi ' . a:group . ' guifg=' . fg . ' guibg=' . bg . ' gui=' . style . ' guisp=' . sp
endfunction

" A temporary command is used to make it easier/less verbose to define highlight
" groups. This command is removed at the end of this file.
command! -nargs=+ Hi call s:Hi(<f-args>)

" Available colors
let s:colors = {
\  'background': '#f2eede',
\  'lbackground': '#f7f3e3',
\  'black': '#000000',
\  'blue': '#1e6fcc',
\  'green': '#216609',
\  'lgreen': '#dfeacc',
\  'red': '#cc3e28',
\  'grey': '#777777',
\  'dgrey': '#555555',
\  'lgrey1': '#d8d5c7',
\  'lgrey2': '#bfbcaf',
\  'lgrey3': '#aaaaaa',
\  'yellow': '#b58900',
\  'lyellow': '#f2de91',
\  'orange': '#a55000',
\  'purple': '#5c21a5',
\  'white': '#ffffff',
\  'cyan': '#158c86'
\ }

" We require/expect true colour support, and make no attempt at supporting UIs
" that don't have true colour support. We also require support for italics.
if has('nvim')
  let g:terminal_color_0 = s:colors['black']
  let g:terminal_color_1 = s:colors['red']
  let g:terminal_color_2 = s:colors['green']
  let g:terminal_color_3 = s:colors['yellow']
  let g:terminal_color_4 = s:colors['blue']
  let g:terminal_color_5 = s:colors['purple']
  let g:terminal_color_6 = s:colors['cyan']
  let g:terminal_color_7 = s:colors['lgrey3']
  let g:terminal_color_8 = s:colors['dgrey']
  let g:terminal_color_9 = s:colors['red']
  let g:terminal_color_10 = s:colors['green']
  let g:terminal_color_11 = s:colors['yellow']
  let g:terminal_color_12 = s:colors['blue']
  let g:terminal_color_13 = s:colors['purple']
  let g:terminal_color_14 = s:colors['cyan']
  let g:terminal_color_15 = s:colors['lgrey3']
else
  let g:terminal_ansi_colors = [
  \   s:colors['black'],
  \   s:colors['red'],
  \   s:colors['green'],
  \   s:colors['yellow'],
  \   s:colors['blue'],
  \   s:colors['purple'],
  \   s:colors['cyan'],
  \   s:colors['lgrey3'],
  \   s:colors['dgrey'],
  \   s:colors['red'],
  \   s:colors['green'],
  \   s:colors['yellow'],
  \   s:colors['blue'],
  \   s:colors['purple'],
  \   s:colors['cyan'],
  \   s:colors['lgrey3']
  \ ]
endif

" Set up all highlight groups.
"
" We use the custom Hi command for this. The syntax of this command is as
" follows:
"
"     Hi NAME FG BG GUI GUISP
"
" Where NAME is the highlight name, FG the foreground color, BG the background
" color, and GUI the settings for the `gui` option (e.g. bold). Since Hi is a
" command and not a function, quotes shouldn't be used. To refer to a color,
" simply use its name (e.g. "black").

" Generic highlight groups
Hi ColorColumn NONE lbackground NONE
Hi Comment grey NONE NONE
Hi Conceal NONE NONE NONE
Hi Constant black NONE NONE
Hi Cursor NONE lgrey1 NONE
Hi CursorLine NONE lbackground NONE
Hi CursorLineNR black NONE bold
Hi Directory purple NONE NONE
Hi ErrorMsg red NONE bold
Hi FoldColumn black background NONE
Hi Identifier black NONE NONE
Hi Include black NONE bold
Hi Keyword black NONE bold
Hi LineNr black NONE NONE
Hi Macro orange NONE NONE
Hi MatchParen NONE NONE bold
Hi MoreMsg black NONE NONE
Hi NonText grey NONE NONE
Hi Normal black background NONE
Hi NormalFloat black background NONE
Hi Bold black NONE bold
Hi Number blue NONE NONE
Hi Operator black NONE NONE
Hi Pmenu black lgrey1 NONE
Hi PmenuSel black lgrey2 bold
Hi PreProc black NONE NONE
Hi Question black NONE NONE
Hi Regexp orange NONE NONE
Hi Search NONE lyellow NONE
Hi IncSearch NONE lyellow NONE
Hi Special black NONE NONE
Hi SpellBad red NONE bold,undercurl
Hi SpellCap purple NONE undercurl
Hi SpellLocal green NONE undercurl
Hi SpellRare purple NONE undercurl
Hi StatusLine black lgrey1 NONE
Hi StatusLineNC black lgrey1 NONE
Hi String green NONE NONE
Hi TabLine dgrey lgrey2 NONE
Hi TabLineFill black lgrey2 NONE
Hi TabLineSel black background bold
Hi Title black NONE bold
Hi Todo grey NONE bold
Hi VertSplit lgrey2 NONE NONE
Hi WarningMsg orange NONE bold
Hi Underlined NONE NONE underline

hi! link Boolean Keyword
hi! link Character String
hi! link Error ErrorMsg
hi! link Folded Comment
hi! link Label Keyword
hi! link PmenuThumb PmenuSel
hi! link PreCondit Macro
hi! link SignColumn FoldColumn
hi! link SpecialKey Number
hi! link Statement Keyword
hi! link StorageClass Keyword
hi! link Type Keyword
hi! link Visual Cursor
hi! link WildMenu PmenuSel

" Diffs
Hi GitSignsAdd lgreen NONE NONE
Hi DiffAdd green NONE NONE
Hi DiffChange NONE NONE NONE
Hi DiffDelete red NONE NONE
Hi DiffText NONE lgreen NONE
Hi diffFile black NONE bold
Hi diffLine blue NONE NONE
hi! link diffAdded DiffAdd
hi! link diffChanged DiffChange
hi! link diffRemoved DiffDelete
hi! link dotKeyChar Operator

" netrw
hi! link netrwClassify Identifier

delcommand Hi
