# ---- 00_InitialSetup ----

venture <- as.character(args[1])
ventureShort <- switch (venture,
                        "Indonesia" = "ID",
                        "Malaysia" = "MY",
                        "Philippines" = "PH",
                        "Singapore" = "SG",
                        "Thailand" = "TH",
                        "Vietnam" = "VN")

dateReport <- format(now(), "%Y%m%d")
weekReport <- paste0("Week",isoweek(now()))
rawDataFile <- file.path("../..","1_Input",venture,"PMP_Data")
rawDataFileDaily <- file.path("../..","1_Input",venture,"PMP_Data",dateReport)
rawDataFileWeekly <- file.path("../..","1_Input",venture,"PMP_Data",weekReport)
manualInputFile <- file.path("../../1_Input",venture)
rDataFile <- file.path("../4_RData",venture)
outputFolder <- file.path("../../2_Output",venture,dateReport)
if (!dir.exists(rawDataFileDaily)) {
        dir.create(rawDataFileDaily)
}
if (!dir.exists(rawDataFileWeekly)) {
        dir.create(rawDataFileWeekly)
}
if (!dir.exists(outputFolder)) {
        dir.create(outputFolder)
}
if (!dir.exists(rDataFile)) {
    dir.create(rDataFile)
}

for (ifile in list.files(rDataFile)){
    unlink(file.path(rDataFile,ifile))
}

tempwb <- loadWorkbook(file.path(manualInputFile,"Script_Params.xlsx"))
params <- readWorksheet(tempwb, 1)
row.names(params) <- params$Parameter
param_1 <- as.numeric(params$Value[1])
if (!is.na(param_1)){
    ATPShortTailType <- "Category_Percentile"
    Threshold <- param_1
} else{
    param_2 <- as.numeric(params$Value[2])
    ATPShortTailType <- "Category_Rank"
    Threshold <- param_2
}
SKURankingMethod <- trimws(params$Value[3])
