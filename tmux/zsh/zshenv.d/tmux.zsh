# tmux-sessionizer (installed by tmux/install.sh) lives in ~/.local/bin.
case ":$PATH:" in
*":$HOME/.local/bin:"*) ;;
*) export PATH="$HOME/.local/bin:$PATH" ;;
esac
