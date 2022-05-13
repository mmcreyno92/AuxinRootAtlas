library(tidyverse)
library(UpSetR)
library(readxl)

#Make UpSet Plot of transcript data
#First read all sheets in your excel file
sets <- excel_sheets(path = "IAA_120_Transc_DE_UpDown_Table.xlsx")

#create a list with each separate dataset
fullUpDnDE <- list()
for (i in 1:length(sets)) {
  fullUpDnDE[[i]] <- read_excel(path = "IAA_120_Transc_DE_UpDown_Table.xlsx", sheet = i, col_types = c("text", "numeric"))
}
#join all the datasets into one binary matrix
fullUpDnDE <- reduce(fullUpDnDE, full_join, by = "Accession")
fullUpDnDE[is.na(fullUpDnDE)] <- 0
fullUpDnDE <- as.data.frame(fullUpDnDE)
fullUpDnDE[-1] <- lapply(X = fullUpDnDE[-1], function(x) as.integer(x))
colnames(fullUpDnDE) <- c("Accession", sets)
fullUpDnDE$Accession <- as.factor(fullUpDnDE$Accession)

#Extract gene ids from the sets, use filter to pick sets of interest to extract, example given is for 3 samples EZ, C, and S tissue auxin 120 min treatment up
#Comment this block out if you only need UPSET plot and not gene IDs from specific sets
fullUpDnDE %>%
  filter(.$`EZ auxin t120 up` == 1 & .$`C auxin t120 up` == 1 & .$`S auxin t120 up` ==1) %>% #add column ids here
  rowwise() %>%
  mutate(sumChk = sum(c_across(2:9))) %>% #should be 2:file final column number of input data
  filter(sumChk == 3) %>% #number equals number of comparisons in set
  select(1) %>%
  write_csv("EZ_aux_up_C_aux_up_S_aux_up.csv") #change csv file name here
 
setEPS() #Create UpSet Plot image as a .EPS
postscript("120min_IAA_upset_transcripts.eps", width = 55, height = 20)
upset(fullUpDnDE, nsets = 8, nintersects = 20, empty.intersections = "on", order.by = "freq", point.size = 18, line.size = 3.5, keep.order = T,
      mainbar.y.label = "Shared Transcripts", sets.x.label = "Total DE Transcripts",
      mb.ratio = c(0.55,0.45), text.scale = c(8,8,4.5,5,8,8), number.angles = 0)
dev.off()

pdf(file = "120min_IAA_upset_transcripts.pdf", width = 55, height = 20, fonts = "sans") #Create Upset Plot image as a .PDF
upset(fullUpDnDE, nsets = 8, nintersects = 20, empty.intersections = "on", order.by = "freq", point.size = 18, line.size = 3.5,
      mainbar.y.label = "Shared Transcripts", sets.x.label = "Total DE Transcripts",
      mb.ratio = c(0.55,0.45), text.scale = c(8,8,4.5,5,8,8), number.angles = 0)
dev.off()

svg("120min_IAA_transcriptUpSet.svg", width = 55, height = 20) #Create Upset Plot image as a .SVG
upset(fullUpDnDE, nsets = 8, nintersects = 20, empty.intersections = "on", order.by = "freq", point.size = 18, line.size = 3.5, keep.order = T,
      mainbar.y.label = "Shared Transcripts", sets.x.label = "Total DE Transcripts",
      mb.ratio = c(0.55,0.45), text.scale = c(8,8,4.5,5,8,8), number.angles = 0)
dev.off()
