# CAV Artifact for `hevm`

This is an artifact for the tool paper "hevm, a Fast Symbolic Execution Framework for EVM Bytecode"
submitted to CAV2024 (submission number: 6413).

We claim that we meet the criteria for the reusable badge (justification provided in sections below).

## Artifact Requirements

The evaluation presented in section 6. of the paper was carried out on a dedicated server with a 16
core CPU with boost frequency up to 4.9GHz (AMD 5950X) and 128GB RAM. A full evaluation required
~24hrs on this machine.

The evaluation script provided as part of this artifact provides a `--brief` option that runs a
randomly selected subset of experiments. This subset was fully evaluated in ~1hr on a modern laptop
(AMD Ryzen 7 7840U / 64GB RAM) with the docker container being restricted to 4 cores and 16GB RAM.

Full instructions for executing the evaluation script are provided in the "Getting Started" section.

## Structure and Content

- `/root/benchmarks`: source code and execution scripts for the benchmarks presented in the paper
- `/root/benchmark-results`: full logs and results of the benchmarking run presented in the paper
- `/root/hevm`: source code (including documentation) for hevm

### Getting Started

First, load the docker image `hevm-cav-image` from the .tar archive (docker may require `sudo` root privileges):

```bash
docker load < hevm-cav-image.tar
```

Upon loading the image, you can run the container with:

```bash
docker run -v `pwd`/graphs:/root/benchmarks/graphs --rm -it hevm-cav
```

The command above starts the docker container and places you in a bash environment, where you can inspect the source code or run the experiments. The `-v` option will mount the `graphs` folder in your current directory to the corresponding folder within the container where the evaluation results will be stored. This will allow you to view the generated output even after the container has stopped running. `--rm` is an optional flag that creates a disposable container that will be deleted upon exit.

To replicate exactly the results from the paper use the following. In order to match the environment
used to generate the results in the paper, the container should have 16 fast cores availabe, and at
least 110GB free RAM.

```bash
./evaluate.sh -m 110000
```

The evaluation script has the following additional options:
* `--smoke-test` option allows you to detect any technical difficulties for the smoke-test phase (should take up to 5 minutes)
* `--brief` option allows you to run a randomly selected subset of experiments (should take up to an hour)

If finished successfully, the evaluation script should print:

```
All experiments were successful.
```

You can exit the container by typing `exit`. Graphs generated by the evaluation script remain available in `$PWD/graphs`. The main graph from section 6. of the paper can be found at `$PWD/graphs/cdf.{eps,png}`.

Upon finishing your review, you can remove the image from the Docker environment using:

```
docker rmi hevm-cav
```

## Functional badge

**reproducibility of results**

The full set of experiments from section 6. of the paper can be reproduced using this artifact via
the evaluation script (see above for usage instructions). Our experiments were run on a powerful
server with lots of RAM (AMD 5950X // 128GB), and took ~24 hours to execute fully.

A randomly selected subset should be reproducible on a modern laptop using the `--brief` option of
the evaluation script.

**correctness of hevm**

- `hevm` is tested in the following ways (described in section 6. of the paper):
  - using the standard evm conformance test suite
  - via a differential fuzzing harness vs geth (the most popular ethereum client)
  - via an smt based semantic fuzzing harness for it's simplification engine
  - via a set of hand written unit tests

**log files**

- Log files from the results presented in the paper are available in the artifact at `/root/benchmark-results`.

**source code**

- Source code for `hevm` is availalbe in the artifact at `/root/hevm`.


## Reusable badge

**licenses**

This artifact is made available under GPLv3. `hevm` is made available under AGPL-V3.

**dependencies**

- `hevm` is written in haskell, we use a modern version of ghc (9.4.6).
- Expected versions of all haskell libraries can be found in the artifact at `/root/hevm/hevm.cabal`
- We depend on a few c libraries: [libff](https://github.com/scipr-lab/libff),
    [libsecp256k1](https://github.com/bitcoin-core/secp256k1), and [GMP](https://gmplib.org/). The
    project build scripts pull these from a recent version of [nixpkgs](https://github.com/NixOS/nixpkgs).
- `hevm` expects one of `Z3`, `CVC5` or `Bitwuzla` to be available on PATH at runtime.

**use beyond the paper**

- the ds-test format introduced by `hevm` is very popular, and in wide use across the ecosystem.
    Most Solidity developers are familiar with it, and can very easily modify their existing fuzz
    tests to use symbolic execution.
- `hevm` is compatible with [foundry](https://github.com/foundry-rs/foundry) projects (a very
    popular project management framework for solidity).
- user facing documentation is published online at [hevm.dev](https://hevm.dev/).

**use outside of the artifact**

- `hevm` has a set of highly reproducible build scripts (based on nix). These allow the project to
    be built on any linux or macos system.
- static binaries for linux and macos are made available for every release
- `hevm` is available via [nixpkgs](https://github.com/NixOS/nixpkgs).
