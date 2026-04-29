#!/bin/bash
# Downloads Whop course videos using cookies directly from your browser.
# No need to manually export cookies.

COURSE_URL="https://whop.com/joined/ai-commerce-academy/course-If4VUeGusgAQIw/app/courses/cors_PrX4f8qPiqK2Z/lessons/lesn_2WOE966AwyLT1tb92Z8WDq/"
COURSE_BASE="https://whop.com/joined/ai-commerce-academy/course-If4VUeGusgAQIw/app/courses/cors_PrX4f8qPiqK2Z/"
OUTPUT_DIR="/home/user/Nath/course_downloads"
ZIP_FILE="/home/user/Nath/course_videos.zip"
BROWSER="${1:-chrome}"  # chrome, firefox, safari, edge, brave

mkdir -p "$OUTPUT_DIR"

echo "==> Using cookies from browser: $BROWSER"
echo "==> Downloading lesson video..."

yt-dlp \
    --cookies-from-browser "$BROWSER" \
    --no-check-certificates \
    --output "$OUTPUT_DIR/%(playlist_index)s - %(title)s.%(ext)s" \
    --format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \
    --merge-output-format mp4 \
    --verbose \
    "$COURSE_URL"

echo ""
echo "==> Also attempting full course download..."
yt-dlp \
    --cookies-from-browser "$BROWSER" \
    --no-check-certificates \
    --output "$OUTPUT_DIR/%(playlist_index)s - %(title)s.%(ext)s" \
    --format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \
    --merge-output-format mp4 \
    "$COURSE_BASE" 2>/dev/null

echo ""
echo "==> Creating zip archive..."
zip -j "$ZIP_FILE" "$OUTPUT_DIR"/*.mp4 2>/dev/null || zip -r "$ZIP_FILE" "$OUTPUT_DIR"

echo ""
echo "==> Done! Files downloaded to: $OUTPUT_DIR"
echo "==> Zip file: $ZIP_FILE"
ls -lh "$OUTPUT_DIR"/ 2>/dev/null
