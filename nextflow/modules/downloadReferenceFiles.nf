process DOWNLOAD_REFERENCE_GENOME {
    label 'download'
    tag "download"
    //publishDir params.outdir

    output:
    path("GRCm39.fasta"), emit: reference_genome

    script:
    """
    wget -O - https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.fna.gz | gunzip -c > GRCm39.fasta
    """
// -P my_dir/
//    wget --timestamping ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/001/696/305/GCF_001696305.1_UCN72.1/GCF_001696305.1_UCN72.1_genomic.gbff.gz -P my_dir/   

}


process DOWNLOAD_REFERENCE_ANNOTATION {
    label 'download'
    tag "download"
    //publishDir params.outdir

    output:
    path("GRCm39.gtf"), emit: reference_annotation
    
    script:
    """
    wget -O - https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.gtf.gz | gunzip -c > GRCm39.gtf
    """

}


process DOWNLOAD_READS_SMALL {
    output:
    tuple val("SRR3287149"), file("SRR3287149_1.fastq"), file("SRR3287149_2.fastq"), emit: paired_end

    script:
    """
    wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR328/009/SRR3287149/SRR3287149_1.fastq.gz
    wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR328/009/SRR3287149/SRR3287149_2.fastq.gz
    gunzip SRR3287149_1.fastq.gz
    gunzip SRR3287149_2.fastq.gz
    """
}

process DOWNLOAD_READS_MEDIUM {
    output:
    tuple val("SRR6822761"), file("SRR6822761_1.fastq"), file("SRR6822761_2.fastq"), emit: paired_end

    script:
    """
    wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR682/001/SRR6822761/SRR6822761_1.fastq.gz
    wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR682/001/SRR6822761/SRR6822761_2.fastq.gz
    gunzip SRR6822761_1.fastq.gz
    gunzip SRR6822761_2.fastq.gz
    """
}

process DOWNLOAD_READS_LARGE {
    output:
    tuple val("SRR13403753"), file("SRR13403753_1.fastq"), file("SRR13403753_2.fastq"), emit: paired_end

    script:
    """
    wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR134/053/SRR13403753/SRR13403753_1.fastq.gz
    wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR134/053/SRR13403753/SRR13403753_2.fastq.gz
    gunzip SRR13403753_1.fastq.gz
    gunzip SRR13403753_2.fastq.gz
    """
}