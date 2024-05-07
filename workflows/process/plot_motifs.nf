process plot_motifs { 
    label 'R'
    publishDir "${params.output}/", mode: 'copy'
    //  errorStrategy 'retry'
    //    maxRetries 1
    input: 
        path(motifs)
    output: 
        path("motifs.pdf")
    script:
        """
        motif_plotting.R \$(ls *.tsv) motifs.pdf

        """
        stub:
        """
        touch motifs.pdf
        """
}