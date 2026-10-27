#!/bin/bash
set -e

cd /home/z/my-project

# Start server
npx next dev --turbopack -H 0.0.0.0 -p 8080 &
sleep 12

# Verify server
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8080)
echo "===SERVER_STATUS: $STATUS==="

if [ "$STATUS" != "200" ]; then
  echo "===SERVER_FAILED==="
  exit 1
fi

# Step 1: Open page
agent-browser open http://21.0.5.146:8080 2>&1 || true
echo "===STEP1_OPEN==="
sleep 3

# Step 2: Click Media Ajar
agent-browser find text "Media Ajar" click 2>&1 || true
echo "===STEP2_MEDIA_AJAR==="
sleep 3

# Step 3: Snapshot to find Tambah Media button
SNAPSHOT=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT"
echo "===STEP3_SNAPSHOT==="

TAMBAH_REF=$(echo "$SNAPSHOT" | grep -oP 'button "Tambah Media" \[ref=\K[^]]+' | head -1)
echo "===TAMBAH_REF: $TAMBAH_REF==="

# Step 4: Click Tambah Media
agent-browser click @$TAMBAH_REF 2>&1 || true
echo "===STEP4_TAMBAH==="
sleep 2

# Step 5: Snapshot dialog
SNAPSHOT2=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT2"
echo "===STEP5_DIALOG==="

TYPE_REF=$(echo "$SNAPSHOT2" | grep -oP 'combobox \[expanded=false, ref=\K[^]]+' | head -1)
echo "===TYPE_REF: $TYPE_REF==="

# Step 6: Click type dropdown
agent-browser click @$TYPE_REF 2>&1 || true
echo "===STEP6_TYPE_CLICK==="
sleep 1

# Step 7: Find LKPD option
SNAPSHOT3=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT3"
echo "===STEP7_TYPE_OPTIONS==="

LKPD_REF=$(echo "$SNAPSHOT3" | grep -oP 'option "LKPD" \[ref=\K[^]]+' | head -1)
echo "===LKPD_REF: $LKPD_REF==="

# Step 8: Select LKPD
agent-browser click @$LKPD_REF 2>&1 || true
echo "===STEP8_LKPD_SELECTED==="
sleep 3

# Step 9: Snapshot LKPD form
SNAPSHOT4=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT4"
echo "===STEP9_LKPD_FORM==="

# Extract refs
JUDUL_REF=$(echo "$SNAPSHOT4" | grep -oP 'textbox "Judul media ajar" \[ref=\K[^]]+' | head -1)
DESKRIPSI_REF=$(echo "$SNAPSHOT4" | grep -oP 'textbox "Deskripsi singkat" \[ref=\K[^]]+' | head -1)
TOPIK_REF=$(echo "$SNAPSHOT4" | grep -oP 'textbox "Topik spesifik" \[ref=\K[^]]+' | head -1)
JUDUL_MATERI_REF=$(echo "$SNAPSHOT4" | grep -oP 'textbox "Judul materi LKPD" \[ref=\K[^]]+' | head -1)
MATERI_PEMB_REF=$(echo "$SNAPSHOT4" | grep -oP 'textbox "Deskripsi materi pembelajaran..." \[ref=\K[^]]+' | head -1)
TUJUAN_PEMB_REF=$(echo "$SNAPSHOT4" | grep -oP 'textbox "Tujuan / Capaian Pembelajaran..." \[ref=\K[^]]+' | head -1)
STATUS_DD_REF=$(echo "$SNAPSHOT4" | grep -oP 'combobox \[expanded=false, ref=\K[^]]+' | sed -n '2p')

echo "===JUDUL_REF: $JUDUL_REF==="
echo "===DESKRIPSI_REF: $DESKRIPSI_REF==="
echo "===TOPIK_REF: $TOPIK_REF==="
echo "===JUDUL_MATERI_REF: $JUDUL_MATERI_REF==="
echo "===MATERI_PEMB_REF: $MATERI_PEMB_REF==="
echo "===TUJUAN_PEMB_REF: $TUJUAN_PEMB_REF==="
echo "===STATUS_DD_REF: $STATUS_DD_REF==="

# Fill form fields
agent-browser fill @$JUDUL_REF "LKPD Rukun Islam" 2>&1 || true
echo "===FILL_JUDUL==="

