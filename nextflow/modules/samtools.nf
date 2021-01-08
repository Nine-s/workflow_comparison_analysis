process SAMTOOLS {
    //publishDir "${params.output}/${params.hisat2_dir}", mode: 'copy', pattern: "*.bai" 
    publishDir params.outdir
    
    input:
    tuple val(sample_name), path(sam_file)
    
    output:
    tuple val(sample_name), path("${sample_name}.sorted.bam"), emit: sample_bam 
    //path("${sample_name}.bam.bai"), emit: sample_bai
    //tuple val(sample_name), path("${sample_name}.bai"), emit: sample_bai

    script:
    """
    samtools view -bS ${sample_name}.sam -@ ${params.threads} | samtools sort -o ${sample_name}.sorted.bam -T tmp  -@ ${params.threads} 
    """
    //samtools index ${sample_name}.sorted.bam -b ${sample_name}.bam.bai
}