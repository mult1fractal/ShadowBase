include { mod_mapping } from './process/mod_mapping.nf'
include { microbemod_motif } from './process/microbemod.nf'
include { microbemod_RM_MT } from './process/microbemod.nf'
include { modkit } from './process/modkit.nf'
include { nanomotif_isolate } from './process/nanomotif_isolate.nf'
include { plot_motifs } from './process/plot_motifs.nf'
include { modkit_motif } from './process/modkit.nf'
include { modkit_call_mods } from './process/modkit.nf'
include { modkit_bedgraph } from './process/modkit.nf'
include { plasflow } from './process/plasflow.nf'



workflow motifs_wf {
    take:
        motif_ch         // tuple val(name), path(bam-file), path(fasta-ref)

    main:                          
            // plasflow bekommt nur die fasta zuerst, dann auf den motif ch matchen
            plasflow_in_ch=motif_ch.map( {it -> tuple(it[0], it[3])}) // find out what is fasta
            plasflow()


            // mapping methylated MM ML tags to reference fasta via minimap
            mod_mapping(motif_ch)
    
            // identify motifs vie MicrobeMod
            microbemod_motif(mod_mapping.out.modmapped_bam_ch)

            // search for RM genes
            rm_genes_microbemod_ch=mod_mapping.out.map( {it -> tuple(it[0], it[3])})
            //rm_genes_microbemod_ch.view()
            microbemod_RM_MT(rm_genes_microbemod_ch)

            // modify channel for plotting // tuple val(name), path("*motifs.tsv"), path("*methylated_sites.tsv"), emit: modmapped_bam_ch
            plot_ch = microbemod_motif.out.collect( {it -> tuple(it[1])})
            // plot motifs found by microbemod for every sample
            plot_motifs(plot_ch)


            // modkit pileup
            modkit(mod_mapping.out.modmapped_bam_ch)
            // modkit call motifgs
            modkit_motif(modkit.out)
            modkit_call_mods(mod_mapping.out.modmapped_bam_ch)

            bedgraph_ch = mod_mapping.out.modmapped_bam_ch.map( {it -> tuple(it[0], it[1], it[2])})
            //bedgraph_ch.view()
            modkit_bedgraph(bedgraph_ch)
            //nanomotif_isolate(modkit.out)
    emit:
        
        modmapped_bam = mod_mapping.out.modmapped_bam_ch  //tuple val(name), path("*.modmapped.bam"),
        
}
