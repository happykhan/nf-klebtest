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
    tuple val(meta), path("contigs.fa")                         , emit: contigs
    tuple val(meta), path("shovill.log")                        , emit: log
    path  "*.version.txt"          , emit: version

    script:
    // Add soft-links to original FastQs for consistent naming in pipeline
    """
    shovill \\
        --R1 ${reads[0]} \\
        --R2 ${reads[1]} \\
        $args \\
        --cpus $task.cpus \\
        --outdir ./ \\
        --force
    shovill --version | sed -e 's/^.*shovill //' > shovill.version.txt
    """
    stub:

    """
      touch contigs.fa
      touch shovill.log
      touch skesa.fasta
      touch shovill.corrections
      touch contig.gfa
      shovill --version | sed -e 's/^.*shovill //' > shovill.version.txt
    """
}

