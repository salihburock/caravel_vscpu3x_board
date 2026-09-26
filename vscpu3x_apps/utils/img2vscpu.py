import argparse
import sys
from PIL import Image, ImageOps, ImageEnhance, ImageFilter

def convert_to_ssd1306(image_path, start_address, method, threshold, invert, denoise, preview):
    target_w, target_h = 128, 64
    try:
        img = Image.open(image_path)
        if img.mode in ('RGBA', 'LA') or (img.mode == 'P' and 'transparency' in img.info):
            bg = Image.new('RGB', img.size, (255, 255, 255))
            bg.paste(img, mask=img.split()[3])
            img = bg
    except Exception as e:
        print(f"Error loading image: {e}")
        sys.exit(1)

    print(f"// --- SSD1306 IMAGE DATA: {image_path} ---")

    # Rotate if needed and strictly resize to 128x64
    if img.size[0] < img.size[1]:
        img = img.rotate(90, expand=True)
    img = ImageOps.fit(img, (target_w, target_h), method=Image.Resampling.LANCZOS)
    img = img.convert('L')

    # Apply Denoise or Contrast Boost
    if denoise:
        img = img.filter(ImageFilter.SMOOTH)
        img = img.point(lambda p: 255 if p > 170 else (0 if p < 50 else p))
    else:
        img = ImageOps.autocontrast(img)
        img = ImageEnhance.Contrast(img).enhance(1.3)

    # Invert colors for OLED
    if invert:
        img = ImageOps.invert(img)

    # Apply B&W Conversion
    if method == 'dither':
        img = img.convert('1')
    else:
        img = img.point(lambda p: 255 if p >= threshold else 0, mode='1')

    # Trigger Live Preview
    if preview:
        img.show()

    pixels = img.load()
    address = start_address

    print("// Architecture: 8 Pages (Horizontal Mode) | 4 Columns per 32-bit Word")
    
    # SSD1306 Page Architecture Loop
    for page in range(8):
        for col in range(0, target_w, 4):
            word_val = 0
            
            # Pack 4 consecutive columns into one 32-bit word
            for byte_offset in range(4):
                current_col = col + byte_offset
                byte_val = 0
                
                # Each column is 8 vertical pixels
                for bit in range(8):
                    y = page * 8 + bit
                    x = current_col
                    
                    # Pillow '1' mode handles White as 255
                    is_lit = 1 if pixels[x, y] > 0 else 0
                    
                    if is_lit:
                        # SSD1306 maps D0 (Bit 0) to top pixel, D7 (Bit 7) to bottom pixel
                        byte_val |= (1 << bit)
                
                # Shift Byte0 to bits 31-24, Byte1 to 23-16, etc.
                word_val |= (byte_val << (24 - 8 * byte_offset))
            
            print(f"{address}: {word_val:<12} // Page {page}, Cols {col}-{col+3}")
            address += 1

    print(f"// Total Words: 256 (1024 bytes)")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert an image to SSD1306 OLED 32-bit VSCPU array.")
    parser.add_argument("image", help="Path to input image")
    parser.add_argument("--start", type=int, default=500, help="Starting VSCPU memory address (Default: 500)")
    parser.add_argument("--method", choices=['threshold', 'dither'], default='dither')
    parser.add_argument("--threshold", type=int, default=128)
    parser.add_argument("--invert", action='store_true', help="Invert colors for OLED")
    parser.add_argument("--denoise", action='store_true', help="Crush background noise")
    parser.add_argument("--preview", action='store_true', help="Open a window to preview the final 1-bit image before generating code.")
    
    args = parser.parse_args()
    convert_to_ssd1306(args.image, args.start, args.method, args.threshold, args.invert, args.denoise, args.preview)