#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
* Nextflow -- methylation-calling
* Author: CaSe-group, mqt
*/

/************************** 
* HELP messages & checks
**************************/
// help message
if ( params.help ) { exit 0, helpMSG() }

// error codes
if ( params.profile ) { exit 1, "[--profile] is WRONG use [-profile]." }
//if ( !workflow.profile.contains('test') && !params.fasta_ref && !params.bam ) { exit 1, "Input missing. Please use --help maybe a typo?" }

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
        //.map { it -> tuple(it.baseName, it) } 
        }
    else { fasta_raw_ch = Channel.empty() }

// multiple files to analyse, provide: name, bam, corresponding ref-fasta
    if (params.samples) { 
        samples_input_ch = Channel.fromPath( params.samples, checkIfExists: true)
            .splitCsv(header: false, sep: ',', strip: true )
            .map { row -> tuple("${row[0]}" ,file(row[1], checkIfExists: true), file(row[2], checkIfExists: true)) }
        }    
    // 
    else { samples_input_ch = Channel.empty() }


/************************** 
* Workflows
**************************/

include { motifs_wf } from './workflows/motifs_wf.nf'


/************************** 
* MAIN WORKFLOW
**************************/
workflow {



// 1. Motif calling
        /*** microbemod ***/
        motif_ch =  bam_raw_ch
                    .combine(fasta_raw_ch)
                    .mix(samples_input_ch)
                     

         motifs_wf(motif_ch)
        //if (!params.bam && !params.fasta_ref && params.samples) { motifs_wf(bam_raw_ch, fasta_raw_ch) }


}
        

def defaultMSG() {
    c_green = "\033[0;32m";
    c_reset = "\033[0m";
    c_yellow = "\033[0;33m";
    c_blue = "\033[0;34m";
    c_dim = "\033[2m";
    log.info """
    ________________________________________________________________________________

    ${c_green}Pop the Mod${c_reset} | Methylation calling
    ________________________________________________________________________________
    ${c_green}
    Profile:                     $workflow.profile ${c_reset}
    ${c_dim}
    Current User:                $workflow.userName
    Nextflow-version:            $nextflow.version
    Max cores [--max_cores]:     $params.max_cores
    Threads / process [--cores]: $params.cores

    Output dir [--output]: 
        $params.output
    \033[2mWorkdir[-work-Dir]:
        $workflow.workDir ${c_reset}
    ________________________________________________________________________________

    
    Single Sample Input
    nextflow run main.nf --fasta_ref test_data/ref-fasta/barcode20.fasta --bam test_data/bam-files/barcode20.bam --output test -work-dir /home/x/Workflows/pop_the_mod/work/ -profile local,docker

    Multi Sample Input (multi reference)
    nextflow run main.nf --samples test_data/multi.csv --output test/samples -work-dir /home/x/Workflows/pop_the_mod/work/ -profile local,docker


    provide a samples.csv file like this:
    A,/home/x/Workflows/pop_the_mod/test_data/bam-files/barcode20.bam,/home/x/Workflows/pop_the_mod/test_data/ref-fasta/barcode20.fasta
    B,/home/x/Workflows/pop_the_mod/test_data/bam-files/barcode21.bam,/home/x/Workflows/pop_the_mod/test_data/ref-fasta/barcode21.fasta
    C,/home/x/Workflows/pop_the_mod/test_data/bam-files/barcode22.bam,/home/x/Workflows/pop_the_mod/test_data/ref-fasta/barcode22.fasta



    ${c_reset}________________________________________________________________________________

    """.stripIndent()

}

