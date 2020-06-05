%%:-wn_connect.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       ONTOLOGIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Place here the ontology you are going to use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%:- include('inspect_modules/auxiliary.bpl').
:- include('inspect_modules/cd_operators.bpl').
:- include('inspect_modules/zip.bpl').



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       MAIN PREDICATES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% inspect(+FileName, +Keyword, -DataAccount), 
%% inspects a file, named FileName seeking for words which are similar to 
%% a Keyword. DataAccount is an account record forming a list with the
%% following structure:
%%    [[texNumber(1)|L1], [texNumber(2)|L2], ...]
%% There is a sublist account for each text stored by the file FileName. The list 
%% LN is a list of triples t(X,N,D); where X is a term similar to the term Keyword, 
%% with degree D, which occurs N times in the text texNumber(N).

inspect(Measure, FileName, Keyword, DataAccount) :- 
	seeing(OLD), 
	see(FileName),
	write('Processing file, '), write(FileName), 
	write(', for category: '), write(Keyword), 
	write('.  This may take a while ...'), nl, 
	processFile(Measure, Keyword, DataAccount),
	seen,
	see(OLD).



%%%%%%%%%%%
%% processFile(+Keyword, -DataAccount)

processFile(Measure, Keyword, DataAccount) :- processDocs(Measure, Keyword, [], DataAccount).

%%% processDocs(+Keyword, +AccAccount, -DataAccount)
%%% Reads a word and if it is a Document Identifier Delimiter (".I"), reads an 
%%% other word to check the number of the text which is going to be processed.
%%% Once these preliminary tasks are completed, it passes the control to the
%%% predicate "processText".
%%%
processDocs(Measure, Keyword, AccAccount, DataAccount):- 
	read_word(Word,EOF),
	(EOF == false -> 
	   (isDocIdentifierDelimiter(Word) ->
		read_word(Word2,EOF2),
		(EOF2 == false -> 
			name(N, Word2),
			(integer(N) -> 
			 	(processText(Measure, Keyword, AccAccount, [TextAccount|AccAccount], EOF3),
			 	 processRemainderDocs(Measure, Keyword, [[texNumber(N)|TextAccount]|AccAccount], EOF3, DataAccount)
			 	);
			 	write('This file does not conform the SMART standards.'), nl,
			 	DataAccount= [['ERROR']|AccAccount]
			);
	   		write('End of file reached.'), nl,
	   		DataAccount= AccAccount 
		);
		write('This file does not conform the SMART standards.'), nl,
		DataAccount= [['ERROR']|AccAccount]
	   );
	   write('End of file reached.'), nl,
	   DataAccount= AccAccount 
	).




%%%%%%%%%%%
%% processRemainderDocs(+Keyword, +AccAccount, +EOF, -DataAccount)
%%% Continues processing Docs as the predicate "processDocs"
	
processRemainderDocs(Measure, Keyword, AccAccount, EOF, DataAccount):-
	(EOF == false -> 
		read_word(Word2,EOF2),
		(EOF2 == false -> 
			name(N, Word2),
			(integer(N) -> 
			 	(processText(Measure, Keyword, AccAccount, [TextAccount|AccAccount], EOF3),
			 	 processRemainderDocs(Measure, Keyword, [[texNumber(N)|TextAccount]|AccAccount], EOF3, DataAccount)
			 	);
			 	write('This file does not conform the SMART standards.'), nl,
				DataAccount = AccAccount
			);
			write('This file does not conform the SMART standards.'), nl,
			DataAccount = AccAccount
		);
		write('End of file reached.'), nl,
		DataAccount = AccAccount
	).




%%%%%%%%%%%
%% processText(+Keyword, +AccAccount, -NewAccAccount, -EOF)
%%% Reads a word and if it is a Text Identifier Delimiter (".W"), 
%%% it passes the control to the predicate "processRemainderText".
%%%

