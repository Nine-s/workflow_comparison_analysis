rule hisat2_index_reference: 
    input:
        ref = REF
    output:
        #"results/{sample}*.ht2"
        [PATH+"results/indexed_genome." + str(i) + ".ht2" for i in range(1,9)]
        #"results/{sample}.{number}.ht2"
    #[WORKING_DIR + "genome/genome." + str(i) + ".ht2" for i in range(1,9)]
    threads: THREADS
    shell:
        """
        hisat2-build {input.ref} results/indexed_genome -p {threads}
        """

rule hisat2_align:
    input:
        #reads = PATH+"results/{sample}_other_sortmerna.fastq",
        r1 = PATH+"results/{sample}_1_trimmed.fastq",
        r2 = PATH+"results/{sample}_2_trimmed.fastq",
        ref = [PATH+"results/indexed_genome." + str(i) + ".ht2" for i in range(1,9)],
        #ref1 = PATH+"results/indexed_genome"
        #ref = PATH+"results/{sample}*.ht2"
    output:
        PATH+"results/{sample}.sam"
    log:
        "{sample}_summary.log"
    threads: THREADS
    shell:
        """
        hisat2 -x {PATH}results/indexed_genome -1 {input.r1} -2 {input.r2} --new-summary --summary-file results/{wildcards.sample}_summary.log -S results/{wildcards.sample}.sam --thread {threads}
        """


