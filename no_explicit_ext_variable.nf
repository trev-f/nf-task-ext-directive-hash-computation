// Script taken from: https://www.nextflow.io/docs/latest/your-first-script.html#run-a-pipeline

params.str = 'Hello world!'

process splitLetters {
    output:
    path 'chunk_*'

    script:
    """
    echo "${task.ext}"
    printf '${params.str}' | split -b 6 - chunk_
    """
}

workflow {
    splitLetters | flatten | view { it.text.trim() }
}
