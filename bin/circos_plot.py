#docker run --rm -it -v $PWD:/input nanozoo/pycirclize:3.12--48de646
 #!/usr/bin/env python3
from pycirclize import Circos
from pycirclize.utils import fetch_genbank_by_accid
from pycirclize.parser import Genbank
from pycirclize.parser import Gff
from pycirclize.utils import ColorCycler, load_eukaryote_example_dataset
import pandas as pd
import argparse
import numpy as np
np.random.seed(0)




1. nomale bedfile laden
2 bedfile in + und minus strand aufteilen
bei plus liegt die methylierung an end, bei - am start
bedfile:
contig_1        345     346     m       1       +       0.00
contig_1        348     349     a       1       +       100.00
contig_1        349     350     a       1       +       100.00
contig_1        351     352     a       1       +       0.00
contig_1        352     353     m       1       +       0.00
contig_3        353     354     m       1       +       100.00


circos = Circos.initialize_from_bed("small_bed_bedfile.bed", start=0, end=359, space=3, endspace=False)
for sector in circos.sectors:
     print(sector.start)
     print(sector.end)
 
6321
6322
5398
5399
5210190
5210191
113637
113638
179589
179590
147441
147442

with open("/root/.cache/pycirclize/eukaryote/hg38/hg38_chr.bed") as myfile:
    firstNlines=myfile.readlines()[0:5]
    >>> print(firstNlines)
['#chrom\tchromStart\tchromEnd\tname\n', 'chr1\t0\t248956422\tNC_000001.11\n', 'chr2\t0\t242193529\tNC_000002.12\n', 'chr3\t0\t198295559\tNC_000003.12\n', 'chr4\t0\t190214555\tNC_000004.12\n']

bedfile_path = 'short_pileup.bed'
bed_df = pd.read_csv(bedfile_path, 
                     sep='\t', 
                     header=None, 
                     names=['contig', 'start', 'end', 'type', 'score', 'strand', 'value'])

# Split the dataframe
df_plus = bed_df[bed_df["strand"] == '+']
df_minus = bed_df[bed_df["strand"] == '-']
small_bed = bed_df[bed_df['contig', 'start', 'end', 'value']]

# Define new paths for easier handling and clarify output files
plus_df_filepath = 'plus_df_bedfile.bed'
minus_df_filepath = 'minus_df_bedfile.bed'
small_bed_filepath = 'small_bed_bedfile.bed'




# Save the dataframes to files
df_plus.to_csv(plus_df_filepath, sep="\t", index=False, header=False)
df_minus.to_csv(minus_df_filepath, sep="\t", index=False, header=False)
small_bed.to_csv(small_bed_filepath, sep="\t", index=False, header=False)

plus_df_filepath, minus_df_filepath


# Initialize Circos from BED chromosomes
Circos.genomicInitialize(bed_df)

circos = Circos.initialize_from_bed("minus_df_bedfile.bed", start=0, end=359, space=5, endspace=False)

circos.text("test", size=15)
chr_names = [s.name for s in circos.sectors]

colors = ColorCycler.get_color_list(len(chr_names))
chr_name2color = {name: color for name, color in zip(chr_names, colors)}

    step = 10000000
    x = np.arange(sector.start + (step / 2), sector.end - (step / 2), step)
    y = np.random.randint(0, 100, size=len(x))
    x = [10, 20, 30, 40]
    y = [10, 30, 40, 20]

for sector in circos.sectors:
    # Plot chromosome outer track
    color = chr_name2color[sector.name]
    outer_track = sector.add_track((95, 100))
    outer_track.axis(fc=color)
    # Create example x,y plot data
    sector.text(sector.name, r=110, size=12)
    # Plot line track
    track1 = sector.add_track((80, 90), r_pad_ratio=0.1)
    track1.axis()
    track1.xticks_by_interval(interval=1)
    track2 = sector.add_track((65, 75), r_pad_ratio=0.1)
    track2.axis()
    track2.line(x, y, vmax=100, color="blue")
    # Create example x,y plot data
    # Filter the dataframe for regions corresponding to the current sector
    #sector_df = df_plus[df_plus['contig'] == sector.name] 
    #print(sector.name)
    #sector_df -create array? from dataframe
    #x = sector_df['end']  # Assuming 'end' column exists in bed_df
    #y = sector_df['value']  # Assuming 'value' column exists for plotting
    # Line track
    #track2 = sector.add_track((65, 75), r_pad_ratio=0.1)
    #track2.axis()
    #track2.line(x, y, vmax=100, color="blue")
    

circos.savefig("test" + ".jpg", dpi=150)


sector size is the problem... with my bedfile the sector size is 1 with bedfile human chr its 0 to 57227415
---------------------------

# Initialize Circos instance with genome size
circos = Circos(sectors={gff.name: gff.range_size})
circos.text(f"{gff.name}\n\n{gff.range_size}bp", size=14)
circos.rect(r_lim=(90, 100), fc="lightgrey", ec="none", alpha=0.5)
sector = circos.sectors[0]

# Plot forward strand CDS
f_cds_track = sector.add_track((95, 100))
f_cds_feats = gff.extract_features("CDS", target_strand=1)
f_cds_track.genomic_features(f_cds_feats, plotstyle="arrow", fc=ringnr1, lw=0.5)

# Plot reverse strand CDS
r_cds_track = sector.add_track((90, 95))
r_cds_feats = gff.extract_features("CDS", target_strand=-1)
r_cds_track.genomic_features(r_cds_feats, plotstyle="arrow", fc=ringnr2, lw=0.5)

# Plot 'gene' qualifier label if exists
labels, label_pos_list = [], []
for feat in gff.extract_features("CDS"):
    start = int(str(feat.location.start))
    end = int(str(feat.location.end))
    label_pos = (start + end) / 2
    gene_name = feat.qualifiers.get("gene", [None])[0]
    name = feat.qualifiers.get("Name", [""])[0]
    if len(name) > int(charlimit):
        name = name[:int(charlimit)] + "..."    
    if gene_name is not None:
        labels.append(gene_name)
        label_pos_list.append(label_pos)
    else:
        labels.append(name)
        label_pos_list.append(label_pos)

f_cds_track.xticks(label_pos_list, labels, label_size=6, label_orientation="vertical")

# Plot xticks (interval = 10 Kb)
r_cds_track.xticks_by_interval(
    10000, outer=False, label_formatter=lambda v: f"{v/1000:.1f} Kb"
)

circos.savefig(plotname + "_" + contigname + ".jpg", dpi=150)
circos.savefig(plotname + "_" + contigname + ".svg", dpi=150)