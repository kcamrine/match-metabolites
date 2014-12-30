### Katie's silly attempt to match metabolites. Need to match column 2 
### (Possible.identities) in berries.metabolites to best match in column 
### 4 (ID) of reference.metabolites to return columns 1 (Metabolism) and
### 2 (Pathway) of reference.metabolites to column 1 (ID) of 
### berries.metabolites

## We shall call this iterative fuzzy mapping of metabolite characterizations

######### SET YOUR PARAMETERS HERE #################

# make this the file you want to match. Right now, it codes the example file
# so you can look at what the format should be for the input file
unknown.metabolites <- read.table("unknown_metabolites_clean.txt") 

# this file should stay the same,unless you have something else to match to. If that's the 
# case, make sure that the format is the same.
# this file has all of the metabolites. It will take a long time, especially if you
# have shorter matches, for example "urea" will match LOTS of stuff perfectly
# so you may want to clean this up before you run it. 
reference.metabolites <- read.table("metabolites_list_processed_clean.txt") 

# how lenient you want to be. 0.1 is 10% difference
subs = 0.1

########### Done setting parameters ##################


unknown.metabolites$V3 <- as.character(unknown.metabolites$V3)

filename <- paste("match-metabolites",subs,"out","txt",sep=".")
sink(filename) #right now, output just sinks to a file. feel free to change

matchtimes <- c()
for(i in 1:length(unknown.metabolites[,1])){
  matchtimes <- c(matchtimes,0); #records num of matches for each query
  teststring <- unknown.metabolites[i,3]
  substitutions <- 0
  matchstring <- rep(0,length(reference.metabolites[,1])) #records what is matched
  matches <- c();
  while(matchtimes[i] < 1 & substitutions < subs){
    for(querynum in 1:length(reference.metabolites[,1])){
      query <- as.character(reference.metabolites[querynum,2])
      match <- agrep(query,teststring,max.distance = 0,ignore.case=TRUE)
      if(length(match) > 0){
        if(matchstring[querynum] == 1){
          next; #go on if it already matched this met
        }
        if(nchar(query) <= 4 & substitutions > 0){
          next; #go on if it is less or equal to 4 (crap match)
        }        
        if(!(query %in% matches)){
          matchtimes[i] = matchtimes[i]+1;
          matches <- c(matches,query)
        }
        ## print the match
        matched.yay <- paste(query,unknown.metabolites[i,1],
		    as.character(reference.metabolites[querynum,2]),
		    as.character(reference.metabolites[querynum,3]), 
		    as.character(reference.metabolites[querynum,4]), 
		    as.character(reference.metabolites[querynum,5]), 
		    as.character(reference.metabolites[querynum,6]),
		    substitutions,teststring, sep= "\t")
        cat(matched.yay,"\n") #print the match
        matchstring[querynum] = 1
      }
    }
    substitutions = substitutions+0.1 #make more lenient
  }
}
sink() #stop the sinking
