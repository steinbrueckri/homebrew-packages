# Homebrew tap maintenance tasks.
# Run `just` to list available recipes.

# Show available recipes
default:
    @just --list

# Report which formulae have a newer upstream release (writes nothing)
check *packages:
    python3 scripts/update.py --dry-run {{packages}}

# Update formulae to the latest upstream release (all by default)
update *packages:
    python3 scripts/update.py {{packages}}
