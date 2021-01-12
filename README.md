# Worflow comparison analysis

The purpose of this repository is to compare the same workflow done with SnakeMake and NextFlow.
This workflow's purpose is to perform the detection of splicing isoforms from RNA-Seq data.
An efficiency and resources usage will be performed on several plateforms.

## Installation

NextFlow: https://www.nextflow.io/docs/latest/getstarted.html

SnakeMake :https://snakemake.readthedocs.io/en/stable/getting_started/installation.html

## DockerFile

DockerHub: *ninondm/workflow_comparison_analysis*

## Inputs

If test data needed, please check: https://github.com/roryk/tiny-test-data

Files required for the workflows to work:

- Paired end read files (*_1.fq, *_2.fq)
- reference genome file (.fasta)
- reference genome annotation file (.gtf)

Please modify *nextflow/main.nf* and *snakemake/Snakefile* to the paths and name of your files.

## Outputs

Please see the output of each steps in the *result/* folder.

## Steps

- Quality control of the reads with Fastqc
- Read treaming with Fastp
- rRna removal with sortmerna (not available now, is being fixed)
- Reference genome indexation with Hisat2
- Read alignement with Hisat2
- Transcriptome assembly and differential expression analysis with CuffLinks

## How to run the workflows

Note: before trying to run the workflows, please modify the paths and name of your data files. Please see the Input section of this document for more details.

Run NextFlow:
```
cd nextflow

nextflow run main.nf \
-with-docker workflow_comparison_test:latest 
```

Run NextFlow with tracing:

```
cd nextflow

nextflow run main.nf \
-with-docker workflow_comparison_test:latest \
-with-report ../nextflow_report \
-with-trace ../nextflow_trace \
-with-timeline ../nextflow_timeline \
-with-dag ../nextflow_dag.html
```


Run SnakeMake:
```
cd snakemake

snakemake \
--cores 4 \
--use-singularity \
--singularity-args "--bind /your/path/to/this/folder:/your/path/to/this/folder"
```
Draw the SnakeMake DAG:
```
cd snakemake

snakemake \
--cores 4 \
--use-singularity \
--singularity-args "--bind /your/path/to/this/folder:/your/path/to/this/folder" \
--forceall --rulegraph | dot -Tpdf > dag.pdf
```

Note: 
- For SnakeMake, the benchmark is integrated in the rules description and will generate the tracing in the *sm_benchnark* folder
- To obtain the DAG visualisation, please install Graphviz
[```sudo apt-get install graphviz``` for Ubuntu 18]
- The command to obtain the SnakeMake DAG will not run the workflow