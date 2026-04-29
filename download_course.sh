#!/bin/bash
# Downloads Whop course videos and packages them into a zip file.
# Requires browser cookies exported from a logged-in Whop session.

COURSE_URL="https://whop.com/joined/ai-commerce-academy/course-If4VUeGusgAQIw/app/courses/cors_PrX4f8qPiqK2Z/lessons/lesn_2WOE966AwyLT1tb92Z8WDq/"
OUTPUT_DIR="/home/user/Nath/course_downloads"
ZIP_FILE="/home/user/Nath/course_videos.zip"
COOKIES_FILE="${1:-}"  # Pass cookies file as first argument

if [ -z "$COOKIES_FILE" ]; then
    echo "Usage: $0 <cookies-file>"
    echo ""
    echo "How to export cookies:"
    echo "  1. Install the 'Get cookies.txt LOCALLY' extension in Chrome/Firefox"
    echo "  2. Log in to whop.com in your browser"
    echo "  3. Navigate to the course page"
    echo "  4. Click the extension and export cookies as 'cookies.txt'"
    echo "  5. Run: $0 /path/to/cookies.txt"
    echo ""
    echo "Alternative - use browser cookies directly (Chrome):"
    echo "  $0 --cookies-from-browser chrome"
    exit 1
fi

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
