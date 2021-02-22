library(readxl)
library(tidyverse)
library(RColorBrewer)
library(viridis)
library(circlize)
library(ComplexHeatmap)


# For our heatmaps, we first read out value table
pheno <- read_csv("phenotype_results_heatmap_logFC.csv")
pheno %>% select(3,4) %>% column_to_rownames(var = "mutant") %>% as.matrix ->BLdat
pheno %>% select(3,6) %>% column_to_rownames(var = "mutant") %>% as.matrix ->MDCdat
pheno %>% select(3,8) %>% column_to_rownames(var = "mutant") %>% as.matrix ->MDCsucdat
pheno %>% select(3,10) %>% column_to_rownames(var = "mutant") %>% as.matrix ->GFPdat

BL <- Heatmap(matrix = t(BLdat),
              name = "BL treatment\nWT-normalized hypocotyl\n[BL/mock] growth FC",
              border = T,
              col = viridis(100),
              row_names_side = "left",
              row_labels = "BL",
              cluster_rows = FALSE,
              cluster_columns = FALSE,
              rect_gp = gpar(col = "white", lwd = 1),
              column_names_gp = gpar(fontface = "italic", fontsize = 10),
              heatmap_legend_param = list(legend_width = unit(6, "cm"),direction = "horizontal", title_position = c("topcenter")),
              cell_fun = function(j, i, x, y, width, h, fill) {
                grid.text(ifelse(na.omit(pheno[j,5] <= 0.1), yes = "*", no = ""), x = x, y-h*0.15,
                          gp = gpar(fontsize = 18, fontface = "bold", col = "black"))
        })

col_funMDC <- colorRamp2(c(-6, 0, 6),plasma(3))
MDC <- Heatmap(matrix = t(MDCdat),
               name = "MDC staining\nAutophagosomes per frame\n[mut/WT] FC",
               col = col_funMDC,
               border = T,
               row_names_side = "left",
               row_labels = "MDC",
               cluster_rows = FALSE,
               cluster_columns = FALSE,
               rect_gp = gpar(col = "white", lwd = 1),
               column_names_gp = gpar(fontface = "italic", fontsize = 10),
               heatmap_legend_param = list(legend_width = unit(6, "cm"),direction = "horizontal", title_position = c("topcenter")),
               cell_fun = function(j, i, x, y, width, h, fill) {
                 grid.text(ifelse(na.omit(pheno[j,7] <= 0.05), yes = "*", no = ""), x, y-h*0.15,
                           gp = gpar(fontsize = 18, fontface = "bold", col = "#7F878F"))
               })

MDCsuc <- Heatmap(matrix = t(MDCsucdat),
                  name = "MDC staining (sucrose starvation)\n WT-nomalized\nAutophagosomes per frame\n[suc-/suc+] FC",
                  col = col_funMDC,
                  border = T,
                  row_names_side = "left",
                  row_labels = "MDC (stress)",
                  cluster_rows = FALSE,
                  cluster_columns = FALSE,
                  rect_gp = gpar(col = "white", lwd = 1),
                  column_names_gp = gpar(fontface = "italic", fontsize = 10),
                  heatmap_legend_param = list(legend_width = unit(6, "cm"),direction = "horizontal", title_position = c("topcenter")),
                  cell_fun = function(j, i, x, y, width, h, fill) {
                    grid.text(ifelse(na.omit(pheno[j,9] <= 0.05), yes = "*", no = ""), x, y-h*0.15,
                           gp = gpar(fontsize = 18, fontface = "bold", col = "#7F878F"))
               })

col_funGFP <- colorRamp2(c(-2, 0, 2),plasma(3))
GFP <- Heatmap(matrix = t(GFPdat),
               name = "GFP-ATG8e\nProtoplasts or root cells with high\nautophagy [mut/WT] FC",
               col = col_funGFP,
               border = T,
               row_names_side = "left",
               cluster_rows = FALSE,
               cluster_columns = FALSE,
               rect_gp = gpar(col = "white", lwd = 1),
               column_names_gp = gpar(fontface = "italic", fontsize = 10),
               heatmap_legend_param = list(legend_width = unit(6, "cm"),direction = "horizontal", title_position = c("topcenter")),
               cell_fun = function(j, i, x, y, width, h, fill) {
                 grid.text(ifelse(na.omit(pheno[j,11] <= 0.054), yes = "*", no = ""), x, y-h*0.15,
                           gp = gpar(fontsize = 18, fontface = "bold", col = "#7F878F"))
               })

ht_list = BL %v% MDC %v% MDCsuc %v% GFP
draw(ht_list, ht_gap = unit(0, "cm"), heatmap_legend_side = "bottom")

pdf(file = "Fig5_heatmap_logFC.pdf", width = 16, height = 4, fonts = "sans")
draw(ht_list, ht_gap = unit(0, "cm"), heatmap_legend_side = "bottom")
dev.off()

svg("phenotype_heatmap.svg", width = 45, height = 5)
draw(ht_list, ht_gap = unit(0, "cm"), heatmap_legend_side = "bottom")
dev.off()

