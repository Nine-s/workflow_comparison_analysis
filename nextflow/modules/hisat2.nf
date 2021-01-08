process HISAT2_INDEX_REFERENCE {
    publishDir params.outdir
    tag 'hisat2_index_reference'
    input:
    path(reference)

    output:
    tuple path(reference), path("${reference.baseName}*.ht2")

    script:
    """
    hisat2-build ${reference} ${reference.baseName} -p ${params.threads} 
    """
}
// -p number of threads

process HISAT2_ALIGN {
    publishDir params.outdir
    tag 'hisat2_align'
    
    input:
    tuple val(sample_name), path(reads)
    tuple path(reference), path(index)

    output:
    path "${sample_name}_summary.log", emit: log
    tuple val(sample_name), path("${sample_name}.sam"), emit: sample_sam 

    script:
    """
    hisat2 -x ${reference.baseName} -1 ${reads[0]} -2 ${reads[0]} --new-summary --summary-file ${sample_name}_summary.log -S ${sample_name}.sam --thread ${params.threads} 
    """
}