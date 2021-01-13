
rule fastqc:
    input:
        ref = config["REF"],
        r1 = "../data/{sample}_1.fq",
        r2 = "../data/{sample}_2.fq"

    output: 
        f1 = "results/{sample}_1_fastqc.zip",
        f2 = "results/{sample}_2_fastqc.zip"

    threads: 
        config["THREADS"] 
        #workflow.cores * 0.75 

    container: 
        config["CONTAINER"]

    benchmark:
        "../sm_benchmarks/{sample}_fastqc_benchmark.txt"

    shell:
        """
        fastqc {input.r1} {input.r2} -o results --thread {threads}
        """
