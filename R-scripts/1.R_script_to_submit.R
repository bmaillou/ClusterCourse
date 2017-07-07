# Set your working directory before openning R

# There are packages that are not installed in the cluster. The following line gives an error
# library(Hmisc)

# CHANGE THIS
# And we are not able to install packages in the cluster.The following line gives an error
# install.packages("Hmisc")

# But we can load packages that are already installed in the cluster. For instance
library(foreign)

#----------------------------------------------------------------#
#      2. EASY SCRIT TO RUN LINE BY LINE (or by pieces)          #
#----------------------------------------------------------------#

# Let's set a folder to save the results. The second line creates the folder if it doesn't exist in the working directory yet.
folder.output <- "output_example1"
if( !file.exists( folder.output ) ) { dir.create( file.path( folder.output ) ) }


# Notes: you can copy and paste each line (line by line) in the Terminal, or copy and paste a group of lines together.

# Create some vectors with 20 observations 
id <- seq(1, 20)
gender <- c("F", "M", "M", "M", "F", "F", "F", "F", "M", "F", "M", "F", "M", "F", "M", "F", "M", "F", "F", "F")
age <- c(60.20, 24.00, 22.30, 64.20, 47.10, 25.50, 24.60, 32.00, 27.90, 19.87, 25.50, 30.60, 26.31, 31.47, 76.00, 55.40, 47.00, 42.10, 37.90, 36.60)
education <- c(10, 11, 8, 12, 12, 13, 14, 10, 11, 12, 10, 12, 8, 7, 10, 8, 10, 10, 10, 11)
bmi <- c(26.14, 21.11, 23.68, 29.41, 30.12, 26.25, 24.82, 33.95, 35.11, 36.48, 35.01, 32.83, 47.22, 36.16, 38.42, 33.28, 39.57, 37.11, 33.71, 32.89)
test <- c(1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0)

# Put the variables in a data frame
example <- data.frame(id, gender, age, education, bmi, test)

# Table with the mean, sd and coefficient of variation of the continuous variables
table <- character()
for(var in c("age", "education", "bmi")){
  
  mean <- round(mean(example[, var], na.rm=T),2)
  sd <- round(sd(example[, var], na.rm=T),2)
  cv <- round(sd/mean, 2)
  result <- c(var, mean, sd, cv)
  
  table <- rbind(table, result)
  
}

table <- as.data.frame(table, row.names = F)
names(table) <- c("Variable", "Mean", "SD", "Coefficient of Variation")
write.csv(table, file = paste0(folder.output, "/Table1.Some descriptive variables.csv"), row.names = F)


# We can run simple linear models
fit <- lm(bmi ~ gender + age + education, data = example)
summary(fit)

# And also general linear models c
fit <- glm( test ~ gender + age + education + bmi, data = example, family = quasibinomial(link="logit"))
summary(fit)

# Can we do plot in R in the cluster? Sure! But I think it works only if we save it in to a file
pdf(file=paste0( folder.output , "/Boxplot of age by gender.pdf"))
boxplot(example$age ~ example$gender, col = c("magenta", "slateblue"))
dev.off()
