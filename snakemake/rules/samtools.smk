rule samtools:
    input:
        PATH+"results/{sample}.sam"
    output:
        PATH+"results/{sample}.sorted.bam"
    #"${sample_name}.bai")
    threads: THREADS
    shell:
        """
        samtools view -bS results/{wildcards.sample}.sam -@ {threads} | samtools sort -o results/{wildcards.sample}.sorted.bam -T tmp -@ {threads}
        """
        #samtools index ${sample_name}.sorted.bam -b ${sample_name}.bai