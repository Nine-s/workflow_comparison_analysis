//source https://github.com/nextflow-io/rnaseq-nf/blob/master/modules/fastqc.nf
params.outdir = 'results'

process FASTQC {
    tag "fastqc $sample_id"
    publishDir params.outdir

    input:
    tuple val(sample_id), path(reads)

    output:
    path("*_fastqc.zip", emit: zip)

    script:
    """
    fastqc ${reads[0]} ${reads[1]} --thread ${params.threads}
    """
}