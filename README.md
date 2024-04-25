
![](https://img.shields.io/badge/licence-GPL--3.0-lightgrey.svg)


![](https://img.shields.io/badge/nextflow-20.07.1-brightgreen)
![](https://img.shields.io/badge/uses-docker-blue.svg)


[![Twitter Follow](https://img.shields.io/twitter/follow/mult1fractal.svg?style=social)](https://twitter.com/mult1fractal) 

# Pop the Mod (PtM)

* by  Mike Marquet
* **this tool is under active development,feel free to report issues and add suggestions**
 


# What is this repo

#### TL;DR
easy way to analyze DNA Modifications of Nanopore Sequencing data
single sample analysis
multi sample analysis (every sample can use a different reference sequence)


# Included tools

[modkit]()
[microbeMod]()


I want to integrate dorado for Basecalling, Visualization 






--------------------------------------------------------------

# Documentation 


 Single Sample Input
    nextflow run main.nf --fasta_ref test_data/ref-fasta/barcode20.fasta --bam test_data/bam-files/barcode20.bam --output test -work-dir /home/x/Workflows/pop_the_mod/work/ -profile local,docker

    Multi Sample Input (multi reference)
    nextflow run main.nf --samples test_data/multi.csv --output test/samples -work-dir /home/x/Workflows/pop_the_mod/work/ -profile local,docker


    provide a samples.csv file like this:
    A,/home/x/Workflows/pop_the_mod/test_data/bam-files/barcode20.bam,/home/x/Workflows/pop_the_mod/test_data/ref-fasta/barcode20.fasta
    B,/home/x/Workflows/pop_the_mod/test_data/bam-files/barcode21.bam,/home/x/Workflows/pop_the_mod/test_data/ref-fasta/barcode21.fasta
    C,/home/x/Workflows/pop_the_mod/test_data/bam-files/barcode22.bam,/home/x/Workflows/pop_the_mod/test_data/ref-fasta/barcode22.fasta