agent-browser fill @$DESKRIPSI_REF "Lembar kerja peserta didik tentang Rukun Islam" 2>&1 || true
echo "===FILL_DESKRIPSI==="

agent-browser fill @$TOPIK_REF "Rukun Islam dan Rukun Iman" 2>&1 || true
echo "===FILL_TOPIK==="

agent-browser fill @$JUDUL_MATERI_REF "Rukun Islam dan Rukun Iman" 2>&1 || true
echo "===FILL_JUDUL_MATERI==="

agent-browser fill @$MATERI_PEMB_REF "Peserta didik memahami lima rukun Islam dan enam rukun Iman" 2>&1 || true
echo "===FILL_MATERI_PEMBELAJARAN==="

agent-browser fill @$TUJUAN_PEMB_REF "Peserta didik mampu menjelaskan rukun Islam dan rukun Iman dengan benar" 2>&1 || true
echo "===FILL_TUJUAN_PEMBELAJARAN==="

# Set Status to "terbit"
agent-browser click @$STATUS_DD_REF 2>&1 || true
echo "===STATUS_CLICK==="
sleep 1

SNAPSHOT5=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT5"
echo "===STATUS_OPTIONS==="

TERBIT_REF=$(echo "$SNAPSHOT5" | grep -oP 'option "Terbit" \[ref=\K[^]]+' | head -1)
echo "===TERBIT_REF: $TERBIT_REF==="

if [ -n "$TERBIT_REF" ]; then
  agent-browser click @$TERBIT_REF 2>&1 || true
  echo "===STATUS_TERBIT_SELECTED==="
else
  TERBIT_REF=$(echo "$SNAPSHOT5" | grep -oP 'option "terbit" \[ref=\K[^]]+' | head -1)
  if [ -n "$TERBIT_REF" ]; then
    agent-browser click @$TERBIT_REF 2>&1 || true
    echo "===STATUS_terbit_SELECTED==="
  else
    echo "===NO_TERBIT_OPTION_FOUND==="
  fi
fi

sleep 2

# IMPORTANT: Re-snapshot after status selection to get fresh refs
SNAPSHOT6=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT6"
echo "===REFRESH_SNAPSHOT==="

# Get fresh Simpan ref
SIMPAN_REF=$(echo "$SNAPSHOT6" | grep -oP 'button "Simpan" \[ref=\K[^]]+' | head -1)
echo "===SIMPAN_REF: $SIMPAN_REF==="

# Click Simpan
echo "===ABOUT_TO_SIMPAN==="
agent-browser click @$SIMPAN_REF 2>&1 || true
echo "===SIMPAN_CLICKED==="
sleep 5

# Snapshot after save
SNAPSHOT7=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT7"
echo "===AFTER_SAVE==="

# Take screenshot
agent-browser screenshot /tmp/lkpd_after_save.png 2>&1 || true
echo "===SCREENSHOT_TAKEN==="

# Check for success indicators
if echo "$SNAPSHOT7" | grep -q "LKPD Rukun Islam"; then
  echo "===LKPD_FOUND_IN_GRID==="
else
  echo "===LKPD_NOT_FOUND_IN_GRID==="
fi

# Check for LKPD count change
LKPD_COUNT=$(echo "$SNAPSHOT7" | grep -oP 'LKPD \K[0-9]+' | head -1)
echo "===LKPD_COUNT: $LKPD_COUNT==="

# Look for Kerjakan button
KERJAKAN_REF=$(echo "$SNAPSHOT7" | grep -oP 'button "Kerjakan" \[ref=\K[^]]+' | head -1)
echo "===KERJAKAN_REF: $KERJAKAN_REF==="

# Also try to find it with different button texts
MAINLAKAN_REF=$(echo "$SNAPSHOT7" | grep -oP 'button "Mainlakan" \[ref=\K[^]]+' | head -1)
LIHAT_REF=$(echo "$SNAPSHOT7" | grep -oP 'button "Lihat" \[ref=\K[^]]+' | head -1)

# If no Kerjakan found, scroll down and look again
if [ -z "$KERJAKAN_REF" ]; then
  echo "===NO_KERJAKAN_SCROLLING==="
  agent-browser scroll down 500 2>&1 || true
  sleep 2
  SNAPSHOT7b=$(agent-browser snapshot -i 2>&1)
  echo "$SNAPSHOT7b"
  echo "===AFTER_SCROLL==="
  KERJAKAN_REF=$(echo "$SNAPSHOT7b" | grep -oP 'button "Kerjakan" \[ref=\K[^]]+' | head -1)
  echo "===KERJAKAN_REF_AFTER_SCROLL: $KERJAKAN_REF==="
