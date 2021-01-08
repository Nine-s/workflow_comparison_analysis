process CUFFLINKS {
    publishDir params.outdir
    //publishDir "${params.output}/${params.hisat2_dir}", mode: 'copy', pattern: "*.bai" 
    //publishDir "results/cufflinks_out" 
    input:
    tuple val(sample_name), path(sorted_bam)
    path(annotation)
    
    output:
    //tuple val(sample_name), path("${sample_name}.gtf"), emit: cufflinks_gtf 
    path('transcripts.gtf'), emit: cufflinks_gtf 
    
    //"${index}"
    script:
    """
    cufflinks -G ${annotation} ${sorted_bam}  --num-threads ${params.threads}
    """
    //cufflinks -G ../data/ref-transcripts.gtf  ${sorted_bam}
    //./results/${sample_name}.sorted.bam
}