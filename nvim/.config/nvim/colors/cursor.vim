highlight clear

function s:highlight(group, bg, fg, style)
  let gui = a:style == '' ? '' : 'gui=' . a:style
  let fg = a:fg == '' ? '' : 'guifg=' . a:fg
  let bg = a:bg == '' ? '' : 'guibg=' . a:bg
  exec 'hi ' . a:group . ' ' . bg . ' ' . fg  . ' ' . gui
endfunction

let s:Color11 = '#33292f'
let s:Color2 = '#B48EAD'
let s:Color8 = '#7b88a1'
let s:Color12 = '#343a48'
let s:Color4 = '#81A1C1'
let s:Color9 = '#1e2127'
let s:Color10 = '#2f3534'
let s:Color5 = '#A3BE8C'
let s:Color1 = '#EBCB8B'
let s:Color0 = '#616E88'
let s:Color6 = '#191c22'
let s:Color14 = '#d8dee9'
let s:Color13 = '#4c566a'
let s:Color7 = '#4b5163'
let s:Color3 = '#88C0D0'

call s:highlight('Comment', '', s:Color0, 'italic')
call s:highlight('TSCharacter', '', s:Color1, '')
call s:highlight('Number', '', s:Color2, '')
call s:highlight('Function', '', s:Color3, '')
call s:highlight('Keyword', '', s:Color4, '')
call s:highlight('Operator', '', s:Color4, '')
call s:highlight('Type', '', s:Color4, '')
call s:highlight('String', '', s:Color5, '')
call s:highlight('StatusLine', s:Color7, s:Color6, '')
call s:highlight('WildMenu', s:Color9, s:Color8, '')
call s:highlight('Pmenu', s:Color9, s:Color8, '')
call s:highlight('PmenuSel', s:Color8, s:Color9, '')
call s:highlight('PmenuThumb', s:Color9, s:Color8, '')
call s:highlight('DiffAdd', s:Color10, '', '')
call s:highlight('DiffDelete', s:Color11, '', '')
call s:highlight('Normal', s:Color9, s:Color8, '')
call s:highlight('Visual', s:Color12, '', '')
call s:highlight('CursorLine', s:Color12, '', '')
call s:highlight('ColorColumn', s:Color12, '', '')
call s:highlight('SignColumn', s:Color9, '', '')
call s:highlight('LineNr', '', s:Color13, '')
call s:highlight('TabLine', s:Color6, s:Color7, '')
call s:highlight('TabLineSel', s:Color14, s:Color9, '')
call s:highlight('TabLineFill', s:Color6, s:Color7, '')
call s:highlight('TSPunctDelimiter', '', s:Color8, '')

highlight! link TSField Constant
highlight! link TSFunction Function
highlight! link TSTag MyTag
highlight! link TSLabel Type
highlight! link TSPunctSpecial TSPunctDelimiter
highlight! link Whitespace Comment
highlight! link TSFuncMacro Macro
highlight! link TSRepeat Repeat
highlight! link Macro Function
highlight! link TSProperty TSField
highlight! link TSParameter Constant
highlight! link TSKeyword Keyword
highlight! link TSConstant Constant
highlight! link TSOperator Operator
highlight! link TelescopeNormal Normal
highlight! link Operator Keyword
highlight! link TSConditional Conditional
highlight! link Conditional Operator
highlight! link TSPunctBracket MyTag
highlight! link TSTagDelimiter Type
highlight! link TSType Type
highlight! link NonText Comment
highlight! link TSParameterReference TSParameter
highlight! link TSComment Comment
highlight! link TSFloat Number
highlight! link Folded Comment
highlight! link TSNumber Number
highlight! link TSString String
highlight! link TSConstBuiltin TSVariableBuiltin
highlight! link CursorLineNr Identifier
highlight! link TSNamespace TSType
highlight! link Repeat Conditional
