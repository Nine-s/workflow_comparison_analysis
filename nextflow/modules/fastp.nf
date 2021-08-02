process FASTP {
    label 'fastp'
    publishDir params.outdir

    input:
    tuple val(name), path(reads_1), path(reads_2)

    output:
    tuple val(name), path("${name}*.trimmed.fastq"), emit: sample_trimmed
    path "${name}_fastp.json", emit: json_report

    script:
    """
    fastp -i ${reads_1} -I ${reads_2} -o ${name}.R1.trimmed.fastq -O ${name}.R2.trimmed.fastq --thread ${task.cpus} --json ${name}_fastp.json --thread ${params.threads}
    """
}
