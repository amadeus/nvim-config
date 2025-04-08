return {
  ["@annotation"] = "PreProc",
  ["@attribute"] = "PreProc",
  ["@boolean"] = "Boolean",
  ["@character"] = "Character",
  ["@character.printf"] = "SpecialChar",
  ["@character.special"] = "SpecialChar",
  ["@comment"] = "Comment",
  ["@comment.error"] = {
    fg = "#db4b4b",
  },
  ["@comment.hint"] = {
    fg = "#1abc9c",
  },
  ["@comment.info"] = {
    fg = "#0db9d7",
  },
  ["@comment.note"] = {
    fg = "#1abc9c",
  },
  ["@comment.todo"] = {
    fg = "#7aa2f7",
  },
  ["@comment.warning"] = {
    fg = "#e0af68",
  },
  ["@constant"] = "Constant",
  ["@constant.builtin"] = "Special",
  ["@constant.macro"] = "Define",
  ["@constructor"] = {
    fg = "#bb9af7",
  },
  ["@constructor.tsx"] = {
    fg = "#2ac3de",
  },
  ["@diff.delta"] = "DiffChange",
  ["@diff.minus"] = "DiffDelete",
  ["@diff.plus"] = "DiffAdd",
  ["@function"] = "Function",
  ["@function.builtin"] = "Special",
  ["@function.call"] = "@function",
  ["@function.macro"] = "Macro",
  ["@function.method"] = "Function",
  ["@function.method.call"] = "@function.method",
  ["@keyword"] = {
    fg = "#9d7cd8",
    italic = true,
  },
  ["@keyword.conditional"] = "Conditional",
  ["@keyword.coroutine"] = "@keyword",
  ["@keyword.debug"] = "Debug",
  ["@keyword.directive"] = "PreProc",
  ["@keyword.directive.define"] = "Define",
  ["@keyword.exception"] = "Exception",
  ["@keyword.function"] = {
    fg = "#bb9af7",
  },
  ["@keyword.import"] = "Include",
  ["@keyword.operator"] = "@operator",
  ["@keyword.repeat"] = "Repeat",
  ["@keyword.return"] = "@keyword",
  ["@keyword.storage"] = "StorageClass",
  ["@label"] = {
    fg = "#7aa2f7",
  },
  ["@lsp.type.boolean"] = "@boolean",
  ["@lsp.type.builtinType"] = "@type.builtin",
  ["@lsp.type.comment"] = "@comment",
  ["@lsp.type.decorator"] = "@attribute",
  ["@lsp.type.deriveHelper"] = "@attribute",
  ["@lsp.type.enum"] = "@type",
  ["@lsp.type.enumMember"] = "@constant",
  ["@lsp.type.escapeSequence"] = "@string.escape",
  ["@lsp.type.formatSpecifier"] = "@markup.list",
  ["@lsp.type.generic"] = "@variable",
  ["@lsp.type.interface"] = {
    fg = "#57c5e5",
  },
  ["@lsp.type.keyword"] = "@keyword",
  ["@lsp.type.lifetime"] = "@keyword.storage",
  ["@lsp.type.namespace"] = "@module",
  ["@lsp.type.namespace.python"] = "@variable",
  ["@lsp.type.number"] = "@number",
  ["@lsp.type.operator"] = "@operator",
  ["@lsp.type.parameter"] = "@variable.parameter",
  ["@lsp.type.property"] = "@property",
  ["@lsp.type.selfKeyword"] = "@variable.builtin",
  ["@lsp.type.selfTypeKeyword"] = "@variable.builtin",
  ["@lsp.type.string"] = "@string",
  ["@lsp.type.typeAlias"] = "@type.definition",
  ["@lsp.type.unresolvedReference"] = {
    sp = "#db4b4b",
    undercurl = true,
  },
  ["@lsp.type.variable"] = {},
  ["@lsp.typemod.class.defaultLibrary"] = "@type.builtin",
  ["@lsp.typemod.enum.defaultLibrary"] = "@type.builtin",
  ["@lsp.typemod.enumMember.defaultLibrary"] = "@constant.builtin",
  ["@lsp.typemod.function.defaultLibrary"] = "@function.builtin",
  ["@lsp.typemod.keyword.async"] = "@keyword.coroutine",
  ["@lsp.typemod.keyword.injected"] = "@keyword",
  ["@lsp.typemod.macro.defaultLibrary"] = "@function.builtin",
  ["@lsp.typemod.method.defaultLibrary"] = "@function.builtin",
  ["@lsp.typemod.operator.injected"] = "@operator",
  ["@lsp.typemod.string.injected"] = "@string",
  ["@lsp.typemod.struct.defaultLibrary"] = "@type.builtin",
  ["@lsp.typemod.type.defaultLibrary"] = {
    fg = "#27a1b9",
  },
  ["@lsp.typemod.typeAlias.defaultLibrary"] = {
    fg = "#27a1b9",
  },
  ["@lsp.typemod.variable.callable"] = "@function",
  ["@lsp.typemod.variable.defaultLibrary"] = "@variable.builtin",
  ["@lsp.typemod.variable.injected"] = "@variable",
  ["@lsp.typemod.variable.static"] = "@constant",
  ["@markup"] = "@none",
  ["@markup.emphasis"] = {
    italic = true,
  },
  ["@markup.environment"] = "Macro",
  ["@markup.environment.name"] = "Type",
  ["@markup.heading"] = "Title",
  ["@markup.heading.1.markdown"] = {
    bold = true,
    fg = "#7aa2f7",
  },
  ["@markup.heading.2.markdown"] = {
    bold = true,
    fg = "#e0af68",
  },
  ["@markup.heading.3.markdown"] = {
    bold = true,
    fg = "#9ece6a",
  },
  ["@markup.heading.4.markdown"] = {
    bold = true,
    fg = "#1abc9c",
  },
  ["@markup.heading.5.markdown"] = {
    bold = true,
    fg = "#bb9af7",
  },
  ["@markup.heading.6.markdown"] = {
    bold = true,
    fg = "#9d7cd8",
  },
  ["@markup.heading.7.markdown"] = {
    bold = true,
    fg = "#ff9e64",
  },
  ["@markup.heading.8.markdown"] = {
    bold = true,
    fg = "#f7768e",
  },
  ["@markup.italic"] = {
    italic = true,
  },
  ["@markup.link"] = {
    fg = "#1abc9c",
  },
  ["@markup.link.label"] = "SpecialChar",
  ["@markup.link.label.symbol"] = "Identifier",
  ["@markup.link.url"] = "Underlined",
  ["@markup.list"] = {
    fg = "#89ddff",
  },
  ["@markup.list.checked"] = {
    fg = "#73daca",
  },
  ["@markup.list.markdown"] = {
    bold = true,
    fg = "#ff9e64",
  },
  ["@markup.list.unchecked"] = {
    fg = "#7aa2f7",
  },
  ["@markup.math"] = "Special",
  ["@markup.raw"] = "String",
  ["@markup.raw.markdown_inline"] = {
    bg = "#414868",
    fg = "#7aa2f7",
  },
  ["@markup.strikethrough"] = {
    strikethrough = true,
  },
  ["@markup.strong"] = {
    bold = true,
  },
  ["@markup.underline"] = {
    underline = true,
  },
  ["@module"] = "Directory",
  ["@module.builtin"] = {
    fg = "#f7768e",
  },
  ["@namespace.builtin"] = "@variable.builtin",
  ["@none"] = {},
  ["@number"] = "Number",
  ["@number.float"] = "Float",
  ["@operator"] = {
    fg = "#89ddff",
  },
  ["@property"] = {
    fg = "#73daca",
  },
  ["@punctuation.bracket"] = {
    fg = "#a9b1d6",
  },
  ["@punctuation.delimiter"] = {
    fg = "#89ddff",
  },
  ["@punctuation.special"] = {
    fg = "#89ddff",
  },
  ["@punctuation.special.markdown"] = {
    fg = "#ff9e64",
  },
  ["@string"] = "String",
  ["@string.documentation"] = {
    fg = "#e0af68",
  },
  ["@string.escape"] = {
    fg = "#bb9af7",
  },
  ["@string.regexp"] = {
    fg = "#b4f9f8",
  },
  ["@tag"] = "Label",
  ["@tag.attribute"] = "@property",
  ["@tag.delimiter"] = "Delimiter",
  ["@tag.delimiter.tsx"] = {
    fg = "#5d7ab8",
  },
  ["@tag.javascript"] = {
    fg = "#f7768e",
  },
  ["@tag.tsx"] = {
    fg = "#f7768e",
  },
  ["@type"] = "Type",
  ["@type.builtin"] = {
    fg = "#27a1b9",
  },
  ["@type.definition"] = "Typedef",
  ["@type.qualifier"] = "@keyword",
  ["@variable"] = {
    fg = "#c0caf5",
  },
  ["@variable.builtin"] = {
    fg = "#f7768e",
  },
  ["@variable.member"] = {
    fg = "#73daca",
  },
  ["@variable.parameter"] = {
    fg = "#e0af68",
  },
  ["@variable.parameter.builtin"] = {
    fg = "#dab484",
  },
  BlinkCmpDoc = {
    bg = "NONE",
    fg = "#c0caf5",
  },
  BlinkCmpDocBorder = {
    bg = "NONE",
    fg = "#27a1b9",
  },
  BlinkCmpGhostText = {
    fg = "#414868",
  },
  BlinkCmpKindArray = "LspKindArray",
  BlinkCmpKindBoolean = "LspKindBoolean",
  BlinkCmpKindClass = "LspKindClass",
  BlinkCmpKindCodeium = {
    bg = "NONE",
    fg = "#1abc9c",
  },
  BlinkCmpKindColor = "LspKindColor",
  BlinkCmpKindConstant = "LspKindConstant",
  BlinkCmpKindConstructor = "LspKindConstructor",
  BlinkCmpKindCopilot = {
    bg = "NONE",
    fg = "#1abc9c",
  },
  BlinkCmpKindDefault = {
    bg = "NONE",
    fg = "#a9b1d6",
  },
  BlinkCmpKindEnum = "LspKindEnum",
  BlinkCmpKindEnumMember = "LspKindEnumMember",
  BlinkCmpKindEvent = "LspKindEvent",
  BlinkCmpKindField = "LspKindField",
  BlinkCmpKindFile = "LspKindFile",
  BlinkCmpKindFolder = "LspKindFolder",
  BlinkCmpKindFunction = "LspKindFunction",
  BlinkCmpKindInterface = "LspKindInterface",
  BlinkCmpKindKey = "LspKindKey",
  BlinkCmpKindKeyword = "LspKindKeyword",
  BlinkCmpKindMethod = "LspKindMethod",
  BlinkCmpKindModule = "LspKindModule",
  BlinkCmpKindNamespace = "LspKindNamespace",
  BlinkCmpKindNull = "LspKindNull",
  BlinkCmpKindNumber = "LspKindNumber",
  BlinkCmpKindObject = "LspKindObject",
  BlinkCmpKindOperator = "LspKindOperator",
  BlinkCmpKindPackage = "LspKindPackage",
  BlinkCmpKindProperty = "LspKindProperty",
  BlinkCmpKindReference = "LspKindReference",
  BlinkCmpKindSnippet = "LspKindSnippet",
  BlinkCmpKindString = "LspKindString",
  BlinkCmpKindStruct = "LspKindStruct",
  BlinkCmpKindSupermaven = {
    bg = "NONE",
    fg = "#1abc9c",
  },
  BlinkCmpKindTabNine = {
    bg = "NONE",
    fg = "#1abc9c",
  },
  BlinkCmpKindText = "LspKindText",
  BlinkCmpKindTypeParameter = "LspKindTypeParameter",
  BlinkCmpKindUnit = "LspKindUnit",
  BlinkCmpKindValue = "LspKindValue",
  BlinkCmpKindVariable = "LspKindVariable",
  BlinkCmpLabel = {
    bg = "NONE",
    fg = "#c0caf5",
  },
  BlinkCmpLabelDeprecated = {
    bg = "NONE",
    fg = "#3b4261",
    strikethrough = true,
  },
  BlinkCmpLabelMatch = {
    bg = "NONE",
    fg = "#2ac3de",
  },
  BlinkCmpMenu = {
    bg = "NONE",
    fg = "#c0caf5",
  },
  BlinkCmpMenuBorder = {
    bg = "NONE",
    fg = "#27a1b9",
  },
  BlinkCmpSignatureHelp = {
    bg = "NONE",
    fg = "#c0caf5",
  },
  BlinkCmpSignatureHelpBorder = {
    bg = "NONE",
    fg = "#27a1b9",
  },
  Bold = {
    bold = true,
    fg = "#c0caf5",
  },
  Character = {
    fg = "#9ece6a",
  },
  ColorColumn = {
    bg = "#15161e",
  },
  Comment = {
    fg = "#565f89",
    italic = true,
  },
  Conceal = {
    fg = "#737aa2",
  },
  Constant = {
    fg = "#ff9e64",
  },
  CopilotAnnotation = {
    fg = "#414868",
  },
  CopilotSuggestion = {
    fg = "#414868",
  },
  CurSearch = "IncSearch",
  Cursor = {
    bg = "#c0caf5",
    fg = "#1a1b26",
  },
  CursorColumn = {
    bg = "#292e42",
  },
  CursorIM = {
    bg = "#c0caf5",
    fg = "#1a1b26",
  },
  CursorLine = {
    bg = "#292e42",
  },
  CursorLineNr = {
    bold = true,
    fg = "#ff9e64",
  },
  Debug = {
    fg = "#ff9e64",
  },
  Delimiter = "Special",
  DiagnosticError = {
    fg = "#db4b4b",
  },
  DiagnosticHint = {
    fg = "#1abc9c",
  },
  DiagnosticInfo = {
    fg = "#0db9d7",
  },
  DiagnosticUnderlineError = {
    sp = "#db4b4b",
    undercurl = true,
  },
  DiagnosticUnderlineHint = {
    sp = "#1abc9c",
    undercurl = true,
  },
  DiagnosticUnderlineInfo = {
    sp = "#0db9d7",
    undercurl = true,
  },
  DiagnosticUnderlineWarn = {
    sp = "#e0af68",
    undercurl = true,
  },
  DiagnosticUnnecessary = {
    fg = "#414868",
  },
  DiagnosticVirtualTextError = {
    bg = "#2d202a",
    fg = "#db4b4b",
  },
  DiagnosticVirtualTextHint = {
    bg = "#1a2b32",
    fg = "#1abc9c",
  },
  DiagnosticVirtualTextInfo = {
    bg = "#192b38",
    fg = "#0db9d7",
  },
  DiagnosticVirtualTextWarn = {
    bg = "#2e2a2d",
    fg = "#e0af68",
  },
  DiagnosticWarn = {
    fg = "#e0af68",
  },
  DiffAdd = {
    bg = "#20303b",
  },
  DiffChange = {
    bg = "#1f2231",
  },
  DiffDelete = {
    bg = "#37222c",
  },
  DiffText = {
    bg = "#394b70",
  },
  Directory = {
    fg = "#7aa2f7",
  },
  EndOfBuffer = {
    fg = "#1a1b26",
  },
  Error = {
    fg = "#db4b4b",
  },
  ErrorMsg = {
    fg = "#db4b4b",
  },
  FloatBorder = {
    bg = "NONE",
    fg = "#27a1b9",
  },
  FloatTitle = {
    bg = "NONE",
    fg = "#27a1b9",
  },
  FoldColumn = {
    bg = "#1a1b26",
    fg = "#565f89",
  },
  Folded = {
    bg = "#3b4261",
    fg = "#7aa2f7",
  },
  Foo = {
    bg = "#ff007c",
    fg = "#c0caf5",
  },
  Function = {
    fg = "#7aa2f7",
  },
  GitSignsAdd = {
    fg = "#449dab",
  },
  GitSignsChange = {
    fg = "#6183bb",
  },
  GitSignsDelete = {
    fg = "#914c54",
  },
  HopNextKey = {
    bold = true,
    fg = "#ff007c",
  },
  HopNextKey1 = {
    bold = true,
    fg = "#0db9d7",
  },
  HopNextKey2 = {
    fg = "#127a90",
  },
  HopUnmatched = {
    fg = "#545c7e",
  },
  Identifier = {
    fg = "#bb9af7",
  },
  IncSearch = {
    bg = "#ff9e64",
    fg = "#15161e",
  },
  Italic = {
    fg = "#c0caf5",
    italic = true,
  },
  Keyword = {
    fg = "#7dcfff",
    italic = true,
  },
  LazyProgressDone = {
    bold = true,
    fg = "#ff007c",
  },
  LazyProgressTodo = {
    bold = true,
    fg = "#3b4261",
  },
  LineNr = {
    fg = "#3b4261",
  },
  LineNrAbove = {
    fg = "#3b4261",
  },
  LineNrBelow = {
    fg = "#3b4261",
  },
  LspCodeLens = {
    fg = "#565f89",
  },
  LspInfoBorder = {
    bg = "NONE",
    fg = "#27a1b9",
  },
  LspInlayHint = {
    bg = "#1d202d",
    fg = "#545c7e",
  },
  LspKindArray = "@punctuation.bracket",
  LspKindBoolean = "@boolean",
  LspKindClass = "@type",
  LspKindColor = "Special",
  LspKindConstant = "@constant",
  LspKindConstructor = "@constructor",
  LspKindEnum = "@lsp.type.enum",
  LspKindEnumMember = "@lsp.type.enumMember",
  LspKindEvent = "Special",
  LspKindField = "@variable.member",
  LspKindFile = "Normal",
  LspKindFolder = "Directory",
  LspKindFunction = "@function",
  LspKindInterface = "@lsp.type.interface",
  LspKindKey = "@variable.member",
  LspKindKeyword = "@lsp.type.keyword",
  LspKindMethod = "@function.method",
  LspKindModule = "@module",
  LspKindNamespace = "@module",
  LspKindNull = "@constant.builtin",
  LspKindNumber = "@number",
  LspKindObject = "@constant",
  LspKindOperator = "@operator",
  LspKindPackage = "@module",
  LspKindProperty = "@property",
  LspKindReference = "@markup.link",
  LspKindSnippet = "Conceal",
  LspKindString = "@string",
  LspKindStruct = "@lsp.type.struct",
  LspKindText = "@markup",
  LspKindTypeParameter = "@lsp.type.typeParameter",
  LspKindUnit = "@lsp.type.struct",
  LspKindValue = "@string",
  LspKindVariable = "@variable",
  LspReferenceRead = {
    bg = "#3b4261",
  },
  LspReferenceText = {
    bg = "#3b4261",
  },
  LspReferenceWrite = {
    bg = "#3b4261",
  },
  LspSignatureActiveParameter = {
    bg = "#20253a",
    bold = true,
  },
  MatchParen = {
    bold = true,
    fg = "#ff9e64",
  },
  ModeMsg = {
    bold = true,
    fg = "#a9b1d6",
  },
  MoreMsg = {
    fg = "#7aa2f7",
  },
  MsgArea = {
    fg = "#a9b1d6",
  },
  NonText = {
    fg = "#545c7e",
  },
  Normal = {
    bg = "#1a1b26",
    fg = "#c0caf5",
  },
  NormalFloat = {
    bg = "NONE",
    fg = "#c0caf5",
  },
  NormalNC = {
    bg = "#1a1b26",
    fg = "#c0caf5",
  },
  NormalSB = {
    bg = "#16161e",
    fg = "#a9b1d6",
  },
  Operator = {
    fg = "#89ddff",
  },
  Pmenu = {
    bg = "#16161e",
    fg = "#c0caf5",
  },
  PmenuMatch = {
    bg = "#16161e",
    fg = "#2ac3de",
  },
  PmenuMatchSel = {
    bg = "#343a55",
    fg = "#2ac3de",
  },
  PmenuSbar = {
    bg = "#1f1f29",
  },
  PmenuSel = {
    bg = "#343a55",
  },
  PmenuThumb = {
    bg = "#3b4261",
  },
  PreProc = {
    fg = "#7dcfff",
  },
  Question = {
    fg = "#7aa2f7",
  },
  QuickFixLine = {
    bg = "#283457",
    bold = true,
  },
  Search = {
    bg = "#3d59a1",
    fg = "#c0caf5",
  },
  SignColumn = {
    bg = "#1a1b26",
    fg = "#3b4261",
  },
  SignColumnSB = {
    bg = "#16161e",
    fg = "#3b4261",
  },
  Special = {
    fg = "#2ac3de",
  },
  SpecialKey = {
    fg = "#545c7e",
  },
  SpellBad = {
    sp = "#db4b4b",
    undercurl = true,
  },
  SpellCap = {
    sp = "#e0af68",
    undercurl = true,
  },
  SpellLocal = {
    sp = "#0db9d7",
    undercurl = true,
  },
  SpellRare = {
    sp = "#1abc9c",
    undercurl = true,
  },
  Statement = {
    fg = "#bb9af7",
  },
  StatusLine = {
    bg = "#16161e",
    fg = "#a9b1d6",
  },
  StatusLineNC = {
    bg = "#16161e",
    fg = "#3b4261",
  },
  String = {
    fg = "#9ece6a",
  },
  Substitute = {
    bg = "#f7768e",
    fg = "#15161e",
  },
  TabLine = {
    bg = "#16161e",
    fg = "#3b4261",
  },
  TabLineFill = {
    bg = "#15161e",
  },
  TabLineSel = {
    bg = "#7aa2f7",
    fg = "#15161e",
  },
  TelescopeBorder = {
    bg = "NONE",
    fg = "#27a1b9",
  },
  TelescopeNormal = {
    bg = "NONE",
    fg = "#c0caf5",
  },
  TelescopePromptBorder = {
    bg = "NONE",
    fg = "#ff9e64",
  },
  TelescopePromptTitle = {
    bg = "NONE",
    fg = "#ff9e64",
  },
  TelescopeResultsComment = {
    fg = "#545c7e",
  },
  Title = {
    bold = true,
    fg = "#7aa2f7",
  },
  Todo = {
    bg = "#e0af68",
    fg = "#1a1b26",
  },
  Type = {
    fg = "#2ac3de",
  },
  Underlined = {
    underline = true,
  },
  VertSplit = {
    fg = "#15161e",
  },
  Visual = {
    bg = "#283457",
  },
  VisualNOS = {
    bg = "#283457",
  },
  WarningMsg = {
    fg = "#e0af68",
  },
  Whitespace = {
    fg = "#3b4261",
  },
  WildMenu = {
    bg = "#283457",
  },
  WinBar = "StatusLine",
  WinBarNC = "StatusLineNC",
  WinSeparator = {
    bold = true,
    fg = "#15161e",
  },
  debugBreakpoint = {
    bg = "#192b38",
    fg = "#0db9d7",
  },
  debugPC = {
    bg = "#16161e",
  },
  diffAdded = {
    bg = "#20303b",
    fg = "#449dab",
  },
  diffChanged = {
    bg = "#1f2231",
    fg = "#6183bb",
  },
  diffFile = {
    fg = "#7aa2f7",
  },
  diffIndexLine = {
    fg = "#bb9af7",
  },
  diffLine = {
    fg = "#565f89",
  },
  diffNewFile = {
    bg = "#20303b",
    fg = "#2ac3de",
  },
  diffOldFile = {
    bg = "#37222c",
    fg = "#2ac3de",
  },
  diffRemoved = {
    bg = "#37222c",
    fg = "#914c54",
  },
  dosIniLabel = "@property",
  healthError = {
    fg = "#db4b4b",
  },
  healthSuccess = {
    fg = "#73daca",
  },
  healthWarning = {
    fg = "#e0af68",
  },
  helpCommand = {
    bg = "#414868",
    fg = "#7aa2f7",
  },
  helpExample = {
    fg = "#565f89",
  },
  htmlH1 = {
    bold = true,
    fg = "#bb9af7",
  },
  htmlH2 = {
    bold = true,
    fg = "#7aa2f7",
  },
  lCursor = {
    bg = "#c0caf5",
    fg = "#1a1b26",
  },
  qfFileName = {
    fg = "#7aa2f7",
  },
  qfLineNr = {
    fg = "#737aa2",
  },
}
