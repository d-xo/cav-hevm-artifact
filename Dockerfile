FROM ghcr.io/nixos/nix

# clone benchmarks and prepare nix shell
WORKDIR /root
RUN git clone https://github.com/eth-sc-comp/benchmarks.git
WORKDIR /root/benchmarks
RUN git reset --hard 06e8a2915e6c1a044bfd7b851d7d9701ec6ab531
RUN nix-shell -p cachix --command "cachix use k-framework"
RUN nix --extra-experimental-features nix-command --extra-experimental-features flakes develop

# clone hevm source
WORKDIR /root
RUN git clone https://github.com/ethereum/hevm.git

# copy bennchmark results
RUN mkdir -p /root/benchmark-results/
COPY benchmark-results.json /root/benchmark-results/results.json
COPY benchmark-results.csv /root/benchmark-results/results.csv

# fix up for evaluation
COPY evaluate.sh /root/benchmarks/evaluate.sh
COPY brief.diff /root/benchmarks/brief.diff
WORKDIR /root/benchmarks

# enter the benchmarks repo and it's nix shell by default
WORKDIR /root/benchmarks
ENTRYPOINT nix --extra-experimental-features nix-command --extra-experimental-features flakes develop

LABEL org.opencontainers.image.source="https://github.com/d-xo/cav-hevm-artifact"
