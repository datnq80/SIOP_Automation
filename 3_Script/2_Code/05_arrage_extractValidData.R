# ---- 05_arrage_extractValidData ----

load(file.path(rDataFile,"siop_atp_matching_purchasability_stock.RData"))

finalData <- siop_atp_matching_purchasability_stock %>%
        mutate(CalendarWeekNo=isoweek(now()),
               Sourceability=ifelse(Sourceability_WH1=="",
                                    as.character(Sourceability_WH2),
                                    as.character(Sourceability_WH1)),
               SourcingPrice=ifelse(is.na(Purchase_price_WH1),
                                    Purchase_Price_WH2,
                                    Purchase_price_WH1)) %>%
        select(CalendarWeekNo,
               SkuSimple=SKU,
               Name=product_Name,
               Category=Cat.level1,
               Brand,
               BU=Business_Unit,
               Category_Rank,
               Visibility=Visible,
               Product_Volumetric=Volumetric_cm3,
               Product_Weight=product_weight,
               Preferred_supplier,
               Sourceability,
               SourcingPrice,
               Net_Items_W8,
               Net_Items_W7,
               Net_Items_W6,
               Net_Items_W5,
               Net_Items_W4,
               Net_Items_W3,
               Net_Items_W2,
               Net_Items_W1,
               Purchasability_W_4,
               Purchasability_W_3,
               Purchasability_W_2,
               Purchasability_W_1,
               XD_Formula,
               Red,
               Black1,
               Black2,
               Current_Inventory_WH1,
               In_Transit_WH1,
               Current_Inventory_WH2,
               In_Transit_WH2,
               Ware_house,
               Total_Bob_reservations,
               Overall_Rank,
               Net_Rev_W4,
               Net_Rev_W3,
               Net_Rev_W2,
               Net_Rev_W1,
               Tiering_in_each_CAT,
               Black_Stock_Items,
               payment_terms,
               supplier_type,
               Final_SKU,
               NumberMultisourceSKU,
               tax1,
               tax2,
               PO_Type,
               General_Tiering,
               Purchase_price_WH1,
               Purchase_Price_WH2,
               special_price) 

finalData <- finalData %>%
    mutate(Average_Net_items=(Net_Items_W4+Net_Items_W3+Net_Items_W2+Net_Items_W1)/4) %>%
    mutate(Price_paid_W4=Net_Rev_W4/Net_Items_W4,
           Price_paid_W3=Net_Rev_W3/Net_Items_W3,
           Price_paid_W2=Net_Rev_W2/Net_Items_W2,
           Price_paid_W1=Net_Rev_W1/Net_Items_W1) %>%
    mutate(Average_price_paid=(Price_paid_W4+Price_paid_W3+Price_paid_W2+Price_paid_W1)/4) %>%
    mutate(Price_Elasticity_W4=((Net_Items_W4-Average_Net_items)/Average_Net_items)/((Price_paid_W4-Average_price_paid)/Average_price_paid)) %>%
    mutate(Price_Elasticity_W3=((Net_Items_W3-Average_Net_items)/Average_Net_items)/((Price_paid_W3-Average_price_paid)/Average_price_paid)) %>%
    mutate(Price_Elasticity_W2=((Net_Items_W2-Average_Net_items)/Average_Net_items)/((Price_paid_W2-Average_price_paid)/Average_price_paid)) %>%
    mutate(Price_Elasticity_W1=((Net_Items_W1-Average_Net_items)/Average_Net_items)/((Price_paid_W1-Average_price_paid)/Average_price_paid)) %>%
    mutate(Final_Price_Elasticity_W4=ifelse(((Net_Items_W4-Average_Net_items)/Average_Net_items)>0 &
                                                ((Price_paid_W4-Average_price_paid)/Average_price_paid)<0,
                                            Price_Elasticity_W4,NA)) %>%
    mutate(Final_Price_Elasticity_W3=ifelse(((Net_Items_W3-Average_Net_items)/Average_Net_items)>0 &
                                                ((Price_paid_W3-Average_price_paid)/Average_price_paid)<0,
                                            Price_Elasticity_W3,NA)) %>%
    mutate(Final_Price_Elasticity_W2=ifelse(((Net_Items_W2-Average_Net_items)/Average_Net_items)>0 &
                                                ((Price_paid_W2-Average_price_paid)/Average_price_paid)<0,
                                            Price_Elasticity_W2,NA)) %>%
    mutate(Final_Price_Elasticity_W1=ifelse(((Net_Items_W1-Average_Net_items)/Average_Net_items)>0 &
                                                ((Price_paid_W1-Average_price_paid)/Average_price_paid)<0,
                                            Price_Elasticity_W1,NA))

save(finalData, file = file.path(rDataFile,"finalData.RData"))
