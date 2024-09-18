process nanomotif_isolate { 
    label 'nanomotif'
    publishDir "${params.output}/${name}/4.Nanomotif_isolate/", mode: 'copy'
    errorStrategy 'ignore'
    //    maxRetries 1
    input: 
        tuple val(name), path(bed), path(fasta_ref)
    output: 
        path("nanomotif") , emit: nanomotif_isolate_ch

    script:
        """
        EXT="fasta"              # Filename extension
            grep ">" *.\${EXT} | \
            sed "s/.*\\///" | \
            sed "s/.\${EXT}:>/\\t/" | \
            awk -F'\\t' '{print \$2 "\\t" \$1}' > contig_bin.tsv

        nanomotif_version=\$(nanomotif --version)

        nanomotif find_motifs ${fasta_ref} ${bed} contig_bin.tsv

        """
    stub:
        """
        touch motifs.tsv
        
       
        """
}