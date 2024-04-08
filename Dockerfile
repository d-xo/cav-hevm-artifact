FROM ghcr.io/nixos/nix

# prepare nix
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
RUN nix-shell -p cachix --command "cachix use k-framework"

# clone benchmarks
WORKDIR /root
RUN git clone https://github.com/eth-sc-comp/benchmarks.git
WORKDIR /root/benchmarks
RUN git reset --hard 723e785dbabc9d54e244429ede9b20bc6914aad5

# install benchmark deps
RUN nix develop
RUN nix-env --install patch

# clone hevm source
WORKDIR /root
RUN git clone https://github.com/ethereum/hevm.git

# copy bennchmark results
RUN mkdir -p /root/benchmark-results/
COPY benchmark-results.json /root/benchmark-results/results.json
COPY benchmark-results.csv /root/benchmark-results/results.csv

# prepare evaluation script
WORKDIR /root/benchmarks
COPY evaluate.sh /root/benchmarks/evaluate.sh
COPY brief.diff /root/benchmarks/brief.diff
RUN patch -p1 < brief.diff
RUN git config user.name 'docker'
RUN git config user.email '<>'
RUN git commit -am "add eval.sh"
RUN nix develop

# enter the benchmarks repo and it's nix shell by default
WORKDIR /root/benchmarks
ENTRYPOINT nix develop
