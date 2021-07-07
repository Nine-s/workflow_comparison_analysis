
nextflow.enable.dsl = 2

include { FASTQC } from './modules/fastqc.nf'
include { FASTP } from './modules/fastp'
include { SORTMERNA } from './modules/sortmerna'
include { HISAT2_INDEX_REFERENCE ; HISAT2_ALIGN } from './modules/hisat2.nf'
include { SAMTOOLS } from './modules/samtools'
include { CUFFLINKS } from './modules/cufflinks'
include { SPLIT_FASTQ } from './modules/split_fastq'

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

// process MERGE_MG2 {
//     publishDir params.outdir
    
//     input:
//     file out_mg2

//     output:
//     path "transcript_gathered.gtf", emit: gathered_mg2
//     //tuple val("transcript_gathered.gtf"), path("transcript_gathered.gtf"), emit: gathered_mg2

//     script:
//     """
//     cat $out_mg2 > transcript_gathered.gtf
//     """
// }

// process MERGE_BAM {
//     publishDir params.outdir
    
//     input:
//     file out_bam

//     output:
//     path "transcript_gathered.bam", emit: gathered_bam
//     //tuple val("transcript_gathered.bam"), path("transcript_gathered.bam"), emit: gathered_bam

//     script:
//     """
//     cat $out_bam > transcript_gathered.bam
//     """
// }


process MERGE_SAM {
    publishDir params.outdir
    
    input:
    file out_sam

    output:
    //path "alignement_gathered.sam", emit: gathered_sam
    //tuple val("alignement_gathered.sam"), path("alignement_gathered.sam"), emit: gathered_sam
    tuple val("alignement_gathered.sam"), path("alignement_gathered.sam"),  emit: gathered_sam

    shell:
    // """
    // header=$(grep @ "$out_sam")
    // sed -i '/@/d' $out_sam
    // sed -i '/test.R/d' $out_sam
    // sort -u $out_sam > alignement_gathered.sam
    // sed -i '1i $header' alignement_gathered.sam
    // """
    //echo !{out_sam[0]}
    //sed -i '/@/d' !{out_sam}
    //sed -i '4i @PG	ID:hisat2	PN:hisat2	VN:2.1.0	CL:"/hisat2/hisat2-align-s --wrapper basic-0 -x hg19 --new-summary --summary-file test.R1.trimmed.1_summary.log -S test.R1.trimmed.1.sam --thread 2 -1 test.R1.trimmed.1.fastq -2 test.R2.trimmed.1.fastq"' alignement_gathered.sam
    //header="$(grep @ !{out_sam[1]})"
    //header="$(cat temp_grep.txt)"
    //sed -i -e 's/\@/\\@/g' temp_grep.txt
    // '''
    // grep @ !{out_sam[1]} > temp_grep.txt
    // parameter="$(cat temp_grep.txt)"
    // sed -i '/test.R/d' !{out_sam}
    // sort -u !{out_sam} > alignement_gathered.sam
    // sed -i 1i\ $(cat temp_grep.txt) alignement_gathered.sam
    // '''
    '''
    grep @ !{out_sam[1]} > temp_grep.txt
    parameter="$(cat temp_grep.txt)"
    sed -i '/test.R/d' !{out_sam}
    sed -i '/@/d' !{out_sam}
    { cat temp_grep.txt; sort -u !{out_sam} ; } > alignement_gathered.sam
    '''
    //@PG	ID:hisat2	PN:hisat2	VN:2.1.0	CL:"/hisat2/hisat2-align-s --wrapper basic-0 -x hg19 --new-summary --summary-file test.R1.trimmed.1_summary.log -S test.R1.trimmed.1.sam --thread 2 -1 test.R1.trimmed.1.fastq -2 test.R2.trimmed.1.fastq"

}

process SORT_MG2 {
    publishDir params.outdir
    
    input:
    file out_sorted_mg2

    output:
    path "transcript_sorted.gtf", emit: gathered_sorted_mg2
    
    script:
    """
    sort $out_sorted_mg2 > transcript_sorted.gtf
    """
}

workflow {
    //.fromFilePairs("../data/*_{1,2}.fq", flat:true)
    //test.R1.trimmed.fastq
    Channel
        .fromFilePairs("../data/test.R{1,2}.trimmed.fastq", flat:true)
        .splitFastq(by:50, pe:true, file:true)
        .view()
        .set{ read_pairs_ch }

    //FASTQC( read_pairs_ch )
    //FASTP( read_pairs_ch ) 
    HISAT2_INDEX_REFERENCE( params.genome )
    HISAT2_ALIGN( read_pairs_ch, HISAT2_INDEX_REFERENCE.out )
    //HISAT2_ALIGN( FASTP.out.sample_trimmed, HISAT2_INDEX_REFERENCE.out )
    
    //merge -> cufflinks -> sort
    MERGE_SAM( HISAT2_ALIGN.out.sample_sam.collect() )
    SAMTOOLS( MERGE_SAM.out.gathered_sam )
    CUFFLINKS( SAMTOOLS.out.sample_bam, params.annot )
    //SORT_MG2( CUFFLINKS.out.cufflinks_gtf )
    
    // cufflinks -> merge -> sort 
    // SAMTOOLS( HISAT2_ALIGN.out.sample_sam )
    // CUFFLINKS( SAMTOOLS.out.sample_bam, params.annot )
    // MERGE_MG2( CUFFLINKS.out.cufflinks_gtf.collect() )
    // SORT_MG2( MERGE_MG2.out.gathered_mg2 )
    
    //merge -> sort?? -> cufflinks
}
