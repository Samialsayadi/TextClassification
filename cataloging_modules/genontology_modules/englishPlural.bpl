

%%% Irregular Plural Forms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
convert_to_singular(men, man):- !.
convert_to_singular(women, woman):- !.
convert_to_singular(children, child):- !.
convert_to_singular(mice, mouse):- !.
convert_to_singular(teeth, tooth):- !.
convert_to_singular(geese, goose):- !.
convert_to_singular(feet, foot):- !.
convert_to_singular(oxen, ox):- !.
convert_to_singular(fish, fish):- !.
convert_to_singular(sheep, sheep):- !.
convert_to_singular(barracks, barracks):- !.
convert_to_singular(people, person):- !.
convert_to_singular(lice, louse):- !.

%%%%%%%%	
%% Other irregular plural (foreign nouns)
%%
convert_to_singular(algae, alga):- !.
convert_to_singular(amoebae, amoeba):- !.	 %% Foreign plural
convert_to_singular(amoebas, amoeba):- !. %% English plural	
convert_to_singular(antennae, antenna):- !. %% Foreign plural
convert_to_singular(antennas, antenna):- !. %% English plural
convert_to_singular(formulae, formula):- !. %% Foreign plural
convert_to_singular(formulas, formula):- !. %% English plural
convert_to_singular(larvae, larva):- !.	
convert_to_singular(nebulae, nebula):- !. %% Foreign plural
convert_to_singular(nebulas, nebula):- !.	
convert_to_singular(vertebrae, vertebra):- !. %% English plural
%%
convert_to_singular(dogmata, dogma):- !.

%%%%%%%%	
%%% Nouns ending in "us" get "a", "i" or the "s" of the English plural:
%%
convert_to_singular(opera, opus):- !. %% Foreign plural
convert_to_singular(corpora, corpus):- !. %% Foreign plural
convert_to_singular(genera, genus):- !.
convert_to_singular(alumni, alumnus):- !.
convert_to_singular(bacilli, bacillus):- !.
%%	
convert_to_singular(cacti, cactus):- !.
convert_to_singular(cactuses, cactus):- !. %% English plural
convert_to_singular(foci, focus):- !.
convert_to_singular(fungi, fungus):- !. %% Foreign plural
convert_to_singular(funguses, fungus):- !. %% English plural
convert_to_singular(nuclei, nucleus):- !.
convert_to_singular(octopi, octopus):- !.	 %% Foreign plural
convert_to_singular(octopuses, octopus):- !. %% English plural
convert_to_singular(radii, radius):- !.
convert_to_singular(stimuli, stimulus):- !.
convert_to_singular(syllabi, syllabus):- !. %% Foreign plural
convert_to_singular(syllabuses, syllabus):- !. %% English plural
convert_to_singular(termini, terminus):- !.
%%
%% other exceptions
convert_to_singular(geniuses, genius):- !. % very intelligent person
convert_to_singular(genii, genius):- !. % supernatural being
convert_to_singular(tempi, tempo):- !.
convert_to_singular(graffiti, graffito):- !.
convert_to_singular(foramina, foramen):- !.


%%%%%%%%	
%%% Nouns ending in "um" get "a", "i" or the "s" of the English plural:
%%
convert_to_singular(addenda, addendum):- !.
convert_to_singular(bacteria, bacterium):- !.
convert_to_singular(curricula, curriculum):- !. %% Foreign plural
convert_to_singular(curriculums, curriculum):- !. %% English plural
convert_to_singular(data, datum):- !.
convert_to_singular(errata, erratum):- !.
convert_to_singular(media, medium):- !.
convert_to_singular(memoranda, memorandum):- !. %% Foreign plural
convert_to_singular(memorandums, memorandum):- !. %% English plural
convert_to_singular(ova, ovum):- !.
convert_to_singular(strata, stratum):- !.
convert_to_singular(symposia, symposium):- !. %% Foreign plural
convert_to_singular(symposiums, symposium):- !. %% English plural

%%%%%%%%	
%%% Nouns ending in "ex" or "ix" get "ices" or get the "s" of the English plural:
%%
convert_to_singular(apices, apex):- !. %% Foreign plural
convert_to_singular(apexes, apex):- !. %% English plural
convert_to_singular(appendices, appendix):- !. %% Foreign plural
convert_to_singular(appendixes, appendix):- !. %% English plural % a medical term
convert_to_singular(cervices, cervix):- !.
convert_to_singular(cervixes, cervix):- !.
convert_to_singular(indices, index):- !. % a mathematical term
convert_to_singular(indexes, index):- !.
convert_to_singular(matrices, matrix):- !.
convert_to_singular(matrixes, matrix):- !.
%
convert_to_singular(vortices, vortex):- !.
%
convert_to_singular(codices, codex):- !.

