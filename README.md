vim-clevertab
=============

Tiny replacement for Supertab that DOES do what I need.

If you're on a blank line or at the beginning of a line, it just 
issues a TAB keypress.
Otherwise, it calls UltiSnips (or NeoSnippet). If no snippet was found, it calls the 
NeoComplete plugin, omni complete and keyword complete one after the 
other following the order you provided.
If there are no matches it calls the following one.

If you are already browsing a completion candidates list, tab will jump
to the next one and shift-tab to the previous one.

I did this because SuperTab did not detect if a completion returned 
something or not, and in some cases I really needed to fall from a 
completion function back to the other (Omni to Keyword or Keyword to 
Omni, and later added support for the excellent NeoComplete plugin).

This piece of code is a derivation of the function suggested by:
[Nikolay Frantsev] (http://stackoverflow.com/users/256497/nikolay-frantsev)
in [StackOverflow.com] 
(http://stackoverflow.com/questions/2136801/vim-keyword-complete-when-omni-complete-returns-nothing) 


Installation
============

With Pathogen:

    cd ~/.vim/bundle/
    git clone https://github.com/neitanod/vim-clevertab.git
    
Edit your .vimrc and then load one of the predefined chains (which try to call UltiSnips), like this:
   
    call CleverTab#KeywordFirst()

or 
    
    call CleverTab#OmniFirst()

or 
    
    call CleverTab#NeoCompleteFirst()

or define your own chain:

    inoremap <silent><tab> <c-r>=CleverTab#Complete('start')<cr>
                          \<c-r>=CleverTab#Complete('tab')<cr>
                          \<c-r>=CleverTab#Complete('ultisnips')<cr>
                          \<c-r>=CleverTab#Complete('keyword')<cr>
                          \<c-r>=CleverTab#Complete('neocomplete')<cr>
                          \<c-r>=CleverTab#Complete('omni')<cr>
                          \<c-r>=CleverTab#Complete('stop')<cr>
    inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>

Here is a chain using NeoSnippet instead of UltiSnips:

    inoremap <silent><tab> <c-r>=CleverTab#Complete('start')<cr>
                          \<c-r>=CleverTab#Complete('tab')<cr>
                          \<c-r>=CleverTab#Complete('neosnippet')<cr>
                          \<c-r>=CleverTab#Complete('keyword')<cr>
                          \<c-r>=CleverTab#Complete('omni')<cr>
                          \<c-r>=CleverTab#Complete('neocomplete')<cr>
                          \<c-r>=CleverTab#Complete('stop')<cr>
    inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>

You must always start with CleverTab#Complete('start'), as it takes care
of the bootstrap of the chain.

Likewise, you must always end with CleverTab#Complete('end') which takes
care of the cases where Tab means "next entry" on a suggestions menu.

Between those two, you can define which functions and plugins to call, 
and in which order.  Each time that a function finds something to do 
the chain is broken and the rest of the calls are ignored.

Options:

  - tab

    Issues a Tab press and breaks the call chain, but only if the cursor 
    is at the beginning of a line.  Only whitespace is allowed at the
    left of the cursor. Otherwise this call is skipped.

  - ultisnips
    
    Starts UltiSnips plugin.  If the keyword at the left of the cursor
    matches a snippet, it gets inserted and the call chain get broken.
    If UltiSnips fails to match the keyword to a snippet, control is 
    passed to the next call.

  - keyword

    Issues a native `<C-P>` keypress.  This starts the Keyword Completion.
    If a match is found and inserted into the buffer, or several matches 
    are found and the pop up menu (PUM) is displayed, the call chain gets
    broken.  If no match is found control is passed to the next call.

  - omni

    Just like the previous option, but instead of the native Keyword 
    Completion function, the Omni Function is used by issuing a `<C-X><C-O>`
    key sequence press.

  - neocomplete

    Works like the keyword and omni calls, but this one starts the 
    NeoComplete plugin to search for matches.  

  - neosnippet

    Starts the NeoSnippet plugin to search for matches.

If you use a completion plugin other than NeoComplete and/or a snippets 
plugin other than UltiSnips or NeoSnippet, I encourage you to hack into this plugin and 
add them yourself!  Each one is just an elseif block with just one to five 
lines of code in it.  Then send me a pull request or just mail it to me.


Usage
=====

While in insert mode, write some code and then just press TAB.
