#!/usr/bin/env Rscript

library(tidyverse)
library(dplyr)

#docker run --rm -it -v $PWD:/input rocker/tidyverse:4.3.1 /bin/bash
## library(tidyverse)
## library(dplyr)

# setwd("/input")


###########################################################
## inputs
###########################################################
args <- commandArgs(trailingOnly = TRUE)
fileout <- args[length(args)] # Letztes Argument ist die Ausgabedatei
filein <- args[-length(args)] # Alle anderen Argumente sind Eingabedateien


# Dateinamen laden
files <- list.files(pattern = "motifs.tsv$")

# Daten einlesen und kombinieren

combined_data <- bind_rows(lapply(files, function(file) {
  # Datei lesen
  data <- read.delim(file, sep = "\t")
  
  # Dateinamen als neue Spalte hinzufügen
  data$Filename <- file
  
  return(data)
  
  }), .id = "id")

# Ergebnis anzeigen
print(combined_data)

# Plot theme 
uniformtheme <- theme_classic() +
		 	theme(legend.position="right", legend.direction="vertical") +
			# theme(legend.position = "none") +
      theme(legend.key.height= unit(3, 'cm'),
            legend.key.width= unit(0.5, 'cm'))+
      theme(plot.title = element_text(size=30))+
      theme(text = element_text(size=30), axis.text.x = element_text(angle = 45, hjust = 1))


plot <- ggplot(data = combined_data, aes(x=Motif, y=Filename, fill=Genome_sites)) + 
    facet_grid(. ~ Methylation_type) +
    geom_tile(width=0.99, height=0.99) +
    labs(x="Motifs", y="Sample", fill="Genome_sites") +
    labs(title = "Methylation mofis") +
	  uniformtheme +
    #scale_fill_gradient(colours=c("#B6A1CE", "#8c6bb1", "#88419d", "#6e016b"))
    scale_fill_gradient(low = "white", high = "steelblue")  
print(plot)


# pdf("Methylation_motifs.pdf",height = 10, width = 25) 
pdf(fileout,height = 10, width = 25) 
plot
dev.off()
#pdf("phage-distribution.pdf") 