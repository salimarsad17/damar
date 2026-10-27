import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

async function seed() {
  console.log('Seeding Media Ajar...')

  // Check if already seeded
  const existing = await prisma.mediaAjar.count()
  if (existing > 0) {
    console.log(`Already have ${existing} media items, skipping seed.`)
    await prisma.$disconnect()
    return
  }

  // --- VIDEO ---
  const v1 = await prisma.mediaAjar.create({ data: { tipe: 'video', judul: 'Memahami Fungsi Al-Quran', deskripsi: 'Video pembelajaran tentang fungsi Al-Quran sebagai pedoman hidup', mapel: 'PAI', kelas: 'VII', semester: '1', materi: 'Al-Quran', status: 'terbit' } })
  await prisma.mediaAjarVideo.create({ data: { mediaAjarId: v1.id, urlYouTube: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', durasi: 300 } })

  const v2 = await prisma.mediaAjar.create({ data: { tipe: 'video', judul: 'Hadits dan Sunnah Nabi', deskripsi: 'Penjelasan tentang kedudukan hadits sebagai sumber hukum Islam', mapel: 'PAI', kelas: 'VIII', semester: '1', materi: 'Hadits', status: 'terbit' } })
  await prisma.mediaAjarVideo.create({ data: { mediaAjarId: v2.id, urlYouTube: 'https://www.youtube.com/watch?v=jNQXAC9IVRw', durasi: 450 } })

  const v3 = await prisma.mediaAjar.create({ data: { tipe: 'video', judul: 'Akhlak Terpuji dalam Islam', deskripsi: 'Membahas akhlak terpuji dan cara menerapkannya', mapel: 'PAI', kelas: 'IX', semester: '2', materi: 'Akhlak', status: 'draf' } })
  await prisma.mediaAjarVideo.create({ data: { mediaAjarId: v3.id, urlYouTube: 'https://www.youtube.com/watch?v=9bZkp7q19f0', durasi: 360 } })

  // --- GAME ---
  const g1 = await prisma.mediaAjar.create({ data: { tipe: 'game', judul: 'Kuis Al-Quran Kelas VII', deskripsi: 'Kuis interaktif tentang Al-Quran untuk kelas VII', mapel: 'PAI', kelas: 'VII', semester: '1', materi: 'Al-Quran', status: 'terbit' } })
  await prisma.mediaAjarGame.create({ data: { mediaAjarId: g1.id, jenisGame: 'kuis', questions: JSON.stringify([
    { soal: 'Berapa jumlah surah dalam Al-Quran?', pilihan: ['114', '120', '100', '150'], jawaban: 0, poin: 10 },
    { soal: 'Surah terpanjang dalam Al-Quran adalah?', pilihan: ['Al-Baqarah', 'Ali Imran', 'An-Nisa', 'Al-Maidah'], jawaban: 0, poin: 10 },
    { soal: 'Al-Fatihah disebut juga?', pilihan: ['Ummul Quran', 'As-Saff', 'Al-Ikhlas', 'Yasin'], jawaban: 0, poin: 10 },
    { soal: 'Juz terakhir Al-Quran berisi surah?', pilihan: ['An-Nas s.d Al-Fatihah', 'An-Nas s.d Al-Baqarah', 'An-Nas', 'Al-Kafirun'], jawaban: 0, poin: 10 },
    { soal: 'Al-Quran diturunkan melalui malaikat?', pilihan: ['Jibril', 'Mikail', 'Israfil', 'Izrail'], jawaban: 0, poin: 10 },
  ]), poin: 50, durasi: 300 } })

  const g2 = await prisma.mediaAjar.create({ data: { tipe: 'game', judul: 'Tebak Gambar Ibadah', deskripsi: 'Game tebak gambar tentang ibadah dalam Islam', mapel: 'PAI', kelas: 'VIII', semester: '1', materi: 'Ibadah', status: 'terbit' } })
  await prisma.mediaAjarGame.create({ data: { mediaAjarId: g2.id, jenisGame: 'tebak-gambar', questions: JSON.stringify([
    { soal: 'Ini adalah rukun Islam yang pertama?', pilihan: ['Syahadat', 'Shalat', 'Zakat', 'Haji'], jawaban: 0, poin: 10 },
    { soal: 'Jumlah rukun Islam ada berapa?', pilihan: ['5', '4', '6', '3'], jawaban: 0, poin: 10 },
    { soal: 'Shalat wajib dalam sehari ada berapa waktu?', pilihan: ['5', '3', '7', '4'], jawaban: 0, poin: 10 },
  ]), poin: 30, durasi: 180 } })

  const g3 = await prisma.mediaAjar.create({ data: { tipe: 'game', judul: 'Benar/Salah Akhlak', deskripsi: 'Game benar atau salah tentang akhlak', mapel: 'PAI', kelas: 'IX', semester: '2', materi: 'Akhlak', status: 'draf' } })
  await prisma.mediaAjarGame.create({ data: { mediaAjarId: g3.id, jenisGame: 'benar-salah', questions: JSON.stringify([
    { soal: 'Berbohong termasuk akhlak tercela', pilihan: ['Benar', 'Salah'], jawaban: 0, poin: 10 },
    { soal: 'Bersyukur termasuk akhlak tercela', pilihan: ['Benar', 'Salah'], jawaban: 1, poin: 10 },
    { soal: 'Sabar termasuk akhlak terpuji', pilihan: ['Benar', 'Salah'], jawaban: 0, poin: 10 },
  ]), poin: 30, durasi: 120 } })

  // --- TTS ---
  const t1 = await prisma.mediaAjar.create({ data: { tipe: 'tts', judul: 'TTS Rukun Iman', deskripsi: 'Teka-teki silang tentang Rukun Iman', mapel: 'PAI', kelas: 'VII', semester: '1', materi: 'Aqidah', status: 'terbit' } })
  await prisma.mediaAjarTTS.create({ data: { mediaAjarId: t1.id, questions: JSON.stringify([
    { arah: 'mendatar', no: 1, clue: 'Kitab suci umat Islam', jawaban: 'QURAN', baris: 0, kolom: 0 },
    { arah: 'menurun', no: 1, clue: 'Malaikat yang menyampaikan wahyu', jawaban: 'JIBRIL', baris: 0, kolom: 0 },
    { arah: 'mendatar', no: 2, clue: 'Nabi terakhir', jawaban: 'MUHAMMAD', baris: 2, kolom: 0 },
    { arah: 'menurun', no: 2, clue: 'Tempat kembali seluruh manusia', jawaban: 'AKHIRAT', baris: 2, kolom: 4 },
  ]), grid: JSON.stringify([
    ['Q','I','B','R','I','L'],
    ['U','','','','K',''],
    ['M','U','H','A','M','M','A','D'],
    ['A','','','','R','','',''],
    ['N','','','','A','','',''],
    ['','','','','T','','',''],
  ]), kesulitan: 'sedang', durasi: 600 } })

  const t2 = await prisma.mediaAjar.create({ data: { tipe: 'tts', judul: 'TTS Ibadah Shalat', deskripsi: 'Teka-teki silang tentang shalat', mapel: 'PAI', kelas: 'VIII', semester: '1', materi: 'Ibadah', status: 'terbit' } })
  await prisma.mediaAjarTTS.create({ data: { mediaAjarId: t2.id, questions: JSON.stringify([
    { arah: 'mendatar', no: 1, clue: 'Shalat wajib lima waktu', jawaban: 'FARDHU', baris: 0, kolom: 0 },
    { arah: 'menurun', no: 1, clue: 'Kiblat umat Islam', jawaban: 'KAABAH', baris: 0, kolom: 0 },
    { arah: 'mendatar', no: 2, clue: 'Bacaan pembuka shalat', jawaban: 'TAKBIR', baris: 2, kolom: 2 },
  ]), grid: JSON.stringify([
    ['F','A','R','D','H','U'],
    ['','','','I','',''],
    ['K','A','T','B','I','R'],
    ['','','','R','',''],
    ['B','','','A','',''],
    ['A','','','H','',''],
    ['H','','','','',''],
  ]), kesulitan: 'mudah', durasi: 480 } })

  // --- CBT ---
  const c1 = await prisma.mediaAjar.create({ data: { tipe: 'cbt', judul: 'UTS PAI Kelas VII Sem 1', deskripsi: 'Ujian Tengah Semester PAI kelas VII semester 1', mapel: 'PAI', kelas: 'VII', semester: '1', materi: 'Al-Quran & Hadits', status: 'terbit' } })
  await prisma.mediaAjarCBT.create({ data: { mediaAjarId: c1.id, questions: JSON.stringify([
    { soal: 'Al-Quran diturunkan sebagai pedoman bagi manusia yang disebut?', tipe: 'pg', pilihan: ['Al-Furqan', 'Al-Kitab', 'Az-Zikr', 'An-Nur'], jawaban: 0, poin: 20 },
    { soal: 'Jumlah rukun iman ada berapa?', tipe: 'pg', pilihan: ['5', '6', '7', '4'], jawaban: 1, poin: 20 },
    { soal: 'Malaikat yang bertugas menyampaikan wahyu adalah?', tipe: 'pg', pilihan: ['Mikail', 'Jibril', 'Israfil', 'Izrail'], jawaban: 1, poin: 20 },
    { soal: 'Kitab yang diturunkan kepada Nabi Musa adalah?', tipe: 'pg', pilihan: ['Injil', 'Zabur', 'Taurat', 'Al-Quran'], jawaban: 2, poin: 20 },
    { soal: 'Hari kiamat termasuk rukun iman ke?', tipe: 'pg', pilihan: ['5', '6', '4', '3'], jawaban: 0, poin: 20 },
  ]), jumlahSoal: 5, durasi: 30, nilaiMin: 70, acakSoal: true, acakOpsi: true } })

  const c2 = await prisma.mediaAjar.create({ data: { tipe: 'cbt', judul: 'UAS PAI Kelas VIII Sem 1', deskripsi: 'Ujian Akhir Semester PAI kelas VIII semester 1', mapel: 'PAI', kelas: 'VIII', semester: '1', materi: 'Ibadah & Akhlak', status: 'terbit' } })
  await prisma.mediaAjarCBT.create({ data: { mediaAjarId: c2.id, questions: JSON.stringify([
    { soal: 'Shalat magrib terdiri dari berapa rakaat?', tipe: 'pg', pilihan: ['3', '2', '4', '1'], jawaban: 0, poin: 25 },
    { soal: 'Zakat fitrah dikeluarkan pada bulan?', tipe: 'pg', pilihan: ['Ramadhan', 'Syawal', 'Dzulhijjah', 'Rajab'], jawaban: 0, poin: 25 },
    { soal: 'Haji adalah rukun Islam ke?', tipe: 'pg', pilihan: ['5', '4', '3', '2'], jawaban: 0, poin: 25 },
    { soal: 'Puasa Ramadhan dimulai dari melihat?', tipe: 'pg', pilihan: ['Hilal', 'Bintang', 'Matahari', 'Bulan purnama'], jawaban: 0, poin: 25 },
  ]), jumlahSoal: 4, durasi: 20, nilaiMin: 75, acakSoal: false, acakOpsi: true } })

  // --- LINK EKSTERNAL ---
  const l1 = await prisma.mediaAjar.create({ data: { tipe: 'link-eksternal', judul: 'Kuis PAI Quizizz', deskripsi: 'Kuis interaktif PAI di platform Quizizz', mapel: 'PAI', kelas: 'VII', semester: '1', materi: 'Al-Quran', status: 'terbit' } })
  await prisma.mediaAjarLink.create({ data: { mediaAjarId: l1.id, namaApp: 'Quizizz', url: 'https://quizizz.com/', petunjuk: 'Klik Buka Aplikasi, lalu masukkan kode kuis yang diberikan guru' } })

  const l2 = await prisma.mediaAjar.create({ data: { tipe: 'link-eksternal', judul: 'Game Kahoot! PAI', deskripsi: 'Game interaktif PAI di Kahoot!', mapel: 'PAI', kelas: 'VIII', semester: '1', materi: 'Ibadah', status: 'terbit' } })
  await prisma.mediaAjarLink.create({ data: { mediaAjarId: l2.id, namaApp: 'Kahoot!', url: 'https://kahoot.it/', petunjuk: 'Masukkan PIN game yang diberikan guru untuk bergabung' } })

  const l3 = await prisma.mediaAjar.create({ data: { tipe: 'link-eksternal', judul: 'Latihan Wordwall PAI', deskripsi: 'Latihan interaktif di Wordwall', mapel: 'PAI', kelas: 'IX', semester: '2', materi: 'Akhlak', status: 'terbit' } })
  await prisma.mediaAjarLink.create({ data: { mediaAjarId: l3.id, namaApp: 'Wordwall', url: 'https://wordwall.net/', petunjuk: 'Pilih aktivitas yang tersedia dan kerjakan secara online' } })

  const l4 = await prisma.mediaAjar.create({ data: { tipe: 'link-eksternal', judul: 'Canva Presentasi PAI', deskripsi: 'Presentasi materi PAI di Canva', mapel: 'PAI', kelas: 'VII', semester: '2', materi: 'Sejarah', status: 'draf' } })
  await prisma.mediaAjarLink.create({ data: { mediaAjarId: l4.id, namaApp: 'Canva', url: 'https://www.canva.com/', petunjuk: 'Buka link presentasi yang dibagikan guru' } })

  const total = await prisma.mediaAjar.count()
  console.log(`Seeded ${total} media items successfully!`)
  await prisma.$disconnect()
}

seed().catch(e => { console.error(e); process.exit(1) })
