rule cufflinks:
    input:
        sorted_bam = PATH+"results/{sample}.sorted.bam",
        annotation = ANNOTATION
    output:
        PATH+"results/{sample}_transcripts.gtf"
    threads: THREADS
    shell:
        """
        cufflinks -G {input.annotation} {input.sorted_bam} -o "results/" --num-threads {threads}
        mv results/transcripts.gtf results/{wildcards.sample}_transcripts.gtf
        """
