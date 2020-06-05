%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       AUXILIARY PREDICATES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%
%% Document Identifier Delimiter = [46, 73]    
%% The code list [46, 73] is equivalent to '.I'
%% Usually the identifier is a number

isDocIdentifierDelimiter(Word) :- Word == [46, 73].



%%%%%%%%%%%
%% Text Delimiter = [46, 73]    
%% The code list [46, 87] is equivalent to '.W'

isTextDelimiter(Word) :- Word == [46, 87].



%%%%%%%%%%%
%% read_word(Word,EOF), extracts a Word from the current input stream.
%% EOF is bounded to 'true' if the end of the file is reached. It skips 
%% all symbols which a considered word delimiters.
%% WordDelimiter = [32, 44, 59, 10]
%% Code 32= ' ', 44=',', 59=';', 10 = NewLine

read_word(Word,EOF) :-
 		get0(C),
		C \== -1 -> %% Code -1 = End of File		
			(member(C, [32, 44, 59, 10]) -> 
				read_word(Word,EOF);
				read_remainderWord(RemainderWord,EOF), Word = [C|RemainderWord]
			);
			Word = [], EOF=true.

read_remainderWord(Word,EOF) :- 
		get0(C),
		C \== -1 -> %% Code -1 = End of File		
			(\+(member(C, [32, 44, 59, 10])) -> 
				read_remainderWord(RemainderWord,EOF), Word = [C|RemainderWord];
				Word = [], EOF=false
			);
			Word = [], EOF=true.


%%%%%%%%%%%
%%% similarToWith(+Mode, +Keyword, +Word1name, -AD)
%%%
%%% Establishes the degree of relation between Keyword and Word1name
%%%
%%% OBSERVATION: Keyword can be a simple word or a word term
%%% pattern of the form W[:T[:S]]
%%% Word1name is a simple word that comes from the file FileName being inspected.
%%%

similarToWith(Mode, Keyword:T:S1, Word1name, AD) :-
		!,
		similarToWith_aux(Mode, Keyword:T:S1, Word1name:T:_S2, AD).

similarToWith(Mode, Keyword:T, Word1name, AD) :-
		!,
		similarToWith_aux(Mode, Keyword:T:_S1, Word1name:T:_S2, AD).

similarToWith(Mode, Keyword, Word1name, AD) :-
		similarToWith_aux(Mode, Keyword:T:_S1, Word1name:T:_S2, AD).


similarToWith_aux(Mode, Keyword:T1:S1, Word1name:T2:S2, AD) :-
	(Mode=ont -> (%%% the relation is established by an ontology
				Keyword ~ Word1name = AD);
	 %%% the relation is established by similarity measures
	 Mode=path -> (findall(D, wn_path(Keyword:T1:S1, Word1name:T2:S2, D), LDs),
				max_degree(LDs, AD));
	 Mode=wup -> (findall(D, wn_wup(Keyword:T1:S1, Word1name:T2:S2, D), LDs),
				max_degree(LDs, AD));
	 Mode=lch -> (findall(D, wn_lch(Keyword:T1:S1, Word1name:T2:S2, D), LDs),
				max_degree(LDs, AD));
	 %%% the relation is established by similarity measures based on information content
	 Mode=res -> (findall(D, wn_res(Keyword:T1:S1, Word1name:T2:S2, D), LDs),
				max_degree(LDs, AD));
	 Mode=jcn -> (findall(D, wn_jcn(Keyword:T1:S1, Word1name:T2:S2, D), LDs),
				max_degree(LDs, AD));
	 Mode=lin -> (findall(D, wn_lin(Keyword:T1:S1, Word1name:T2:S2, D), LDs),
				max_degree(LDs, AD));
	 %%% OTHERWISE 
	 write("Undefined mode: "), write(Mode), nl, 
	 fail
	).
 
max_degree([], 0).
max_degree([D|LDs], AD):- max_list([D|LDs], AD).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
in_wordnet(Word:T:S):- !, wn_s(_,_,Word,T,S,_).
in_wordnet(Word:T):- !, wn_s(_,_,Word,T,_,_).
in_wordnet(Word):- wn_s(_,_,Word,_,_,_).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%
%%       HIGH ORDER PREDICATES
%%%%%%%%%%%%%%
% applyTo(P, [X1, ..., Xn]) : Builds and executes the atom P(X1, ..., Xn)
%
applyTo(P, Xs) :- Atom =.. [P|Xs], call(Atom).



%%%%%%%%%%%%%%
%%       STATISTICS 
%%%%%%%%%%%%%%
% This is how time and space are measured.

% stat_start(I), Initialization procedure. I is the total number of inferences 
%              (passes via the call and redo ports) since the system was started.
% stat_start(output)
stat_start(I) :- garbage_collect, %%%% Sicstus % nogc, 
	   statistics(runtime,_), statistics(inferences,I).

% stat_end(I), "I" must be the total number of inferences computed by stat_start
% stat_end(input)
stat_end(I) :- statistics(runtime,[_,MSec]), Time is MSec/1000,
          statistics(inferences,I2), Inf is I2 - I, 
          statistics(global_stack,[GBytes,_]), MbG is GBytes/1048576,
          statistics(local_stack,[LBytes,_]),  MbL is LBytes/1048576,
          write('Runtime: '), write(Time), write(' sec   '), 
          write('Num. of inferences: '), write(Inf), write('  '), nl,
          write('MEMORY USAGE: '), 
          write('(Global stack) '), write(MbG), write(' Mb   '), 
          write('(Local stack) '), write(MbL), write(' Mb   '), 
          nl, nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
