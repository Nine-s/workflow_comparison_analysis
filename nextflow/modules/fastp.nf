//source https://github.com/hoelzer-lab/rnaflow/blob/master/modules/fastp.nf
process FASTP {
    tag 'fastp'
    publishDir params.outdir

    input:
    tuple val(name), path(reads)

    output:
    tuple val(name), path("${name}*.trimmed.fastq"), emit: sample_trimmed
    path "${name}_fastp.json", emit: json_report

    script:
    """
    fastp -i ${reads[0]} -I ${reads[1]} -o ${name}.R1.trimmed.fastq -O ${name}.R2.trimmed.fastq --thread ${task.cpus} --json ${name}_fastp.json --thread ${params.threads}
    """
}
