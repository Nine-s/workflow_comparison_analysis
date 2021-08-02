process FASTQC {
    label 'fastqc'
    tag "fastqc $sample_id"
    publishDir params.outdir

    input:
    tuple val(sample_id), path(reads_1), path(reads_2)

    output:
    path("*_fastqc.zip", emit: zip)

    script:
    """
    fastqc ${reads_1} ${reads_2} 
    """
    //--thread ${params.threads}
}