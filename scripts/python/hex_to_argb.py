def hex_to_argb(hex_code, alpha=255):
    """
    Converts a HEX color code to ARGB format.

    Args:
        hex_code (str): The HEX color code (e.g., '#RRGGBB' or 'RRGGBB').
        alpha (int): The alpha value (0-255). Default is 255 (fully opaque).

    Returns:
        str: A string representing the ARGB value in the format 0xAARRGGBB.
    """
    # Remove '#' if present
    if hex_code.startswith('#'):
        hex_code = hex_code[1:]

    # Ensure the hex code is valid
    if len(hex_code) != 6:
        raise ValueError("Invalid HEX code. It must be in the format '#RRGGBB' or 'RRGGBB'.")

    # Convert the HEX code to RGB values
    r = int(hex_code[0:2], 16)
    g = int(hex_code[2:4], 16)
    b = int(hex_code[4:6], 16)

    # Format the ARGB value
    argb = (alpha << 24) | (r << 16) | (g << 8) | b

    return f"0x{argb:08X}"

# Example usage
hex_color = "#B21589"  # A shade of purple
alpha_value = 255       # Fully opaque
argb = hex_to_argb(hex_color, alpha_value)
print("ARGB:", argb)
