
nextflow.enable.dsl = 2

include { DOWNLOAD_REFERENCE_GENOME ; DOWNLOAD_REFERENCE_ANNOTATION ; DOWNLOAD_READS_SMALL ; DOWNLOAD_READS_MEDIUM ; DOWNLOAD_READS_LARGE } from './modules/downloadReferenceFiles.nf'
include { FASTQC } from './modules/fastqc.nf'
include { FASTP } from './modules/fastp'
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

process MERGE_SAM {
    publishDir params.outdir
    
    input:
    file out_sam

    output:
    tuple val("alignement_gathered.sam"), path("alignement_gathered.sam"),  emit: gathered_sam

    shell:
    '''
    grep @ !{out_sam[1]} > temp_grep.txt
    parameter="$(cat temp_grep.txt)"
    sed -i '/test.R/d' !{out_sam}
    sed -i '/@/d' !{out_sam}
    { cat temp_grep.txt; sort -u !{out_sam} ; } > alignement_gathered.sam
    '''
    
}

workflow {

    Channel
        .fromFilePairs(params.reads, flat:true)
        .splitFastq(by:4642229*3, pe:true, file:true)
        .view()
        .set{ read_pairs_ch }

    //DOWNLOAD_READS_SMALL().splitFastq(by:4642229, pe:true, file:true).view().set{read_pairs_ch}
    //DOWNLOAD_REFERENCE_ANNOTATION()
    //DOWNLOAD_REFERENCE_GENOME()
    FASTQC( read_pairs_ch )
    FASTP( read_pairs_ch ) 
    //HISAT2_INDEX_REFERENCE( DOWNLOAD_REFERENCE_GENOME.out.reference_genome )
    HISAT2_INDEX_REFERENCE( params.reference_genome )
    HISAT2_ALIGN( FASTP.out.sample_trimmed, HISAT2_INDEX_REFERENCE.out )
    MERGE_SAM( HISAT2_ALIGN.out.sample_sam.collect() )
    SAMTOOLS( MERGE_SAM.out.gathered_sam )
    //CUFFLINKS( SAMTOOLS.out.sample_bam, DOWNLOAD_REFERENCE_ANNOTATION.out.reference_annotation )
    CUFFLINKS( SAMTOOLS.out.sample_bam, params.reference_annotation )
    
}
