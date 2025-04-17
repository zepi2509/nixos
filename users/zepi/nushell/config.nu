# ----------------------
# Miscellaneous Settings
# ----------------------
$env.config.show_banner = false


# ---------------------------
# Commandline Editor Settings
# ---------------------------
$env.config.edit_mode = "vi"
$env.config.buffer_editor = "nvim"
$env.config.cursor_shape.vi_insert = "underscore"
$env.config.cursor_shape.vi_normal = "block"


# --------------------
# Completions Behavior
# --------------------
$env.config.completions.algorithm = "fuzzy"


# -------------
# Table Display
# -------------
$env.config.table.mode = "compact"


# -------
# Modules
# -------
source ~/.cache/.zoxide.nu

# --------
# carapace
# --------
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir ($nu.data-dir | path join "carapace")
carapace _carapace nushell | save -f ($nu.data-dir | path join "carapace/init.nu")


# ------
# zoxide
# ------
mkdir ($nu.data-dir | path join "zoxide")
zoxide init --cmd cd nushell | save -f ($nu.data-dir | path join "zoxide/.zoxide.nu")


# --------
# starship
# --------
mkdir ($nu.data-dir | path join "starship")
starship init nu | save -f ($nu.data-dir | path join "starship/starship.nu")
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = ""
