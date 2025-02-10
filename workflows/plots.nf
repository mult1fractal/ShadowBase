include { mod_mapping } from './process/mod_mapping.nf'




workflow plots_wf {
    take:
        motif_ch         // tuple val(name), path(bam-file), path(fasta-ref)

    main:                          
          
            microbemod_motif(mod_mapping.out.modmapped_bam_ch)

            // search for RM genes
            rm_genes_microbemod_ch=mod_mapping.out.map( {it -> tuple(it[0], it[3])})
            //rm_genes_microbemod_ch.view()
            microbemod_RM_MT(rm_genes_microbemod_ch)

    emit:
        
        modmapped_bam = mod_mapping.out.modmapped_bam_ch  //tuple val(name), path("*.modmapped.bam"),
        
}
