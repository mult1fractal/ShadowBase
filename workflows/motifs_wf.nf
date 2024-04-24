include { mod_mapping } from './process/mod_mapping.nf'
include { motif_calling } from './process/motif_calling.nf'

workflow motifs_wf {
    take:
        bam         // tuple val(name), path(fasta-file)
        fasta_ref   // tuple val(name), path(fasta-file)
    main:                          
            
            
            
            mod_mapping(bam, fasta_ref)
            motif_calling(mod_mapping.out.modmapped_bam_ch, fasta_ref)

    emit:
        
        modmapped_bam = mod_mapping.out.modmapped_bam_ch  //tuple val(name), path("*.modmapped.bam"),
        
}
