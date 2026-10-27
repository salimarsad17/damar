#!/bin/bash

cd /home/z/my-project

# Kill any existing Next.js processes
pkill -f "next" 2>/dev/null || true
sleep 2

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

echo "===STEP1: OPEN PAGE==="
agent-browser open http://21.0.5.146:8080 2>&1 || true
sleep 3

echo "===STEP2: CLICK MEDIA AJAR==="
agent-browser find text "Media Ajar" click 2>&1 || true
sleep 3

echo "===STEP3: SNAPSHOT==="
SNAPSHOT=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT"

TAMBAH_REF=$(echo "$SNAPSHOT" | grep -oP 'button "Tambah Media" \[ref=\K[^]]+' | head -1)
echo "===TAMBAH_REF: $TAMBAH_REF==="

echo "===STEP4: CLICK TAMBAH==="
agent-browser click @$TAMBAH_REF 2>&1 || true
sleep 2

echo "===STEP5: DIALOG SNAPSHOT==="
SNAPSHOT2=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT2"

TYPE_REF=$(echo "$SNAPSHOT2" | grep -oP 'combobox \[expanded=false, ref=\K[^]]+' | head -1)
echo "===TYPE_REF: $TYPE_REF==="

echo "===STEP6: OPEN TYPE DROPDOWN==="
agent-browser click @$TYPE_REF 2>&1 || true
sleep 1

SNAPSHOT3=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT3"

LKPD_REF=$(echo "$SNAPSHOT3" | grep -oP 'option "LKPD" \[ref=\K[^]]+' | head -1)
echo "===LKPD_REF: $LKPD_REF==="

echo "===STEP7: SELECT LKPD==="
agent-browser click @$LKPD_REF 2>&1 || true
sleep 3

echo "===STEP8: LKPD FORM SNAPSHOT==="
SNAPSHOT4=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT4"

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

echo "===STEP9: FILL FORM==="
agent-browser fill @$JUDUL_REF "LKPD Rukun Islam" 2>&1 || true
agent-browser fill @$DESKRIPSI_REF "Lembar kerja peserta didik tentang Rukun Islam" 2>&1 || true
agent-browser fill @$TOPIK_REF "Rukun Islam dan Rukun Iman" 2>&1 || true
agent-browser fill @$JUDUL_MATERI_REF "Rukun Islam dan Rukun Iman" 2>&1 || true
agent-browser fill @$MATERI_PEMB_REF "Peserta didik memahami lima rukun Islam dan enam rukun Iman" 2>&1 || true
agent-browser fill @$TUJUAN_PEMB_REF "Peserta didik mampu menjelaskan rukun Islam dan rukun Iman dengan benar" 2>&1 || true
echo "===FORM FILLED==="

echo "===STEP10: SET STATUS==="
agent-browser click @$STATUS_DD_REF 2>&1 || true
sleep 1
SNAPSHOT5=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT5"
TERBIT_REF=$(echo "$SNAPSHOT5" | grep -oP 'option "Terbit" \[ref=\K[^]]+' | head -1)
echo "===TERBIT_REF: $TERBIT_REF==="
if [ -n "$TERBIT_REF" ]; then
  agent-browser click @$TERBIT_REF 2>&1 || true
fi
sleep 2

echo "===STEP11: CLICK SIMPAN==="
SNAPSHOT6=$(agent-browser snapshot -i 2>&1)
SIMPAN_REF=$(echo "$SNAPSHOT6" | grep -oP 'button "Simpan" \[ref=\K[^]]+' | head -1)
echo "===SIMPAN_REF: $SIMPAN_REF==="
agent-browser click @$SIMPAN_REF 2>&1 || true
echo "===SIMPAN CLICKED==="
sleep 5

echo "===STEP12: AFTER SAVE==="
SNAPSHOT7=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT7"

agent-browser screenshot /tmp/lkpd_after_save2.png 2>&1 || true

if echo "$SNAPSHOT7" | grep -q "berhasil"; then
  echo "===SAVE_SUCCESS: YES==="
else
  echo "===SAVE_SUCCESS: NO==="
fi

LKPD_COUNT=$(echo "$SNAPSHOT7" | grep -oP 'LKPD \K[0-9]+' | head -1)
echo "===LKPD_COUNT: $LKPD_COUNT==="

echo "===STEP13: FILTER TO LKPD==="
LKPD_BTN_REF=$(echo "$SNAPSHOT7" | grep -oP 'button "LKPD [0-9]+" \[ref=\K[^]]+' | head -1)
echo "===LKPD_BTN_REF: $LKPD_BTN_REF==="

agent-browser click @$LKPD_BTN_REF 2>&1 || true
sleep 3

echo "===STEP14: LKPD FILTERED VIEW==="
SNAPSHOT8=$(agent-browser snapshot -i 2>&1)
echo "$SNAPSHOT8"

KERJAKAN_REF=$(echo "$SNAPSHOT8" | grep -oP 'button "Kerjakan" \[ref=\K[^]]+' | head -1)
echo "===KERJAKAN_REF: $KERJAKAN_REF==="

if echo "$SNAPSHOT8" | grep -q "LKPD Rukun Islam"; then
  echo "===LKPD_IN_GRID: YES==="
else
  echo "===LKPD_IN_GRID: NO==="