processText(Measure, Keyword, AccAccount, NewAccAccount, EOF) :-
	read_word(Word1,EOF1),
	(EOF1 = false ->
		(isTextDelimiter(Word1) ->
			processRemainderText(Measure, Keyword, [], TextAccount, EOF2),
			NewAccAccount = [TextAccount|AccAccount], EOF = EOF2;
			write('This file does not conform the SMART standards.'), nl,
			NewAccAccount = [['ERROR']|AccAccount], EOF = EOF1	
		);
		write('End of file reached.'), nl,
		NewAccAccount = AccAccount, EOF = EOF1
	).



%%%%%%%%%%%
%% processRemainderText(+Keyword, +TextAccAccount, -TextAccount, -EOF)
%%% Reads word by word until it finds an EOF or a Document Identifier 
%%% Delimiter (".I"). 
%%%
%%% If the word is NOT an EOF or a Document Identifier Delimiter, it checks if  
%%% it is similar to the "Keyword" (a pre-established category that may be 
%%% assigned to the document being processed) with a certain degree AD.
%%% If this is the case the information "t(Word1name,1,AD)" that a word in the
%%% text has been found is introduced into the accumulator text account list
%%% continuing the process of remainder text recursively.
%%% Else, continuing the process of remainder text.
%%%
%%% If the word IS an EOF or a Document Identifier Delimiter the process terminates
%%% returning the accumulator text account list (through the parameter "TextAccount")
%%% and EOF.
%%%
%%% OBSERVE that words are read as code list and have to be converted into atoms
%%% using the predicate: name(?Atomic, ?CodeList).

