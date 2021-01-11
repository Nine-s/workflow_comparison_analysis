
rule fastqc:
    input:
        ref=REF,
        # determine `r1` based on the {sample} wildcard defined in `output`
        # and the fixed value `1` to indicate the read direction
        r1=PATH+"../data/{sample}_1.fq",
        # determine `r2` based on the {sample} wildcard similarly
        r2=PATH+"../data/{sample}_2.fq"

    output: 
        PATH+"results/{sample}_1_fastqc.zip",
        PATH+"results/{sample}_2_fastqc.zip"

    # better to pass in the threads than to hardcode them in the shell command
    threads: THREADS#workflow.cores * 0.75 
    container: CONTAINER
    benchmark:
        PATH+"../sm_benchmarks/{sample}_fastqc_benchmark.txt"
    shell:
        """
        fastqc {input.r1} {input.r2} -o results --thread {threads}
        """
