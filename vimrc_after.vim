let s:palette = g:lightline#colorscheme#wombat#palette
" active tabs
let s:palette.tabline.tabsel = [ [ '#202020', '#add8e6', 252, 66, 'NONE' ] ]
" inactive tabs
let s:palette.tabline.left = [ [ '#e0e0f0', '#505070', 252, 66, 'NONE'  ] ]
" remainder of the line
let s:palette.tabline.middle = [ [ '#ffffff', '#9090a0', 252, 66, 'NONE'  ] ]
unlet s:palette
