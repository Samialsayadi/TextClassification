#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 15 22:19:37 2020

@author: samialsayadi
"""

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

stop_words = set(stopwords.words('english'))
Lem = WordNetLemmatizer()

data = open("reuters10_path.ont","w")

#list1=['associations', 'consulting', 'electricity', 'employment','fuel', 'hydrogen', 'management', 'oil', 'renewable', 'utilities']
list1=['acq', 'corn', 'crude', 'earn','grain', 'interest', 'money', 'ship','trade','wheat']
#list1=['acq','copper', 'earn','grain', 'interest','rapeseed','oilseed', 'money', 'ship','wheat']
#list1=['policy', 'transportation', 'agriculture', 'health', 'climate_change', 'air', 'atmosphere', 'water']


#print(wn_lemm(classes))
def glossdef(token):
    tokens=[]
    for term in token:
        for token in  wordnet.synsets(term):
            token=token.gloss
            token=tokens.append(token)
    return tokens

def Removedub(list2): 
    final_list = [] 
    for num in list2: 
        if num not in final_list: 
            final_list.append(num) 
    return final_list

def hy(token):
    tokens=[]
    for term in token:
        for token in  wn.synsets(term):
            typesOfVehicles = list(set([w for s in token.closure(lambda s:s.hyponyms()) for w in s.lemma_names()]))
            token=tokens.append(typesOfVehicles)
    return tokens


def main():
    for i in range(len(list1)):
        for label in [list1[i]]:
            for token in  wn.synsets(label):
                tkn=list(set([w for s in token.closure(lambda s:s.hyponyms()) for w in s.lemma_names()]))
#                deftoken=token.closure(lambda s:s.hyponyms())
#                tkn=word_tokenize(deftoken)  
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
                            if s != None and s > 0.01:
                                #save all ontologies in a txt file 
                                print(label,'~',token,'=',s,'.', file=data)
                                
main()

         
