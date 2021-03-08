rule samtools:
    input:
        s1 = "results/{sample}.sam"

    output:
        f1 = "results/{sample}.sorted.bam"
    
    threads: 
        config["THREADS"] 
    
    container:
        config["CONTAINER_SAMTOOLS"]

    benchmark:
        "../sm_benchmarks/{sample}_samtools_benchmark.txt"
    
    shell:
        """
        samtools view -bS {input.s1} -@ {threads} | samtools sort -o {output.f1} -T tmp -@ {threads}
        """
        