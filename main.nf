#!/usr/bin/env nextflow
/*
========================================================================================
    nf-core/klebtest
========================================================================================
    Github : https://github.com/nf-core/klebtest
    Website: https://nf-co.re/klebtest
    Slack  : https://nfcore.slack.com/channels/klebtest
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

/*
========================================================================================
    GENOME PARAMETER VALUES
========================================================================================
*/

params.fasta = WorkflowMain.getGenomeAttribute(params, 'fasta')

/*
========================================================================================
    VALIDATE & PRINT PARAMETER SUMMARY
========================================================================================
*/

WorkflowMain.initialise(workflow, params, log)

/*
========================================================================================
    NAMED WORKFLOW FOR PIPELINE
========================================================================================
*/

include { KLEBTEST } from './workflows/klebtest'

//
// WORKFLOW: Run main nf-core/klebtest analysis pipeline
//
workflow NFCORE_KLEBTEST {
    KLEBTEST ()
}

/*
========================================================================================
    RUN ALL WORKFLOWS
========================================================================================
*/

//
// WORKFLOW: Execute a single named workflow for the pipeline
// See: https://github.com/nf-core/rnaseq/issues/619
//
workflow {
    NFCORE_KLEBTEST ()
}

/*
========================================================================================
    THE END
========================================================================================
*/
