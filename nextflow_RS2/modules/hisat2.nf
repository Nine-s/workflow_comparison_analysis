process HISAT2_INDEX_REFERENCE {
    label 'hisat2'
    publishDir params.outdir
    
    input:
    path(reference)

    output:
    tuple path(reference), path("${reference.baseName}*.ht2")

    script:
    """
    hisat2-build ${reference} ${reference.baseName}
    """
    // -p ${params.threads} 
}

process HISAT2_ALIGN {
    label 'hisat2'
    publishDir params.outdir
    
    input:
    tuple val(sample_name), path(reads_1), path(reads_2)
    tuple path(reference), path(index)

    output:
    path "${reads_1.getBaseName()}_summary.log", emit: log
    tuple val(sample_name), path("${reads_1.getBaseName()}.sam"), emit: sample_sam 

    script:
    """
    hisat2 -x ${reference.baseName} -1 ${reads_1} -2 ${reads_2} --new-summary --summary-file ${reads_1.getBaseName()}_summary.log -S ${reads_1.getBaseName()}.sam
    """
    //sort ${sample_name}.sam > ${sample_name}.sam
}