%%%%%%%%%
%%
convert_to_singular(series, series):- !.
convert_to_singular(species, species):- !.
convert_to_singular(police, police):- !.
convert_to_singular(clothes, clothes):- !.
%%
%% garments consisting of two parts.
%%
convert_to_singular(pyjamas, pyjamas):- !.
convert_to_singular(trousers, trousers):- !.
convert_to_singular(breeches, breeches):- !.
convert_to_singular(pants, pants):- !.
%%
%%% instruments consisting of two parts.
%%
convert_to_singular(eyeglasses, eyeglasses):- !.
convert_to_singular(binoculars, binoculars):- !.
convert_to_singular(spectacles, spectacles):- !.
convert_to_singular(pliers, pliers):- !.
convert_to_singular(shears, shears):- !.
convert_to_singular(scissors, scissors):- !.
convert_to_singular(scales, scales):- !.
%%
%%% Some nouns never take the s of the plural and are always singular:
%%
convert_to_singular(advice, advice):- !.
convert_to_singular(baggage, baggage):- !.
convert_to_singular(luggage, luggage):- !.
convert_to_singular(furniture, furniture):- !.
convert_to_singular(information, information):- !.
convert_to_singular(knowledge, knowledge):- !.
convert_to_singular(rubbish, rubbish):- !.
%%%%

%%%%%%%%	
%%% Nouns that are always singular:
%% A handful of nouns appear to be plural in form but (may) take a singular verb:
%%
convert_to_singular(news, news):- !.
%%
%%% nouns ending in "ics" (example: gymnastics-> gymnastics)
%% are treated by the rule below 
%%
convert_to_singular(PWord, PWord) :-
    atom_chars(PWord, L), append(_, [i, c, s], L), !.


%%%%%%%%%
%%% 1.4. Nouns ending in -f or -fe
%% 1.4.1. Add -s: Plurals ending in "fs" and "fes" will be treated by 
%% the general case (see last clause), except:
%%
convert_to_singular(safes, safe):- !.

%% 1.4.2. Substitute with -ves
%% Only twelve nouns ending "f" or "fe" drop the "f" or "fe" and add "ves"
%%
convert_to_singular(shelves, shelf):- !.
convert_to_singular(thieves, thief):- !.
convert_to_singular(wives, wife):- !.
convert_to_singular(wolves, wolf):- !.
convert_to_singular(calves, calf):- !.
convert_to_singular(halves, half):- !.
convert_to_singular(knives, knife):- !.
convert_to_singular(leaves, leaf):- !.
convert_to_singular(lives, life):- !.
convert_to_singular(loaves, loaf):- !.
convert_to_singular(selves, self):- !.
convert_to_singular(sheaves, sheaf):- !.

%% Both forms are possible with the following nous:
%%
convert_to_singular(scarfs, scarf):- !.
convert_to_singular(scarves, scarf):- !.
convert_to_singular(hoofs, hoof):- !.
convert_to_singular(hooves, hoof):- !.
convert_to_singular(wharfs, wharf):- !.
convert_to_singular(wharves, wharf):- !.

%%%%%%%%%
%%% Specific cases for (1.3): Nouns ending in "y"
%% There are two forms of the plural of the word penny:
%%
convert_to_singular(pence, penny):- !.   %% refered to the price
convert_to_singular(pennies, penny):- !. %% refered to the single coins


%%%%%%%%%
%%% Specific cases for (1.2): Nouns ending in sibilants ("s", "ss", "sh", 
%%  "ch", "x", or "z")
%% exceptions (to remedy problems with sibilant words & plural words ending "es")
%%
convert_to_singular(menses, menses):-!.

%%% This specific case is necessary because the word "ax" exists.
%%
convert_to_singular(axes, axis):-!.

%% In some cases, singular nouns ending in -s or -z, require that you double 
%% the -s or -z prior to adding the -es for pluralization.
%%
convert_to_singular(fezzes, fez):- !.
convert_to_singular(gasses, gas):-!.
%%%%%%%%%

%%% Specific case: Nouns ending in "is" becoming "es" in plural:
%%
convert_to_singular(irides, iris):- !.
%%%%%%%%%



%%% GENERAL RULES FOR TRANSFORMING PLURALS INTO SINGULARS
%%%%%%%%%
%%% Nouns ending in "eau" get "x" or the "s" of the English plural
%% example: plateau-> plateaux
%% "plateaus" is possible but it is treated by the general case (see below)
%%
convert_to_singular(PWord, SWord) :-
    atom_chars(PWord, L), append(Stem, [e, a, u, x], L),
    append(Stem, [e, a, u], SL), atom_chars(SWord, SL), !.