fi

# Step: Click Kerjakan if found
if [ -n "$KERJAKAN_REF" ]; then
  echo "===CLICKING_KERJAKAN==="
  agent-browser click @$KERJAKAN_REF 2>&1 || true
  sleep 5

  # Snapshot the LKPD player
  SNAPSHOT8=$(agent-browser snapshot -i 2>&1)
  echo "$SNAPSHOT8"
  echo "===LKPD_PLAYER==="

  # Take screenshot of player
  agent-browser screenshot /tmp/lkpd_player.png 2>&1 || true
  echo "===PLAYER_SCREENSHOT==="

  # Check for sections
  for section in "Materi Pembelajaran" "Tujuan Pembelajaran" "Pilihan Ganda" "Isian Singkat" "Studi Kasus" "Nilai Diskusi"; do
    if echo "$SNAPSHOT8" | grep -qi "$section"; then
      echo "===SECTION_FOUND: $section==="
    else
      echo "===SECTION_MISSING: $section==="
    fi
  done

  # Try to answer some questions - look for radio buttons or options in Pilihan Ganda
  echo "===TRYING_TO_ANSWER==="
  # Find first option/radio button
  FIRST_RADIO=$(echo "$SNAPSHOT8" | grep -oP 'radio \[ref=\K[^]]+' | head -1)
  if [ -n "$FIRST_RADIO" ]; then
    agent-browser click @$FIRST_RADIO 2>&1 || true
    echo "===ANSWERED_PG_1==="
    sleep 1
  fi

  # Find second radio button
  SNAPSHOT9=$(agent-browser snapshot -i 2>&1)
  SECOND_RADIO=$(echo "$SNAPSHOT9" | grep -oP 'radio \[ref=\K[^]]+' | head -2 | tail -1)
  if [ -n "$SECOND_RADIO" ]; then
    agent-browser click @$SECOND_RADIO 2>&1 || true
    echo "===ANSWERED_PG_2==="
    sleep 1
  fi

  # Look for Isian Singkat text fields
  ISIAN_REF=$(echo "$SNAPSHOT9" | grep -oP 'textbox \[ref=\K[^]]+' | head -1)
  if [ -n "$ISIAN_REF" ]; then
    agent-browser fill @$ISIAN_REF "Syahadat" 2>&1 || true
    echo "===ANSWERED_ISIAN_1==="
  fi

  # Look for "Selesai & Kumpulkan" button
  SELESAI_REF=$(echo "$SNAPSHOT9" | grep -oP 'button "Selesai.*Kumpulkan" \[ref=\K[^]]+' | head -1)
  if [ -z "$SELESAI_REF" ]; then
    # Try alternative text
    SELESAI_REF=$(echo "$SNAPSHOT9" | grep -oP 'button "Kumpulkan" \[ref=\K[^]]+' | head -1)
  fi
  if [ -z "$SELESAI_REF" ]; then
    SELESAI_REF=$(echo "$SNAPSHOT9" | grep -oP 'button "Selesai" \[ref=\K[^]]+' | head -1)
  fi
  echo "===SELESAI_REF: $SELESAI_REF==="

  if [ -n "$SELESAI_REF" ]; then
    agent-browser click @$SELESAI_REF 2>&1 || true
    echo "===SUBMITTED==="
    sleep 3
    
    # Snapshot results
    SNAPSHOT10=$(agent-browser snapshot -i 2>&1)
    echo "$SNAPSHOT10"
    echo "===RESULTS==="

    # Take screenshot of results
    agent-browser screenshot /tmp/lkpd_results.png 2>&1 || true
    echo "===RESULTS_SCREENSHOT==="

    # Check for score/grade indicators
    if echo "$SNAPSHOT10" | grep -qi "nilai\|skor\|score\|benar\|salah"; then
      echo "===GRADING_FOUND==="
    else
      echo "===NO_GRADING_FOUND==="
    fi
  else
    echo "===NO_SELESAI_BUTTON==="
  fi
else
  echo "===NO_KERJAKAN_BUTTON_FOUND==="
fi

echo "===ALL_DONE==="
