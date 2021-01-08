process hisat2index {
    label 'hisat2'
    input:
    path(reference)

    output:
    tuple path(reference), path("${reference.baseName}*.ht2")

    script:
    """
    hisat2-build -p ${task.cpus} ${reference} ${reference.baseName}
    """
}