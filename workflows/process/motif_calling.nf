process motif_calling {
    label 'minimap2'
    errorStrategy 'ignore'
    publishDir "${params.output}/${name}/2.pgap", mode: 'copy'
    input: 
        tuple val(name), path(fasta), val(species)
        tuple path(pgap_db), path(pgap_db_ani)
    output: 
        tuple val(name), env(PGAP_VERSION), env(PGAP_DB_VERSION), env(COMMAND), path("annot*"), path("VERSION"), emit: pgap_report_ch
        path ("ani*"), emit: tax_check_ch
        tuple val(name), path("annot*"), path("VERSION"), path("pgap_tool_info.txt"), emit: pgap_file_ch 
    script:
        """
        # ACTIVATE HISTORY AND PIPEFAIL