%%%%%%%%%
%%% Nouns ending in "on" becoming "a":
%% example: automaton-> automata
%%
convert_to_singular(PWord, SWord) :-
    atom_chars(PWord, L), append(Stem, [a], L),
    append(Stem, [o,n], SL), atom_chars(SWord, SL), in_wordnet(SWord), !.


%%%%%%%%%
%% 1.5. Nouns ending in "o" add "s" or "es"
%%
%% 1.5.1. Add -s: words of foreign origen or abbreviated words
%% example: a photo	two photos
%%
convert_to_singular(PWord, SWord) :-
    atom_chars(PWord, L), append(Stem, [o,s], L),
    append(Stem, [o], SL), atom_chars(SWord, SL), !.

%% 1.5.2. Add -es
%%
convert_to_singular(PWord, SWord) :-
    atom_chars(PWord, L), append(Stem, [o,e,s], L),
    append(Stem, [o], SL), atom_chars(SWord, SL), !.


%%%%%%%%%
%%% 1.3. Nouns ending in "y"
%% 1.3.1. "y" after consonant ==> Change "y" to "i", then add "es".
%%
convert_to_singular(PWord, SWord) :-
    atom_chars(PWord, L), append(Prefix, [C, i, e, s], L), is_constant(C),
    append(Prefix, [C,y], SL), atom_chars(SWord, SL), in_wordnet(SWord), !.


%% 1.3.2. "y" after vowel ==> Add "s" after a vowel.
%%% ERASED BECAUSE IT CAN BE TREATED BY THE GENERAL CASE.
% convert_to_singular(PWord, SWord) :-
%    atom_chars(PWord, L), append(Prefix, [V, y, s], L), is_vowel(V)),
%    append(Prefix, [V,y], SL), atom_chars(SWord, SL), in_wordnet(SWord), !.


%%%%%%%%%
%%% 1.2. Nouns ending in sibilants ("s", "ss", "sh", "ch", "x", or "z")
%%  Add -es. Add -s if the noun ends in one -e (treated as the general case).
%%
convert_to_singular(PWord, SWord) :-
    atom_chars(PWord, L), append(Stem, [e, s], L),
    append(_, Ending, Stem), sibilant(Ending),
    atom_chars(SWord, Stem), in_wordnet(SWord), !.

%%%%%%%%%%%%%%%%


%%% Nouns ending in "is" becoming "es" in plural:
%%
convert_to_singular(PWord, SWord) :-
	atom_chars(PWord, L), append(Stem, [e, s], L),
	append(Stem, [i,s], SL), atom_chars(SWord, SL), in_wordnet(SWord),!.
%%%%%%%%%%%%%%%%

%%% GENERAL CASE %%%%%%%%%%%%%%%%
%%% 1.1. To make regular nouns plural, add -s to the end.
%%
convert_to_singular(PWord, SWord) :-
	atom_chars(PWord, L), append(SL, [s], L),
    atom_chars(SWord, SL), in_wordnet(SWord),!.

%%% the initial word was in singular form or it is impossible
%%% to recover its singular form.
convert_to_singular(SWord, SWord):-
    (in_wordnet(SWord) ->
        true
        ;
        write('"'), write(SWord), write('"'), writeln(" is not in WordNet.")
    ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% AUXILIARY PREDICATES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

is_letter(Letter):-
    member(Letter, ['A', a, 'B', b, 'C', c, 'D', d, 'E', e, 'F', f, 'G', g, 'H', h, 'I', i, 'J', j, 'K', k, 'L', l, 'M', m, 'N', n, 'O', o, 'P', p, 'Q', q, 'R', r, 'S', s, 'T', t, 'U', u, 'V', v, 'W', w, 'X', x, 'Y', y, 'Z', z]).

is_constant(Constant):-
    member(Constant, ['B', b, 'C', c, 'D', d, 'F', f, 'G', g, 'H', h, 'J', j, 'K', k, 'L', l, 'M', m, 'N', n, 'P', p, 'Q', q, 'R', r, 'S', s, 'T', t, 'V', v, 'W', w, 'X', x, 'Y', y, 'Z', z]).
is_vowel(Vowel):-
    member(Vowel, ['A', a, 'E', e, 'I', i, 'O', o, 'U', u]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% sibilant(?Ending)
%%% Checks if a word ends in a sibilant. That is: "s", "ss", "sh", "ch", "x", or "z".
sibilant([s]). 
sibilant([s,s]).
sibilant([s,h]).
sibilant([c,h]).
sibilant([x]). 
sibilant([z]).

