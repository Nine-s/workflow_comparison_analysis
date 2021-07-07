process HISAT2_INDEX_REFERENCE {
    label 'hisat2'
    publishDir params.outdir
    
    input:
    path(reference)

    output:
    tuple path(reference), path("${reference.baseName}*.ht2")

    script:
    """
    hisat2-build ${reference} ${reference.baseName} -p ${params.threads} 
    """
}

process HISAT2_ALIGN {
    label 'hisat2'
    publishDir params.outdir
    
    input:
    tuple val(sample_name), path(reads)
    tuple path(reference), path(index)

    output:
    path "${sample_name}_summary.log", emit: log
    tuple val(sample_name), path("${sample_name}.sam"), emit: sample_sam 

    script:
    """
    hisat2 -x ${reference.baseName} -1 ${reads[0]} -2 ${reads[1]} --new-summary --summary-file ${sample_name}_summary.log -S ${sample_name}.sam --thread ${params.threads} 
    sort ${sample_name}.sam > ${sample_name}.sam
    """
}