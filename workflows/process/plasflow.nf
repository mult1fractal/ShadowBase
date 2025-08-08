process plasflow {
        label 'plasflow'
        publishDir "${params.output}/${name}/", mode: 'copy'
    input:
        tuple val(name), path(fasta)
    output:
        tuple val(name), path("${name}_chromosomes.fasta"), emit: chromosomes  optional true
        tuple val(name), path("${name}_plasmids_plasmids.fasta"), emit: plasmids  optional true
        tuple val(name), path("${name}_unclassified_unclassified.fasta"), emit: unclassified  optional true

    script:
        """
        PlasFlow.py --input ${fasta} --output ${name}.masked --threshold 0.7

        # remove empty file
        find . -name "*.fasta" -type f -size 0 -print0 | xargs -0 echo rm
        """
        stub:
        """
        touch  ${name}_chromosomes.fasta ${name}_plasmids.fasta ${name}_unclassified.fasta
        """
}


// sollte noch vor dem modmapping  bam v fasta kommen?
