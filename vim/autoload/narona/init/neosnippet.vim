scriptencoding utf-8

function! narona#init#neosnippet#hook_source() abort
	" Plugin key-mappings.
	" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
	imap <C-k>     <Plug>(neosnippet_expand_or_jump)
	smap <C-k>     <Plug>(neosnippet_expand_or_jump)
	xmap <C-k>     <Plug>(neosnippet_expand_target)

	" SuperTab like snippets behavior.
	" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
	imap <expr><TAB>
				\ pumvisible() ? "\<C-n>" :
				\ neosnippet#expandable_or_jumpable() ?
				\    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

	imap <expr><CR>
				\ (pumvisible() && neosnippet#expandable()) ? "\<Plug>(neosnippet_expand_or_jump)" : "\<CR>"


	smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
				\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

	" For conceal markers.
	"if has('conceal')
	"  set conceallevel=2 concealcursor=niv
	"endif
endfunction
