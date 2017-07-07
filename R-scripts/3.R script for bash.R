
# 
# 
# ## WORKING DIRECTORY                                                              
# MAC = T
# wd <- ifelse(test = MAC==T, 
#              yes = "~/Dropbox/J.HOPKINS/SMALL PROJECTS/7. Cluster and R course/Examples", 
#              no = "C:/Users/mg3749/Dropbox/J.HOPKINS/SMALL PROJECTS/7. Cluster and R course/Examples" )
# setwd( wd )                                                                       
# 
# 
# 

#---------------------------------#
#    3. BOOTSRAPING EXAMPLE       #
#---------------------------------#

library(foreign)                                                                  

# Let's set a folder to save the results. The second line creates the folder if it doesn't exist in the working directory yet.
folder.output <- "output_example3"
if( !file.exists( folder.output ) ) { dir.create( file.path( folder.output ) ) }

#-------------------------------------------------#
#   Read NHANES data, merge and save in a CSV     #
#-------------------------------------------------#

demo <- read.xport("NHANES_data/DEMO_H.XPT") ; dim(demo) 
names(demo)
smoking <- read.xport("NHANES_data/SMQ_H.XPT") ; dim(smoking)
body <- read.xport("NHANES_data/BMX_H.XPT") ; dim(body)
activity <- read.xport("NHANES_data/PAQ_H.XPT") ; dim(activity)
insurance <- read.xport(("NHANES_data/HIQ_H.XPT")) ; dim(insurance)
dissability <- read.xport(("NHANES_data/DLQ_H.XPT")) ; dim(dissability)
sleep <- read.xport(("NHANES_data/SLQ_H.XPT")) ; dim(sleep)

# Lets merge the data bases
merge.data <- merge(demo[, c("SEQN", "RIDAGEYR", "RIAGENDR", "RIDRETH1", "INDHHIN2")], body[, c("SEQN", "BMXBMI", "BMXWAIST")], by = "SEQN", all.x = F, all.y = F) ; dim(merge.data)
merge.data <- merge(merge.data, smoking[, c("SEQN", "SMQ040")], by = "SEQN", all.x = F, all.y = F) ; dim(merge.data)
merge.data <- merge(merge.data, activity[, c("SEQN", "PAD680", "PAQ635")], by = "SEQN", all.x = F, all.y = F) ; dim(merge.data)
merge.data <- merge(merge.data, insurance[, c("SEQN", "HIQ011")], by = "SEQN", all.x = F, all.y = F) ; dim(merge.data)
merge.data <- merge(merge.data, dissability[, c("SEQN", "DLQ040")], by = "SEQN", all.x = F, all.y = F) ; dim(merge.data)
merge.data <- merge(merge.data, sleep[, c("SEQN", "SLD010H")], by = "SEQN", all.x = F, all.y = F) ; dim(merge.data)

write.csv(merge.data, paste0(folder.output, "/merge.data.csv"), row.names=F)


### Dictionary of some variables from
# DEMO_H
#   SEQN - Respondent sequence number
#   RIDAGEYR - Age in years at screening
#   RIAGENDR - Gender (1 male, 2 female)
#   RIDRETH1 - Race (1 Mexican American, 2 other Hispanic, 3 Non-Hispanic White, 4 Non-Hispanic Black, 5 other/multi-racial)
#   INDHHIN2 - Annual household income
# Body measures
#   BMXBMI - Body Mass Index (kg/m**2)
#   BMXWAIST - Waist Circumference (cm)
# Smoking
#   SMQ040 - Do you now smoke cigarettes (1 every day, 2 some days, 3 never)
# Physical Activity
#   PAD680 - Minutes sedentary activity
#   PAQ635 - Walk or bicycle
# Health Insurance
#   HIQ011 - Covered by health insurance
# Dissability
#   DLQ040 - Have serious difficulty concentrating ? (1 yes, 2 no, 7 and 9 are missing data)
# Sleep behavior
#   SLD010H - How much sleep do you get (hours)?

merge.data$SLD010H[merge.data$SLD010H>24] <- NA
merge.data$DLQ040[merge.data$DLQ040==2 ] <- 0
merge.data$DLQ040[merge.data$DLQ040==7 | merge.data$DLQ040==9] <- NA

# Original coefficient, standard error and p-value of the main predictor ()
fit <- glm(DLQ040 ~ SLD010H + RIDAGEYR + RIAGENDR + RIDRETH1 + PAD680 + PAQ635, data = merge.data, family = quasibinomial(link = "logit") )
beta <- round(summary(fit)$coeff[2, "Estimate"], 3)
se <- round(summary(fit)$coeff[2, "Std. Error"], 3)
pvalue <- round(summary(fit)$coeff[2, "Pr(>|t|)"], 3)
original.result <- c("Traditonal result:", beta, se, pvalue)


#--------------------------------------------------------
# Reproduce the results using simulation (bootstraping)
#--------------------------------------------------------

set.seed(123)

n.sim <- 500
store.matrix <- matrix(NA, nrow=n.sim, ncol=1)

for(i in 1:n.sim) {
  
  #--------------------------------------------------------------------------
  # Create a new data base WITH replacement and run the model with this one
  #--------------------------------------------------------------------------
  
  data.new <- merge.data[sample(1:nrow(merge.data), nrow(merge.data), replace=TRUE),]
  fit <- glm(DLQ040 ~ SLD010H + RIDAGEYR + RIAGENDR + RIDRETH1 + PAD680 + PAQ635, data = data.new, family = quasibinomial(link = "logit") )
  
  #-----------------------------------------------
  # Store the results
  #-----------------------------------------------
  
  store.matrix[i, ] <- round(summary(fit)$coeff[2, "Estimate"], 3)
  
}

# Obtain the mean , SE and p-value of the estimates obtained with all the simulations
boot.mean <- round(mean(store.matrix[,1]), 3)
boot.sd <- round(sd(store.matrix[,1]), 3)
boot.pvalue <- round(2*pnorm(boot.mean/boot.sd, mean = 0, sd = 1),3)
boot.result <- c("Bootstraping result:", boot.mean, boot.sd, boot.pvalue)

# Save the original and the bootstraping result together
result <- rbind(original.result, boot.result)
result <- as.data.frame(result, row.names = NULL)
names(result) <- c("", "Beta", "SE", "P value")
result
write.csv(result, paste0(folder.output, "/3.Bootstraping example.csv"), row.names = F)
