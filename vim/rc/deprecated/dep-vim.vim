
    Plug 'rhysd/git-messenger.vim'
    nmap <Leader>gm <Plug>(git-messenger)
    let g:git_messenger_include_diff = 'current'
    let g:git_messenger_always_into_popup = v:true
    let g:git_messenger_into_popup_after_show = v:true

" git
    Plug 'cohama/agit.vim'

    Plug 'tpope/vim-fugitive'

    " Plug 'airblade/vim-gitgutter'

    " Statusline
    Plug 'itchyny/lightline.vim'
    let g:lightline = {
                \ 'colorscheme': 'material',
                \ 'active': {
                \   'left': [ [ 'mode', 'paste' ], ['fugitive', 'filename', 'modified', 'readonly' ] ],
                \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
                \ },
                \ 'tabline': {'left': [['buffers']], 'right': [['close']]},
                \ 'component_function': {
                \   'cocstatus': 'coc#status',
                \   'fugitive': 'LightlineFugitive',
                \   'filename': 'LightlineFilename',
                \   'fileformat': 'LightlineFileformat',
                \   'filetype': 'LightlineFiletype',
                \   'fileencoding': 'LightlineFileencoding',
                \   'mode': 'LightlineMode',
                \ },
                \ 'component_expand': {
                \   'syntastic': 'SyntasticStatuslineFlag',
                \   'buffers': 'lightline#bufferline#buffers',
                \ },
                \ 'component_type': {
                \   'syntastic': 'error',
                \   'buffers': 'tabsel',
                \ },
                \ 'subseparator': { 'left': '|', 'right': '|' }
                \ }

    function! LightlineModified()
        return &filetype =~? 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
    endfunction

    function! LightlineReadonly()
        return &filetype !~? 'help' && &readonly ? 'RO' : ''
    endfunction

    function! LightlineFilename()
        let fname = expand('%:t')
        return fname ==? 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
                    \ fname ==? '__Tagbar__' ? g:lightline.fname :
                    \ fname =~? '__Gundo\|NERD_tree' ? '' :
                    \ &filetype ==? 'vimfiler' ? vimfiler#get_status_string() :
                    \ &filetype ==? 'unite' ? unite#get_status_string() :
                    \ &filetype ==? 'vimshell' ? vimshell#get_status_string() :
                    \ ('' !=? LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
                    \ ('' !=? fname ? fname : '[No Name]') .
                    \ ('' !=? LightlineModified() ? ' ' . LightlineModified() : '')
    endfunction

    function! LightlineFugitive()
        try
            if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &filetype !~? 'vimfiler' && exists('*fugitive#head')
                let mark = ''  " edit here for cool mark
                let branch = fugitive#head()
                return branch !=# '' ? mark.branch : ''
            endif
        catch
        endtry
        return ''
    endfunction

    function! LightlineFileformat()
        return winwidth(0) > 70 ? &fileformat : ''
    endfunction

    function! LightlineFiletype()
        return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
    endfunction

    function! LightlineFileencoding()
        return winwidth(0) > 70 ? (&fileencoding !=# '' ? &fileencoding : &encoding) : ''
    endfunction

    function! LightlineMode()
        let fname = expand('%:t')
        return fname ==? '__Tagbar__' ? 'Tagbar' :
                    \ fname ==? 'ControlP' ? 'CtrlP' :
                    \ fname ==? '__Gundo__' ? 'Gundo' :
                    \ fname ==? '__Gundo_Preview__' ? 'Gundo Preview' :
                    \ fname =~? 'NERD_tree' ? 'NERDTree' :
                    \ &filetype ==? 'unite' ? 'Unite' :
                    \ &filetype ==? 'vimfiler' ? 'VimFiler' :
                    \ &filetype ==? 'vimshell' ? 'VimShell' :
                    \ winwidth(0) > 60 ? lightline#mode() : ''
    endfunction

    function! CtrlPMark()
        if expand('%:t') =~? 'ControlP' && has_key(g:lightline, 'ctrlp_item')
            call lightline#link('iR'[g:lightline.ctrlp_regex])
            return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
                        \ , g:lightline.ctrlp_next], 0)
        else
            return ''
        endif
    endfunction

    let g:ctrlp_status_func = {
                \ 'main': 'CtrlPStatusFunc_1',
                \ 'prog': 'CtrlPStatusFunc_2',
                \ }

    function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
        let g:lightline.ctrlp_regex = a:regex
        let g:lightline.ctrlp_prev = a:prev
        let g:lightline.ctrlp_item = a:item
        let g:lightline.ctrlp_next = a:next
        return lightline#statusline(0)
    endfunction

    function! CtrlPStatusFunc_2(str)
        return lightline#statusline(0)
    endfunction

    let g:tagbar_status_func = 'TagbarStatusFunc'

    function! TagbarStatusFunc(current, sort, fname, ...) abort
        let g:lightline.fname = a:fname
        return lightline#statusline(0)
    endfunction

    augroup AutoSyntastic
        autocmd!
        autocmd BufWritePost *.c,*.cpp call s:syntastic()
    augroup END
    function! s:syntastic()
        SyntasticCheck
        call lightline#update()
    endfunction

    let g:unite_force_overwrite_statusline = 0
    let g:vimfiler_force_overwrite_statusline = 0
    let g:vimshell_force_overwrite_statusline = 0



    Plug 'szymonmaszke/vimpyter', {'for': 'ipynb'}
    augroup vimpyter
        autocmd Filetype ipynb nmap <silent><C-s>b :VimpyterInsertPythonBlock<CR>
        autocmd Filetype ipynb nmap <silent><C-s>j :VimpyterStartJupyter<CR>
        autocmd Filetype ipynb nmap <silent><C-s>n :VimpyterStartNteract<CR>
    augroup END


" もし設定のキャッシュファイルを読み込めなかったら
" tomlファイルを再読み込みする
"if dein#load_state(s:dein_dir)
"    call dein#begin(s:dein_dir) " 設定開始
"
"    " プラグインリストを収めた TOML ファイル
"    " 予め TOML ファイル（後述）を用意しておく
"    let g:rc_dir = expand('~/.vim/rc')
"    let s:dein_toml = g:rc_dir . '/dein.toml'
"    let s:lazy_dein_toml = g:rc_dir . '/lazy_dein.toml'
"    if !has('nvim')
"      call dein#add('roxma/nvim-yarp')
"      call dein#add('roxma/vim-hug-neovim-rpc')
"    endif
"    " TOML を読み込み、キャッシュしておく
"    call dein#load_toml(s:dein_toml,      {'lazy': 0})
"    call dein#load_toml(s:lazy_dein_toml, {'lazy': 1})
"
"    call dein#end() " 設定終了
"    call dein#save_state() " キャッシュ保存
"endif
"
"" もし、未インストールものものがあったらインストール
"if dein#check_install()
"    call dein#install()
"endif
"
"" plugin remove check
"let s:removed_plugins = dein#check_clean()
"if len(s:removed_plugins) > 0
"    call map(s:removed_plugins, "delete(v:val, 'rf')")
"    call dein#recache_runtimepath()
"endif


