rule hisat2_index_reference: 
    input:
        ref = config["REF"]

    output:
        ["results/indexed_genome." + str(i) + ".ht2" for i in range(1,9)]
    
    threads: 
        config["THREADS"] 

    benchmark:
        "../sm_benchmarks/_hisat2_index_reference_benchmark.txt"
    
    shell:
        """
        hisat2-build {input.ref} results/indexed_genome -p {threads}
        """


rule hisat2_align:
    input:
        r1 = "results/{sample}_1_trimmed.fastq",
        r2 = "results/{sample}_2_trimmed.fastq",
        ref = ["results/indexed_genome." + str(i) + ".ht2" for i in range(1,9)]
        
    output:
        f1 = "results/{sample}.sam"
    
    benchmark:
        "../sm_benchmarks/{sample}_hisat2_align_benchmark.txt"
    
    log:
        l1 = "results/{sample}_summary.log"
    
    threads:
        config["THREADS"] 
    
    shell:
        """
        hisat2 -x results/indexed_genome -1 {input.r1} -2 {input.r2} --new-summary --summary-file {log.l1} -S {output.f1} --thread {threads}
        """
