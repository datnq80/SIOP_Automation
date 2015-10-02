# ---- 03_PurchasabilityData ----

load(file.path(rDataFile,"siop_atp_matching.RData"))

week1 <- paste0("Week",isoweek(now()))
week2 <- paste0("Week",isoweek(now())-1)
week3 <- paste0("Week",isoweek(now())-2)
week4 <- paste0("Week",isoweek(now())-3)

week1Data <- read.csv(file.path(rawDataFile,week1,"Purchasability_last_7days.csv"),
                      stringsAsFactors = FALSE,
                      col.names = c("SKU","Purchasability_W_1"))
week2Data <- read.csv(file.path(rawDataFile,week2,"Purchasability_last_7days.csv"),
                      stringsAsFactors = FALSE,
                      col.names = c("SKU","Purchasability_W_2"))
week3Data <- read.csv(file.path(rawDataFile,week3,"Purchasability_last_7days.csv"),
                      stringsAsFactors = FALSE,
                      col.names = c("SKU","Purchasability_W_3"))
week4Data <- read.csv(file.path(rawDataFile,week4,"Purchasability_last_7days.csv"),
                      stringsAsFactors = FALSE,
                      col.names = c("SKU","Purchasability_W_4"))

PurchasabilitySelfNew <- full_join(week4Data, week3Data)
PurchasabilitySelfNew <- full_join(PurchasabilitySelfNew, week2Data)
PurchasabilitySelfNew <- full_join(PurchasabilitySelfNew, week1Data)

siop_atp_matching_purchasability <- left_join(siop_atp_matching, PurchasabilitySelfNew, by="SKU")

siop_atp_matching_purchasability <- siop_atp_matching_purchasability %>%
    mutate(Purchasability_W_4=ifelse(is.na(Purchasability_W_4),0,Purchasability_W_4),
           Purchasability_W_3=ifelse(is.na(Purchasability_W_3),0,Purchasability_W_3),
           Purchasability_W_2=ifelse(is.na(Purchasability_W_2),0,Purchasability_W_2),
           Purchasability_W_1=ifelse(is.na(Purchasability_W_1),0,Purchasability_W_1))

save(siop_atp_matching_purchasability, file = file.path(rDataFile,"siop_atp_matching_purchasability.RData"))
