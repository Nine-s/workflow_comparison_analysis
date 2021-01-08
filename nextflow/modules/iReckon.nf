process IRECKON {
    //publishDir "${params.output}/${params.hisat2_dir}", mode: 'copy', pattern: "*.bai" 

    input:
    tuple val(sample_name), path(reads)
    tuple val(reference), path(index)
    tuple val(annotation), path(bed_file)
    tuple val(alignment), path(bai_file)
    
    output:
    tuple val(sample_name), path("${sample_name}.gtf"), emit: iReckon_gtf 
    

    script:
    """
    java -Xmx15000M -jar iReckon-1.0.7.jar "${bai_file}" "${index}" "${bed_file}" -1 "${reads[0]}" -2 "${reads[1]}" 
    """
}