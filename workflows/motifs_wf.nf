include { mod_mapping } from './process/mod_mapping.nf'
include { motif_calling } from './process/motif_calling.nf'

workflow motifs_wf {
    take:
        motif_ch         // tuple val(name), path(bam-file), path(fasta-ref)

    main:                          

            mod_mapping(motif_ch)
            mod_mapping.out.modmapped_bam_ch.view()
            motif_calling(mod_mapping.out.modmapped_bam_ch)

    emit:
        
        modmapped_bam = mod_mapping.out.modmapped_bam_ch  //tuple val(name), path("*.modmapped.bam"),
        
}
