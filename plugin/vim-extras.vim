" FUNCTIONS
" {{{


" buffer delete
function! BufferDelete()
    if &modified
        echohl ErrorMsg
        echomsg "No write since last change. Not closing buffer."
        echohl NONE
    else
        let s:total_nr_buffers = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))

        if s:total_nr_buffers == 1
            bdelete
            echo "Buffer deleted. Created new buffer."
        else
            bprevious
            bdelete #
            echo "Buffer deleted."
        endif
    endif
endfunction


" toggle absolute / relative line numbers
function! g:ToggleNuMode()
    if(&rnu == 1)
        set rnu!
    else
        set rnu
    endif
endfunction


" toggle wrap + set multiline editing
function! ToggleWrap()
    if &wrap
        echo "Wrap OFF"
        setlocal nowrap
        "set virtualedit=all
        "silent! nunmap <buffer> <Up>
        "silent! nunmap <buffer> <Down>
        "silent! nunmap <buffer> <Home>
        "silent! nunmap <buffer> <End>
        "silent! iunmap <buffer> <Up>
        "silent! iunmap <buffer> <Down>
        "silent! iunmap <buffer> <Home>
        "silent! iunmap <buffer> <End>
        "silent! vunmap <buffer> <Up>
        "silent! vunmap <buffer> <Down>
        "silent! vunmap <buffer> <Home>
        "silent! vunmap <buffer> <End>
    else
        echo "Wrap ON"
        setlocal wrap
        "setlocal wrap linebreak nolist
        "set virtualedit=
        "setlocal display+=lastline
        "noremap   <buffer> <silent> <Up>   gk
        "noremap   <buffer> <silent> <Down> gj
        "noremap   <buffer> <silent> <Home> g<Home>
        "noremap   <buffer> <silent> <End>  g<End>
        "noremap   <buffer> <silent> k gk
        "noremap   <buffer> <silent> j gj
        "noremap   <buffer> <silent> 0 g0
        "noremap   <buffer> <silent> $ g$
        "inoremap  <buffer> <silent> <Up>   <C-o>gk
        "inoremap  <buffer> <silent> <Down> <C-o>gj
        "inoremap  <buffer> <silent> <Home> <C-o>g<Home>
        "inoremap  <buffer> <silent> <End>  <C-o>g<End>
        "vnoremap  <buffer> <silent> <Up>   gk
        "vnoremap  <buffer> <silent> <Down> gj
        "vnoremap  <buffer> <silent> <Home> g<Home>
        "vnoremap  <buffer> <silent> <End>  g<End>
        "vnoremap  <buffer> <silent> k gk
        "vnoremap  <buffer> <silent> j gj
        "vnoremap  <buffer> <silent> 0 g0
        "vnoremap  <buffer> <silent> $ g$
    endif
endfunction

" XMLLint, DoPrettyXML
"au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"
function! DoPrettyXML()
    " save the filetype so we can restore it later
    let l:origft = &ft
    set ft=
    " delete the xml header if it exists. This will
    " permit us to surround the document with fake tags
    " without creating invalid xml.
    1s/<?xml .*?>//e
    " insert fake tags around the entire document.
    " This will permit us to pretty-format excerpts of
    " XML that may contain multiple top-level elements.
    0put ='<PrettyXML>'
    $put ='</PrettyXML>'
    silent %!XMLLINT_INDENT="    " xmllint --format -
    " xmllint will insert an <?xml?> header. it's easy enough to delete
    " if you don't want it.
    " delete the fake tags
    2d
    $d
    " restore the 'normal' indentation, which is one extra level
    " too deep due to the extra tags we wrapped around the document.
    silent %<
    " back to home
    1
    " restore the filetype
    exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

" sftp link shortcut
command! -nargs=1 Sftp :e sftp://<args>//


