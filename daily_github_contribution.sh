#!/bin/bash

# ─────────────────────────────────────────────────────────────
#  Daily GitHub Contribution Script
#  Keeps your GitHub profile GREEN every day automatically!
#  
#  SETUP:
#  1. Create a GitHub repo (e.g. "daily-contributions")
#  2. Clone it locally: git clone https://github.com/YOUR_USER/daily-contributions
#  3. Place this script inside that cloned folder
#  4. Update REPO_PATH below
#  5. chmod +x daily_github_contribution.sh
#  6. Schedule with cron (see bottom of this file)
# ─────────────────────────────────────────────────────────────

# ── CONFIGURATION ─────────────────────────────────────────────
REPO_PATH="/home/iamkadhalan/Documents/Workspace/daily-contributions"   # ← Change to your repo path
BRANCH="main"
LOG_FILE="$HOME/git_contribution.log"
CONTRIBUTION_FILE="$REPO_PATH/daily_log.md"
# ──────────────────────────────────────────────────────────────

# ── Colour codes ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%H:%M:%S')
DAY=$(date '+%A')
WEEK=$(date '+Week %U of %Y')

echo -e "${BOLD}${CYAN}==========================================${NC}"
echo -e "${BOLD}${CYAN}   Daily GitHub Contribution Updater     ${NC}"
echo -e "${BOLD}${CYAN}==========================================${NC}"
echo -e "${YELLOW}Date : $DATE  |  Time : $TIME${NC}"
echo ""

# ── Check repo path exists ─────────────────────────────────────
if [ ! -d "$REPO_PATH" ]; then
    echo -e "${RED}Error: Repo path not found: $REPO_PATH${NC}"
    echo -e "${YELLOW}Run: git clone https://github.com/YOUR_USER/daily-contributions $REPO_PATH${NC}"
    exit 1
fi

cd "$REPO_PATH" || exit 1

# ── Pull latest changes first ──────────────────────────────────
echo -e "${YELLOW}[1/5] Pulling latest from remote...${NC}"
git pull origin "$BRANCH" --quiet
echo -e "${GREEN}Pull done.${NC}"
echo ""

# ── Append today's entry to daily_log.md ──────────────────────
echo -e "${YELLOW}[2/5] Writing today's contribution entry...${NC}"

# Create file with header if it doesn't exist
if [ ! -f "$CONTRIBUTION_FILE" ]; then
    cat > "$CONTRIBUTION_FILE" << 'HEADER'
# 🟩 Daily Contribution Log

> Auto-generated daily to keep the GitHub contribution graph green.

---

HEADER
    echo -e "${GREEN}Created daily_log.md${NC}"
fi

# Motivational quotes (rotates daily)
QUOTES=(
    "Keep pushing, every commit counts!"
    "Consistency beats perfection."
    "Small steps every day lead to big results."
    "Code today, celebrate tomorrow."
    "Green squares are built one commit at a time."
    "Progress, not perfection."
    "Show up every day. That's the secret."
    "Another day, another commit. You've got this!"
    "The best time to commit was yesterday. The second best time is now."
    "Every expert was once a beginner who kept going."
    "Discipline is doing it even when you don't feel like it."
    "Your future self will thank you for today's commit."
)
DAY_NUM=$(date '+%j')
QUOTE=${QUOTES[$((DAY_NUM % ${#QUOTES[@]}))]}

cat >> "$CONTRIBUTION_FILE" << ENTRY

## 📅 $DATE — $DAY ($WEEK)
- **Time:** $TIME
- **Status:** ✅ Active
- **Quote:** *"$QUOTE"*

---
ENTRY

echo -e "${GREEN}Entry added to daily_log.md${NC}"
echo ""

# ── git status ─────────────────────────────────────────────────
echo -e "${YELLOW}[3/5] Git Status...${NC}"
git status --short
echo ""

# ── git add ────────────────────────────────────────────────────
echo -e "${YELLOW}[4/5] Staging changes...${NC}"
git add daily_log.md

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: git add failed.${NC}"
    exit 1
fi
echo -e "${GREEN}Files staged.${NC}"
echo ""

# ── git commit ─────────────────────────────────────────────────
COMMIT_MSG="🟩 Daily contribution – $DATE $TIME"

echo -e "${YELLOW}[5/5] Committing: \"$COMMIT_MSG\"${NC}"
git commit -m "$COMMIT_MSG"

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: git commit failed. Nothing to commit?${NC}"
    echo "$DATE $TIME - SKIPPED (nothing to commit)" >> "$LOG_FILE"
    exit 0
fi
echo ""

# ── git push ───────────────────────────────────────────────────
echo -e "${YELLOW}Pushing to origin/$BRANCH...${NC}"
git push origin "$BRANCH"

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: git push failed. Check credentials or remote URL.${NC}"
    echo "$DATE $TIME - PUSH FAILED" >> "$LOG_FILE"
    exit 1
fi

# ── Log success ────────────────────────────────────────────────
echo "$DATE $TIME - SUCCESS ✅" >> "$LOG_FILE"

echo ""
echo -e "${BOLD}${GREEN}==========================================${NC}"
echo -e "${BOLD}${GREEN}  ✅ Contribution Pushed! Stay Green! 🟩  ${NC}"
echo -e "${BOLD}${GREEN}==========================================${NC}"
echo ""

# ─────────────────────────────────────────────────────────────
# HOW TO SCHEDULE THIS SCRIPT WITH CRON (Linux/Mac)
#
# Run: crontab -e
# Add ONE of these lines:
#
#  Every day at 9:00 AM:
#  0 9 * * * /bin/bash /path/to/daily_github_contribution.sh >> ~/git_cron.log 2>&1
#
#  Every day at 8:30 PM:
#  30 20 * * * /bin/bash /path/to/daily_github_contribution.sh >> ~/git_cron.log 2>&1
#
#  Every day at midnight:
#  0 0 * * * /bin/bash /path/to/daily_github_contribution.sh >> ~/git_cron.log 2>&1
#
# ─────────────────────────────────────────────────────────────
