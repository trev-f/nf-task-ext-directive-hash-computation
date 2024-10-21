// Script taken from: https://www.nextflow.io/docs/latest/your-first-script.html#run-a-pipeline

params.str = 'Hello world!'

process explicitTaskExtAccess {
    output:
    path 'chunk_*'

    script:
    """
    echo "${task.ext.args}"
    printf '${params.str}' | split -b 6 - chunk_
    """
}

process noExplicitTaskExtAccess {
    output:
    path 'chunk_*'

    script:
    """
    echo "${task.ext}"
    printf '${params.str}' | split -b 6 - chunk_
    """
}

workflow {
    explicitTaskExtAccess | flatten | view { it.text.trim() }

    noExplicitTaskExtAccess | flatten | view { it.text.trim() }
}
