# 🐰hop

A fast, intuitive tmux session manager for the terminal.

Inspired by [sesh](https://github.com/joshmedeski/sesh) - Another excellent tmux session manager

## Why hop?

Managing tmux sessions can be tedious. You forget session names, lose track of what's running where, and constantly type out `tmux attach -t <session>`. 

**hop** solves this by providing:

- A visual, fuzzy-searchable list of all your tmux sessions
- Saved session templates that auto-create with the right directory and startup command
- Quick keyboard shortcuts for common actions (create, rename, kill, detach)
- Smart prioritization with clear visual distinction between attached and detached sessions
- Lightning-fast performance with intelligent caching

Instead of remembering session names and typing commands, just run `hop` and press Enter.

## Features

- **Fuzzy search** - Quickly find sessions by typing
- **Saved sessions** - Define session templates in TOML with name, path, and startup command
- **Smart prioritization** - Current client's session appears first, attached sessions highlighted
- **Lightning fast** - Optimized startup with caching (7x performance improvement)
- **Keyboard-driven** - All actions accessible via shortcuts

## Requirements

- **bash** (4.0+)
- **tmux**
- **fzf** - Fuzzy finder for the session list
- **gum** - For confirmation dialogs and input prompts
- **Python 3.11+** - For TOML parsing (uses built-in `tomllib`)

### Installing dependencies

**Arch Linux:**
```bash
sudo pacman -S tmux fzf gum python
```

**macOS (Homebrew):**
```bash
brew install tmux fzf gum python
```

**Ubuntu/Debian:**
```bash
sudo apt install tmux fzf python3
# gum requires manual install: https://github.com/charmbracelet/gum#installation
```

## Installation

### Option 1: Using the install script (recommended)

1. Clone or download this repository:
   ```bash
   git clone https://github.com/ize-302/hop.git
   cd hop
   ```

2. Run the install script:
   ```bash
   ./install
   ```

   This will install hop to `/usr/local/bin`, data files to `/usr/local/share/hop`, and create a default `sessions.toml` configuration file in `~/.config/hop/` if it doesn't exist.

3. Run it:
   ```bash
   hop
   ```

### Option 2: Manual installation

1. Clone or download this repository:
   ```bash
   git clone https://github.com/ize-302/hop.git
   cd hop
   ```

2. Make the script executable:
   ```bash
   chmod +x hop
   ```

3. (Optional) Add to your PATH:
   ```bash
   ln -s "$(pwd)/hop" ~/.local/bin/hop
   # Or copy to a directory in your PATH
   sudo cp hop /usr/local/bin/
   sudo cp -r data /usr/local/share/hop/
   ```

4. Run it:
   ```bash
   hop
   ```

### Uninstalling

To uninstall hop installed via the install script:
```bash
./install --uninstall
```

## Configuration

hop looks for saved sessions in `~/.config/hop/sessions.toml`.

### Example configuration

```toml
[[session]]
name = "File manager"
path = "/home/user"
startup_command = "yazi"

[[session]]
name = "Work"
path = "~/work/"
startup_command = "nvim"

[[session]]
name = "Personal"
path = "~/personal/"
startup_command = "nvim"
```

### Session options

| Field | Description |
|-------|-------------|
| `name` | Display name for the session (supports emojis) |
| `path` | Working directory (supports `~` expansion) |
| `startup_command` | Command to run when the session is created |

## Usage

Run `hop` to open the session picker:

```bash
hop
```

### Keyboard shortcuts

| Key | Action |
|-----|--------|
| `Enter` | Switch to selected session (creates if saved & doesn't exist) |
| `Ctrl+N` | Create a new session |
| `Ctrl+R` | Rename selected session |
| `Ctrl+D` | Detach selected session |
| `Ctrl+X` | Kill selected session |
| `Tab` | Move down |
| `Shift+Tab` | Move up |
| `Esc` | Quit |
| Type | Filter sessions by name |

### Display

```
★ Personal · 2h ago *        # Current client session (top priority)
main · 5m ago                # Other client attached session (green)
★ Notes · 1h ago             # Saved session, detached (gray)
work · 45m ago               # Regular session, detached (gray)
★ File manager · (saved)     # Saved session, not yet created
```

- `★` - Saved session (defined in sessions.toml)
- `*` - Attached to current tmux client
- `(saved)` - Session doesn't exist yet, will be created on selection
- **Green text** - Session attached to any tmux client
- **Gray text** - Detached session
- **Top priority** - Current client's session appears first

## Development

### Versioning

hop uses [Semantic Versioning](https://semver.org/). Version information is stored in the `VERSION` file.

### CI/CD

This project uses GitHub Actions for:
- **Continuous Integration**: Automated testing on every push and pull request
- **Automated Releases**: Versioned releases with changelog generation when tags are pushed

### Releasing

To create a new release:

1. Update the `VERSION` file with the new version number
2. Commit and push the changes
3. Create and push a git tag: `git tag vX.Y.Z && git push origin vX.Y.Z`
4. GitHub Actions will automatically create a release with changelog and assets

## License

MIT
