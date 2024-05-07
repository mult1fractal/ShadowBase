include { mod_mapping } from './process/mod_mapping.nf'
include { motif_calling } from './process/motif_calling.nf'
include { modkit } from './process/modkit.nf'
include { nanomotif_isolate } from './process/nanomotif_isolate.nf'
include { plot_motifs } from './process/plot_motifs.nf'

workflow motifs_wf {
    take:
        motif_ch         // tuple val(name), path(bam-file), path(fasta-ref)

    main:                          
            // mapping methylated MM ML tags to reference fasta via minimap
            mod_mapping(motif_ch)
    
            // identify motifs vie MicrobeMod
            motif_calling(mod_mapping.out.modmapped_bam_ch)
                    
            // modify channel for plotting
            // tuple val(name), path("*motifs.tsv"), path("*methylated_sites.tsv"), emit: modmapped_bam_ch
            plot_ch = motif_calling.out.modmapped_bam_ch.collect( {it -> tuple(it[1])})
            plot_motifs(plot_ch)


            //modkit(mod_mapping.out.modmapped_bam_ch)
            //nanomotif_isolate(modkit.out)
    emit:
        
        modmapped_bam = mod_mapping.out.modmapped_bam_ch  //tuple val(name), path("*.modmapped.bam"),
        
}
