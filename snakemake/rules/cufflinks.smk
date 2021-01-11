rule cufflinks:
    input:
        sorted_bam = PATH+"results/{sample}.sorted.bam",
        annotation = ANNOTATION
    output:
        PATH+"results/{sample}/transcripts.gtf"
    threads: THREADS
    benchmark:
        PATH+"../sm_benchmarks/{sample}_cufflinks_benchmark.txt"
    shell:
        """
        cufflinks -G {input.annotation} {input.sorted_bam} -o "results/{wildcards.sample}/" --num-threads {threads}
        """
        #mv results/transcripts.gtf results/{wildcards.sample}_transcripts.gtf
