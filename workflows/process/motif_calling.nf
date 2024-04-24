process motif_calling { 
    label 'microbemod'
    publishDir "${params.output}/${name}/2.Micobemod_motifs/", mode: 'copy'
    //errorStrategy 'retry'
    //    maxRetries 1
    input: 
        tuple val(name), path(modmapped_bam), path(modmapped_bam_bai)
        tuple val(fasta_ref_name), path(fasta_ref)
    output: 
        tuple path("*motifs.tsv"), path("*methylated_sites.tsv"), emit: modmapped_bam_ch
    script:
        """
        ##Microbemod_version=\$(MicrobeMod --version)

        MicrobeMod call_methylation -b ${modmapped_bam} -r ${fasta_ref} -t 10

        """
}