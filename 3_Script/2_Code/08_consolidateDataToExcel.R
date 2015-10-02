# ---- 08_consolidateDataToExcel ----

load(file.path(rDataFile,"finalData.RData"))
load(file.path(rDataFile,"uniqueSupplier.RData"))
load(file.path(rDataFile,"whRatios.RData"))
write.csv(finalData, file.path(outputFolder,"Basis_SQL_New.csv"), row.names = FALSE)
write.csv(whRatios, file.path(outputFolder,"whRatios.csv"), row.names = FALSE)
write.csv(uniqueSupplier, file.path(outputFolder,"Seller_List.csv"), row.names = FALSE)
unlink("../5_Batch/Basis_SQL_New.csv")
unlink("../5_Batch/whRatios.csv")
unlink("../5_Batch/Seller_List.csv")
file.copy(file.path(outputFolder,"Basis_SQL_New.csv"), "../5_Batch/Basis_SQL_New.csv")
file.copy(file.path(outputFolder,"whRatios.csv"), "../5_Batch/whRatios.csv")
file.copy(file.path(outputFolder,"Seller_List.csv"), "../5_Batch/Seller_List.csv")

macroFile <- file.path("../5_Batch/VN_Bottom Up_SI&OP MWH.xlsb")
if (file.exists(macroFile))
        unlink(macroFile)
file.copy("../../1_Input/Vietnam/Output_Templates/VN_Bottom Up_SI&OP MWH.xlsb",
          macroFile)

setwd("../5_Batch/")
system(paste0("cscript ExcelVBATrigger.vbs"))
setwd("../2_Code/")

finalFile <- file.path(outputFolder,paste0("VN_Bottom Up_SI&OP MWH_Test_",dateReport,".xlsb"))

if (file.exists(finalFile))
        unlink(finalFile)
file.copy("../5_Batch/VN_Bottom Up_SI&OP MWH_Final.xlsb",
          finalFile)
