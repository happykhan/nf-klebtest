// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from '../functions'

params.options = [:]
options        = initOptions(params.options)

process KLEBORATE {
    tag "$meta.id"
    label 'process_low'

    conda (params.enable_conda ? "bioconda::kleborate=2.1.0" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container 'https://depot.galaxyproject.org/singularity/kleborate:2.1.0--pyhdfd78af_1'
    } else {
        container 'quay.io/biocontainers/kleborate:2.1.0--pyhdfd78af_1'
    }

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path("*.tsv"), emit: txt
    path  "*.version.txt"          , emit: version

    script:
    // Add soft-links to original FastQs for consistent naming in pipeline
    def software = getSoftwareName(task.process)
    def args = task.ext.args ?: ''

    """
    kleborate \\
        $args \\
        --outfile ${meta.id}.results.tsv \\
        --assemblies $fasta

    kleborate --version | sed 's/Kleborate v//;' > ${software}.version.txt
    """
    stub:
    def software = getSoftwareName(task.process)
    """
      touch ${meta.id}.results.tsv 
      kleborate --version | sed 's/Kleborate v//;' > ${software}.version.txt
    """

}

