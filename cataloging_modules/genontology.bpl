%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% NOTE.
% TO USE THE PREDICATES IN THIS FILE IT IS NECESSARY TO HAVE ACCESS TO THE
% LIBRARIES:
%%% Michael A. Covington's Efficient Tokenizer (module etu.pl)
%%%
%%% Accessing WordNet you should have automatic access to them (but it is not the case in BPL)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:- include('genontology_modules/englishPlural.bpl').
%:- include('genontology_modules/etu.bpl').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% gen_ontology_file(+ListOfCategories, +File, +Measure)
%%% Given a list of categories, ListOfCategories, the name of a file, File,
%%% and the acronym of a measure, Measure (by now [path, wup, lch, res, lin, jcn,
%%% yarm]), it generates a set of proximity equations and stores them into the file File.
%%%
gen_ontology_file(ListOfCategories, File, Measure) :-
   gen_ontology_file(ListOfCategories, File, Measure, complex).

%%% gen_ontology_file(ListOfCategories, File, Measure, Mode):-
gen_ontology_file(ListOfCategories, File, Measure, Mode):-
    file_name_extension(_, Extension, File),
    ((Extension = ont) -> File_ont = File;
     (Extension = '')  -> file_name_extension(File, ont, File_ont)
    ),
    (exists_file(File_ont) ->
        write('The file '), write(File), write(' or '), write(File_ont), write(' does exists.'), nl
        ;
        (member(Measure, [path, wup, lch, res, lin, jcn, hso, lesk, vector, yarm]) ->
            open(File_ont, write, OutputStream),
            write(OutputStream,'%% PROXIMITY EQUATIONS'), nl(OutputStream),
            gen_equations(ListOfCategories, Measure, Mode, OutputStream),
            close(OutputStream)
            ;
            write(Measure), write(' is not a similarity or relatedness measure.'), nl
        )
    ).


%%% gen_equations(ListOfCategories, Measure, Mode, OutputStream),
%
gen_equations([], _,  _, _).
gen_equations([Category|Categories], Measure, Mode, OutputStream):-
	(in_wordnet(Category) ->
		glossList(Category, Gloss_list),
		gen_equations4category(Gloss_list, Category, Measure, Mode, OutputStream)
		;
		write('Warning: the word '), write(Category), write(' is not in WordNet.'), nl
	),
	gen_equations(Categories, Measure, Mode, OutputStream).


%%% gen_equations4category(Gloss_list, Category, Measure, Mode, OutputStream)
%%% For each word, "Word", in the list of words, "Gloss_list" (obtained from the WordNet 
%%% gloss of the "Category") it builds the proximity equation "Category ~ Word = SimDegree" 
%%% and it write the proximity equation into the file named "File".
%%%
%%% The degree "SimDegree" is obtained using the similarity measure "Measure", where "Measure"
%%% can be any of the following acronyms: [path, wup, lch, res, lin, jcn, yarm].
%%%
%%% If generation mode "Mode" is equal to "simple" the generated proximity equation has
%%% the form "Category ~ Word = SimDegree", but if it is "complex" the category, is expressed
%%% as a pattern: "Category:Type:Sense ~ Word = SimDegree".
%%%
%%% NOTES: The words "Category" and "Word" must be words of the same part of
%%%        speech (either nouns or verbs) except if the "yarm" measure is used.
%%%
%%%%similarToWith(+Mode, +Keyword, +Word1name, -AD)
gen_equations4category([], _, _, _, _).
gen_equations4category([Word|Gloss_list], Category, Measure, Mode, OutputStream):-
		similarToWith(Measure, Category, Word, SimDegree), 
		((SimDegree > 0) -> 
		normalize_degree(Measure, SimDegree, NormalizedDegree),
		write_equation(Category, Word, NormalizedDegree, Mode, OutputStream)
		;
		true
		),
		gen_equations4category(Gloss_list, Category, Measure, Mode, OutputStream).


%%% write_equation(+Category, +Word, + SimDegree, +Mode, +OutputStream)
%%%
write_equation(Category, Word, SimDegree, simple, OutputStream) :- 
		atomic_list_concat([Category,'~', Word, '=', SimDegree, '.'], ProxEqu),
		write(OutputStream,ProxEqu), nl(OutputStream).

