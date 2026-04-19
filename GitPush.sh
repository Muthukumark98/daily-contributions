#!/bin/bash

# ─────────────────────────────────────────────
#  Git Workflow Script
#  Steps: status → add → status → commit → push
# ─────────────────────────────────────────────

# ── Colour codes ──────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Colour

echo -e "${BOLD}${CYAN}==============================${NC}"
echo -e "${BOLD}${CYAN}    Git Workflow Script       ${NC}"
echo -e "${BOLD}${CYAN}==============================${NC}"
echo ""

# ── Step 1: git status (before add) ──────────
echo -e "${YELLOW}[Step 1] Checking Git Status...${NC}"
git status
echo ""

# ── Prompt: File name ────────────────────────
read -p "$(echo -e ${BOLD}"Enter file name to add (or '.' to add all): "${NC})" FILE_NAME

if [ -z "$FILE_NAME" ]; then
    echo -e "${RED}Error: File name cannot be empty.${NC}"
    exit 1
fi

# ── Step 2: git add ───────────────────────────
echo ""
echo -e "${YELLOW}[Step 2] Adding file: ${BOLD}$FILE_NAME${NC}"
git add "$FILE_NAME"

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: 'git add' failed. Please check the file name.${NC}"
    exit 1
fi
echo -e "${GREEN}File(s) added successfully.${NC}"
echo ""

# ── Step 3: git status (after add) ───────────
echo -e "${YELLOW}[Step 3] Checking Git Status after add...${NC}"
git status
echo ""

# ── Prompt: Commit message ───────────────────
read -p "$(echo -e ${BOLD}"Enter commit message: "${NC})" COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
    echo -e "${RED}Error: Commit message cannot be empty.${NC}"
    exit 1
fi

# ── Step 4: git commit ────────────────────────
echo ""
echo -e "${YELLOW}[Step 4] Committing with message: ${BOLD}\"$COMMIT_MSG\"${NC}"
git commit -m "$COMMIT_MSG"

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: 'git commit' failed.${NC}"
    exit 1
fi
echo -e "${GREEN}Commit successful.${NC}"
echo ""

# ── Step 5: git push ──────────────────────────
echo -e "${YELLOW}[Step 5] Pushing to origin main...${NC}"
git push origin main

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: 'git push' failed. Check your remote/branch settings.${NC}"
    exit 1
fi

echo ""
echo -e "${BOLD}${GREEN}==============================${NC}"
echo -e "${BOLD}${GREEN}  Push Completed Successfully!${NC}"
echo -e "${BOLD}${GREEN}==============================${NC}"
