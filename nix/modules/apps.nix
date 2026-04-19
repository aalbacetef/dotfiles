
  { sysPkgs }:

  let 
    devopsAndInfra = with sysPkgs; [
        ansible
        ansible-lint
        act
        doctl
        gh
        glab
        gitlab-ci-local
        kustomize
        terraform
        pgcli
        sqlfluff
    ];

    apps = with sysPkgs; [
        brave
        emacs
        helix
        meld
        neovim
        obsidian
        octaveFull
        ranger

        ## disabled (causing issues)
        # zed-editor
    ];

    cliTools = with sysPkgs; [
        # general CLI tools
        alacritty
        asciidoctor
        bitwarden-cli
        btop
        bun
        devenv
        doggo
        fish
        glow
        http-server
        httpie
        jq
        kitty
        macchina
        minio-client
        moor # pager, replaces less
        ngrok
        tmux
        tree-sitter
        yq
        zellij
    ];

    networkAndSecurity = with sysPkgs; [
        assetfinder
        netcat
        nmap
        nmap-formatter
        semgrep
        subfinder
        testssl
        thc-hydra
    ];

    generalDevTools = with sysPkgs; [
        ## solana dev environment 
        anchor
        solana-cli

        ## dev tools
        air
        dotenvx 
        goose
        sqlc
        web-ext 
        wrk
    ];

    ai = with sysPkgs; [
        # temporary disabling:
        ## aider-chat

        gemini-cli
        crush 
        ollama
        opencode
        llama-swap
    ];

    multimediaAndStreaming = with sysPkgs; [
        ffmpeg
        jellyfin
        mangayomi
        mpv
        vlc
    ];

  in
    devopsAndInfra ++ apps ++ cliTools ++ networkAndSecurity ++ generalDevTools ++ ai ++ multimediaAndStreaming