write_equation(Category:_:_, Word, SimDegree, complex, OutputStream) :-
		atomic_list_concat([Category, '~', Word, '=', SimDegree, '.'], ProxEqu),
		write(OutputStream,ProxEqu), nl(OutputStream).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% glossList(+Word, -Gloss_list)
%%%
glossList(Word, Gloss_list) :-
    listify_gloss(Word, GL),
    delete_stop_words(GL, RGL),
    convert_words_to_singular(RGL, SGL),
    delete_repeated_elements(SGL, Gloss_list).


convert_words_to_singular([],[]).
convert_words_to_singular([W|Ws], [SW|SWs]):-
            convert_to_singular(W, SW),
            convert_words_to_singular(Ws, SWs).

%%% listify_gloss(+Word, -Gloss_list)
%%%
listify_gloss(Word, Gloss_list) :-
        wn_gloss_of(Word, Gloss),
        atom_string(Gloss, SGloss),
        open_string(SGloss, Stream),
        tokenizeLine(Stream,TGloss),
        tokensWords(TGloss,Gloss_list).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% delete_stop_words(+Gloss_list, -Pruned_Gloss_list)
%%%
delete_stop_words([],[]).
delete_stop_words([Word|Words], Pruned_Gloss_list) :-
        stop_words(StopWords_list),
        %(lists:member(Word, StopWords_list) ->
        (member(Word, StopWords_list) ->
            delete_stop_words(Words, Pruned_Gloss_list)
            ;
            delete_stop_words(Words, Tail_Pruned_Gloss_list),
            Pruned_Gloss_list = [Word|Tail_Pruned_Gloss_list]
        ).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%        LOCAL AXILIARY PREDICATES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%
%%% stop_words(List)
%%% English Stop Words (CSV)
%%% FROM WIKIPEDIA: https://en.wikipedia.org/wiki/Stop_words
%%%
stop_words([a, able, about, across, after, all, almost, also, am, among, an, and, any, are, as, at, be, because, been, but, by, can, cannot, could, dear, did, do, does, either, else, ever, every, for, from, get, got, had, has, have, he, her, hers, him, his, how, however, i, if, in, into, is, it, its, just, least, let, like, likely, may, me, might, most, must, my, neither, no, nor, not, of, off, often, on, only, or, other, our, own, rather, said, say, says, she, should, since, so, some, than, that, the, their, them, then, there, these, they, this, tis, to, too, twas, us, wants, was, we, were, what, when, where, which, while, who, whom, why, will, with, would, yet, you, your]).


%%%%%%%%
%%% delete_repeated_elements(+MultiSet, -Set)
delete_repeated_elements(L1, L2) :- delete_repeated_elements(L1, [], L2).

delete_repeated_elements([], A, A).
delete_repeated_elements([X|R], A, L):-
    %(lists:member(X,A) ->
    (member(X,A) ->
        delete_repeated_elements(R, A, L)
        ;
        delete_repeated_elements(R, [X|A], L)
    ).


%%%%%%%%
%%% normalize_degree(+Measure, +Degree, -NormalizedDegree)
%% This predicate normalizes to the range [0, 1] the Degree obtained using 
%% a similarity/relatedness Measure. 
%% The normalization is done with regard to the measure maximum value:
%%
%%        NormalizedDegree = Degree / Measure_max_value
%%
%% Note that, measures path, wup, res, jcn, lin, and yarm have Measure_max_value=1, 
%% therefore, no normalization is necessary.
%%
normalize_degree(path, Degree, Degree).

normalize_degree(wup, Degree, Degree).

normalize_degree(lch, Degree, NormalizedDegree):- 
		NormalizedDegree is Degree/3.6888794541139363.

normalize_degree(res, Degree, Degree). 
% WARNING: Check this value! because Measure_max_value is unknown
%  nl, write('WARNING: Normalization is not checked.'), nl.

normalize_degree(jcn, Degree, Degree).
% WARNING: Check this value! because Measure_max_value is unknown
%  nl, write('WARNING: Normalization is not checked.'), nl.

normalize_degree(lin, Degree, Degree).

normalize_degree(yarm, Degree, Degree).

%%% This mesure is not implemented yet and it is not clear what is its 
%%% Measure_max_value
% normalize_degree(lesk, Degree, NormalizedDegree) :- ????.

%%% This mesure is not implemented yet, but it is known that Measure_max_value =16.
%
normalize_degree(hso, Degree, NormalizedDegree):- 
		NormalizedDegree is Degree/16.





