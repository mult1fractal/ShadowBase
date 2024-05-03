process modkit { 
    label 'modkit'
    publishDir "${params.output}/${name}/3.Modkit/", mode: 'copy'
    // errorStrategy 'ignore'
    //    maxRetries 1
    input: 
        tuple val(name), path(modmapped_bam), path(modmapped_bam_bai), path(fasta_ref)
    output: 
        tuple val(name), path("*_pileup.bed"), path(fasta_ref), emit: pileup_bed_ch // path("bedgraph_results")

    script:
        """
        modkit_version=\$(modkit -Version)

         modkit pileup ${modmapped_bam} ${name}_pileup.bed \
            --ref ${fasta_ref} \
            --preset traditional

        """
    stub:
        """
        ## mkdir bedggraph_results
        touch Y_pileup.bed
        """
}

// ## modkit pileup ${modmapped_bam} bedgraph_results --bedgraph
