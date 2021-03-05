
nextflow.enable.dsl = 2

include { FASTQC } from './modules/fastqc.nf'
include { FASTP } from './modules/fastp'
include { SORTMERNA } from './modules/sortmerna'
include { HISAT2_INDEX_REFERENCE ; HISAT2_ALIGN } from './modules/hisat2.nf'
include { SAMTOOLS } from './modules/samtools'
include { CUFFLINKS } from './modules/cufflinks'

log.info """\
         RNAseq differential analysis using NextFlow 
         =============================
         genome: ${params.genome}
         annot : ${params.annot}
         reads : ${params.reads}
         outdir: ${params.outdir}
         basedir : ${params.basedir}
         """
         .stripIndent()
 
params.outdir = 'results'


workflow {
    read_pairs_ch = channel.fromFilePairs( params.reads, checkIfExists: true ) 
    read_reference_ch = channel.fromPath( params.genome, checkIfExists: true ) 
    annotation_ch =  channel.fromPath( params.annot, checkIfExists: true ) 
    FASTQC( read_pairs_ch )
    FASTP( read_pairs_ch )
    HISAT2_INDEX_REFERENCE( read_reference_ch )
    HISAT2_ALIGN(FASTP.out.sample_trimmed, HISAT2_INDEX_REFERENCE.out)
    SAMTOOLS(HISAT2_ALIGN.out.sample_sam)
    CUFFLINKS(SAMTOOLS.out.sample_bam, annotation_ch)
}

