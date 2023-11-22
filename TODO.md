# To Do


### bootstrap 

This could be implemented via a setup.sh at the project root level. CI can run this, I could also run it in a Dockerfile.

It would go through the steps of installing all the necessary packages, copying configs over, setting environment variables, etc...

### project variables

I need to find a way to add variables into my system. Ideally, I'd add a config.sample.yml, the bootstrap script could check for a config.yml, and exit if it can't find it.


### Templates in files

For example, alacritty requires that files be imported using absolute paths or ~/ paths, in which case
I would need to be able to subsitute $DOTFILES into it.


