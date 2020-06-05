%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       ZIP AUXILIARY PREDICATES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% A number of predicates that mimics the typical zip function of Haskell 
%% which takes two lists and "compresses" them into a single list of pairs.
%% They are defined to compress a specific kind of lists: Data account lists,
%% as the ones returned by the predicate inspect, after they a processed by a 
%% compatibility degree operator. To be specific, lists of the form:
%%
%% [[texNumber(1), TopicK, G1K], [texNumber(2), TopicK, G2K], ...]

%% zips one list (actually no zip)
zip([], []).
zip([[texNumber(N), Topic1, G1]|L1], 
    [[texNumber(N), [Topic1, G1]]|L2]):-
	zip(L1,L2).

%% zips two lists
zip([],[],[]).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), [Topic1, G1], [Topic2, G2]]|L3]):-
	zip(L1,L2,L3).


%% zips three lists
zip([],[],[],[]).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3]]|L4]):-
	zip(L1,L2,L3,L4).


%% zips four lists
zip([],[],[],[], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4]]|L5]):-
	zip(L1,L2,L3,L4,L5).


%% zips five lists
zip([],[],[],[], [], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), Topic5, G5]|L5],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4], [Topic5, G5]]|L6]):-
	zip(L1,L2,L3,L4,L5,L6).


%% zips six lists
zip([],[],[],[], [], [], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), Topic5, G5]|L5],
    [[texNumber(N), Topic6, G6]|L6],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4], [Topic5, G5], [Topic6, G6]]|L7]):-
	zip(L1,L2,L3,L4,L5,L6,L7).


%% zips seven lists
zip([],[],[],[], [], [], [], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), Topic5, G5]|L5],
    [[texNumber(N), Topic6, G6]|L6],
    [[texNumber(N), Topic7, G7]|L7],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4], [Topic5, G5], [Topic6, G6], [Topic7, G7]]|L8]):-
	zip(L1,L2,L3,L4,L5,L6,L7,L8).

%% zips eight lists
zip([],[],[],[], [], [], [], [], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), Topic5, G5]|L5],
    [[texNumber(N), Topic6, G6]|L6],
    [[texNumber(N), Topic7, G7]|L7],
    [[texNumber(N), Topic8, G8]|L8],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4], [Topic5, G5], [Topic6, G6], [Topic7, G7], [Topic8, G8]]|L9]):-
	zip(L1,L2,L3,L4,L5,L6,L7,L8,L9).


%% zips nine lists
zip([],[],[],[], [], [], [], [], [], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), Topic5, G5]|L5],
    [[texNumber(N), Topic6, G6]|L6],
    [[texNumber(N), Topic7, G7]|L7],
    [[texNumber(N), Topic8, G8]|L8],
    [[texNumber(N), Topic9, G9]|L9],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4], [Topic5, G5], [Topic6, G6], [Topic7, G7], [Topic8, G8], [Topic9, G9]]|L10]):-
	zip(L1,L2,L3,L4,L5,L6,L7,L8,L9,L10).



%% zips ten lists
zip([],[],[],[], [], [], [], [], [], [], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), Topic5, G5]|L5],
    [[texNumber(N), Topic6, G6]|L6],
    [[texNumber(N), Topic7, G7]|L7],
    [[texNumber(N), Topic8, G8]|L8],
    [[texNumber(N), Topic9, G9]|L9],
    [[texNumber(N), Topic10, G10]|L10],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4], [Topic5, G5], [Topic6, G6], [Topic7, G7], [Topic8, G8], [Topic9, G9], [Topic10, G10]]|L11]):-
	zip(L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11).



%% zips eleven lists
zip([],[],[],[], [], [], [], [], [], [], [], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), Topic5, G5]|L5],
    [[texNumber(N), Topic6, G6]|L6],
    [[texNumber(N), Topic7, G7]|L7],
    [[texNumber(N), Topic8, G8]|L8],
    [[texNumber(N), Topic9, G9]|L9],
    [[texNumber(N), Topic10, G10]|L10],
    [[texNumber(N), Topic11, G11]|L11],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4], [Topic5, G5], [Topic6, G6], [Topic7, G7], [Topic8, G8], [Topic9, G9], [Topic10, G10], [Topic11, G11]]|L12]):-
	zip(L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12).


