# Nextflow Task Ext Directive Cache Invalidation

This repo contains a reproducible example for a bug in Nextflow task hash cache invalidation.

## Bug report

Only the variables from the task ext directive that are explicitly accessed in a process are used to compute the task hash.
This is at odds with the way the docs are written as these imply that any changes to the task ext directive should cause a change in the computation of the task hash.

## Reproducible example

For convenience, a reproducible example can be run with a single command.

This command runs the `ext_task_hash_test.nf` pipeline twice -- on the second run, `ext_args.config` is supplied to change the value of `task.ext.args`.
The task hashes are extracted from the two runs, and a diff is produced to check that task hashes are updated.

`ext_task_hash_test.nf` runs two processes:

1. `explicitTaskExtAccess` -- Explicitly accesses `task.ext.args` in the `script` block.
2. `noExplicitTaskExtAccess` -- Only accesses `task.ext` in the `script` block.

### Run reprex

```bash
./compare-hashes.sh ext_task_hash_test.nf
```

### Reprex output

```
Starting Run 1
Hello
world!
Hello
world!

Starting Run 2
Hello
world!
Hello
world!

Task hash diff:
1c1
< [explicitTaskExtAccess] cache hash: 9c235f212efac9273fab8a12f679a5ab; mode: STANDARD; entries: [
---
> [explicitTaskExtAccess] cache hash: c883dcfe8824349d780b12ac5d7acc2a; mode: STANDARD; entries: [
```

As expected, the diff shows that the process that explictly accesses `task.ext.args` in the `script` block has a different task hash after resuming with a different `task.ext.args` value.

However, the process that only accesses `task.ext` without explicitly accessing the `args` variable does not have a different task hash after resuming with a different value for `task.ext.args`.
