vim-clevertab
=============

Tiny replacement for Supertab that DOES do what I need.

If you're on a blank line or at the beginning of a line, it just 
issues a TAB keypress.
Otherwise, it calls UltiSnips. If no snippet was found, it calls the 
NeoComplete plugin, omni complete and keyword complete one after the 
other following the order you provided.
If there are no matches it calls the following one.

If you are already browsing a completion candidates list, tab will jump
to the next one and shift-tab to the previos one.

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
    
Edit your .vimrc and add this line:
   
    call CleverTab#KeywordFirst()

or 
    
    call CleverTab#OmniFirst()

or 
    
    call CleverTab#NeoCompleteFirst()


Usage
=====

While in insert mode, write some code and then just press TAB.
