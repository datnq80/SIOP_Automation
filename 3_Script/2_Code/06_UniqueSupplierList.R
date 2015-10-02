# ---- 06_UniqueSupplierList ----

load(file.path(rDataFile,"finalData.RData"))
uniqueSupplier <- as.data.frame(unique(finalData$Preferred_supplier))

colnames(uniqueSupplier) <- c("Supplier")

save(uniqueSupplier,
     file = file.path(rDataFile,"uniqueSupplier.RData"))