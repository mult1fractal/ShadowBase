include { mod_mapping } from './process/mod_mapping.nf'
include { motif_calling } from './process/motif_calling.nf'

workflow motifs_wf {
    take:
        bam         // tuple val(name), path(fasta-file)
        fasta_ref   // tuple val(name), path(fasta-file)
    main:                          
            
            
            
            if (params.bakta_db) { database_bakta = file(params.bakta_db) }
            else { database_bakta = bakta_database() }
                
            bakta(fasta_input,database_bakta)

    emit:
        
        
        
        json_annotation = bakta.out.bakta_JSON_ch                       // tuple val(name), path(bakta_json_annotation_file)
        json = bakta.out.bakta_file_ch                                  // tuple val(name), file(bakta_result_file), path(bakta_info_file)
        report = bakta.out.bakta_report_ch                              // tuple val(name), val(version), val(db_version), val(command), file(bakta_result_file)
        gff3 = bakta.out.gff3                                           // tuple val(name), path(gff3)
}
