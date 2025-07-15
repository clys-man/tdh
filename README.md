# tmux-dev-helper

`tmux-dev-helper` is a Bash script that automates the creation and management of [tmux](https://github.com/tmux/tmux) sessions for development projects. It can automatically open windows for editors, shells, Git tools, Docker/Sail environments, and Makefile builds, streamlining your workflow.

## Features

- Automatically creates a new tmux session for a given project directory.
- Opens windows for:
  - `nvim` (or your preferred editor)
  - Shell
  - [lazygit](https://github.com/jesseduffield/lazygit) if the directory is a Git repository
  - [lazydocker](https://github.com/jesseduffield/lazydocker) if Docker or Sail is detected
  - Makefile build window if a Makefile is present
- Supports running Docker Compose or Laravel Sail in the background or interactively.
- Verbose mode for running commands interactively in a dedicated window.

## Requirements

- [tmux](https://github.com/tmux/tmux)
- [nvim](https://neovim.io/) (or change to your preferred editor in the script)
- [lazygit](https://github.com/jesseduffield/lazygit) (optional, for Git integration)
- [lazydocker](https://github.com/jesseduffield/lazydocker) (optional, for Docker integration)
- [docker](https://www.docker.com/) and [docker-compose](https://docs.docker.com/compose/) (optional)
- [Laravel Sail](https://laravel.com/docs/8.x/sail) (optional)
- [make](https://www.gnu.org/software/make/) (optional)

## Installation

You can install directly from GitHub using `curl` or `wget` (no sudo required):

```zsh
# Make sure ~/.local/bin exists and is in your $PATH
mkdir -p ~/.local/bin

# Using curl
curl -o ~/.local/bin/tdh "https://raw.githubusercontent.com/clys-man/tmux-dev-helper/main/tdh.sh" && chmod +x ~/.local/bin/tdh

# Or using wget
wget -O ~/.local/bin/tdh "https://raw.githubusercontent.com/clys-man/tmux-dev-helper/main/tdh.sh" && chmod +x ~/.local/bin/tdh
```

Make sure `~/.local/bin` is in your `$PATH`. You can add this to your `~/.bashrc`, `~/.zshrc`, or equivalent:

```zsh
export PATH="$HOME/.local/bin:$PATH"
```

Alternatively, you can clone or download this repository and move the script manually:

1. Clone or download this repository.
2. Make the script executable:

   ```zsh
   chmod +x tdh.sh
   ```

3. Move it to a directory in your `$PATH` (e.g., `~/.local/bin`):

   ```zsh
   mv tdh.sh ~/.local/bin/tdh
   ```

## Usage

```zsh
tdh [--docker] [--sail] [--make] [--verbose] [project_path]
```

- `--docker`: Use Docker Compose if `docker-compose.yml` is present.
- `--sail`: Use Laravel Sail if `vendor/bin/sail` is executable.
- `--make`: Open a window for `make` if a Makefile is present.
- `--verbose`: Run Docker/Sail/Make commands interactively in a startup window.
- `project_path`: Path to your project directory (defaults to current directory).

**Note:** Do not use `--docker` and `--sail` together.

## Example

```zsh
tdh --docker --make --verbose ~/Projects/my-app
```

This will create a tmux session for `my-app` with windows for `nvim`, shell, lazygit, lazydocker, and make, running Docker Compose and Make interactively.

---

Feel free to customize the script to fit your workflow!
