// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from '../functions'

params.options = [:]
options        = initOptions(params.options)

process MLST {
    tag "$meta.id"

    label 'process_low'

    publishDir "${params.outdir}/${getSoftwareName(task.process)}/",
        mode: params.publish_dir_mode

    conda (params.enable_conda ? "bioconda::mlst=2.19.0" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container 'https://depot.galaxyproject.org/singularity/mlst:2.19.0--hdfd78af_1'
    } else {
        container 'quay.io/biocontainers/mlst:2.19.0--hdfd78af_1'
    }

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path("*.tsv"), emit: tsv
    path  "*.version.txt"          , emit: version

    script:
    // Add soft-links to original FastQs for consistent naming in pipeline
    def software = getSoftwareName(task.process)
    """
    mlst \\
        --threads $task.cpus \\
        $fasta \\
        > ${meta.id}.tsv
    mlst --version | sed 's/${software} //' > ${software}.version.txt
    """
    stub:
    def software = getSoftwareName(task.process)
    """
      touch ${meta.id}.tsv
      mlst --version | sed 's/${software} //' > ${software}.version.txt
    """

}
