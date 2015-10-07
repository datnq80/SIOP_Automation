# ---- 08_consolidateDataToExcel ----

load(file.path(rDataFile,"finalData.RData"))
load(file.path(rDataFile,"uniqueSupplier.RData"))
load(file.path(rDataFile,"whRatios.RData"))
write.csv(finalData, file.path(outputFolder,"Basis_SQL_New.csv"), row.names = FALSE)
write.csv(whRatios, file.path(outputFolder,"whRatios.csv"), row.names = FALSE)
write.csv(uniqueSupplier, file.path(outputFolder,"Seller_List.csv"), row.names = FALSE)
unlink(file.path("../5_Batch",venture,"Basis_SQL_New.csv"))
unlink(file.path("../5_Batch",venture,"whRatios.csv"))
unlink(file.path("../5_Batch",venture,"Seller_List.csv"))
file.copy(file.path(outputFolder,"Basis_SQL_New.csv"), file.path("../5_Batch",venture,"Basis_SQL_New.csv"))
file.copy(file.path(outputFolder,"whRatios.csv"), file.path("../5_Batch",venture,"whRatios.csv"))
file.copy(file.path(outputFolder,"Seller_List.csv"), file.path("../5_Batch",venture,"Seller_List.csv"))

macroFile <- file.path("../5_Batch",venture,paste0(ventureShort,"_Bottom Up_SI&OP MWH.xlsb"))
if (file.exists(macroFile))
    unlink(macroFile)
file.copy(file.path("../../1_Input",venture,"Output_Templates",paste0(ventureShort,"_Bottom Up_SI&OP MWH.xlsb")),
          macroFile)

setwd(file.path("../5_Batch",venture))
system(paste0("cscript ",ventureShort,"_ExcelVBATrigger.vbs"))
setwd("../../2_Code/")

finalFile <- file.path(outputFolder,paste0(ventureShort,"_Bottom Up_SI&OP MWH_Test_",dateReport,".xlsb"))

if (file.exists(finalFile))
    unlink(finalFile)
file.copy(file.path("../5_Batch/",venture,paste0(ventureShort,"_Bottom Up_SI&OP MWH_Final.xlsb")),
          finalFile)

