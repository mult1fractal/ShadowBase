process mod_mapping { 
    label 'minimap2'
    publishDir "${params.output}/${name}/1.Modmapped_bam", mode: 'copy'
    errorStrategy 'retry'
        maxRetries 2
    input: 
        tuple val(bam_name), path(bam)
        tuple val(fasta_ref_name), path(fasta_ref)
    output: 
        path ("ani*"), emit: tax_check_ch
        tuple val(name), path("*.modmapped.bam"), emit: modmapped_bam 
    script:
        """
        minimap_version=\$(minimap2 --version)

        samtools fastq -T MM,ML -n ${bam} | minimap2 -y -ax map-ont ${fasta_ref} - -t 12 | \
        samtools view -u - | samtools sort -@ 12 -o ${bam_name}.modmapped.bam; samtools index ${bam_name}.modmapped.bam -@ 12

        """
}