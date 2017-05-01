### Setting up Exercism CLI completion (optional)

#### Bash

If you use a Bash shell, you can use the CLI Bash-completion script.

First download the script [[view source]](http://cli.exercism.io/exercism_completion.bash):

```bash
mkdir -p ~/.config/exercism/
curl http://cli.exercism.io/exercism_completion.bash > ~/.config/exercism/exercism_completion.bash
```

Load up the completion in your `.bashrc`, `.bash_profile` or `.profile` by adding the following snippet:

```bash
if [ -f ~/.config/exercism/exercism_completion.bash ]; then
  . ~/.config/exercism/exercism_completion.bash
fi
```

After opening a new Bash shell, you should be able to type `exercism s` then press Tab, and Bash completion will give you `exercism submit`.

#### Zsh

If you use a Zsh shell, you can use the CLI Zsh-completion script.

First download the script [[view source]](http://cli.exercism.io/exercism_completion.zsh):

```zsh
mkdir -p ~/.config/exercism/
curl http://cli.exercism.io/exercism_completion.zsh > ~/.config/exercism/exercism_completion.zsh
```

Load up the completion in your `.zshrc`, `.zsh_profile` or `.profile` by adding the following snippet:

```zsh
if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
  . ~/.config/exercism/exercism_completion.zsh
fi
```

If you are using the popular [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) framework to manage your Zsh plugins,
you don't need to add the above snippet, all you need to do is create a file `exercism_completion.zsh` inside `~/.oh-my-zsh/custom`.

After opening a new Zsh shell, you should be able to type `exercism s` and Zsh completion will give you `exercism submit`.
