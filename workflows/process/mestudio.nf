process mestudio {
    publishDir "${params.output}/mestudio/${name}/", mode: 'copy'
    label "mestudio"
    input:
        tuple val(name), path (fasta)       // Reference genome
        tuple val(name), path (annotation)  // Passed in via a new --gff_anno parameter
        tuple val(name), path (bedmethyl)   // The output channel from ShadowBase's Modkit process
        tuple val(name), path (motifs)      // Passed in via a new --motifs parameter
    output:
        tuple val(name), path("${name}_mestudio.html")
    script:
        """

        adjust_bam_for_mestudio.sh modkitfile.bed


       mkdir mestudio_out
       mestudio -f ${fasta} -anno ${annotation} -smart modifications.gff -mo ${motifs} -out mestudio_out
        """
            
    