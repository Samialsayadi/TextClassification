%% TEXT CATALOGING version 2.0: main program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
AUTHOR: Pascual Julian-Iranzo (Universidad de Castilla-La Mancha, Spain)
         Fernando Saenz-Perez  (Universidad Complutense de Madrid, Spain)

This software is licensed for research and educational purposes only and it is
distributed with NO WARRANTY OF ANY KIND. You are freely allowed to use, copy
and distribute WN_CONNECT provided that you make no modifications to any of its
files and give credit to their original authors.
*******************************************************************************/

:- wn_connect.

:- include('cataloging_modules/auxiliary.bpl').

%%%%%%%%%%%%%%%%%%%%%
%%% include modules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% genontology.bpl
:- include('cataloging_modules/genontology_modules/englishPlural.bpl').
:- include('cataloging_modules/genontology_modules/etu.bpl').
:- include('cataloging_modules/genontology.bpl').

%%% inspect.bpl
:- include('cataloging_modules/inspect_modules/cd_operators.bpl').
:- include('cataloging_modules/inspect_modules/zip.bpl').
:- include('cataloging_modules/inspect.bpl').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% welcome_message
%
%     Shows the initial welcome message.
%

welcome_info :-
	nl,
	write('                                                     Universidad de'), nl,
	write('                                                  Castilla - La Mancha'), nl,
	write('[T [E \\X [T - (C /A [T /A [L (O) (G [I [N (G.        (Version 2.0)'), nl,
	write('-----------------------------------------------------------------------------'), nl,
	write('    AUTHOR: '), nl,
	write('             Pascual Julian-Iranzo (Universidad de Castilla-La Mancha, Spain)'), nl,
	nl,
	write('    This software is licensed for research and educational purposes only and'), nl,
	write('    it is distributed with NO WARRANTY OF ANY KIND. You are freely allowed to'), nl, 
	write('    use, copy and distribute it provided that you make no modifications to any'), nl,
	write('    of its files and give credit to its original author.'), nl,
	write('-----------------------------------------------------------------------------'), nl,
	write('-----------------------------------------------------------------------------'), nl,
	write('--    Enter \'info\' to get help on some of the available predicates       --'), nl,
	write('-----------------------------------------------------------------------------'), nl,
	nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% help predicates
%
%     Show information of some of the available predicates.
%

info :-  
     write('-------------------------------------------------------------------------------'), nl,
     write('[ PREDICATE        ][  DESCRIPTION                                            ]'), nl,
     write('-------------------------------------------------------------------------------'), nl,
     write('-------------------------------------------------------------------------------'), nl,
	write('welcome_info:        Writes a welcome message with license information.        '), nl,
	write('-------------------------------------------------------------------------------'), nl,
	write('-------------------------------------------------------------------------------'), nl,
	write('convert_to_singular: Converts a plural word into singular.                     '), nl,
	write('glossList:           Tokenizes the gloss of a word.                            '), nl,
	write('gen_ontology_file:   Generates an ontology file from a list of words. It is    '), nl,
	write('                     stored into a file.                                       '), nl,
	write('-------------------------------------------------------------------------------'), nl,
	write('-------------------------------------------------------------------------------'), nl,
	write('inspect:             inspects a file seeking for words which are similar to a  '), nl,
	write('                     Keyword and generates account information.                '), nl, 
	write('seqInspect:          Like inspect but for a list of Keywords.                  '), nl,
	write('th_catalog:          Produces an automatic classification of a dataset.        '), nl,
	write('experiment:          Compares the automatic classification of the dataset with '), nl,
	write('                     an expert classification and generates statistical data.  '), nl,
	write('-------------------------------------------------------------------------------'), nl,
	write('-------------------------------------------------------------------------------'), nl,
	write('--    Enter \'info(Predicate)\' to obtain more help on this predicate         ---'), nl,
	write('-------------------------------------------------------------------------------'), nl,
	nl.


info(gen_ontology_file):-
write('gen_ontology_file(+ListOfCategories, +File, +Measure):'), nl, 
write('       Given a list of categories, ListOfCategories, the name of a file, File, and the'), nl, 
write('       acronym of a measure, Measure (by now [path, wup, lch, res, lin, jcn, yarm]), it'), nl, 
write('       generates a set of proximity equations and stores them into the file File.'), nl, nl,
write('       EXAMPLE: gen_ontology_file([cat:n:1,lion:n:1], ontFile, wup).'), nl, !.

info(glossList):-
write('glossList(+Word, -Gloss_list): '), nl,
write('       Returns the list of tokens, Gloss_list, of the gloss of the word Word.'), nl, !.

info(convert_to_singular):-
write('convert_to_singular(+ Word, -SWord): '), nl,
write('       Converts a plural word, Word, into a singular word SWord.'), nl, !.

info(inspect):-
write('inspect(+FileName, +Keyword, -DataAccount): '), nl,
write('       Inspects a file, named FileName, seeking for words which are similar to '), nl,
write('       a Keyword. DataAccount is an account record forming a list with the '), nl,
write('       following structure:'), nl,
write('           [[texNumber(1)|L1], [texNumber(2)|L2], . . .]'), nl,
write('       There is a sublist account for each text stored by the file FileName. The list '), nl,
write('       LN is a list of triples t(X,N,D); where X is a term similar to the term Keyword, '), nl,
write('       with degree D, which occurs N times in the text texNumber(N).'), nl,
nl, 
write('       EXAMPLE: inspect(path, \'Files4exps/textos_FP\', wheat, DataAccountList).'), nl, !.

