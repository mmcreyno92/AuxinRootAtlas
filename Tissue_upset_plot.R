library(tidyverse)
library(UpSetR)
library(readxl)

#Make UpSet Plot of transcript data
#First read all sheets in your excel file
sets <- excel_sheets(path = "30minTISSUE_Transc_DE_UpDown_Table.xlsx")

#create a list with each separate dataset
fullUpDnDE <- list()
for (i in 1:length(sets)) {
  fullUpDnDE[[i]] <- read_excel(path = "30minTISSUE_Transc_DE_UpDown_Table.xlsx", sheet = i, col_types = c("text", "numeric"))
}
#join all the datasets into one binary matrix
fullUpDnDE <- reduce(fullUpDnDE, full_join, by = "Accession")
fullUpDnDE[is.na(fullUpDnDE)] <- 0
fullUpDnDE <- as.data.frame(fullUpDnDE)
fullUpDnDE[-1] <- lapply(X = fullUpDnDE[-1], function(x) as.integer(x))
colnames(fullUpDnDE) <- c("Accession", sets)
fullUpDnDE$Accession <- as.factor(fullUpDnDE$Accession)

setEPS()
postscript("30minTissue_upset_transcripts.eps", width = 25, height = 15)
upset(fullUpDnDE, nsets = 17, nintersects = 50, order.by = "freq", point.size = 8, line.size = 3.5, keep.order = T, 
mainbar.y.label = "Shared Transcripts", sets.x.label = "Total DE transcripts",
mb.ratio = c(0.55,0.45), text.scale = c(6,5,4,5,4,3), number.angles = 30)
dev.off()

pdf(file = "30minTissue_upset_transcripts.pdf", width = 50, height = 30, fonts = "sans")
upset(fullUpDnDE, nsets = 20, nintersects = 75, order.by = "freq", point.size = 8, line.size = 3.5, keep.order = T,
      mainbar.y.label = "Shared Transcripts", sets.x.label = "Total DE transcripts",
      mb.ratio = c(0.55,0.45), text.scale = c(6,5,4,5,4,3), number.angles = 20)
dev.off()

svg("30minTissueTranscriptUpSet.svg", width = 25, height = 15)
upset(fullUpDnDE, sets = c(colnames(select(fullUpDnDE,matches("transc")))), point.size = 8, line.size = 3.5, keep.order = T,
      mainbar.y.label = "Shared transcripts", sets.x.label = "Total DE transcripts",
      mb.ratio = c(0.55,0.45), text.scale = c(6,5,4,5,4,3), number.angles = 30)
dev.off()