%% zips twelve lists
zip([],[],[],[], [], [], [], [], [], [], [], [], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), Topic5, G5]|L5],
    [[texNumber(N), Topic6, G6]|L6],
    [[texNumber(N), Topic7, G7]|L7],
    [[texNumber(N), Topic8, G8]|L8],
    [[texNumber(N), Topic9, G9]|L9],
    [[texNumber(N), Topic10, G10]|L10],
    [[texNumber(N), Topic11, G11]|L11],
    [[texNumber(N), Topic12, G12]|L12],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4], [Topic5, G5], [Topic6, G6], [Topic7, G7], [Topic8, G8], [Topic9, G9], [Topic10, G10], [Topic11, G11], [Topic12, G12]]|L13]):-
	zip(L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13).


%% zips thirteen lists
zip([],[],[],[], [], [], [], [], [], [], [], [], [], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), Topic5, G5]|L5],
    [[texNumber(N), Topic6, G6]|L6],
    [[texNumber(N), Topic7, G7]|L7],
    [[texNumber(N), Topic8, G8]|L8],
    [[texNumber(N), Topic9, G9]|L9],
    [[texNumber(N), Topic10, G10]|L10],
    [[texNumber(N), Topic11, G11]|L11],
    [[texNumber(N), Topic12, G12]|L12],
    [[texNumber(N), Topic13, G13]|L13],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4], [Topic5, G5], [Topic6, G6], [Topic7, G7], [Topic8, G8], [Topic9, G9], [Topic10, G10], [Topic11, G11], [Topic12, G12], [Topic13, G13]]|L14]):-
	zip(L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14).


%% zips fourteen lists
zip([],[],[],[], [], [], [], [], [], [], [], [], [], [], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), Topic5, G5]|L5],
    [[texNumber(N), Topic6, G6]|L6],
    [[texNumber(N), Topic7, G7]|L7],
    [[texNumber(N), Topic8, G8]|L8],
    [[texNumber(N), Topic9, G9]|L9],
    [[texNumber(N), Topic10, G10]|L10],
    [[texNumber(N), Topic11, G11]|L11],
    [[texNumber(N), Topic12, G12]|L12],
    [[texNumber(N), Topic13, G13]|L13],
    [[texNumber(N), Topic14, G14]|L14],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4], [Topic5, G5], [Topic6, G6], [Topic7, G7], [Topic8, G8], [Topic9, G9], [Topic10, G10], [Topic11, G11], [Topic12, G12], [Topic13, G13], [Topic14, G14]]|L15]):-
	zip(L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14,L15).

%% zips fifteen lists
zip([],[],[],[], [], [], [], [], [], [], [], [], [], [], [], []).
zip([[texNumber(N), Topic1, G1]|L1],
    [[texNumber(N), Topic2, G2]|L2],
    [[texNumber(N), Topic3, G3]|L3],
    [[texNumber(N), Topic4, G4]|L4],
    [[texNumber(N), Topic5, G5]|L5],
    [[texNumber(N), Topic6, G6]|L6],
    [[texNumber(N), Topic7, G7]|L7],
    [[texNumber(N), Topic8, G8]|L8],
    [[texNumber(N), Topic9, G9]|L9],
    [[texNumber(N), Topic10, G10]|L10],
    [[texNumber(N), Topic11, G11]|L11],
    [[texNumber(N), Topic12, G12]|L12],
    [[texNumber(N), Topic13, G13]|L13],
    [[texNumber(N), Topic14, G14]|L14],
    [[texNumber(N), Topic15, G15]|L15],
    [[texNumber(N), [Topic1, G1], [Topic2, G2], [Topic3, G3], [Topic4, G4], [Topic5, G5], [Topic6, G6], [Topic7, G7], [Topic8, G8], [Topic9, G9], [Topic10, G10], [Topic11, G11], [Topic12, G12], [Topic13, G13], [Topic14, G14], [Topic15, G15]]|L16]):-
	zip(L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14,L15,L16).

