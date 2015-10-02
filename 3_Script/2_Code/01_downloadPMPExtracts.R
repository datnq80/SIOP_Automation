# ---- 01_downloadPMPExtracts ----

# Daily download
extractListDaily <- c("SIOP_VN_multi_WH_Test",
                      "ATP Multisource VN 800",
                      "Outright Inventory Ex VN")
extractDailyExtension <- c("csv","zip","csv")
dateReportDownload <- format(now(), "%Y-%m-%d")
for (i in 1:length(extractListDaily)){
        file <- extractListDaily[i]
        ext <- extractDailyExtension[i]
        destFile <- file.path(rawDataFileDaily,paste(file,".",ext,sep = ""))
        fileUrl <- paste("http://reports.pmp.lazada.com/",file,"_",venture,"_",dateReportDownload,".",ext,sep = "")
        fileUrl <- gsub(" ", "%20",fileUrl)
        if (url.exists(fileUrl)){
                if (!file.exists(destFile)){
                        download.file(fileUrl,destFile)
                }
                if(ext=="zip")
                        unzip(destFile,exdir = rawDataFileDaily)
        }
}

# Weekly download
extractsWeekly <- c("Sales_Destinations_Levels",
                    "Purchasability_last_7days")
extractsWeeklyExtension <- c("csv","csv")
extractsWeeklyWeekday <- c("Monday","Monday") #Not used

for (i in 1:length(extractsWeekly)){
        file <- extractsWeekly[i]
        ext <- extractsWeeklyExtension[i]
        weekdayExtract <- extractsWeeklyWeekday[i]
        tryCatch({
                destFile <- file.path(rawDataFileWeekly,paste(file,".",ext,sep = ""))
                fileUrl <- paste("http://reports.pmp.lazada.com/",file,"_",venture,"_",dateReportDownload,".",ext,sep = "")
                fileUrl <- gsub(" ", "%20",fileUrl)
                if (url.exists(fileUrl)){
                        if (!file.exists(destFile)){
                                download.file(fileUrl,destFile)
                        }
                        if(ext=="zip")
                                unzip(destFile,exdir = rawDataFileDaily)
                }
        }, error = function(e) {
                print(e)
        })
}

