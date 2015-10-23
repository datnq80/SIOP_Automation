# ---- 03_PurchasabilityData ----

load(file.path(rDataFile,"siop_atp_matching.RData"))

week1 <- paste0("Week",isoweek(now()))
week2 <- paste0("Week",isoweek(now())-1)
week3 <- paste0("Week",isoweek(now())-2)
week4 <- paste0("Week",isoweek(now())-3)

if (file.exists(file.path(rawDataFile,week1,"Purchasability_last_7days.csv"))){
    week1Data <- read.csv(file.path(rawDataFile,week1,"Purchasability_last_7days.csv"),
                          stringsAsFactors = FALSE,
                          col.names = c("SKU","Purchasability_W_1"))
}else{
    week1Data <- data.frame(SKU=character(),
                            Purchasability_W_1=integer())
}

if (file.exists(file.path(rawDataFile,week2,"Purchasability_last_7days.csv"))){
    week2Data <- read.csv(file.path(rawDataFile,week2,"Purchasability_last_7days.csv"),
                          stringsAsFactors = FALSE,
                          col.names = c("SKU","Purchasability_W_2"))
}else{
    week2Data <- data.frame(SKU=character(),
                            Purchasability_W_2=integer())
}
if (file.exists(file.path(rawDataFile,week2,"Purchasability_last_7days.csv"))){
    week3Data <- read.csv(file.path(rawDataFile,week3,"Purchasability_last_7days.csv"),
                          stringsAsFactors = FALSE,
                          col.names = c("SKU","Purchasability_W_3"))
}else{
    week3Data <- data.frame(SKU=character(),
                            Purchasability_W_3=integer())
}
if (file.exists(file.path(rawDataFile,week2,"Purchasability_last_7days.csv"))){
    week4Data <- read.csv(file.path(rawDataFile,week4,"Purchasability_last_7days.csv"),
                          stringsAsFactors = FALSE,
                          col.names = c("SKU","Purchasability_W_4"))
}else{
    week4Data <- data.frame(SKU=character(),
                            Purchasability_W_4=integer())
}

PurchasabilitySelfNew <- full_join(week4Data, week3Data, by="SKU")
PurchasabilitySelfNew <- full_join(PurchasabilitySelfNew, week2Data, by="SKU")
PurchasabilitySelfNew <- full_join(PurchasabilitySelfNew, week1Data, by="SKU")

siop_atp_matching_purchasability <- left_join(siop_atp_matching, PurchasabilitySelfNew, by="SKU")

siop_atp_matching_purchasability <- siop_atp_matching_purchasability %>%
    mutate(Purchasability_W_4=ifelse(is.na(Purchasability_W_4),7,Purchasability_W_4)) %>%
    mutate(Purchasability_W_3=ifelse(is.na(Purchasability_W_3),7,Purchasability_W_3)) %>%
    mutate(Purchasability_W_2=ifelse(is.na(Purchasability_W_2),7,Purchasability_W_2)) %>%
    mutate(Purchasability_W_1=ifelse(is.na(Purchasability_W_1),7,Purchasability_W_1))

save(siop_atp_matching_purchasability, file = file.path(rDataFile,"siop_atp_matching_purchasability.RData"))
