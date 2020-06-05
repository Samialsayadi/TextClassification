%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% et.pl - M. Covington      2003 February 12
% etu.pl - Modified for Unicode - Donald Rogers     2006 July 17
%          email: dero9753@ihug.co.nz
%          Modified to cope with comma in numbers   2006 July 20
% ET the Efficient Tokenizer
% Measured speed: On a 1-GHz Pentium III,
% about 6 seconds per megabyte of text tokenized,
% or about three lines of text per millisecond.
% New in this version: Special handling of apostrophes.
% The apostrophe is a whitespace character except in
% the sequence 't which is treated as just t,
% making morphological analysis easier.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For more information see: http://ai1.ai.uga.edu/mc/pronto/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% User-callable routines
%%
%%    tokensWords/2,     %%% (+Tokens,-Words)
%%    tokenizeFile/2,    %%% (+Filename,-Tokens)
%%    tokenizeStream/2,  %%% (+Stream,-Tokens)
%%    tokenizeLine/2,    %%% (+Stream,-Tokens)
%%    tokenizeLine_dl/2  %%% (+Stream,-Tokens/Tail)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tokensWords(+Tokens,-Words)
%  From the output of the other routines, extracts just
%  the word tokens and converts them to atoms.
tokensWords([],[]).
tokensWords([w(Chars)|Tokens],[Atom|Atoms]) :-
   !,
   atom_chars(Atom,Chars),
   tokensWords(Tokens,Atoms).

tokensWords([_|Tokens],Atoms) :-
   % skip non-word tokens
   tokensWords(Tokens,Atoms).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tokenizeFile(+Filename,-Tokens)
%  Reads an entire file and tokenizes it.

tokenizeFile(Filename,Tokens) :-
   open(Filename,read,Stream),
   tokenizeStream(Stream,Tokens),
   close(Stream).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tokenizeStream(+Stream,-Tokens)
%  Reads an entire stream and tokenizes it.
tokenizeStream(Stream,[]) :-
   at_end_of_stream(Stream),
   !.

tokenizeStream(Stream,Tokens) :-
   tokenizeLine_dl(Stream,Tokens/Tail),
   tokenizeStream(Stream,Tail).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tokenizeLine(+Stream,-Tokens)
%  Reads a line of input and returns a list of tokens.

