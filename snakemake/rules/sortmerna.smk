rule sortmerna:
    input:
        r1 = PATH+"results/{sample}_1_trimmed.fastq",
        r2 = PATH+"results/{sample}_2_trimmed.fastq"
    output:
        #PATH+"results/{sample}_aligned_sortmerna.fastq"
        PATH+"results/{sample}_other_sortmerna.fastq"
    log:
        "{sample}_aligned_sortmerna.log"
    threads: THREADS
    shell:
        """
        sortmerna \
        --ref ../rrna_db/rfam-5.8s-database-id98.fasta,../rrna_db/rfam-5.8s-database-id98 \
        --reads {input.r1} \
        --reads {input.r2} \
        --aligned results/{wildcards.sample}_aligned_sortmerna \
        --fastx \
        --other results/{wildcards.sample}_other_sortmerna \
        --log \
        -a {threads} \
        -v
        """
    