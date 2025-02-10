docker run --rm -it -v $PWD:/input rocker/tidyverse:4.3.1 /bin/bash

install.packages("circlize")
library(tidyverse)
library(dplyr)

library(circlize)
setwd("/input")

data <- read.delim("small_bed_bedfile.bed", sep = "\t")
header <- c('contig', 'start', 'end', 'type', 'score', 'strand', 'value') # Adjust based on your file, this is just an example
data <- read.delim("short_pileup.bed", header = FALSE, col.names = header, sep = "\t")

png("your_plot_name.png")


# Initialize circos layout with unique sectors
sectors <- unique(data$contig)
# Adjust cell padding
circos.par(cell.padding = c(0, 0, 0, 0))

# Finding the range for y globally to keep the scale consistent across sectors
global_y_range <- range(data$value)

circos.initialize(factors = sectors, x = rep(1, length(sectors)))


circos.initialize(factors = sectors, xlim = cbind(min(data$start), max(data$end)))

# Adjust global circos plot parameters if needed
circos.par(gap.degree = 1)  # Adjust the gap between sectors if necessary

# Create track(s)
circos.trackPlotRegion(factors = data$contig, y = global_y_range, bg.border = NA, track.height = 0.1, panel.fun = function(x, y) {
  sector.name <- get.cell.meta.data("sector.index")
  subdata <- subset(data, contig == sector.name)
  circos.lines(subdata$start, subdata$value, col = "red")  # Example of adding lines, adjust as necessary
  circos.text(mean(subdata$start), max(subdata$value), labels = sector.name, cex = 0.6, facing = "clockwise", niceFacing = TRUE)
}, bg.bg = NA)

# Add more tracks as necessary, for example, to add highlights or other annotations

# When done, generate the plot
dev.off()  # if you're generating the plot to a file


dev.off()
