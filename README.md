# ZSH Theme
<img alt="ZSH theme example" src="resources/example.png" width="625">

A simple and minimalistic ZSH theme tailored to my personal workflow.
It provides a compact, clean prompt showing the last command's exit status and the current working directory.
When inside a Git repository, it displays the active Git reference (branch, tag or commit hash), automatically truncating long branch names.
An indicator appears when there are uncommitted changes, keeping the prompt informative without clutter.

<img alt="ZSH theme example" src="resources/example.gif" width="625">

## Installation
Select and follow the installation instructions for a shell framework of your choice.

<details>
    <summary>Plain (without a framework)</summary>

### Without Framework
1. Download the theme file `zsh-theme.zsh` to any directory.
The next shell command will download the theme as the `~/.zshrc.vstelmakh.plugin.zsh` file:
```shell
curl -fL# --create-dirs \
    -o "${HOME}/.zshrc.vstelmakh.plugin.zsh" \
    "https://raw.githubusercontent.com/vstelmakh/zsh-theme/main/zsh-theme.zsh"
```

2. Source the theme in `~/.zshrc` file.
The next shell command will source the theme in the `~/.zshrc` file:
```shell
echo -e "\nsource ${HOME}/.zshrc.vstelmakh.plugin.zsh\n" >> "${ZSH_CONFIG}"
```

3. Restart your terminal or run `source ~/.zshrc` to apply the changes.
</details>

<details>
    <summary>Oh My ZSH</summary>

### Oh My ZSH
1. Download the theme file `zsh-theme.zsh` to Oh My ZSH custom theme directory.
The next shell command will download the theme to the OMZ custom themes location with the name `vstelmakh.zsh-theme`: 
```shell
curl -fL# --create-dirs \
    -o "$([ -z "${ZSH_CUSTOM}" ] && echo "${ZSH}/custom" || echo "${ZSH_CUSTOM}")/themes/vstelmakh.zsh-theme" \
    "https://raw.githubusercontent.com/vstelmakh/zsh-theme/main/zsh-theme.zsh"
```

2. Configure theme `ZSH_THEME=vstelmakh` in `~/.zshrc` file.
The next shell command will update the theme in the `~/.zshrc` file:
```shell
sed -i -E "s/^\(\s*ZSH_THEME=\)\(.*\)/\1\"vstelmakh\"/g" "${HOME}/.zshrc"
```

3. Restart your terminal or run `source ~/.zshrc` to apply the changes.
</details>

## Contributing
Contributions are welcome - especially bug fixes and improvements to stability.
However, not all changes may be accepted, as the goal is to keep the theme simple and aligned with my personal preferences.
If you are looking for additional styling options or customizations, please fork the repository and adapt the theme to your needs.

## Credits
[Volodymyr Stelmakh](https://github.com/vstelmakh)  
Licensed under the MIT License. See [LICENSE](LICENSE) for more information.  
