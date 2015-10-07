# ---- 04_RedBlackStockData ----

load(file.path(rDataFile,"siop_atp_matching_purchasability.RData"))

StockCondition <- read.csv(file.path(rawDataFileDaily,paste0("Outright Inventory Ex ",ventureShort,".csv")),
                           stringsAsFactors = FALSE)

StockConditionOnly <- select(StockCondition, 1,7,44:46)
colnames(StockConditionOnly) <- c("SKU","Black_Stock_Items","Red","Black1","Black2")
StockConditionOnly <- StockConditionOnly %>%
        mutate(Black_Stock_Items=ifelse(Black1>0|Black2>0,
                                        Black_Stock_Items,0))

siop_atp_matching_purchasability_stock <- left_join(siop_atp_matching_purchasability, StockConditionOnly,
                                                    by=c("SKU"="SKU"))

siop_atp_matching_purchasability_stock <- mutate(siop_atp_matching_purchasability_stock,
                                                 Red=ifelse(is.na(Red),0,Red),
                                                 Black1=ifelse(is.na(Red),0,Red),
                                                 Black2=ifelse(is.na(Red),0,Red))

save(siop_atp_matching_purchasability_stock,
     file = file.path(rDataFile,"siop_atp_matching_purchasability_stock.RData"))