# ---- 02_ATPSIOPMatching ----

# Load ATP_MUltisource
atp_multisource <- read.csv(file.path(rawDataFileDaily,paste0("ATP Multisource ",ventureShort,".csv")),
                            stringsAsFactors = FALSE,
                            col.names = c("sku","Product_Name","NumberMultisourceSKU",
                                          "Multisource_parent_sku","Final_SKU","category",
                                          "X_Docking","Ware_house","Dropshipping","Total_Bob_reservations",
                                          "Visibility","Purchasability","Total_Revenue","Units_Sold",
                                          "Sourceability","Business_Unit","Seller_Supplier","Category_Rank",
                                          "BU_Rank","Overall_Rank","Shipment_Route","Weight","Cumulative_Weight",
                                          "General_Tiering","Cumulative_Weight_in_each_CAT","Tiering_in_each_CAT",
                                          "ATP","Non_ATP","Days_of_Cover","Weight_Days","BU_Ship","BI_Status"))

#SKU ranking
if (SKURankingMethod=="Retail with Multisource MP"){
    temp <- atp_multisource %>% group_by(Final_SKU) %>%
        summarize(Max_Revenue=max(Total_Revenue))
    temp <- temp %>%
        mutate(Ranking=row_number(-temp$Max_Revenue)) %>%
        select(1,3)
    atp_multisource <- left_join(atp_multisource, temp, by=c("Final_SKU"))
    retailSKU <- filter(atp_multisource, Business_Unit=="Retail")$Final_SKU
    atp_multisource <- filter(atp_multisource, Final_SKU %in% retailSKU)
}else if (SKURankingMethod=="Retail Only"){
    atp_multisource <- filter(atp_multisource, Business_Unit=="Retail")
}else {
    atp_multisource <- atp_multisource %>% mutate(Ranking=Overall_Rank)
}

# Filter only shortail SKUs in ATP_Multisource data
if (ATPShortTailType=="Category_Percentile"){
    atp_multisource_shortail <- filter(atp_multisource, Cumulative_Weight_in_each_CAT<=Threshold)
} else {
    atp_multisource_shortail <- filter(atp_multisource, Category_Rank<=Threshold)
}

# Get only needed column from ATP_Multisource data
atp_multisource_matching <- select(atp_multisource_shortail,
                                   sku,
                                   Final_SKU,
                                   NumberMultisourceSKU,
                                   atpCategory=category,
                                   Overall_Rank,
                                   Category_Rank,
                                   Tiering_in_each_CAT,
                                   General_Tiering,
                                   X_Docking,
                                   Ware_house,
                                   Total_Bob_reservations,
                                   Ranking)

# Load SIOP_Multi_WH data
siop_multi_wh <- read.csv(file.path(rawDataFileDaily,paste0("SIOP_",ventureShort,"_multi_WH_Test.csv")),
                          stringsAsFactors = FALSE, 
                          col.names = c("SKU","product_Name","Brand","Cat.level1",
                                        "Business_Unit",
                                        "PO_Type","Visible","Sourceability_WH1","Sourceability_WH2",
                                        "Unit_Price","special_price","Purchase_price_WH1","Purchase_Price_WH2",
                                        "Lowest_Purchase_price","Supplier_lowest_price","Net_Revenue",
                                        "Gross_item","Net_Item","Total_Cancelled","Cancelled_by_Cust",
                                        "Cancelled_by_Lazada","Items_Returned","Net_Rev_W12","Net_Rev_W11",
                                        "Net_Rev_W10","Net_Rev_W9","Net_Rev_W8","Net_Rev_W7","Net_Rev_W6",
                                        "Net_Rev_W5","Net_Rev_W4","Net_Rev_W3","Net_Rev_W2","Net_Rev_W1",
                                        "Net_Items_W12","Net_Items_W11","Net_Items_W10","Net_Items_W9",
                                        "Net_Items_W8","Net_Items_W7","Net_Items_W6","Net_Items_W5",
                                        "Net_Items_W4","Net_Items_W3","Net_Items_W2","Net_Items_W1",
                                        "Preferred_supplier","Current_Inventory_WH1","Outright","Consignment",
                                        "Marketplace_WH1","In_Transit_WH1","Current_Inventory_WH2","Marketplace_WH2",
                                        "In_Transit_WH2","Average_Revenue_last_4_weeks","Average_Item_Sold_last_4_weeks",
                                        "Special_Selling_Price","latest_promotion_start_date","latest_promotion_end_date",
                                        "competitor_price","competitor","product_dimension","product_weight","package_height",
                                        "package_length","package_width","supplier_type","supply_po_average","Leadtime",
                                        "purchasable","tax1","tax2","payment_terms"))

siop_multi_wh <- siop_multi_wh %>%
    mutate(package_height=as.numeric(package_height)) %>%
    mutate(package_width=as.numeric(package_width)) %>%
    mutate(package_length=as.numeric(package_length)) %>%
    mutate(Volumetric_cm3=package_height*package_width*package_length) %>%
    mutate(Net_Rev_W4=as.numeric(Net_Rev_W4)) %>%
    mutate(Net_Rev_W3=as.numeric(Net_Rev_W3)) %>%
    mutate(Net_Rev_W2=as.numeric(Net_Rev_W2)) %>%
    mutate(Net_Rev_W1=as.numeric(Net_Rev_W1)) %>%
    mutate(Net_Items_W4=as.numeric(Net_Items_W4)) %>%
    mutate(Net_Items_W3=as.numeric(Net_Items_W3)) %>%
    mutate(Net_Items_W2=as.numeric(Net_Items_W2)) %>%
    mutate(Net_Items_W1=as.numeric(Net_Items_W1))

# Filled the NA value in ATP_Multisource data with 0
atp_multisource_matching[is.na(atp_multisource_matching)] <- 0

# Matching the ATP_Multisource data with SIOP_Multi_WH
siop_atp_matching <- inner_join(siop_multi_wh,
                                atp_multisource_matching,
                                by=c("SKU"="sku"))
siop_atp_matching <- siop_atp_matching %>%
    mutate(Cat.level1=atpCategory)

# Calculate the XD stocks available
siop_atp_matching <- mutate(siop_atp_matching, 
                            XD_Formula=ifelse(X_Docking-ifelse(Total_Bob_reservations-Ware_house<0,0,
                                                               Total_Bob_reservations-Ware_house)<0,0,
                                              X_Docking-ifelse(Total_Bob_reservations-Ware_house<0,0,
                                                               Total_Bob_reservations-Ware_house)))
# Sort the matched data by Overall Rank of the SKUs
siop_atp_matching <- arrange(siop_atp_matching, Ranking)

save(siop_atp_matching, file = file.path(rDataFile,"siop_atp_matching.RData"))
