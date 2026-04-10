#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
* Nextflow -- methylation-calling
* Author: CaSe-group, mqt
*/

/************************** 
* Includes
**************************/
include { helpMSG; defaultMSG; progressBar } from './libs/messages.nf'
include { motifs_wf } from './workflows/motifs_wf.nf'

/************************** 
* MAIN WORKFLOW
**************************/
workflow {

    params.help ? { exit 0, helpMSG() }() : defaultMSG()

/************* 
* ERROR HANDLING
*************/
    // profiles
    if ( workflow.profile == 'standard' ) { exit 1, "NO VALID EXECUTION PROFILE SELECTED, use e.g. [-profile local,docker]" }

    if (
        workflow.profile.contains('singularity') ||
        workflow.profile.contains('stub') ||
        workflow.profile.contains('docker')
        ) { "engine selected" }
    else { exit 1, "No engine selected:  -profile EXECUTER,ENGINE" }

    if (
        workflow.profile.contains('local') ||
        workflow.profile.contains('test') ||
        workflow.profile.contains('slurm') ||
        workflow.profile.contains('lsf') ||
        workflow.profile.contains('ukj_cloud') ||
        workflow.profile.contains('stub')
        ) { "executer selected" }
    else { exit 1, "No executer selected:  -profile EXECUTER,ENGINE" }

    if ( workflow.profile.contains('singularity') ) {
        println ""
        println "\033[0;33mWARNING: Singularity image building sometimes fails!"
        println "Multiple resumes (-resume) and --max_cores 1 --cores 1 for local execution might help.\033[0m\n"
    }

    // params tests
    if ( !params.fasta_ref && !params.bam && !params.samples && !workflow.profile.contains('test') ) { 
        exit 1, "Input missing. Please use --help maybe a typo?" 
    }

/************* 
* INPUT HANDLING
*************/

    // Bam file input
    bam_raw_ch = params.bam ? 
        Channel.fromPath(params.bam, checkIfExists: true).map { it -> tuple(it.baseName, it) } : 
        Channel.empty()

    // fasta-ref file input
    fasta_raw_ch = params.fasta_ref ? 
        Channel.fromPath(params.fasta_ref, checkIfExists: true) : 
        Channel.empty()

    // multiple files to analyse
    samples_input_ch = params.samples ? 
        Channel.fromPath(params.samples, checkIfExists: true)
            .splitCsv(header: false, sep: ',', strip: true )
            .map { row -> tuple("${row[0]}" ,file(row[1], checkIfExists: true), file(row[2], checkIfExists: true)) } :
        Channel.empty()

/************************** 
* workflow flow control
**************************/

    // 1. Motif calling
    motif_ch = bam_raw_ch
                .combine(fasta_raw_ch)
                .mix(samples_input_ch)
                 
    motifs_wf(motif_ch)

}

/*************  
* COMPLETION
*************/
workflow.onComplete { 
    progressBar(workflow)
    log.info ( workflow.success ? "\nDone! Results are stored here --> $params.output \nThank you for using ShadowBase\n" : "Oops .. something went wrong" )
}
