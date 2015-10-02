library(dplyr)
purchasability_current <- read.csv("../1_Raw_Extracts/Vietnam/Self_Updated/Purchasability_Weekly (1).csv",
                                   stringsAsFactors = FALSE)
purchasability_used <- read.csv("../1_Raw_Extracts/Vietnam/Self_Updated/Purchasability_Weekly.csv",
                                stringsAsFactors = FALSE)


filter(purchasability_current, SKU=="VE835FAAVEQ6VNAMZ-528505")

filter(siop_atp_matching_purchasability_stock, SKU=="SI461OTAE82SVNAMZ-202172")
