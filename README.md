# hop

A fast, intuitive tmux session manager for the terminal.

## Why hop?

Managing tmux sessions can be tedious. You forget session names, lose track of what's running where, and constantly type out `tmux attach -t <session>`. 

**hop** solves this by providing:

- A visual, fuzzy-searchable list of all your tmux sessions
- Saved session templates that auto-create with the right directory and startup command
- Quick keyboard shortcuts for common actions (rename, kill, detach)
- Clear visual distinction between active and inactive sessions

Instead of remembering session names and typing commands, just run `hop` and press Enter.

## Features

- **Fuzzy search** - Quickly find sessions by typing
- **Saved sessions** - Define session templates in TOML with name, path, and startup command
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

   This will install hop to `/usr/local/bin` and data files to `/usr/local/share/hop`.

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
★ File manager · (new)       # Saved session, not yet created
★ Personal · 2h ago *        # Saved session, active (attached)
★ Notes · 1h ago             # Saved session, running
main · 30m ago                   # Regular tmux session
work · 45m ago                   # Regular tmux session
```

- `★` - Saved session (defined in sessions.toml)
- `*` - Currently attached
- `(saved)` - Session doesn't exist yet, will be created on selection
- Green text - Attached session
- Gray text - Detached session

## License

MIT