%%%%%%%
info(seqInspect):-
write('seqInspect(+File, +CategoryList, +Process, -ResultList)'), nl,
write('       FileName: File name or path name of a file containing the documents to be'), nl, 
write('       classified (stored in the the SMART standard format).'), nl,
write('       CategoryList: is a list of Terms (the so called categories) to be found'), nl,
write('       Process: A compatibility degree operator (e.g.: sum, wa, mIn, mAx)'), nl,
write('       ResultList: A list of elements of type \'r(Category, CategoryResultList)\','), nl,
write('       where CategoryResultList is a DataAccount List as the one computed by inspect'), nl,
nl,        
write('       EXAMPLE: seqInspect(wup, \'finalexperiments/odp/odp\',[oil:n:3, gas:n:3, '), nl,
write('                  utitily:n:1, electricity:n:2, consulting:v:1, management:n:1, '), nl,
write('                  management:n:2, employment:n:1, employment:n:2, \'fuel cells\':n:1, '), nl,
write('                  association:n:1, association:n:5, hydrogen:n:1], sUm, ResultList).'), nl, !.

%%%%%%%
info(th_catalog):-
write('th_catalog(+Measure, +FileName, +CategoryList, +Process, -TexCatalog): '), nl,
nl, 
write('       PARAMETERS: '), nl,
write('       \'Measure\' can be one of the following constants: [ont, path, wup, lch, res, jcn, jin, yarm]. The'), nl, 
write('       constant \'ont\' means that you want to perform the experimentes using a predefined ontology, that'), nl, 
write('       you must first load before launching the predicate \'experiment/4\'. The other constants are the'), nl, 
write('       acronyms of standard linguistic similarity measures which are computed thanks to the connection to'), nl, 
write('       the Prolog version of the WordNet database. This connection is automatically established by the'), nl, 
write('       cataloging.bpl program (and it does not require uploading an ontology). '), nl,
nl,
write('       \'FileName\' is the file name or path name of a file containing the documents to be classified '), nl,
write('       (stored in the the SMART standard format).'), nl,
nl,
write('       \'CategoryList\' is a list of categories (i.e., the keywords used to classify the texts).'), nl,
nl, 
write('       \'Process\' is a compatibility degree operator (e.g.: sUm, wa, mIn, mAx) used to perform the computation'), nl,
write('       of the compatibility degree between the keywords and the texts to be classified.'), nl, 
nl,
write('       \'TexCatalog\' is the theoretical classification where different keywords are assigned to the documents'), nl,
write('       to be classified. It is a list with the following structure:'), nl,
write('           [[texNumber(1)|ListOfkeywords1], [texNumber(2)|ListOfkeywords2], ...].'), nl, !.


info(experiment):-
nl, 
write('experiment(+Measure, +FileName, +CategoryList, +Process):'), nl,
write('       Performs an experiment comparing the theoretical classification \'TexCatalog\' obtained by the'), nl, 
write('       predicate \'th_catalog\' and the expert classification \'ExpTexCatalog\' associated to the file'), nl,
write('       \'FileName\'. '), nl,
nl,
write('       PARAMETERS:'), nl,
write('       \'Measure\' can be one of the following constants: [ont, path, wup, lch, res, jcn, jin, yarm]. The '), nl,
write('       constant \'ont\' means that you want to perform the experimentes using a predefined ontology, that '), nl,
write('       you must first load before launching the predicate \'experiment/4\'. The other constants are the '), nl,
write('       acronyms of standard linguistic similarity measures which are computed thanks to the connection to '), nl,
write('       the Prolog version of the WordNet database. This connection is automatically established by the '), nl,
write('       cataloging.bpl program (and it does not require uploading an ontology). '), nl,
nl,
write('       \'FileName\' is the file name or path name of a file containing the documents to be classified '), nl,
write('       (stored in the the SMART standard format).'), nl,
nl,
write('       \'CategoryList\' is a list of categories (i.e., the keywords used to classify the texts).'), nl,
nl, 
write('       \'Process\' is a compatibility degree operator (e.g.: sUm, wa, mIn, mAx) used to perform the computation'), nl,
write('       of the compatibility degree between the keywords and the texts to be classified. '), nl,

write('       OUTPUT INFORMATION:'), nl,
write("       Positive:  percentage of positive classifications (In this case, \'Positive\' means that "), nl,
write('                  at least one of the categories assigned by the classifier to a text '), nl,
write('                  is in the set of categories assigned by the expert to that text).'), nl, 
write('       Negative:  percentage of negative classifications; it is a measure of the number'), nl,
write('                  of texts bad classified (Negative means that none of the categories '), nl,
write('                  assigned by the classifier to a text match the expert classification).'), nl,
write('       Undefined: percentage of texts not classified by the classification procedure.'), nl,
nl, 
write('       [OBSERVATION: when computing Positive, Negative, and Undefined, the percentage is w.r.t. '), nl,
write('                    the total number of texts to be classified.]'), nl,

nl, 
write('       Precision: percentage of total positive classifications w.r.t. the total of classifications '), nl,
write('                  performed by the classifier method. In this case \'positive classification\' means'), nl,
write('                  a classification where the classifier and the expert judgement coincides.'), nl,
write('       Recall:   percentage of total positive classifications w.r.t. the total of classifications '), nl,
write('                 performed by the expert classifier.'), nl,
write('       Fmeasure: the harmonic mean between precision and recall.'), nl,
nl, 
write('       EXAMPLE: experiment(ont, \'Files4exps/odp/odp\',[oil:n:3, gas:n:3, utitily:n:1, electricity:n:2, '), nl,
write('                management:n:1, management:n:2, employment:n:1, employment:n:2, \'fuel cells\':n:1, '), nl,
write('                consulting:v:1, association:n:1, association:n:5, hydrogen:n:1], sUm).'), nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%:- welcome_info. %% it does not work in BPL



