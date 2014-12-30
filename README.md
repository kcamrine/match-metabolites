# README for implementing match_metabolites.R

## A description of the data one would process with the code in this repository

## files include:

README.md			     -- this file

match_metabolites.R		     -- code to create the matches

metabolites_list_processed_clean.txt -- metabolites from XML files from the Human 
Metabolite database (http://www.hmdb.ca)

parse_mets_out.pl		     -- process R raw output to just include matches
from none, 10%, 20% and 30% variability from each query

Metabolite matches are processed from XML files of HMDB database downloaded in 
November of 2014: Citations:

Wishart DS, Tzur D, Knox C, et al., HMDB: the Human Metabolome Database. Nucleic 
Acids Res. 2007 Jan;35(Database issue):D521-6. 17202168 

Wishart DS, Knox C, Guo AC, et al., HMDB: a knowledgebase for the human metabolome. 
Nucleic Acids Res. 2009 37(Database issue):D603-610. 18953024 

Wishart DS, Jewison T, Guo AC, Wilson M, Knox C, et al., HMDB 3.0 — The Human 
Metabolome Database in 2013. Nucleic Acids Res. 2013. Jan 1;41(D1):D801-7. 23161693 