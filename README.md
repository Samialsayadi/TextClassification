#  Classify Unlabeled Short Texts

This library classifies short texts, Using Wordnet Ontologies and Fuzzy Declarative modeling. It is geared towards creating Semantic Classification of corpora of relatively short documents, such as comments on social media, or online product reviews. The WordNet-Gloss and Hyponyms use to create the ontologies, then apply Fuzzy Declarative to classify short Docs.

The library consists of two main scripts to generate ontologies: `aut_ontology_based_gloss.py`  and `auto_ontology_based_hy.py`. 

In both scripts used the same Pre-Processing steps:

* Tokenization using the NLTK Liberary
```python
from nltk.tokenize import word_tokenize
tokens=word_tokenize(token)

```
* Removal of stopwords using an augmented version of the NLTK English stopwords corpus, [here](http://www.nltk.org/nltk_data/)
```python
from nltk.corpus import stopwords
stop_words = set(stopwords.words('english'))

```
* Convert all plural noun forms (irregular and regular) into singular noun forms using pattern library, [here](https://github.com/clips/pattern) .
```python
from pattern.text.en import singularize

        if w not in stop_words and len(w)>1:
                    #b.    Convert all plural nouns form (irregular and regular) to singular noun form
                    #using pattern library in python.
            token=singularize(w)

```
* Lemmatization using the NLTK WordNetLemmatizer, [here](http://www.nltk.org/api/nltk.stem.html#module-nltk.stem.wordnet) 
```python
from nltk.stem.wordnet import WordNetLemmatizer
Lem = WordNetLemmatizer()
# verb: pos='a' 
token=WordNetLemmatizer().lemmatize(token,'v')
# # adjective: pos='a' 
token=WordNetLemmatizer().lemmatize(token,'a')
#  adverb: pos='r' 
token=WordNetLemmatizer().lemmatize(token,'r')
```
Generate Ontologies based wordnet definition(gloss):
```python
from nltk.corpus import wordnet as wn  
for label in [list1[Terms]]:
for def_labels in   wn.synsets(label):
    #get all gloss definiation
    deftoken=def_labels.definition()
```
Generate Ontologies based wordnet  hyponyms:
```python
from nltk.corpus import wordnet as wn  

for def_label in  wn.synsets(label):
tkn=list(set([w for s in def_label.closure(lambda s:s.hyponyms()) for w in s.lemma_names()]))
```
You can get the similarity degree between keywords and their definition or hyponyms by the follow code:
```python
from nltk.corpus import wordnet as wn  

wordFromList1 = wn.synsets(label)
wordFromList2 = wn.synsets(token)
if wordFromList1 and wordFromList2: 
    degree = wordFromList1[0].path_similarity(wordFromList2[0])
    if degree != None and degree > 0.01:
        #save all ontologies in a txt file 
        print(label,'~',token,'=',degree,'.', file=data)
```


# Classification Method by using Bousi~Prolog system
> Perform an experiment, launching the goal: experiment(Measure, FileName, CategoryList, Process).
>The "Measure" parameter can be one of the following constants: [ont, path, wup, lch, res, jcn, jin, yarm]. 
>The constant "ont" means that you want to perform the experimentes using a predefined ontology, that you must first load before launching the predicate "experiment/4". 
>The other constants are the acronyms of standard linguistic similarity measures which are computed thanks to the connection to the Prolog version of the WordNet database. 
>This connection is automatically established by the cataloging.bpl program (and it does not require uploading an ontology). 

>EXPLANATION:
>FileName: File name or path name of a file containing the documents to be classified (stored in the the SMART standard format).
>CategoryList: A list of categories related with the ontology loaded. 
>Process: A compatibility degree operator (e.g.: sUm, wa, mIn, mAx).

# In order to install the Bousi~Prolog system, follow these steps:

Download Bousi~Prolog system: [here](https://dectau.uclm.es/bousi-prolog/2018/07/26/downloads).
Follow the instructions, which found in [Bousi~Prolog ON-LINE MANUAL
:](https://dectau.uclm.es/bousi-prolog/2019/02/26/on-line-manual) 

 

 # Execute the Bousi~Prolog system to reproduce the experiments, follow these steps: 
<ol>
<li> After install, please follow the instructions that found in [Bousi~Prolog ON-LINE MANUAL :](https://dectau.uclm.es/bousi-prolog/2019/02/26/on-line-manual) to lunch the Bousi~Prolog system.

```
>> bousi
```


                                                    Universidad de
|O)               |D)                            Castilla - La Mancha
|O)(O)\U(S)|I| ~~ || |R (O) |L (O) (G|.    (Version Devel ~ January, 22nd 2020)
-----------------------------------------------------------------------------
    Welcome to Bousi~Prolog, a fuzzy logic programming system created by
    Juan Gallardo-Casero and Pascual Julian-Iranzo. Fernando Saenz-Perez
    (UCM) contributed to this version. This software is for research and
    educational purposes only, and it is distributed with NO WARRANTY.
    Please visit our website for the latest news on Bousi~Prolog:
                https://dectau.uclm.es/bousi-prolog
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------


<li>Go to the working directory: the one where is placed the cataloging.bpl program and a directory 'finalexperiments' containing the document collections and ontologies.

```
BPL> cd Downloads/A Fuzzy to Classify based ontologies
```

<li> Load the cataloging.bpl program and an ontology. 
 
  ```
  BPL> ld cataloging
 Parsing and translating 'cataloging.bpl'...
 'cataloging.tpl' is being loaded...
 Program loaded!
  ```
<li>Load an ontology. 

  ```
 BPL> ld -o 'finalexperiments/odp/wikipedia.ont'
 Parsing and translating 'cataloging.bpl' using ontology 'wikipedia.ont'...
 'cataloging-wikipedia.tpl' is being loaded...
 Ontology loaded!
```
<li>Reproduce the experiments.

   ```
 BPL> experiment(ont, 'finalexperiments/odp/odp',[renewable, electricity, oil_gas, utilities, fuel_cells, hydrogen, consulting, employment, associations, management], sUm)
   ```
  </ol> 
   The results:
   
 ```
 Processing file, finalexperiments/odp/odp, for category: renewable.  This may take a while ...
 End of file reached.
 Processing file, finalexperiments/odp/odp, for category: electricity.  This may take a while ...
 End of file reached.
 Processing file, finalexperiments/odp/odp, for category: oil_gas.  This may take a while ...
 End of file reached.
 Processing file, finalexperiments/odp/odp, for category: utilities.  This may take a while ...
 End of file reached.
 Processing file, finalexperiments/odp/odp, for category: fuel_cells.  This may take a while ...
 End of file reached.
 Processing file, finalexperiments/odp/odp, for category: hydrogen.  This may take a while ...
 End of file reached.
 Processing file, finalexperiments/odp/odp, for category: consulting.  This may take a while ...
 End of file reached.
 Processing file, finalexperiments/odp/odp, for category: employment.  This may take a while ...
 End of file reached.
 Processing file, finalexperiments/odp/odp, for category: associations.  This may take a while ...
 End of file reached.
 Processing file, finalexperiments/odp/odp, for category: management.  This may take a while ...
 End of file reached.
 Reading file, finalexperiments/odp/odp.exp with an expert classification...
 .............................................................................
 ............ ABSOLUTE RESULTS ...............................................
  Positive classifications:       88
  Negative classifications:       27
  Undefined classifications:      0
  Total classifications:          153
  Total Expert classifications:   115
  Total positive classifications: 88
 .............................................................................
 ............ PERCENT RESULTS ................................................
 
  Positive classifications (w.r.t. the total num. of documents): 76.52173913043478
  
  Negative classifications (w.r.t. the total num. of documents): 23.47826086956522
  
  Undefined classifications (w.r.t. the total num. of documents): 0
  
  Precision (w.r.t. the set of categories): 57.51633986928104
  
  Recall (w.r.t. the set of categories):    76.52173913043478
  
  F measure:                                      :  65.67164179104478
  
 .............................................................................
 true .

```
# Dependencies

* [Bousi~Prolog :](https://dectau.uclm.es/bousi-prolog/2018/07/26/downloads) `bpl-3.5-highsierra-executable` (BPL version 3.5 )
* [NLTK:](https://anaconda.org/anaconda/nltk) `conda install nltk` 
* [Pattern :](https://anaconda.org/asmeurer/pattern) `conda install pattern ` 

