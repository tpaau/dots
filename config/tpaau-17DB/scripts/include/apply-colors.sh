apply_colors()
{
	source ~/.config/tpaau-17DB/scripts/include/paths.sh

	local input="$COLORS_DIR/colors.css"
	local output="$HOME/.config/hypr/sources/colors.conf"

	> "$output"

	while IFS= read -r line; do
		local name=$(echo "$line" | sed -n 's/@define-color[[:space:]]\+\([a-zA-Z0-9_-]\+\)[[:space:]]\+#.*$/\1/p')
		local color=$(echo "$line" | sed -n 's/.*#\([a-fA-F0-9]\{6\}\);*$/\1/p')
		echo "\$$name = $color" >> "$output"
	done < "$input"

}
