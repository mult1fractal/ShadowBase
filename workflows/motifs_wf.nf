include { mod_mapping } from './process/mod_mapping.nf'
include { motif_calling } from './process/motif_calling.nf'
include { modkit } from './process/modkit.nf'
include { nanomotif_isolate } from './process/nanomotif_isolate.nf'

workflow motifs_wf {
    take:
        motif_ch         // tuple val(name), path(bam-file), path(fasta-ref)

    main:                          

            mod_mapping(motif_ch)
            mod_mapping.out.modmapped_bam_ch.view()
            motif_calling(mod_mapping.out.modmapped_bam_ch)
            modkit(mod_mapping.out.modmapped_bam_ch)
            
            //nanomotif_isolate(modkit.out)
    emit:
        
        modmapped_bam = mod_mapping.out.modmapped_bam_ch  //tuple val(name), path("*.modmapped.bam"),
        
}
