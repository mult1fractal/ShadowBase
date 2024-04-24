#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
* Nextflow -- Genome Analysis Pipeline
* Author: CaSe-group
*/

/************************** 
* HELP messages & checks
**************************/
// help message
if ( params.help ) { exit 0, helpMSG() }

// error codes
if ( params.profile ) { exit 1, "[--profile] is WRONG use [-profile]." }
if ( !workflow.profile.contains('test') && !params.fasta && !params.ont && !params.paired && !params.fastq_pass ) { exit 1, "Input missing. Please use --help maybe a typo?" }

// DEFAULT MESSAGE

 defaultMSG()

/************************** 
* INPUTs
**************************/

// pod5 input

// Pod5_pass input

// Bam file input
    if ( params.bam ) { 
        bam_raw_ch = Channel.fromPath( params.bam, checkIfExists: true)
        .map { it -> tuple(it.baseName, it) } }
    else { bam_raw_ch = Channel.empty() }

// fasta-ref file input
    if ( params.fasta_ref ) { 
        fasta_raw_ch = Channel.fromPath( params.fasta_ref, checkIfExists: true)
        .map { it -> tuple(it.baseName, it) } }
    else { fasta_raw_ch = Channel.empty() }

/************************** 
* Workflows
**************************/

include { motifs_wf } from './workflows/motifs_wf.nf'


/************************** 
* MAIN WORKFLOW
**************************/


// 1. Motif calling
        /*** microbemod ***/
        ont_reads_to_assembly = motifs_wf(bam_raw_ch, fasta_raw_ch)
        


