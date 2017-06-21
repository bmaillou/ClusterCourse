library(Hmisc)

vector.a <- c(1,2,3,4,5,6,7,8,9,10)
vector.b <- rep(2, 10)

matrix.A <- matrix(seq(1,100,), nrow = 10, ncol = 10)

describe(vector.a)
print(vector.a - vector.b)
print(matrix.A%*%vector.a)

result.1 <- vector.a - vector.b
result.2 <- t(vector.a)%*%matrix.A

write.csv(result.1, "result1.csv", row.names = F)
write.csv(result.2, "result2.csv", row.names = F)