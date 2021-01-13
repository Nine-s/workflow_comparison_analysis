rule cufflinks:
    input:
        sorted_bam = "results/{sample}.sorted.bam",
        annotation = config["ANNOTATION"]
    
    output:
        "results/{sample}/transcripts.gtf"
    
    threads:
        config["THREADS"] 
    
    benchmark:
        "../sm_benchmarks/{sample}_cufflinks_benchmark.txt"
    
    shell:
        """
        cufflinks -G {input.annotation} {input.sorted_bam} -o "results/{wildcards.sample}/" --num-threads {threads}
        """
        #mv results/transcripts.gtf results/{wildcards.sample}_transcripts.gtf
