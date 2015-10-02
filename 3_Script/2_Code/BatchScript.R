options(java.parameters = "-Xmx6g")
library(dplyr)
library(lubridate)
library(XLConnect)
library(RCurl)

insertRow <- function(existingDF, newrow, r) {
    require(dplyr)
    existingDF <- rbind(existingDF,newrow)
    existingDF <- existingDF[order(c(1:(nrow(existingDF)-1),r-0.5)),]
    row.names(existingDF) <- 1:nrow(existingDF)
    existingDF <- filter(existingDF, !is.na(JobName))
    return(existingDF)  
}

trackingLog <- function(trackingLogDF, jobName, runID, step, activity, description){
    newRecord <- data.frame(jobName, runID, step, activity, Sys.time(), description)
    colnames(newRecord) <- c("JobName", "RunID","Step","Activity","Timestamp","Description")
    insertRow(trackingLogDF, newRecord, 1)
}

runningStep <- function(stepSource, stepName, trackingLogDF, jobName, runID){
    trackingLogDF <- trackingLog(trackingLogDF, jobName, runID,
                                 stepName, "Start", "Step Note")
    
    tryCatch(source(file = stepSource, echo = FALSE),
             error = function(e){
                 trackingLogDF <<- trackingLog(trackingLogDF, jobName, runID,
                                               stepName, "Error", as.character(e))
             },
             warning=function(e) {
                 trackingLogDF <<- trackingLog(trackingLogDF, jobName, runID,
                                               stepName, "Warning", as.character(e))
             },
             finally={
                 
             })
    
    trackingLogDF <- trackingLog(trackingLogDF, jobName, runID,
                                 stepName, "End", "Step Note")
    
    save(trackingLogDF, file = paste0("../3_Log/",jobName,"_",runID,".RData"))
    
    trackingLogDF
}

runningAll <- function(){
    pb <- txtProgressBar(min=0,max=9, style = 3)
    
    jobName <- "SOIP_Automation"
    runID <- format(Sys.time(),"%Y%m%d%H%M")
    
    trackingLogDF <- data.frame(JobName=character(),
                                RunID=character(),
                                Step=character(),
                                Activity=character(),
                                Timestamp=as.POSIXct(character()),
                                Description=character())
    
    
    trackingLogDF <- runningStep(stepSource = "../2_Code/00_Initial_Setup.R", stepName = "00_Initial_Setup", trackingLogDF, jobName, runID)
    setTxtProgressBar(pb, 1)
    trackingLogDF <- runningStep(stepSource = "../2_Code/01_downloadPMPExtracts.R", stepName = "01_downloadPMPExtracts", trackingLogDF, jobName, runID)
    setTxtProgressBar(pb, 2)
    trackingLogDF <- runningStep(stepSource = "../2_Code/02_ATPSIOPMatching.R", stepName = "02_ATPSIOPMatching", trackingLogDF, jobName, runID)
    setTxtProgressBar(pb, 3)
    trackingLogDF <- runningStep(stepSource = "../2_Code/03_PurchasabilityData.R", stepName = "03_PurchasabilityData", trackingLogDF, jobName, runID)
    setTxtProgressBar(pb, 4)
    trackingLogDF <- runningStep(stepSource = "../2_Code/04_RedBlackStockData.R", stepName = "04_RedBlackStockData", trackingLogDF, jobName, runID)
    setTxtProgressBar(pb, 5)
    trackingLogDF <- runningStep(stepSource = "../2_Code/05_arrage_extractValidData.R", 
                                 stepName = "05_arrage_extractValidData", trackingLogDF, jobName, runID)
    setTxtProgressBar(pb, 6)
    trackingLogDF <- runningStep(stepSource = "../2_Code/06_UniqueSupplierList.R", stepName = "06_UniqueSupplierList", trackingLogDF, jobName, runID)
    setTxtProgressBar(pb, 7)
    trackingLogDF <- runningStep(stepSource = "../2_Code/07_whRatiosCalculation.R", stepName = "07_whRatiosCalculation", trackingLogDF, jobName, runID)
    setTxtProgressBar(pb, 8)
    trackingLogDF <- runningStep(stepSource = "../2_Code/08_consolidateDataToExcel.R", stepName = "08_consolidateDataToExcel", trackingLogDF, jobName, runID)
    setTxtProgressBar(pb, 9)
    
    close(pb)
    trackingLogDF
}

runningAll()

