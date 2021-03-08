
rule fastp:
    input:
        r1 = "../data/{sample}_1.fq",
        r2 = "../data/{sample}_2.fq"

    output: 
        f1 = "results/{sample}_1_trimmed.fastq",
        f2 = "results/{sample}_2_trimmed.fastq"
    
    log:
        l1 = "results/{sample}_fastp_log.json"
    
    threads: 
        config["THREADS"] 
    
    container:
        config["CONTAINER_FASTP"]
    
    benchmark:
        "../sm_benchmarks/{sample}_fastp_benchmark.txt"
    
    shell:
        """
        fastp -i {input.r1} -I {input.r2} -o {output.f1} -O {output.f2} --json {log.l1} --thread {threads}
        """
    