tokenizeLine(Stream,Tokens) :-
   tokenizeLine_dl(Stream,Tokens/[]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tokenizeLine_dl(+Stream,-Tokens/Tail)
%  Like tokenizeLine, but uses a difference list.
%  This makes it easier to append the results of successive calls.

tokenizeLine_dl(Stream,Tail/Tail) :-
   at_end_of_stream(Stream),                        % unnecessary test?
   !.

tokenizeLine_dl(Stream,Dlist) :-
   getChar_and_type(Stream,Char,Type),
   tokenizeLine_x(Type,Char,Stream,Dlist).

%%
%% Auxiliary predicates for tokenization
%%

% getChar_and_type(+Stream,-Char,-Type)
%  Reads a character, determines its type, and translates
%  it as specified in charType_char.

getChar_and_type(Stream,Char,Type) :-
   get_char(Stream,C),
   charType_char(C,Type,Char).


% tokenizeLine_x(+Type,+Char,+Stream,-Tokens/Tail)
%  Tokenizes (the rest of) a line of input.
%  Type and Char describe the character that has been read ahead.

tokenizeLine_x(eol,_,_,Tail/Tail) :-               % end of line mark; terminate
   !.

tokenizeLine_x(whitespace,_,Stream,Dlist) :-       % whitespace, skip it
   !,
   tokenizeLine_dl(Stream,Dlist).


% Word tokens and number tokens have to be completed,
% maintaining 1 character of read-ahead as this is done.
% NewChar and NewType are the character read ahead
% after completing the token.

tokenizeLine_x(letter,Char,Stream,[w(T)|Tokens]/Tail) :-
   !,
   tokenizeLetters(letter,Char,Stream,T,NewType,NewChar),
   tokenizeLine_x(NewType,NewChar,Stream,Tokens/Tail).

tokenizeLine_x(digit,Char,Stream,[n(T)|Tokens]/Tail) :-
   !,
   tokenizeDigits(digit,Char,Stream,T,NewType,NewChar),
   tokenizeLine_x(NewType,NewChar,Stream,Tokens/Tail).


% A period is handled like a digit if it is followed by a digit.
% This handles numbers that are written with the decimal point first.

tokenizeLine_x(_, '.', Stream,Dlist) :-
   peek_char(Stream,P),
   charType_char(P,digit,_),
   !,
   % Start over, classifying '.' as a digit
   tokenizeLine_x(digit, '.', Stream,Dlist).

% Donald: A comma is also handled like a digit if it is followed by a digit.
% For those locales where a comma is used as a decimal separator.
% Users may want to allow a decimal separator (say ',') but remove 
% the (ten)thousands separator (say '.'). Further coding is required for this.

tokenizeLine_x(_, ',', Stream,Dlist) :-
   peek_char(Stream,P),
   charType_char(P,digit,_),
   !,
   % Start over, classifying ',' as a digit
   tokenizeLine_x(digit, ',', Stream,Dlist).


% Special characters and unidentified characters are easy:
% they stand by themselves, and the next token begins with
% the very next character.

tokenizeLine_x(special,Char,Stream,[s(Char)|Tokens]/Tail) :-   % special char
   !,
   tokenizeLine_dl(Stream,Tokens/Tail).

tokenizeLine_x(_,Char,Stream,[other(Char)|Tokens]/Tail) :-     % unidentified char
   !,
   tokenizeLine_dl(Stream,Tokens/Tail).


% tokenizeLetters(+Type,+Char,+Stream,-Token,-NewChar,-NewType)
%   Completes a word token beginning with Char, which has
%   been read ahead and identified as type Type.
%   When the process ends, NewChar and NewType are the
%   character that was read ahead after the token.

tokenizeLetters(letter,Char,Stream,[Char|Rest],NewType,NewChar) :-
   % It's a letter, so process it, read another character ahead, and recurse.
   !,
   getChar_and_type(Stream,Char2,Type2),
   tokenizeLetters(Type2,Char2,Stream,Rest,NewType,NewChar).

tokenizeLetters(_,'''',Stream,Rest,NewType,NewChar) :-
   %
   % Absorb an apostrophe, but only when it precedes t.
   % This keeps words together like doesn't, won't.
   %
   peek_char(Stream,t),
   !,
   get_char(Stream,_),
   tokenizeLetters(letter,t,Stream,Rest,NewType,NewChar).

tokenizeLetters(Type,Char,_,[],Type,Char).
   % It's not a letter, so don't process it; pass it to the calling procedure.


% tokenizeDigits(+Type,+Char,+Stream,-Token,-NewChar,-NewType)
%   Like tokenizeLetters, but completes a number token instead.
%   Additional subtleties for commas and decimal points.

tokenizeDigits(digit,Char,Stream,[Char|Rest],NewType,NewChar) :-
   % It's a digit, so process it, read another character ahead, and recurse.
   !,
   getChar_and_type(Stream,Char2,Type2),
   tokenizeDigits(Type2,Char2,Stream,Rest,NewType,NewChar).

tokenizeDigits(_, '.', Stream,['.'|Rest],NewType,NewChar) :-
   peek_char(Stream,P),
   charType_char(P,digit,Char2),
   !,
   % It's a period followed by a digit, so include it and continue.
   get_char(Stream,_),
   tokenizeDigits(digit,Char2,Stream,Rest,NewType,NewChar).

% Donald added this clause for commas in numbers:

tokenizeDigits(_, ',', Stream,[','|Rest],NewType,NewChar) :-
   peek_char(Stream,P),
   charType_char(P,digit,Char2),
   !,
   % It's a comma followed by a digit, so include it and continue.
   get_char(Stream,_),
   tokenizeDigits(digit,Char2,Stream,Rest,NewType,NewChar).

tokenizeDigits(Type,Char,_,[],Type,Char).
   % It's not any of those, so don't process it;
   % pass it to the calling procedure.


%%
%% Character classification
%%

% charType_char(+Char,-Type,-TranslatedChar)
%   Classifies all characters as letter, digit, special, etc.,
%   and also translates each character into the character that
%   will represent it, converting upper to lower case.

charType_char(Char,Type,Tr) :-
   charTable(Char,Type,Tr),
   !.

% Donald changed this from special to letter.
% Using downcase_atom saves having an enormous table
% and should handle all languages.
charType_char(Char,letter,Char2) :-
   atom_chars(L2,[Char]),
   downcase_atom(L2,L3),
   atom_chars(L3,[Char2]). 

% End of line marks
charTable(end_of_file, eol, end_of_file).
charTable('\n',        eol, '\n'       ).

% Whitespace characters
charTable(' ',     whitespace,  ' ').     % blank
charTable('\t',    whitespace,  ' ').     % tab
charTable('\r',    whitespace,  ' ').     % return
charTable('''',    whitespace, '''').     % apostrophe does not translate to blank

% Donald removed the letter characters and replaced them by special characters.
% There are too many Unicode letters to put them all in a table.
% The third parameter may be useless, but maybe someone will want to convert
% some of the special characters.
% There may be other Unicode characters that need to be added.

charTable('~',     special,    '~' ).
charTable('`',     special,    '`' ).
charTable('!',     special,    '!' ).
charTable('@',     special,    '@' ).
charTable('#',     special,    '#' ).
charTable('$',     special,    '$' ).
charTable('\u0025',special,    '\u0025' ). %
charTable('^',     special,    '^' ).
charTable('&',     special,    '&' ).
charTable('*',     special,    '*' ).
charTable('(',     special,    '(' ).
charTable(')',     special,    ')' ).
charTable('_',     special,    '_' ).
charTable('-',     special,    '-' ).
charTable('+',     special,    '+' ).
charTable('=',     special,    '=' ).
charTable('{',     special,    '{' ).
charTable('[',     special,    '[' ).
charTable('}',     special,    '}' ).
charTable(']',     special,    ']' ).
charTable('|',     special,    '|' ).
charTable('\\',    special,    '\\' ).
charTable(':',     special,    ':' ).
charTable(';',     special,    ';' ).
charTable('"',     special,    '"' ).
charTable('<',     special,    '<' ).
charTable(',',     special,    ',' ).
charTable('>',     special,    '>' ).
charTable('.',     special,    '.' ).
charTable('?',     special,    '?' ).
charTable('/',     special,    '/' ).

% Digits
charTable('0',   digit,     '0' ).
charTable('1',   digit,     '1' ).
charTable('2',   digit,     '2' ).
charTable('3',   digit,     '3' ).
charTable('4',   digit,     '4' ).
charTable('5',   digit,     '5' ).
charTable('6',   digit,     '6' ).
charTable('7',   digit,     '7' ).
charTable('8',   digit,     '8' ).
charTable('9',   digit,     '9' ).

% Everything else is a letter character.