fi

if [ -n "$KERJAKAN_REF" ]; then
  echo "===STEP15: CLICK KERJAKAN==="
  agent-browser click @$KERJAKAN_REF 2>&1 || true
  sleep 5

  echo "===STEP16: LKPD PLAYER==="
  SNAPSHOT9=$(agent-browser snapshot -i 2>&1)
  echo "$SNAPSHOT9"

  agent-browser screenshot /tmp/lkpd_player2.png 2>&1 || true

  for section in "Materi Pembelajaran" "Tujuan Pembelajaran" "Pilihan Ganda" "Isian Singkat" "Studi Kasus" "Nilai Diskusi"; do
    if echo "$SNAPSHOT9" | grep -qi "$section"; then
      echo "===SECTION_FOUND: $section==="
    else
      echo "===SECTION_MISSING: $section==="
    fi
  done

  # Answer PG questions via JS
  echo "===STEP17: ANSWER PG==="
  agent-browser eval "
    const dialog = document.querySelector('[role=dialog]');
    if (dialog) {
      const buttons = dialog.querySelectorAll('button');
      let clicked = 0;
      for (const btn of buttons) {
        const text = btn.textContent?.trim();
        if (text && text.length <= 3 && clicked < 5) {
          const parent = btn.closest('.space-y-4');
          if (parent && clicked < 5) {
            btn.click();
            clicked++;
          }
        }
      }
      'Clicked ' + clicked + ' options';
    } else {
      'No dialog found';
    }
  " 2>&1
  sleep 1

  # Answer Isian via JS
  agent-browser eval "
    const dialog = document.querySelector('[role=dialog]');
    if (dialog) {
      const inputs = dialog.querySelectorAll('input[type=text]');
      for (let i = 0; i < Math.min(inputs.length, 3); i++) {
        const setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
        setter.call(inputs[i], 'Syahadat');
        inputs[i].dispatchEvent(new Event('input', { bubbles: true }));
        inputs[i].dispatchEvent(new Event('change', { bubbles: true }));
      }
      'Filled ' + Math.min(inputs.length, 3) + ' isian';
    } else 'No dialog';
  " 2>&1
  echo "===ANSWERED_ISIAN==="

  # Answer Studi Kasus via JS
  agent-browser eval "
    const dialog = document.querySelector('[role=dialog]');
    if (dialog) {
      const textareas = dialog.querySelectorAll('textarea');
      for (let i = 0; i < Math.min(textareas.length, 2); i++) {
        const setter = Object.getOwnPropertyDescriptor(window.HTMLTextAreaElement.prototype, 'value').set;
        setter.call(textareas[i], 'Analisis tentang rukun Islam');
        textareas[i].dispatchEvent(new Event('input', { bubbles: true }));
        textareas[i].dispatchEvent(new Event('change', { bubbles: true }));
      }
      'Filled ' + Math.min(textareas.length, 2) + ' studi kasus';
    } else 'No dialog';
  " 2>&1
  echo "===ANSWERED_STUDI_KASUS==="

  # Set diskusi nilai
  agent-browser eval "
    const dialog = document.querySelector('[role=dialog]');
    if (dialog) {
      const buttons = dialog.querySelectorAll('button');
      for (const btn of buttons) {
        if (btn.textContent?.trim() === '8') {
          btn.click();
          break;
        }
      }
      'Set diskusi nilai to 8';
    } else 'No dialog';
  " 2>&1
  echo "===SET_DISKUSI_NILAI==="

  agent-browser screenshot /tmp/lkpd_answered.png 2>&1 || true

  # Submit
  echo "===STEP18: SUBMIT==="
  agent-browser eval "
    const dialog = document.querySelector('[role=dialog]');
    if (dialog) {
      const buttons = dialog.querySelectorAll('button');
      for (const btn of buttons) {
        if (btn.textContent?.includes('Selesai') && btn.textContent?.includes('Kumpulkan')) {
          btn.click();
          'Clicked Selesai & Kumpulkan';
          break;
        }
      }
    } else 'No dialog';
  " 2>&1
  sleep 3

  echo "===STEP19: RESULTS==="
  SNAPSHOT11=$(agent-browser snapshot -i 2>&1)
  echo "$SNAPSHOT11"

  agent-browser screenshot /tmp/lkpd_results2.png 2>&1 || true

  if echo "$SNAPSHOT11" | grep -qi "Penilaian\|Total Nilai\|Nilai"; then
    echo "===GRADING_FOUND: YES==="
  else
    echo "===GRADING_FOUND: NO==="
  fi

  if echo "$SNAPSHOT11" | grep -qi "dikumpulkan"; then
    echo "===SUBMISSION_CONFIRMED: YES==="
  else
    echo "===SUBMISSION_CONFIRMED: NO==="
  fi

  # Check for total score value
  agent-browser eval "
    const dialog = document.querySelector('[role=dialog]');
    if (dialog) {
      const text = dialog.textContent;
      const match = text?.match(/Total Nilai.*?(\\d+)/s);
      match ? 'Total Nilai: ' + match[1] : 'No total nilai found';
    } else 'No dialog';
  " 2>&1

else
  echo "===NO_KERJAKAN_BUTTON==="
fi

echo "===ALL_DONE==="
