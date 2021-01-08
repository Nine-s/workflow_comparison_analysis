
rule fastp:
    input:
        r1=PATH+"../data/{sample}_1.fq",
        r2=PATH+"../data/{sample}_2.fq"

    output: 
        PATH+"results/{sample}_1_trimmed.fastq",
        PATH+"results/{sample}_2_trimmed.fastq"
    log:
        PATH+"results/{sample}_fastp_log.json"
    threads: THREADS
    container: CONTAINER
    shell:
        """
        fastp -i {input.r1} -I {input.r2} -o results/{wildcards.sample}_1_trimmed.fastq -O results/{wildcards.sample}_2_trimmed.fastq --json results/{wildcards.sample}_fastp_log.json --thread {threads}
        """
    