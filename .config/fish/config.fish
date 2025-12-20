if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/ivan/.ghcup/bin # ghcup-env

# Set default C and C++ compilers
export CC=$(which clang)
export CXX=$(which clang++)

function fish_greeting
  cat ~/reminders.txt
end

export WALLPAPER_DIR=/home/ivan/custom/wallpaper

function gimpmath
  gimp ~/gimpmath/*.xcf
end

function gimpfund
  gimp ~/gimpfundamentals/*.xcf
end
