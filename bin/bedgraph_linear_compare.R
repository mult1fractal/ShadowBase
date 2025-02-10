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
files <- list.files(pattern = "bedgraph$")

# Daten einlesen und kombinieren

read_and_append_filename <- function(filename) {
  # Read the file assuming no header, dynamically handling varying row lengths
  df <- read.table(filename, header = FALSE, fill = TRUE)  
  # Manually assign column names (if known in advance)
  colnames(df) <- c("contig", "start", "end", "Value", "V5") # Adjust column names based on your data structure
  df$Filename <- filename  # Append filename as a new column
  return(df)
}

# Combine the data from all files into a single dataframe
combined_df <- do.call(rbind, lapply(file_list, read_and_append_filename))

# View the combined dataframe
print(combined_df)


# Plot theme 
uniformtheme <- theme_classic() +
		 	theme(legend.position="right", legend.direction="vertical") +
			# theme(legend.position = "none") +
      theme(legend.key.height= unit(3, 'cm'),
            legend.key.width= unit(0.5, 'cm'))+
      theme(plot.title = element_text(size=30))+
      theme(text = element_text(size=30), axis.text.x = element_text(angle = 45, hjust = 1))


plot <- ggplot(data = combined_df, aes(x=V2, y=V4)) + 
    geom_bar(stat="identity") +
    geom_tile(width=0.99, height=0.99) +
    labs(x="genome position", y="methylation likelyhood", fill="contig") +
    labs(title = "Methylation frequency bedfile") +
	  uniformtheme
    #scale_fill_gradient(colours=c("#B6A1CE", "#8c6bb1", "#88419d", "#6e016b"))
    # scale_fill_gradient(low = "white", high = "steelblue")  
print(plot)


pdf('Methylation_motifs_bar.pdf', width=25, height=5)
plot
dev.off()
