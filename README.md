vim-clevertab
=============

Tiny replacement for Supertab that DOES do what I need.

First of all, if you're on a blank line or at the beginning of a 
line, it just issues a TAB.
Otherwise, it calls UltiSnips. If no snippet was found, it calls 
omni complete or keyword complete (the one you defined to be called 
first) and if there are no matches, it calls the other one.

If you are already browsing a completion candidates list, tab will jump
to the next one and shift-tab to the previos one.

I did this because SuperTab did not detect if a completion returned 
something or not, and I really needed to fall from a completion
function back to the other (Omni to Keyword or Keyword to Omni) in 
some cases.


Installation
============

    cd ~/.vim/bundle/
    git clone https://github.com/neitanod/vim-clevertab.git
    
Edit your .vimrc and add this line:
   
    call CleverTab#KeywordFirst()

or 
    
    call CleverTab#OmniFirst()


Usage
=====

While in insert mode, write some code and then just press TAB.
