process FASTP {
    label 'fastp'
    publishDir params.outdir

    input:
    tuple val(name), path(reads_1), path(reads_2)

    output:
    tuple val(name), path("${name}*R1.trimmed.fastq"), path("${name}*R2.trimmed.fastq"), emit: sample_trimmed
    path "${name}_fastp.json", emit: json_report

    script:
    """
    fastp -i ${reads_1} -I ${reads_2} -o ${reads_1.getBaseName()}.R1.trimmed.fastq -O ${reads_1.getBaseName()}.R2.trimmed.fastq --thread ${task.cpus} --json ${name}_fastp.json 
    """
}
