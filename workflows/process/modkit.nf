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

        modkit pileup --only-tabs ${modmapped_bam} ${name}_pileup.bed --threads ${task.cpus}
            ##--ref ${fasta_ref} \
            ## --preset traditional


        """
    stub:
        """
        ## mkdir bedggraph_results
        touch Y_pileup.bed
        """
}

// ## modkit pileup ${modmapped_bam} bedgraph_results --bedgraph

process modkit_motif { 
    label 'modkit'
    publishDir "${params.output}/${name}/3.Modkit/find_motifs", mode: 'copy', pattern: "*"
    // errorStrategy 'ignore'
    //    maxRetries 1
    input: 
        tuple val(name), path(pileup_bed), path(fasta_ref)
    output: 
        tuple val(name), path("*_motifs.tsv"), path("*modkit_find_motifs_log.txt"), emit: pileup_bed_ch // path("bedgraph_results")

    script:
        """
        modkit_version=\$(modkit -Version)

        modkit find-motifs \
        -i ${pileup_bed} \
        -r ${fasta_ref} \
        -o ${name}_motifs.tsv \
        --threads ${task.cpus} \
        --log ${name}_modkit_find_motifs_log.txt 

        """
    stub:
        """
        touch Y_modkit_find_motifs_log.txt 
        touch Y_motifs.tsv 
        """
}
