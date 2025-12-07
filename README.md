# ZSH Theme
A simple and minimalistic ZSH theme tailored to my personal workflow.
It provides a compact, clean prompt showing the last command's exit status and the current working directory.
When inside a Git repository, it displays the active Git reference (branch, tag or commit hash), automatically truncating long branch names.
An indicator appears when there are uncommitted changes, keeping the prompt informative without clutter.

## Installation
Select and follow the installation instructions for a shell framework or your framework of choice.

<details>
    <summary>Plain (without a framework)</summary>

### Without Framework
1. Download the theme file `zsh-theme.zsh` to any directory. For example, to `~/.zshrc.vstelmakh.plugin.zsh`:
```shell
curl -fL --create-dirs \
    -o "${HOME}/.zshrc.vstelmakh.plugin.zsh" \
    "https://raw.githubusercontent.com/vstelmakh/zsh-theme/main/zsh-theme.zsh"
```

2. Source the theme in `~/.zshrc` file:
```shell
echo -e "\nsource ${HOME}/.zshrc.vstelmakh.plugin.zsh\n" >> "${ZSH_CONFIG}"
```

3. Restart your terminal or run `source ~/.zshrc` to apply the changes.
</details>

<details>
    <summary>Oh My ZSH</summary>

### [Oh My ZSH](https://ohmyz.sh/)
1. Download the theme file `zsh-theme.zsh` to Oh My ZSH custom theme directory:
```shell
curl -fL --create-dirs \
    -o "$([ -z "${ZSH_CUSTOM}" ] && echo "${ZSH}/custom" || echo "${ZSH_CUSTOM}")/themes/vstelmakh.zsh-theme" \
    "https://raw.githubusercontent.com/vstelmakh/zsh-theme/main/zsh-theme.zsh"
```

2. Configure theme `ZSH_THEME=vstelmakh` in `~/.zshrc` file:
```shell
sed -i -E "s/^\(\s*ZSH_THEME=\)\(.*\)/\1\"vstelmakh\"/g" "${HOME}/.zshrc"
```

3. Restart your terminal or run `source ~/.zshrc` to apply the changes.
</details>

## Contributing
Contributions are welcome - especially bug fixes and improvements to stability.
However, not all changes may be accepted, as the goal is to keep the theme simple and aligned with my personal workflow.
If you are looking for additional styling options or customizations, please fork the repository and adapt the theme to your needs.

## Credits
[Volodymyr Stelmakh](https://github.com/vstelmakh)  
Licensed under the MIT License. See [LICENSE](LICENSE) for more information.  
