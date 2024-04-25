process modkit { 
    label 'modkit'
    publishDir "${params.output}/${bam_name}/3.Modkit/", mode: 'copy', 
    //errorStrategy 'retry'
    //    maxRetries 1
    input: 
        tuple val(bam_name), path(bam), path(fasta_ref)
    output: 
        tuple val(bam_name), path("*.modmapped.bam"), path("*modmapped.bam.bai"), path(fasta_ref), emit: modmapped_bam_ch

    script:
        """
        modkit_version=\$(modkit -Version)

        modkit pileup ${bam} ${bam_name}_pileup.bed \
            --ref ${fasta_ref} \
            --preset traditional

        modkit pileup ${bam} bedgraph_results --bedgraph ${bam_name}


        """
    stub:
        """
        touch X_.modmapped.bam
        touch Y_modmapped.bam.bai
        touch Z.fasta
        """
}