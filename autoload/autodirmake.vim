"=============================================================================
" File:autoload/autodirmake.vim
" Author: mopp
" Created: 2013-12-11
"=============================================================================

scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let g:autodirmake#is_confirm = get(g:, 'autodirmake#is_confirm', 1)
let g:autodirmake#msg_highlight = get(g:, 'autodirmake#msg_highlight', 'None')


let s:V = vital#of('autodirmake')
let s:Prelude = s:V.import('Prelude')
unlet s:V



function! autodirmake#make_dir(dir)
    if !isdirectory(a:dir)
        if s:confirm(a:dir)
            call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
        endif
    endif
endfunction


function! s:confirm(dir)
    if !g:autodirmake#is_confirm
        return 1
    endif

    let hl = g:autodirmake#msg_highlight
    if hl !=# '' && hl !=# 'None'
        execute 'echohl' hl
    endif

    try
        let prompt = '"%s" does not exist. Create? [y/N]'
        let maxlen = &columns - 1
        let maxlen -= strlen(prompt) + 8    " %s(2) + cosmetic space(10)
        let abbrdir = a:dir
        if strlen(abbrdir) > maxlen
            " footer_width: separator + filename
            let footer_width = strlen(fnamemodify(a:dir, ':t')) + 1
            let abbrdir = s:Prelude.truncate_skipping(abbrdir, maxlen - 3, footer_width, '...')
        endif
        return input(printf(prompt, abbrdir)) =~? '^y\%[es]$'
    finally
        if hl !=# '' && hl !=# 'None'
            echohl None
        endif
    endtry
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo

