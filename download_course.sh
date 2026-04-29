#!/bin/bash
# Downloads Whop course videos and packages them into a zip file.
# Requires browser cookies exported from a logged-in Whop session.

COURSE_URL="https://whop.com/joined/ai-commerce-academy/course-If4VUeGusgAQIw/app/courses/cors_PrX4f8qPiqK2Z/lessons/lesn_2WOE966AwyLT1tb92Z8WDq/"
OUTPUT_DIR="/home/user/Nath/course_downloads"
ZIP_FILE="/home/user/Nath/course_videos.zip"
COOKIES_FILE="${1:-$HOME/Downloads/whop.com_cookies}"

if [ ! -f "$COOKIES_FILE" ]; then
    echo "ERROR: Cookies file not found at: $COOKIES_FILE"
    echo "Please ensure 'whop.com_cookies' is in your Downloads folder, or pass the path as an argument:"
    echo "  $0 /path/to/whop.com_cookies"
    exit 1
fi

echo "==> Using cookies file: $COOKIES_FILE"

mkdir -p "$OUTPUT_DIR"

echo "==> Downloading course videos from Whop..."
yt-dlp \
    --cookies "$COOKIES_FILE" \
    --no-check-certificates \
    --output "$OUTPUT_DIR/%(playlist_index)s - %(title)s.%(ext)s" \
    --format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \
    --merge-output-format mp4 \
    --write-info-json \
    --write-thumbnail \
    --no-playlist \
    "$COURSE_URL"

if [ $? -ne 0 ]; then
    echo "==> Download failed. Trying the full course playlist URL..."
    COURSE_BASE="https://whop.com/joined/ai-commerce-academy/course-If4VUeGusgAQIw/app/courses/cors_PrX4f8qPiqK2Z/"
    yt-dlp \
        --cookies "$COOKIES_FILE" \
        --no-check-certificates \
        --output "$OUTPUT_DIR/%(playlist_index)s - %(title)s.%(ext)s" \
        --format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \
        --merge-output-format mp4 \
        "$COURSE_BASE"
fi

echo ""
echo "==> Creating zip archive at $ZIP_FILE..."
zip -j "$ZIP_FILE" "$OUTPUT_DIR"/*.mp4 2>/dev/null || zip -r "$ZIP_FILE" "$OUTPUT_DIR"

echo ""
echo "==> Done! Zip file: $ZIP_FILE"
ls -lh "$ZIP_FILE" 2>/dev/null
