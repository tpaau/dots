APPLY_COLORS_SOURCED=1

if (( PATHS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/paths.sh; fi

apply_colors()
{
	local input="$CURRENT_COLORS"
	local tmp="$TMP_DIR/hypr_colors.conf"
	local target="$HOME/.config/hypr/sources/colors.conf"

	> "$tmp"

	while IFS= read -r line; do
		local name=$(echo "$line" | sed -n 's/@define-color[[:space:]]\+\([a-zA-Z0-9_-]\+\)[[:space:]]\+#.*$/\1/p')
		local color=$(echo "$line" | sed -n 's/.*#\([a-fA-F0-9]\{6\}\);*$/\1/p')
		echo "\$$name = $color" >> "$tmp"
	done < "$input"

	mv "$tmp" "$target"
}