processRemainderText(Measure, Keyword, TextAccAccount, TextAccount, EOF) :-
	read_word(Word1,EOF1),
	name(Word1name, Word1), 
	(EOF1 = false ->
		(isDocIdentifierDelimiter(Word1) ->
			TextAccount = TextAccAccount, 
			EOF = EOF1;
%%%			(Keyword ~ Word1name = AD ->
			(similarToWith(Measure, Keyword, Word1name, AD) ->
				(insert(t(Word1name,1,AD), TextAccAccount, NewTextAccAccount),
				processRemainderText(Measure, Keyword, NewTextAccAccount, TextAccount, EOF)
				);
				processRemainderText(Measure, Keyword, TextAccAccount, TextAccount, EOF)
			)
		);
		TextAccount = TextAccAccount, EOF = EOF1
	).



%%%%%%%%%%%
%%% insert(+E, +L1, -L2), 
%%% inserts an element E=t(T,N1,D) in the list L1 to obtain L2.
%%% If t(T,N2,D) is a member of L2 it updates N2 to a new value N1+N2

insert(t(T,N,D), [], [t(T,N,D)]).
insert(t(T1,N1,D), [t(T2,N2,_)|R], [t(T1,N,D)|R]) :- T1 == T2, N is N1+N2. 
insert(t(T1,N1,D), [t(T2,N2,D2)|R2], [t(T2,N2,D2)|R]) :- T1 \== T2, insert(t(T1,N1,D), R2, R). 




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% seqInspect(+File, +CategoryList, +Process, -ResultList)
%%%
%%% "FileName": File name or path name of a file containing the documents to be 
%%% classified (stored in the the SMART standard format).
%%% "CategoryList": is a list of Terms (the so called categories) to be found
%%% "Process": A compatibility degree operator (e.g.: sum, wa, mIn, mAx)
%%% "ResultList" is a list of elements of type "r(Category, CategoryResultList)"
%%%  where CategoryResultList is DataAccount List as the one computed by inspect
%%%
seqInspect(_Measure, _,[],_,[]).
seqInspect(Measure, File, [Category|Remainder_CategoryList], Process, [r(Category, CategoryResultList)|Remainder_ResultList]) :-
	inspect(Measure, File, Category, DataAccountList), applyTo(Process, [DataAccountList, CategoryResultList]),
	seqInspect(Measure, File, Remainder_CategoryList, Process,  Remainder_ResultList).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ZIP RESULTs AND CLASSIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% rewriteResultList(ResultList, RwRList)

rewriteResultList([], []).
rewriteResultList([r(Topic,List)|ResultList], [TopicList|RwRList]) :- 
	insertTopic_intoList(List, Topic, TopicList), 
	rewriteResultList(ResultList, RwRList).

insertTopic_intoList([], _, []).
insertTopic_intoList([[texNumber(N), G]|List], Topic, [[texNumber(N), Topic, G]|TopicList]):-
	insertTopic_intoList(List, Topic, TopicList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% zipResultList(ResultList, ZipList)
zipResultList(ResultList, ZipList) :-
	rewriteResultList(ResultList, RwRList),
	append(RwRList, [ZipList], Args),
	applyTo(zip,Args).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% classify(ZipList, ClassifiedList)

classify([], []).
classify([[texNumber(N)|Topics_forText]|ZipList], [[texNumber(N)|WinnersTopics_forText]|ClassifiedList]) :-
	select_winners(Topics_forText, WinnersTopics_forText),
	classify(ZipList, ClassifiedList).


%%%%%%%%%%%%%
%%% select_winners(Topics_forText, WinnersTopics_forText)
%
select_winners(Topics_forText, WinnersTopics_forText) :- 
		selectMax(Topics_forText, High),
		Low is High - (High * 0.1),
		select_winners(Topics_forText, Low, High, [], WinnersTopics_forText).

%%% selectMax(Topics_forText, Max)
%
selectMax(Topics_forText, Max) :- selectMax(Topics_forText, 0, Max).

selectMax([], Max, Max).
selectMax([[_, G]|Topics_forText], Acc_Max, Max) :-
	((G > Acc_Max) ->
		selectMax(Topics_forText, G, Max)
		;
		selectMax(Topics_forText, Acc_Max, Max)
	).


%%% select_winners(Topics_forText, Low, High, Acc_WinnersTopics_forText, WinnersTopics_forText)
%
select_winners([], _, _, WinnersTopics_forText, WinnersTopics_forText).
select_winners([[Topic, G]|Topics_forText], Low, High, Acc_WinnersTopics_forText, WinnersTopics_forText) :-
	((Low =< G, G =< High) ->
		select_winners(Topics_forText, Low, High, [Topic|Acc_WinnersTopics_forText], WinnersTopics_forText)
		;
		select_winners(Topics_forText, Low, High, Acc_WinnersTopics_forText, WinnersTopics_forText)
     ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% compare(+TexCatalog, +ExpTexCatalog, -Positive, -Negative, -Undefined, -Precision, -Recall, -Fmeasure)
%% 
%% Comparison of the theoretical classification "TexCatalog" obtained by the predicate  
%% "th_catalog" and the expert classification "ExpTexCatalog".
%%
%% Positive: percentage of positive classifications (In this case, 'positive' means that,
%%           at least one of the categories assigned by the classifier to a text 
%%           is in the set of categories assigned by the expert to that text). 
%% Negative: percentage of negative classifications; it is a measure of the number
%%           of texts bad classified (Negative means that, none of the categories 
%%           assigned by the classifier to a text match the expert classification).
%% Undefined: percentage of texts not classified by the classification procedure.
%%
%% OBSERVATION: when computing Positive, Negative, and Undefined, the percentage is w.r.t. 
%%              the total number of texts to be classified.
%%%%%%%%%%%%%%%%%%%
%%
%% Precision: percentage of total positive classifications w.r.t. the total of classifications 
%%            performed by the classifier method. In this case 'positive classification' means
%%            a classification where the classifier and the expert judgement coincides.
%% Recall:   percentage of total positive classifications w.r.t. the total of classifications 
%%           performed by the expert classifier.
%% Fmeasure: the harmonic mean between precision and recall.
%%

compare(TexCatalog, ExpTexCatalog, Positive, Negative, Undefined, Precision, Recall, Fmeasure) :-
	compare(TexCatalog, ExpTexCatalog, 0, 0, 0, 0, 0, 0, Pos, Neg, Undef, TTexC, TExpTexC, TPos),
	length(TexCatalog, N),
	Positive is (Pos / N) * 100,
	Negative is (Neg / N) * 100,
	Undefined is (Undef / N) * 100,
	UnitPrecision is TPos / TTexC,
	Precision is UnitPrecision * 100,
	UnitRecall is TPos / TExpTexC,
	Recall is UnitRecall * 100,
	Fmeasure is ((2 * UnitPrecision * UnitRecall) / (UnitPrecision + UnitRecall)) * 100.
	
%% compare(TexCatalog, ExpTexCatalog, Positive_Acc, Negative_Acc, Undefined_Acc, Total_TexClassif_Acc, Total_ExpTexClassif_Acc, Total_Positive_Acc, Positive, Negative, Undefined, Total_TexClassif, Total_ExpTexClassif, Total_Positive)

compare([], [], P, N, U, TC, TE, TP, P, N, U, TC, TE, TP).	
compare([[texNumber(N1)|L1]|TexCatalog], [[texNumber(N2)|L2]|ExpTexCatalog], P_Acc, N_Acc, U_Acc, TC_Acc, TE_Acc, TP_Acc, P, N, U, TC, TE, TP) :-
	(N1 =\= N2 -> write('It is not possible to compare files with text number '), 
	              write(N1), write(' and text number '), write(N2), nl,
	              fail;
	              true),
	length(L2,LL2),
	(L1 = [] -> (PP_Acc = P_Acc, NN_Acc = N_Acc, UU_Acc is U_Acc + 1, 
                TCC_Acc = TC_Acc, TEE_Acc is TE_Acc + LL2, TPP_Acc = TP_Acc);
			   length(L1,LL1),
			   matchPositive(L1, L2,CP),
			   ( CP =:= 0 -> 
					PP_Acc = P_Acc, NN_Acc is N_Acc + 1, UU_Acc = U_Acc,
					TCC_Acc is TC_Acc + LL1, TEE_Acc is TE_Acc + LL2, TPP_Acc = TP_Acc;
					PP_Acc is P_Acc +1, NN_Acc = N_Acc, UU_Acc = U_Acc,
					TCC_Acc is TC_Acc + LL1, TEE_Acc is TE_Acc + LL2, TPP_Acc is TP_Acc + CP
			   )	  
	),
	compare(TexCatalog, ExpTexCatalog, PP_Acc, NN_Acc, UU_Acc, TCC_Acc, TEE_Acc, TPP_Acc, P, N, U, TC, TE, TP).


%% matchPositive(Catalog, ExpCatalog, Tot_Pos)
%% matchPositive(input, input, output)
%% Given a text, Tot_Pos is the total number of positive catalogations, that is,
%% the number of categories in the Catalog provided by the text classifier which
%% are in the Catalog provided by the Expert.
matchPositive([], _, 0).
matchPositive([X|Resto], ExpCatalog, Tot_Pos) :- 
					member(X, ExpCatalog) -> 
						matchPositive(Resto, ExpCatalog, Tot_Pos_2),
                     			Tot_Pos is Tot_Pos_2 + 1;
                     			matchPositive(Resto, ExpCatalog, Tot_Pos).



%% compareW(TexCatalog, ExpTexCatalog), compares and Writes the classification results
compareW(TexCatalog, ExpTexCatalog) :-
	compare(TexCatalog, ExpTexCatalog, 0, 0, 0, 0, 0, 0, Pos, Neg, Undef, TTexC, TExpTexC, TPos),
	write('.............................................................................'), nl,
	write('............ ABSOLUTE RESULTS ...............................................'), nl,
	write(' Positive classifications:       '), write(Pos), nl,
	write(' Negative classifications:       '), write(Neg), nl,
	write(' Undefined classifications:      '), write(Undef), nl,
	write(' Total classifications:          '), write(TTexC), nl,
	write(' Total Expert classifications:   '), write(TExpTexC), nl,
	write(' Total positive classifications: '), write(TPos), nl,
	write('.............................................................................'), nl,
	length(TexCatalog, N), %%write("length TexCatalog: "), write(N), nl,
	Positive is (Pos / N) * 100, %%write("Positive x100: "), write(Positive), nl,
	Negative is (Neg / N) * 100, %%write("Negative x100: "), write(Negative), nl,
	Undefined is (Undef / N) * 100, %%write("Undefined x100: "), write(Undefined), nl,
	UnitPrecision is TPos / TTexC, %%write("UnitPrecision : "), write(UnitPrecision), nl,
	Precision is UnitPrecision * 100,  %%write("Precision x100: "), write(Precision), nl,
	UnitRecall is TPos / TExpTexC,  %%write("UnitRecall : "), write(UnitRecall), nl,
	Recall is UnitRecall * 100, %%write("Recall x100: "), write(Recall), nl,
	(0 is (UnitPrecision + UnitRecall) ->
		write("Zero UnitPrecision and UnitRecall. Unable to compute Fmeasure."), nl
		;
		Fmeasure is ((2 * UnitPrecision * UnitRecall) / (UnitPrecision + UnitRecall)) * 100 %%,
		%%write("Fmeasure x100: "), write(Fmeasure), nl
	),
	write('............ PERCENT RESULTS ................................................'), nl,
	write(' Positive classifications (w.r.t. the total num. of documents): '), write(Positive), nl,
	write(' Negative classifications (w.r.t. the total num. of documents): '), write(Negative), nl,
	write(' Undefined classifications (w.r.t. the total num. of documents): '), write(Undefined), nl,
	write(' Precision (w.r.t. the set of categories): '), write(Precision), nl,
	write(' Recall (w.r.t. the set of categories):    '), write(Recall), nl,
	write(' F measure:                              '), write(Fmeasure), nl,
	write('.............................................................................'), nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PUTTING IT ALL TOGETHER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% th_catalog(+Measure, +File, +CategoryList, +Process, -TexCatalog)
th_catalog(Measure, File, CategoryList, Process, TexCatalog) :- 
	seqInspect(Measure, File, CategoryList, Process, ResultList), 
	zipResultList(ResultList, ZipList), 
	classify(ZipList, TexCatalog).

experiment(Measure, FileName, CategoryList, Process, Positive, Negative, Undefined, Precision, Recall, Fmeasure):-
	th_catalog(Measure, FileName, CategoryList, Process, TexCatalog),
%	concat_atom([FileName,'.',exp], FileName_exp),
	atomic_list_concat([FileName,exp], '.', FileName_exp),
	see(FileName_exp),
	write('Reading file, '), write(FileName_exp), 
	write(' with an expert classification...'), nl, 
	read(ExpTexCatalog),
	seen,
	compare(TexCatalog, ExpTexCatalog, Positive, Negative, Undefined, Precision, Recall, Fmeasure).

experiment(Measure, FileName, CategoryList, Process):-
	th_catalog(Measure, FileName, CategoryList, Process, TexCatalog),
%	concat_atom([FileName,'.',exp], FileName_exp),
	atomic_list_concat([FileName,exp], '.', FileName_exp),
	see(FileName_exp),
	write('Reading file, '), write(FileName_exp), 
	write(' with an expert classification...'), nl, 
	read(ExpTexCatalog),
	seen,
	compareW(TexCatalog, ExpTexCatalog).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       GOAL (Examples)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% How to use some useful predicates: inspect/3 and seqInspect/4
i(Result) :- inspect('Files4exps/textos_FP3', corn, L), filter(L, Result).

si(ResultList):- seqInspect('Files4exps/textos_FP3', [wheat,sugar,rice,cotton,cooper,lead], sUm, ResultList).


exp(FileName):-
	experiment(FileName, [wheat,sugar,rice,cotton,cooper,lead], sUm).

exp1(FileName):-
	experiment(FileName, [wheat,sugar,rice,cotton,cooper,lead], wa).

exp2(FileName):-
	experiment(FileName, [wheat,sugar,rice,cotton,cooper,lead], mAx).

exp3(FileName):-
	experiment(FileName, [wheat,sugar,rice,cotton,cooper,lead], mIn).


%% How to obtain execution statistics:
goal(Goal) :- stat_start(I), call(Goal), stat_end(I).

g :- goal(exp('Files4exps/textos_FP3')).



