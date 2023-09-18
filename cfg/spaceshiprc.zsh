# Display time
SPACESHIP_TIME_SHOW=true

if [ "$(uname -n)" != "kali" ]; then
    SPACESHIP_TIME_FORMAT='%D{%b %d, %H:%M:%S}'
fi

SPACESHIP_USER_SHOW="needed"

SPACESHIP_BATTERY_SHOW=false

SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

# Show I can use cached sudo passwordless
SPACESHIP_SUDO_SHOW=true

# Default prompt order
# SPACESHIP_PROMPT_ORDER=(
#   time          # Time stampts section
#   user          # Username section
#   dir           # Current directory section
#   host          # Hostname section
#   git           # Git section (git_branch + git_status)
#   hg            # Mercurial section (hg_branch  + hg_status)
#   package       # Package version
#   node          # Node.js section
#   ruby          # Ruby section
#   python        # Python section
#   elm           # Elm section
#   elixir        # Elixir section
#   xcode         # Xcode section
#   swift         # Swift section
#   golang        # Go section
#   php           # PHP section
#   rust          # Rust section
#   haskell       # Haskell Stack section
#   java          # Java section
#   julia         # Julia section
#   docker        # Docker section
#   aws           # Amazon Web Services section
#   gcloud        # Google Cloud Platform section
#   venv          # virtualenv section
#   conda         # conda virtualenv section
#   dotnet        # .NET section
#   kubectl       # Kubectl context section
#   terraform     # Terraform workspace section
#   ibmcloud      # IBM Cloud section
#   exec_time     # Execution time
#   async         # Async jobs indicator
#   line_sep      # Line break
#   battery       # Battery level and status
#   jobs          # Background jobs indicator
#   exit_code     # Exit code section
#   char          # Prompt character
# )

# Right prompt order is empty by default
# SPACESHIP_RPROMPT_ORDER=()
