# Worflow comparison analysis

The purpose of this repository is to compare the same workflow done with SnakeMake and NextFlow.
This workflow's purpose is to perform the detection of splicing isoforms from RNA-Seq data.
An efficiency and resources usage will be performed on several plateforms.

## Requirements

Here are listed the pre-requisits. Please see the quick install for Linux systems.

iReckon version 1.0.8

Requirements:
 - iReckon works on linux. You need to have at least java-1.6 and the latest version of BWA installed and added to the PATH.
 - For large datasets and genomes, anticipate an important memory cost and running time (It is usually around 16G and 24 hours on 8 processors for human RNA-Seq with 60M read pairs).
   The working directory (output directory) should have enough memory space (>100G for the previous example). 
 - Make sure the coordinates (chromosome name, reference) are the same for the alignment file (.bam), the annotation file and the reference.
NSMAP?FlipFlop?

## Quick installation

### Java1.8

### NextFlow

### SnakeMake

## Quick start

## Inputs

Example provided in the data folder.
Read files (.fastq)
reference genome file (.fasta)
reference genome annotation file (.gtf/savant?)

Data Folder contains:
- mus musculus genome (fasta file) https://www.ncbi.nlm.nih.gov/assembly/GCF_000001635.27
- mus musculus genome annotation (gtf file) https://www.ncbi.nlm.nih.gov/assembly/GCF_000001635.27
- 

## Outputs

## Steps

### Quality control

Fastqc

### RNA pre-processing

*Possible Tools:* 
fastp [https://pubmed.ncbi.nlm.nih.gov/30423086/] (It can perform quality control, adapter trimming, quality filtering, per-read quality pruning and many other operations with a single scan of the FASTQ data. This tool is developed in C++ and has multi-threading support. Based on our evaluation, fastp is 2-5 times faster than other FASTQ preprocessing tools such as Trimmomatic or Cutadapt despite performing far more operations than similar tools. )
- FASTX-toolkit (http://hannonlab.cshl.edu/fastx_toolkit/) (no advantage is shown on the presentation of the tool compared to others)
- CUDA based tool that can also work on CPU only (https://github.com/zanton123/PreprocessReads). The tool draws GPU acceleration and can process 100 milion 100 nucleotide Solexa reads in approximately 5 minutes on a NVIDIA Keppler or Maxwell accelerator.

=> preprocessed reads is prefered as it can deal with CPU (with number of threads declared) and GPU (CUDA) (opti++)

### rRNA removal 

Purpose: "Although most RNA-Seq protocols include the depletion ofrRNA before sequencing, moderate up to high amounts of rRNA can still be found in samples. In particular, this is true for non-model organisms where library preparation kits are not optimized " cf article RKI

Tools: SortMeRNA

### Mapping reads to reference

Bowtie+Tophat2 => iReckon works with Tophat output

### isoform reconstruction and abundance estimation

iReckon 
http://compbio.cs.toronto.edu/ireckon/
https://genome.cshlp.org/content/23/3/519
usage: http://compbio.cs.toronto.edu/ireckon/readme.txt

