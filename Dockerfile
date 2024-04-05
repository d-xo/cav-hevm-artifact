FROM ghcr.io/nixos/nix
WORKDIR /root
RUN git clone https://github.com/eth-sc-comp/benchmarks.git
WORKDIR /root/benchmarks
RUN git reset --hard 06e8a2915e6c1a044bfd7b851d7d9701ec6ab531
RUN nix-shell -p cachix --command "cachix use k-framework"
RUN nix --extra-experimental-features nix-command --extra-experimental-features flakes develop
