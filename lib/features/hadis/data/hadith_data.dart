import '../models/hadith_book.dart';

class HadithData {
  static final List<HadithBook> staticHadithBooks = [
    HadithBook(
      id: "sahih-bukhari",
      name: "Sahih Bukhari",
      writer: "Imam Bukhari",
      chapters: "99",
      hadiths: "7276",
    ),
    HadithBook(
      id: "sahih-muslim",
      name: "Sahih Muslim",
      writer: "Imam Muslim",
      chapters: "56",
      hadiths: "7564",
    ),
    HadithBook(
      id: "al-tirmidhi",
      name: "Jami' Al-Tirmidhi",
      writer: "Abu `Isa Muhammad at-Tirmidhi",
      chapters: "50",
      hadiths: "3956",
    ),
    HadithBook(
      id: "abu-dawood",
      name: "Sunan Abu Dawood",
      writer: "Imam Abu Dawud Sulayman ibn al-Ash'ath as-Sijistani",
      chapters: "43",
      hadiths: "5274",
    ),
    HadithBook(
      id: "ibn-e-majah",
      name: "Sunan Ibn-e-Majah",
      writer: "Imam Muhammad bin Yazid Ibn Majah al-Qazvini",
      chapters: "39",
      hadiths: "4341",
    ),
    HadithBook(
      id: "sunan-nasai",
      name: "Sunan An-Nasa`i",
      writer: "Imam Ahmad an-Nasa`i",
      chapters: "52",
      hadiths: "5761",
    ),
    HadithBook(
      id: "mishkat",
      name: "Mishkat Al-Masabih",
      writer: "Imam Khatib at-Tabrizi",
      chapters: "29",
      hadiths: "6293",
    ),
    HadithBook(
      id: "musnad-ahmad",
      name: "Musnad Ahmad",
      writer: "Imam Ahmad ibn Hanbal",
      chapters: "14",
      hadiths: "0",
    ),
    HadithBook(
      id: "al-silsila-sahiha",
      name: "Al-Silsila Sahiha",
      writer: "Allama Muhammad Nasir Uddin Al-Bani",
      chapters: "28",
      hadiths: "0",
    ),
  ];
}
