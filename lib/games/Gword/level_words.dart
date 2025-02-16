final Map<int, List<String>> levelWords = {
  1: ["KELİME", "BULMACA", "OYUN", "EĞLENCE", "ZAMAN", "FİKİR"],
  2: ["ELMA", "MUZ", "PORTAKAL", "ŞEFTALİ", "ÜZÜM", "KİVİ"],
  3: ["KEDİ", "KÖPEK", "KUŞ", "BALIK", "ASLAN", "TİGRİ"],
  4: ["ARABA", "OTOBÜS", "TREN", "UÇAK", "GEMİ", "BİSİKLET"],
  5: ["KIRMIZI", "YEŞİL", "MAVİ", "SARI", "MOR", "PEMBE"],
  6: ["İLKBAHAR", "YAZ", "SONBAHAR", "KIŞ", "YAĞMUR", "KAR"],
  7: ["MÜZİK", "FİLM", "KİTAP", "SANAT", "DANS", "TİYATRO"],
  8: ["KAHVE", "ÇAY", "MEYVESUYU", "SÜT", "SU", "KOLA"],
  9: ["DAĞ", "NEHİR", "ORMAN", "ÇÖL", "OKYANUS", "GÖL"],
  10: [
    "BİLGİSAYAR",
    "YAZILIM",
    "PROGRAM",
    "ALGORİTM",
    "VERİTABANI",
    "İNTERNET",
  ],
  11: ["FENER", "MAHALLE", "SOKAK", "KARDEŞ", "ANNE", "BABA"],
  12: ["ÜNİVERSİTE", "OKUL", "SINIF", "ÖĞRETMEN", "ÖĞRENCİ", "DERS"],
  13: ["GÜNEŞ", "AY", "YILDIZ", "GECE", "GÖKYÜZÜ", "BULUT"],
  14: ["KUTU", "MASA", "SANDALYE", "LİMON", "DEFTER", "KALEM"],
  15: [
    "FENERBAHÇE",
    "GALATASARAY",
    "BEŞİKTAŞ",
    "TRABZON",
    "MARMARA",
    "BESİKTAŞ",
  ],
  16: ["YEMEK", "SİPARİŞ", "MENÜ", "RESTAURANT", "TATLI", "TUZLU"],
  17: ["GECE", "GÜNDÜZ", "YILDIZ", "AY", "GÜNEŞ", "SEMAVİ"],
  18: ["KALEM", "DEFTER", "ÇANTA", "LİSTE", "KİTAP", "OKUMA"],
  19: ["BİNA", "EV", "APARTMAN", "MÜLK", "OTOPARK", "BAHÇE"],
  20: ["TELEFON", "BİLGİSAYAR", "İNTERNET", "TELEVİZYON", "RADYO", "EKRAN"],
  21: ["ŞEHİR", "KÖY", "İLÇE", "BÖLGE", "ÜLKE", "KÜRE"],
  22: ["FUTBOL", "BASKETBOL", "VOLEYBOL", "TENİS", "YÜZME", "KOŞU"],
  23: ["SİNEMA", "TİYATRO", "KONSER", "FESTİVAL", "SANAT", "PERDE"],
  24: ["SİHİR", "BÜYÜ", "MASAL", "PERİ", "EFSANE", "HİKAYE"],
  25: ["PARA", "BANKA", "EKONOMİ", "YATIRIM", "KAZANÇ", "MASRAF"],
  26: ["TEMİZ", "KİRLİ", "SU", "HAVA", "TOPRAK", "ORTAM"],
  27: ["AĞAÇ", "YAPRAK", "DAL", "KÖK", "MEYVE", "ÇİÇEK"],
  28: ["ÇOCUK", "ERKEK", "KADIN", "YAŞ", "NESİL", "BEBEK"],
  29: ["DENİZ", "SAHİL", "KUM", "FIRTINA", "YEL", "DALGA"],
  30: ["SÖZ", "CÜMLE", "KİTAP", "YAZI", "OKUMA", "ANLAM"],
  31: ["TAHTA", "DEMİR", "CAM", "AHŞAP", "İCAT", "TESLİM"],
  32: ["SANAT", "MÜZİK", "RESİM", "HEYKEL", "KONSER", "SERGİ"],
  33: ["ARKADAŞ", "DOST", "SEVGİ", "AŞK", "BAĞ", "KARDEŞ"],
  34: ["HAVA", "RÜZGAR", "YAĞMUR", "KAR", "GÖKKUŞAĞI", "FIRTINA"],
  35: ["OKUL", "SINIF", "DERS", "ÖĞRETMEN", "ÖĞRENCİ", "SINAV"],
  36: ["YOL", "KARAYOL", "OTOBÜS", "TREN", "UÇAK", "GEMİ"],
  37: ["TARIM", "FAZLA", "HASAT", "EKİN", "BUĞDAY", "ARPA"],
  38: ["MİMAR", "YAPI", "BİNA", "KÖPRÜ", "YOL", "KULE"],
  39: ["EĞLENCE", "OYUN", "ŞAKA", "KOMİK", "GÜLME", "NEŞE"],
  40: ["TARİH", "KÜLTÜR", "MEDENİYET", "ESER", "BELGE", "MÜZE"],
  41: ["BÜYÜK", "KÜÇÜK", "UZUN", "KISA", "GENİŞ", "DAR"],
  42: ["SİYAH", "BEYAZ", "KIRMIZI", "YEŞİL", "MAVİ", "SARI"],
  43: ["TEKNİK", "SANAT", "BİLİM", "İCAT", "YENİLİK", "GELİŞİM"],
  44: ["HAYAT", "ÖLÜM", "DOĞUM", "YAŞAM", "SÜREKLİ", "DÖNGÜ"],
  45: ["YÜKSEK", "ALÇAK", "DERİN", "İNCE", "KALIN", "ZARIF"],
  46: ["NEFES", "KAN", "KALP", "BEYİN", "SİNİR", "DUYGU"],
  47: ["BİLGİ", "AKIL", "FİKİR", "DÜŞÜNCE", "HÜNER", "YETENEK"],
  48: ["MUTLULUK", "ÜZÜNTÜ", "KAHRAMAN", "CESUR", "YÜREK", "SEVGİ"],
  49: ["MAĞAZA", "PAZAR", "ALIŞVERİŞ", "FİYAT", "İNDIRİM", "KAMPANYA"],
  50: ["FIRSAT", "AN", "DEĞER", "KAZANÇ", "YÜKSEK", "DÜŞÜK"],
  51: ["DOĞA", "YABAN", "VAHŞİ", "YEŞİL", "MAVİ", "TOPRAK"],
  52: ["ÇALIŞMA", "EMEK", "BAŞARI", "HAYAL", "HEDEF", "VİZYON"],
  53: ["İLETİŞİM", "BAĞLANTI", "MESAJ", "KONUŞMA", "SESLİ", "YAZILI"],
  54: ["MODA", "STİL", "TASARIM", "TREND", "RENK", "DESEN"],
  55: ["İLİŞKİ", "BAĞ", "DOSTLUK", "AŞK", "SEVGİ", "KARDEŞLİK"],
  56: ["TELEFON", "BİLGİSAYAR", "TABLET", "İNTERNET", "AĞ", "SOSYAL"],
  57: ["YEMEK", "MUTFAK", "TATLI", "TUZLU", "PİŞİRME", "LEZZET"],
  58: ["DÜNYA", "KÜRE", "ÜLKE", "ŞEHİR", "KÖY", "BÖLGE"],
  59: ["HAYAL", "GERÇEK", "KURGU", "FARK", "RENK", "ÖZGÜVEN"],
  60: ["SON", "BİTİŞ", "MEZUNİYET", "KAPANIŞ", "ÖZEL", "FARKLI"],
};
