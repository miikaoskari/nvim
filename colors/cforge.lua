-- cforge.lua
-- A dark Neovim colorscheme tuned for reading/writing C and C++.
--
-- Design goals, specific to C/C++:
--   * Preprocessor directives (#include, #define, #ifdef...) get their own
--     hue (purple) so they visually separate from real code.
--   * Types (int, struct Foo, typedefs, template params) are yellow/gold,
--     distinct from control-flow keywords (blue), so you can scan a
--     signature like `static const Foo *bar(int n)` and immediately see
--     which tokens are types vs. qualifiers vs. control flow.
--   * Storage-class/qualifiers (static, const, volatile, extern, constexpr,
--     mutable) get their own orange, since in C/C++ these change semantics
--     a lot (const-correctness, linkage) and are easy to miss.
--   * Pointer/reference operators and other operators (*, &, ->, ::, ==)
--     are red so pointer arithmetic and address-of/deref jump out.
--   * Macros (#define'd constants/function-macros) are a distinct purple
--     tint from string/number literals, since macro misuse is a classic
--     C/C++ foot-gun worth flagging visually.
--   * Functions/methods are teal, separate from types and variables.
--   * Function parameters get their own dusty blue (via Treesitter's
--     @variable.parameter), and variables declared inside a function body
--     get a distinct khaki (via clangd's LSP semantic tokens, which alone
--     can tell a local from a global) - so you can see at a glance what
--     came in as an argument vs. what was declared locally.
--
-- Works with legacy Vim regex syntax (syntax/c.vim, cpp.vim) AND with
-- nvim-treesitter (c, cpp parsers) AND clangd semantic tokens.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "cforge"

local p = {
  bg          = "#1a1c1e",
  bg_dark     = "#141618",
  bg_alt      = "#212429",
  bg_high     = "#2a2e35",
  bg_select   = "#33393f",
  fg          = "#d4d7de",
  fg_dim      = "#a0a8b7",
  comment     = "#5c6370",
  red         = "#e06c75", -- operators, pointers, errors
  red_dim     = "#a85a60",
  orange      = "#d19a66", -- numbers, storage-class qualifiers
  yellow      = "#e5c07b", -- types, structs, enums, typedefs
  green       = "#98c379", -- strings
  teal        = "#56b6c2", -- functions/methods
  blue        = "#61afef", -- control-flow keywords
  purple      = "#c678dd", -- preprocessor, macros
  param       = "#b8ab86", -- function arguments/parameters
  gray        = "#7f848e",
  gutter_gray = "#3b4048",
  none        = "NONE",
}

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ===== Editor UI =====================================================
hi("Normal",        { fg = p.fg, bg = p.bg })
hi("NormalFloat",   { fg = p.fg, bg = p.bg_alt })
hi("FloatBorder",   { fg = p.gutter_gray, bg = p.bg_alt })
hi("Cursor",        { fg = p.bg, bg = p.fg })
hi("CursorLine",    { bg = p.bg_alt })
hi("CursorLineNr",  { fg = p.yellow })
hi("LineNr",        { fg = p.gutter_gray })
hi("SignColumn",    { bg = p.bg })
hi("ColorColumn",   { bg = p.bg_alt })
hi("Visual",        { bg = p.bg_select })
hi("VisualNOS",     { bg = p.bg_select })
hi("Search",        { fg = p.bg, bg = p.yellow })
hi("IncSearch",     { fg = p.bg, bg = p.orange })
hi("CurSearch",     { fg = p.bg, bg = p.orange })
hi("Pmenu",         { fg = p.fg, bg = p.bg_alt })
hi("PmenuSel",      { fg = p.bg, bg = p.blue })
hi("PmenuSbar",     { bg = p.bg_alt })
hi("PmenuThumb",    { bg = p.gutter_gray })
hi("StatusLine",    { fg = p.fg, bg = p.bg_alt })
hi("StatusLineNC",  { fg = p.gray, bg = p.bg_alt })
hi("VertSplit",     { fg = p.gutter_gray })
hi("WinSeparator",  { fg = p.gutter_gray })
hi("TabLine",       { fg = p.gray, bg = p.bg_alt })
hi("TabLineSel",    { fg = p.fg, bg = p.bg_high })
hi("Folded",        { fg = p.gray, bg = p.bg_alt })
hi("FoldColumn",    { fg = p.gutter_gray })
hi("MatchParen",    { fg = p.red, underline = true })
hi("NonText",       { fg = p.gutter_gray })
hi("Whitespace",    { fg = p.gutter_gray })
hi("EndOfBuffer",   { fg = p.bg })
hi("Directory",     { fg = p.blue })
hi("Title",         { fg = p.blue })
hi("WinBar",        { fg = p.fg_dim, bg = p.bg })
hi("WinBarNC",      { fg = p.gray, bg = p.bg })

-- ===== Generic syntax (fallback for any filetype) ====================
hi("Comment",    { fg = p.comment })
hi("Constant",   { fg = p.orange })
hi("String",     { fg = p.green })
hi("Character",  { fg = p.green })
hi("Number",     { fg = p.orange })
hi("Boolean",    { fg = p.orange })
hi("Float",      { fg = p.orange })
hi("Identifier", { fg = p.fg })
hi("Function",   { fg = p.teal })
hi("Statement",  { fg = p.blue })
hi("Conditional",{ fg = p.blue })
hi("Repeat",     { fg = p.blue })
hi("Label",      { fg = p.purple })
hi("Operator",   { fg = p.red })
hi("Keyword",    { fg = p.blue })
hi("Exception",  { fg = p.blue })
hi("PreProc",    { fg = p.purple })
hi("Include",    { fg = p.purple })
hi("Define",     { fg = p.purple })
hi("Macro",      { fg = p.purple })
hi("PreCondit",  { fg = p.purple })
hi("Type",       { fg = p.yellow })
hi("StorageClass",{ fg = p.orange })
hi("Structure",  { fg = p.yellow })
hi("Typedef",    { fg = p.yellow })
hi("Special",    { fg = p.red })
hi("SpecialChar",{ fg = p.red })
hi("Tag",        { fg = p.blue })
hi("Delimiter",  { fg = p.fg_dim })
hi("SpecialComment", { fg = p.comment })
hi("Debug",      { fg = p.red })
hi("Underlined", { underline = true })
hi("Ignore",     { fg = p.gray })
hi("Error",      { fg = p.red, underline = true })
hi("Todo",       { fg = p.bg, bg = p.yellow })

-- ===== C / C++ legacy syntax (syntax/c.vim, cpp.vim) ==================
hi("cInclude",     { fg = p.purple })
hi("cDefine",      { fg = p.purple })
hi("cMacro",       { fg = p.purple })
hi("cMacroParam",  { fg = p.fg_dim })
hi("cPreProc",     { fg = p.purple })
hi("cPreCondit",   { fg = p.purple })
hi("cIncluded",    { fg = p.green })      -- "header.h" after #include
hi("cCommentL",    { fg = p.comment })
hi("cComment",     { fg = p.comment })
hi("cCommentStart",{ fg = p.comment })
hi("cCppString",   { fg = p.green })
hi("cCppOut",      { fg = p.gray })    -- inactive #if 0 blocks
hi("cCppOut2",     { fg = p.gray })
hi("cCppSkip",     { fg = p.gray })
hi("cCppInIf2",    { fg = p.fg })
hi("cCharacter",   { fg = p.green })
hi("cSpecial",     { fg = p.red })
hi("cSpecialCharacter", { fg = p.red })
hi("cNumber",      { fg = p.orange })
hi("cFloat",       { fg = p.orange })
hi("cOctal",       { fg = p.orange })
hi("cOctalZero",   { fg = p.orange })
hi("cConditional", { fg = p.blue })
hi("cRepeat",      { fg = p.blue })
hi("cLabel",       { fg = p.purple })
hi("cUserLabel",   { fg = p.purple })
hi("cGoto",        { fg = p.blue })      -- goto keyword
hi("cOperator",    { fg = p.red })                    -- *, &, ->, sizeof
hi("cStorageClass",{ fg = p.orange })  -- static const volatile
hi("cStructure",   { fg = p.blue })                   -- struct/union/enum kw
hi("cTypedef",     { fg = p.blue })
hi("cType",        { fg = p.yellow })                 -- int, char, typedef'd types
hi("cConstant",    { fg = p.orange })
hi("cErrInParen",  { fg = p.red, undercurl = true })
hi("cErrInBracket",{ fg = p.red, undercurl = true })
hi("cError",       { fg = p.red, undercurl = true })
hi("cParenGroup",  { fg = p.none })
hi("cBoolean",     { fg = p.orange })

-- C++ specific
hi("cppStructure",   { fg = p.blue })                 -- class/namespace kw
hi("cppType",        { fg = p.yellow })                -- bool, auto, size_t
hi("cppExceptions",  { fg = p.blue })     -- try/catch/throw
hi("cppStatement",   { fg = p.blue })     -- new/delete
hi("cppAccess",      { fg = p.orange }) -- public/private/protected
hi("cppModifier",    { fg = p.orange }) -- override/final/noexcept
hi("cppCast",        { fg = p.blue })                  -- static_cast<> etc
hi("cppStorageClass",{ fg = p.orange }) -- constexpr/mutable
hi("cppNamespace",   { fg = p.fg })
hi("cppOperator",    { fg = p.red })
hi("cppBoolean",     { fg = p.orange })
hi("cppConstant",    { fg = p.orange })

-- ===== Treesitter (nvim-treesitter c/cpp parsers) =====================
hi("@comment",              { link = "Comment" })
hi("@comment.documentation",{ fg = p.comment })
hi("@string",                { link = "String" })
hi("@string.escape",         { fg = p.red })
hi("@character",             { link = "Character" })
hi("@character.special",     { fg = p.red })
hi("@number",                { link = "Number" })
hi("@number.float",          { link = "Float" })
hi("@boolean",               { link = "Boolean" })

hi("@variable",              { fg = p.fg })
hi("@variable.builtin",      { fg = p.red }) -- this, nullptr
hi("@variable.parameter",    { fg = p.param })
hi("@variable.member",       { fg = p.fg_dim })
hi("@field",                 { fg = p.fg_dim })
hi("@property",              { fg = p.fg_dim })
hi("@constant",              { link = "Constant" })
hi("@constant.builtin",      { fg = p.orange })
hi("@constant.macro",        { fg = p.purple }) -- #define'd constants

hi("@keyword",                { link = "Keyword" })
hi("@keyword.function",       { fg = p.blue })
hi("@keyword.return",         { fg = p.blue })
hi("@keyword.operator",       { fg = p.blue })
hi("@keyword.import",         { fg = p.purple })          -- #include
hi("@keyword.repeat",         { link = "Repeat" })
hi("@keyword.conditional",    { link = "Conditional" })
hi("@keyword.exception",      { link = "Exception" })
hi("@keyword.storage",        { fg = p.orange }) -- static/const/extern
hi("@keyword.directive",      { fg = p.purple })          -- preproc keyword itself
hi("@keyword.directive.define",{ fg = p.purple })
hi("@keyword.coroutine",      { fg = p.blue })

hi("@type",                   { link = "Type" })
hi("@type.builtin",           { fg = p.yellow }) -- int, char, bool
hi("@type.definition",        { fg = p.yellow, underline = false })
hi("@type.qualifier",         { fg = p.orange }) -- const/volatile
hi("@storageclass",           { fg = p.orange })
hi("@attribute",              { fg = p.purple }) -- [[nodiscard]]
hi("@namespace",              { fg = p.fg })
hi("@module",                 { fg = p.fg })

hi("@function",               { link = "Function" })
hi("@function.builtin",       { fg = p.teal })
hi("@function.call",          { fg = p.teal })
hi("@function.macro",         { fg = p.purple })          -- function-like macros
hi("@method",                 { fg = p.teal })
hi("@method.call",            { fg = p.teal })
hi("@constructor",            { fg = p.yellow })

hi("@operator",               { link = "Operator" })
hi("@punctuation.delimiter",  { fg = p.fg_dim })
hi("@punctuation.bracket",    { fg = p.fg_dim })
hi("@punctuation.special",    { fg = p.red })

hi("@label",                  { link = "Label" })
hi("@tag",                    { fg = p.blue })
hi("@tag.attribute",          { fg = p.orange })
hi("@tag.delimiter",          { fg = p.fg_dim })

hi("@preproc",                { link = "PreProc" })
hi("@include",                { fg = p.purple })
hi("@define",                 { fg = p.purple })
hi("@symbol",                 { fg = p.orange })
hi("@error",                  { link = "Error" })

-- ===== LSP semantic tokens (clangd) ====================================
hi("@lsp.type.class",         { link = "@type" })
hi("@lsp.type.struct",        { link = "@type" })
hi("@lsp.type.enum",          { link = "@type" })
hi("@lsp.type.enumMember",    { fg = p.orange })
hi("@lsp.type.interface",     { link = "@type" })
hi("@lsp.type.typeAlias",     { link = "@type" })
hi("@lsp.type.typeParameter", { fg = p.yellow })
hi("@lsp.type.namespace",     { fg = p.fg })
hi("@lsp.type.parameter",     { link = "@variable.parameter" })
hi("@lsp.type.variable",      { link = "@variable" })
-- clangd-specific: tags any variable declared inside a function body with a
-- "functionScope" modifier. Treesitter alone can't make this distinction
-- (it only knows "parameter" vs. everything else), so this only lights up
-- with clangd's semantic tokens enabled.
hi("@lsp.type.property",      { link = "@property" })
hi("@lsp.type.function",      { link = "@function" })
hi("@lsp.type.method",        { link = "@method" })
hi("@lsp.type.macro",         { link = "@constant.macro" })
hi("@lsp.type.comment",       { link = "Comment" })
hi("@lsp.type.keyword",       { link = "Keyword" })
hi("@lsp.type.modifier",      { fg = p.orange }) -- const/static in signatures
hi("@lsp.mod.readonly",       { fg = p.orange })
hi("@lsp.mod.static",         {})
hi("@lsp.mod.deprecated",     { strikethrough = true, fg = p.gray })
hi("@lsp.typemod.variable.globalScope", { fg = p.orange })

-- ===== Diagnostics ======================================================
hi("DiagnosticError", { fg = p.red })
hi("DiagnosticWarn",  { fg = p.yellow })
hi("DiagnosticInfo",  { fg = p.blue })
hi("DiagnosticHint",  { fg = p.teal })
hi("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = p.yellow })
hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = p.blue })
hi("DiagnosticUnderlineHint",  { undercurl = true, sp = p.teal })
hi("DiagnosticVirtualTextError", { fg = p.red_dim, bg = p.bg_alt })
hi("DiagnosticVirtualTextWarn",  { fg = p.orange, bg = p.bg_alt })
hi("DiagnosticVirtualTextInfo",  { fg = p.blue, bg = p.bg_alt })
hi("DiagnosticVirtualTextHint",  { fg = p.teal, bg = p.bg_alt })

-- ===== Git / gitsigns ====================================================
hi("DiffAdd",    { fg = p.green, bg = p.none })
hi("DiffChange", { fg = p.yellow, bg = p.none })
hi("DiffDelete", { fg = p.red, bg = p.none })
hi("DiffText",   { fg = p.blue, bg = p.none })
hi("GitSignsAdd",    { fg = p.green })
hi("GitSignsChange", { fg = p.yellow })
hi("GitSignsDelete", { fg = p.red })
