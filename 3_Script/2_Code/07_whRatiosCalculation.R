# ---- 07_whRatiosCalculation ----

# Load Sales Destination Data
salesDestinationLevels <- read.csv(file.path(rawDataFileWeekly,"Sales_Destinations_Levels.csv"),
                                   encoding = "UTF-8", stringsAsFactors = FALSE,
                                   col.names = c("sku","Net_Item_sold","city","postcode",
                                                 "Destination_level1","Destination_level2","Destination_level3",
                                                 "Destination_level4"))
# Load Manual Input Data - WH Allocation
tempwb <- loadWorkbook(filename = file.path(manualInputFile,"WH_Allocation.xlsx"))
whAllocation <- readWorksheet(tempwb,sheet = 1)

# Matching the Sales_Destination data with WH Allocation to find the Origin Warehouse of the sales
salesDestinationLevels <- left_join(salesDestinationLevels,whAllocation,
                                    by = c("Destination_level3"="City.Province"))

# Summarized the product sales desitnation by Origin Warehouse and the ratio of each
whRatios <- salesDestinationLevels %>% group_by(sku) %>%
        summarize(Hanoi=sum(as.numeric(ifelse(Origin=="Ha Noi",Net_Item_sold,0))),
                  HCMC=sum(as.numeric(ifelse(Origin=="Ho Chi Minh",Net_Item_sold,0))),
                  Total=Hanoi+HCMC,
                  Ratio_Hanoi=Hanoi/Total,
                  Ratio_HCMC=HCMC/Total)

save(whRatios, file = file.path(rDataFile,"whRatios.RData"))
