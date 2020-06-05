%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       COMPATIBILITY DEGREE OPERATORS AND FILTERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A range of predicates to manipulate Data Account Lists 


%%%%%%%%%%%
%%% filter_null(L1, L2)
filter_null(L, L).

%%%%%%%%%%%
%%% filter(L1, L2)
%%% Given a Data Account List L1 (as the one produced by the predicate inspect)
%%% this predicate removes from L1 all the elements of the form [texNumber(N)].
%%% That is, all the elements which do not provide Account information.

filter([], []).
filter([[texNumber(_)]|L1], L2) :- filter(L1, L2).
filter([[texNumber(N)|L]|L1], [[texNumber(N)|L]|L2]) :- filter(L1, L2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%
%%% mIn(L1, L2)
%%% Produces a Processed List containing the minimum degree
%%% in the list of the results of the text Number(N).

mIn([], []).
mIn([[texNumber(N)]|L1], [[texNumber(N), 0]|L2]) :- mIn(L1, L2).
mIn([[texNumber(N)|L]|L1], [[texNumber(N), Min]|L2]) :- 
	m_degree(L,Min),
	mIn(L1, L2).

m_degree(L, Min) :- min_element(L, t(_,_,Min)).


%%%%%%%%%%%
%%% filter_MIN(L1, L2)
%%% Filters a Data Account List L1 (as the predicate filter does). Additionally, 
%%% it produces a Processed List. The Processed List contains the minimum element
%%% in the list of the results of the text Number(N).

filter_MIN([], []).
filter_MIN([[texNumber(_)]|L1], L2) :- filter_MIN(L1, L2).
filter_MIN([[texNumber(N)|L]|L1], [[texNumber(N)|[MinE]]|L2]) :- 
	min_element(L,MinE),
	filter_MIN(L1, L2).

%% min_element(L, MinE)
%% The minimum element MinE of the list [t(T1,N1,D1), ..., t(Tn,Nn,Dn)] is:
%% MinE = t(Tk,Nk,Dk) where Dk = Min{D1, ..., Dn}

min_element(L, MinE) :- min_element(L, t(_,_,1), MinE).

min_element([], MinE, MinE).
min_element([t(T,N,D)|L], t(AT,AN,AD), MinE) :- 
		AD < D -> min_element(L, t(AT,AN,AD), MinE);
			  min_element(L, t(T,N,D), MinE). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%
%%% mAx(L1, L2)
%%% Produces a Processed List containing the maximum degree
%%% in the list of the results of the text Number(N).

mAx([], []).
mAx([[texNumber(N)]|L1], [[texNumber(N), 0]|L2]) :- mAx(L1, L2).
mAx([[texNumber(N)|L]|L1], [[texNumber(N)|[Max]]|L2]) :- 
	max_degree(L,Max),
	mAx(L1, L2).
	
max_degree(L, Max) :- max_element(L, t(_,_,Max)).

	
%%%%%%%%%%%
%%% filter_MAX(L1, L2)
%%% Filters a Data Account List L1 (as the predicate filter does). Additionally, 
%%% it produces a Processed List. The Processed List contains the maximum element
%%% in the list of the results of the text Number(N).

filter_MAX([], []).
filter_MAX([[texNumber(_)]|L1], L2) :- filter_MAX(L1, L2).
filter_MAX([[texNumber(N)|L]|L1], [[texNumber(N)|[MaxE]]|L2]) :- 
	max_element(L,MaxE),
	filter_MAX(L1, L2).

%% max_element(L, MaxE)
%% The maximum element MaxE of the list [t(T1,N1,D), ..., t(Tn,Nn,Dn)] is:
%% MaxE = t(Tk,Nk,Dk) where Dk = Max{D1, ..., Dn}

max_element(L, MaxE) :- max_element(L, t(_,_,0), MaxE).

max_element([], MaxE, MaxE).
max_element([t(T,N,D)|L], t(AT,AN,AD), MaxE) :- 
		AD > D -> max_element(L, t(AT,AN,AD), MaxE);
			  max_element(L, t(T,N,D), MaxE). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%
%%% sUm(L1, L2)
%%% Produces a Processed List which contains a sequence of pairs [texNumber(N), WSUM]
%%% where WSUM is the weighted sum of the results in the text Number(N).

sUm([], []).
sUm([[texNumber(N)]|L1], [[texNumber(N), 0]|L2]) :- sUm(L1, L2).
sUm([[texNumber(N)|L]|L1], [[texNumber(N),WSUM]|L2]) :- 
	weighted_sum(L,WSUM),
	sUm(L1, L2).

%%%%%%%%%%%
%%% filter_SUM(L1, L2)
%%% Filters a Data Account List L1 (as the predicate filter does). Additionally, 
%%% it produces a Processed List. The Processed List contains a weighted sum
%%% of the results in the text Number(N).

filter_SUM([], []).
filter_SUM([[texNumber(_)]|L1], L2) :- filter_SUM(L1, L2).
filter_SUM([[texNumber(N)|L]|L1], [[texNumber(N),WSUM]|L2]) :- 
	weighted_sum(L,WSUM),
	filter_SUM(L1, L2).

%% weighted_sum(L, WSUM)
%% The weighted sum WSUM of the list [t(T1,N1,D1), ..., t(Tn,Nn,Dn)] is:
%% WSUM = (N1 * D1 + ... + Nn * Dn) 
weighted_sum(L, WSUM) :- weighted_sum(L, 0, WSUM).

weighted_sum([], WSUM, WSUM).
weighted_sum([t(_,N,D)|L], WSUM_Acc, WSUM) :- 
		N_WSUM_Acc is N*D + WSUM_Acc,
		weighted_sum(L, N_WSUM_Acc, WSUM). 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%
%%% wa(L1, L2)
%%% Produces a Processed List which contains a sequence of pairs [texNumber(N), WAL]
%%% where WAL is the weighted average of the results in the text Number(N).

wa([], []).
wa([[texNumber(N)]|L1], [[texNumber(N)|[0]]|L2]) :- wa(L1, L2).
wa([[texNumber(N)|L]|L1], [[texNumber(N)|[WAL]]|L2]) :- 
	weighted_average(L,WAL),
	wa(L1, L2).

%%%%%%%%%%%
%%% filter_WA(L1, L2)
%%% Filters a Data Account List L1 (as the predicate filter does). Additionally, 
%%% it produces a Processed List. The Processed List contains a weighted average
%%% of the results in the text Number(N).

filter_WA([], []).
filter_WA([[texNumber(_)]|L1], L2) :- filter_WA(L1, L2).
filter_WA([[texNumber(N)|L]|L1], [[texNumber(N)|[WAL]]|L2]) :- 
	weighted_average(L,WAL),
	filter_WA(L1, L2).

%% weighted_average(L, WA)
%% The weighted average WA of the list [t(T1,N1,D1), ..., t(Tn,Nn,Dn)] is:
%% WA = N_WA / D_WA = (N1 * D1 + ... + Nn * Dn) / (N1 + ... + Nn)
weighted_average(L, WA) :- weighted_average(L, 0, 0, N_WA, D_WA), WA is (N_WA/D_WA).

weighted_average([], N_WA, D_WA, N_WA, D_WA).
weighted_average([t(_,N,D)|L], N_WAcc, D_WAcc, N_WA, D_WA) :- 
		NN_WAcc is N*D + N_WAcc,
		ND_WAcc is N + D_WAcc,
		weighted_average(L, NN_WAcc, ND_WAcc, N_WA, D_WA). 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
