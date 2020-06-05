#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar  6 15:43:54 2020

@author: samialsayadi
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar  6 12:25:09 2020

@author: samialsayadi
"""

#from pattern.en import wordnet  
from nltk.tokenize import word_tokenize
from pattern.text.en import singularize
from pattern.en import tenses, PAST, PL
from nltk.stem.wordnet import WordNetLemmatizer
from nltk.corpus import wordnet as wn  
from nltk.corpus import stopwords
from sklearn.metrics.pairwise import cosine_similarity



from sematch.semantic.similarity import WordNetSimilarity
wns = WordNetSimilarity()

#stop_words = set(stopwords.words('english'))
Lem = WordNetLemmatizer()

def getEnglishStopWords():
        '''
        returns a set of stop words for NLP pre-processing
        from nltk.corpus.stopwords()
        Also, some words and letters are added to the set,
        such as "please", "sincerely", "u", etc...
        '''
        stop_words = set(stopwords.words("english"))
        
        stop_words.add('please')
        for item in 'abcdefghijklmnopqrstuvwxyz':
            stop_words.add(item)
        return stop_words


data = open("reuters10_gloss_path.ont","w")
#list1=['associations', 'consulting', 'electricity', 'employment','fuel', 'hydrogen', 'management', 'oil', 'renewable', 'utilities']
list1=['acq', 'corn', 'crude', 'earn','grain', 'interest', 'money', 'ship','trade','wheat']
#list1=['acq','copper', 'earn','grain', 'interest','rapeseed','oilseed', 'money', 'ship','wheat']
#list1=['policy', 'transportation', 'agriculture', 'health', 'climate_change', 'air', 'atmosphere', 'water']


#list1=['associations', 'consulting', 'electricity', 'employment','fuel_cells', 'hydrogen', 'management', 'oil_gas', 'renewable', 'utilities']
#list1=['policy']
#list1=['acquisition', 'corn', 'atmosphere', 'climate_change', 'health', 'policy', 'transportation', 'water']
#list1=['cat']
#list1=['policy', 'transportation', 'agriculture', 'health', 'climate_change', 'air', 'atmosphere', 'water']
#list1=['cat']
def wn_lemm(tokens):
    tokenize=[]
    tokens = [line.rstrip('\n') for line in tokens]
    tokens = [line.rstrip('\.') for line in tokens]
    tokens = [i for i in tokens if not i.isdigit()]
    tokens=tokens.lower()
#    tokens = ''.join(i for i in tokens if not i.isdigit())
    for token in tokens:
    # tokenization using nltkl ibrary
        tokens=word_tokenize(token)
        for w in tokens:
            if w not in stop_words and len(w)>1:
            #b.	Convert all plural nouns form (irregular and regular) to singular noun form
            #using pattern library in python.
                token=singularize(w)
             # # Verb: pos='v' 
                token=WordNetLemmatizer().lemmatize(token,'v')
            # # adjective: pos='a' 
                token=WordNetLemmatizer().lemmatize(token,'a')
            #  adverb: pos='r' 
                token=WordNetLemmatizer().lemmatize(token,'r')
             #  adverb: pos='r' 
                tokenize.append(token)
    return tokenize

 
#print(wn_lemm(classes))
def glossdef(token):
    tokens=[]
    for term in token:
        for token in  wn.synsets(term):
            token=token.definition()
            token=tokens.append(token)
    return tokens

def Removedub(list2): 
    final_list = [] 
    for num in list2: 
        if num not in final_list: 
            final_list.append(num) 
    return final_list

def main():
    for i in range(len(list1)):
        for label in [list1[i]]:
            for g in   wn.synsets(label):
                #get all gloss definiation
                deftoken=g.definition()
#                print(deftoken)
                #get all tokenize
                tkn=word_tokenize(deftoken)  
                for w in tkn:
                    # remove stop words
                    if w not in stop_words and len(w)>1:
            #b.	Convert all plural nouns form (irregular and regular) to singular noun form
            #using pattern library in python.
                        token=singularize(w)
             
                        token = ''.join(i for i in token if not i.isdigit())
                        token=token.lower()
                        token=WordNetLemmatizer().lemmatize(token,'v')
            # # adjective: pos='a' 
                        token=WordNetLemmatizer().lemmatize(token,'a')
            #  adverb: pos='r' 
                        token=WordNetLemmatizer().lemmatize(token,'r')
                        wordFromList1 = wn.synsets(label)
                        wordFromList2 = wn.synsets(token)
                        if wordFromList1 and wordFromList2: 
                            s = wordFromList1[0].path_similarity(wordFromList2[0])
                            if s != None and s > 0.001:
                                #save all ontologies in a txt file 
                                print(label,'~',token,'=',s,'.', file=data)
                                
main()

         
