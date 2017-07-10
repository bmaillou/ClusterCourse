
## WORKING DIRECTORY  
# /ifs/scratch/msph/arsenic/bjm2103/R-test/R-Scripts/script2                                                            
MAC = T
wd <- ifelse(test = MAC==T, 
             yes = "/ifs/scratch/msph/arsenic/bjm2103/R-test/R-Scripts/script2", 
             no = "C:/Users/mg3749/Dropbox/J.HOPKINS/SMALL Pq()ROJECTS/7. Cluster and R #course/Examples" )
setwd( wd ) 
# setwd(system("pwd", intern = T) )                                                                      




#--------------------------------------------------------------------------------#
#   2. Go over Dietary data and summarize it with one single entry per person    #
#--------------------------------------------------------------------------------#

library(foreign)                                                                  

# Let's set a folder to save the results. The second line creates the folder if it doesn't exist in the working directory yet.
folder.output <- "output_example2"
if( !file.exists( folder.output ) ) { dir.create( file.path( folder.output ) ) }

# The dietary data in Nhanes has several entries for the same participant.
# Each entry corresponds to a meal reported (I think) and it is indicated by the variable "

diet <- read.xport("NHANES_data/DR1IFF_H.XPT") 
dim(diet)
length(unique(diet$SEQN))
names(diet)
diet[ 1:20, c("SEQN", "DR1ILINE")]

# To do this table takes around 10 minutes in my laptop
table <- c()
for(id in unique(diet$SEQN)){
  
  table.var <- c()
  for(var in subset(names(diet), names(diet)!="SEQN") ){
    total.value <- sum(diet[diet$SEQN==id, var], na.rm=T)
    table.var <- cbind(table.var, total.value)  
  }
  table.var <- cbind(id, table.var)
  table <- rbind(table, table.var)
  
}

table <- as.data.frame(table, row.names = NULL)
names(table) <- names(diet)
write.csv(table, paste0(folder.output, "/2.Summarized_diet_data.csv"), row.names = F)




