process mod_mapping { 
    label 'minimap2'
    publishDir "${params.output}/${bam_name}/1.Modmapped_bam/", mode: 'copy', pattern: "*.bam*"
    //errorStrategy 'retry'
    //    maxRetries 1
    input: 
        tuple val(bam_name), path(bam), path(fasta_ref)
    output: 
        tuple val(bam_name), path("*.modmapped.bam"), path("*modmapped.bam.bai"), path(fasta_ref), emit: modmapped_bam_ch

    script:
        """
        minimap_version=\$(minimap2 --version)

        samtools fastq -T MM,ML -n ${bam} | minimap2 -y -ax map-ont ${fasta_ref} - -t 12 | \
        samtools view -u - | samtools sort -@ 12 -o ${bam_name}.modmapped.bam; samtools index ${bam_name}.modmapped.bam -@ 12

        """
    stub:
        """
        touch X_.modmapped.bam
        touch Y_modmapped.bam.bai
        touch Z.fasta
        """
}