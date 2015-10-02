lastweekData <- read.csv("Self_Updated/Purchasability_Weekly.csv")


week34Data <- read.csv("Week34/Purchasability_last_7days.csv",
                       col.names = c("SKU","Week34"))

week35Data <- read.csv("Week35/Purchasability_last_7days.csv",
                        col.names = c("SKU","Week35"))

week36Data <- read.csv("Week36/Purchasability_last_7days.csv",
                       col.names = c("SKU","Week36"))

library(dplyr)
newData <- full_join(lastweekData,week34Data)
newData <- full_join(newData, week35Data)
newData <- full_join(newData, week36Data)

newDataFinal <- newData %>%
        mutate(Purchasability_W_4=Purchasability_W_3,
               Purchasability_W_3=Week34,
               Purchasability_W_2=Week35,
               Purchasability_W_1=Week36)
outputData <- select(newDataFinal, 1:5)
write.csv(outputData,"Self_Updated/Purchasability_Weekly.csv",
          row.names = FALSE)