process SORTMERNA {
    tag 'sortmerna'
    publishDir params.outdir

    input:
    tuple val(name), path(reads)

    output:
    tuple val(name), path("${name}.other.fastq"), emit: no_rrna_fastq
    path "${name}.aligned.log", emit: log

    script:
        """
        ls ../../../../
        sortmerna --ref ${params.rrnadbpath}/silva-bac-16s-id90.fasta,${params.rrnadbpath}/silva-bac-16s-id90: \
        --reads ${reads[0]} \
        --reads ${reads[1]} \
        --aligned ${name}.aligned \
        --other ${name}.other \
        --fastx \
        -a ${params.threads} \
        --log \
        --num_alignments 1 \
        -v 
        """
    //sortmerna \
    //--ref ${params.rrnadbpath}/rfam-5.8s-database-id98.fasta,${params.rrnadbpath}/rfam-5.8s-database-id98 \
    //--ref ${params.rrnadbpath}/silva-bac-16s-id90.fasta,${params.rrnadbpath}/silva-bac-16s-id90: \
        
}
