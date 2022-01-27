library(tidyverse)
library(UpSetR)
library(readxl)

#Make UpSet Plot of transcript data
#First read all sheets in your excel file
sets <- excel_sheets(path = "IAA_30_Transc_DE_UpDown_Table.xlsx")

#create a list with each separate dataset
fullUpDnDE <- list()
for (i in 1:length(sets)) {
  fullUpDnDE[[i]] <- read_excel(path = "IAA_30_Transc_DE_UpDown_Table.xlsx", sheet = i, col_types = c("text", "numeric"))
}
#join all the datasets into one binary matrix
fullUpDnDE <- reduce(fullUpDnDE, full_join, by = "Accession")
fullUpDnDE[is.na(fullUpDnDE)] <- 0
fullUpDnDE <- as.data.frame(fullUpDnDE)
fullUpDnDE[-1] <- lapply(X = fullUpDnDE[-1], function(x) as.integer(x))
colnames(fullUpDnDE) <- c("Accession", sets)
fullUpDnDE$Accession <- as.factor(fullUpDnDE$Accession)

setEPS()
postscript("30min_IAA_upset_transcripts.eps", width = 55, height = 20)
upset(fullUpDnDE, nsets = 8, nintersects = 20, order.by = "freq", point.size = 8, line.size = 3.5, keep.order = T, 
mainbar.y.label = "Shared transcripts", sets.x.label = "Total DE Transcripts",
mb.ratio = c(0.55,0.45), text.scale = c(8,8,4.5,5,5,7), number.angles = 30)
dev.off()

pdf(file = "30min_IAA_upset_transcripts.pdf", width = 55, height = 20, fonts = "sans")
upset(fullUpDnDE, nsets = 8, nintersects = 20, empty.intersections = "on", order.by = "freq", point.size = 8, line.size = 3.5, keep.order = T,
      mainbar.y.label = "Shared Transcripts", sets.x.label = "Total DE Transcripts",
      mb.ratio = c(0.55,0.45), text.scale = c(8,8,4.5,5,5,7), number.angles = 30)
dev.off()

svg("30min_IAA_upset_transcripts.svg", width = 55, height = 20)
upset(fullUpDnDE, nsets = 8, nintersects = 20, empty.intersections = "on", order.by = "freq", point.size = 8, line.size = 3.5, keep.order = T,
      mainbar.y.label = "Shared Transcripts", sets.x.label = "Total DE Transcripts",
      mb.ratio = c(0.55,0.45), text.scale = c(8,8,4.5,5,5,7), number.angles = 30)
dev.off()
