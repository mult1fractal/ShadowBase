process microbemod_motif { 
    label 'microbemod'
    publishDir "${params.output}/${name}/2.Micobemod_motifs/", mode: 'copy'
    //  errorStrategy 'retry'
    errorStrategy 'ignore'
    //    maxRetries 1
    input: 
        tuple val(name), path(modmapped_bam), path(modmapped_bam_bai), path(fasta_ref)
    output: 
        tuple val(name), path("*motifs.tsv"), path("*methylated_sites.tsv"), emit: modmapped_bam_ch
    script:
        """
        ##Microbemod_version=\$(MicrobeMod --version)

        MicrobeMod call_methylation -b ${modmapped_bam} -r ${fasta_ref} -t ${task.cpus} 

        """
        stub:
        """
        touch X_motifs.tsv
        touch Y_methylated_sites.tsv
        """
}

process microbemod_RM_MT { 
    label 'microbemod'
    publishDir "${params.output}/${name}/2.Micobemod_motifs/RN_genes", mode: 'copy'
    //  errorStrategy 'retry'
    //    maxRetries 1
    errorStrategy 'ignore'
    input: 
        tuple val(name), path(fasta_ref)
    output: 
        tuple val(name), path("*_RM_genes*"), emit: modmapped_bam_ch
    script:
        """
        ##Microbemod_version=\$(MicrobeMod --version)

        MicrobeMod annotate_rm -f ${fasta_ref} -o ${name}_RM_genes -t ${task.cpus} 

        """
        stub:
        """
        tocch X_RN_genes.tsv
 
        """
}

// there is also other outputs that can to be "Published"