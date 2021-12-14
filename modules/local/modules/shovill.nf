// Import generic module functions
include { saveContigs } from '../na-functions'

process SHOVILL {
    tag "$meta.id"
    label 'process_medium'

    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveContigs(filename:filename, publish_dir:'ass', meta:meta) }

    conda (params.enable_conda ? "bioconda::shovill=1.1.0" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/shovill:1.1.0--0"
    } else {
        container "quay.io/biocontainers/shovill:1.1.0--0"
    }

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("${meta.id}.fa")                         , emit: contigs
    tuple val(meta), path("${meta.id}.shovill.log")                        , emit: log
    path  "*.version.txt"          , emit: version

    script:
    """
    shovill \\
        --R1 ${reads[0]} \\
        --R2 ${reads[1]} \\
        $args \\
        --cpus $task.cpus \\
        --outdir ./ \\
        --force
    mv contigs.fa ${meta.id}.fa
    mv shovill.log ${meta.id}.shovill.log
    shovill --version | sed -e 's/^.*shovill //' > shovill.version.txt
    """
    stub:

    """
      touch ${meta.id}.fa
      touch ${meta.id}.shovill.log
      shovill --version | sed -e 's/^.*shovill //' > shovill.version.txt
    """
}

