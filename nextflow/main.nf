
nextflow.enable.dsl = 2

params.reads = "../data/*_{1,2}.fq"
//params.annot = "/home/ninon/Documents/workflows_comparison_analysis/data/ref-transcripts.gtf"
params.annot = "../data/ref-transcripts.gtf"
params.genome = "../data/hg19.fasta"
params.outdir = "results"
params.basedir = "."
params.threads = 2
//params.rrnadbpath = "../rrna_db"
params.rrnadbpath = "../data/rrna_db"
//params.annot = "../data/GCA_000001635.9_GRCm39_genomic.gtf.bed"


log.info """\
         G O  N E X T F L O W <3     
         =============================
         genome: ${params.genome}
         annot : ${params.annot}
         reads : ${params.reads}
         outdir: ${params.outdir}
         basedir : ${params.basedir}
         """
         .stripIndent()
 
// todo add single read option
params.outdir = 'results'

include { FASTQC } from './modules/fastqc.nf'
include { FASTP } from './modules/fastp'
include { SORTMERNA } from './modules/sortmerna'
include { HISAT2_INDEX_REFERENCE ; HISAT2_ALIGN } from './modules/hisat2.nf'
include { SAMTOOLS } from './modules/samtools'
//include { IRECKON } from './modules/iReckon'
include { CUFFLINKS } from './modules/cufflinks'


workflow {
    read_pairs_ch = channel.fromFilePairs( params.reads, checkIfExists: true ) 
    FASTQC( read_pairs_ch )
    FASTP( read_pairs_ch )
    //SORTMERNA( FASTP.out.sample_trimmed )

    read_reference_ch = channel.fromPath( params.genome, checkIfExists: true ) 
    annotation_ch =  channel.fromPath( params.annot, checkIfExists: true ) 

    HISAT2_INDEX_REFERENCE( read_reference_ch )
    HISAT2_ALIGN(FASTP.out.sample_trimmed, HISAT2_INDEX_REFERENCE.out)
    SAMTOOLS(HISAT2_ALIGN.out.sample_sam)
    CUFFLINKS(SAMTOOLS.out.sample_bam, annotation_ch)
}

