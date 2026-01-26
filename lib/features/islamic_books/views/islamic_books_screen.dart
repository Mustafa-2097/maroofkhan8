import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFFDFDFD);
const Color kTextGrey = Color(0xFF757575);
const Color kOrangeBook = Color(0xFFF57C00); // Color for the book cover placeholder

// ==========================================
// SCREEN 1: BOOK LIST SCREEN
// ==========================================
class IslamicBooksListScreen extends StatelessWidget {
  const IslamicBooksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () => Navigator.pop(context), // Placeholder for back nav
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Islamic Book's",
          style: GoogleFonts.playfairDisplay(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Search Bar Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.bookmark_border, color: Colors.grey, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List of Books
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return _BookListItem(
                    title: "Endless Bliss: Third Fascicle",
                    subtitle: "Reflections on the Path to Inner\nPeace",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BookReaderScreen()),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _BookListItem({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Book Cover Placeholder
            Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: kOrangeBook,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 2, width: 30, color: Colors.black12),
                    const SizedBox(height: 4),
                    const Text(
                      "Endless\nBliss",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(height: 2, width: 30, color: Colors.black12),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: kTextGrey),
                  ),
                ],
              ),
            ),

            // Arrow Button
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: kPrimaryBrown,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 2: BOOK READER SCREEN (PDF View)
// ==========================================
class BookReaderScreen extends StatelessWidget {
  const BookReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
            ),
          ),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Islamic Book's",
              style: GoogleFonts.playfairDisplay(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Endless Bliss: Third Fascicle.pdf",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page Controls
                Row(
                  children: [
                    const Text("1/200", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 15),
                    const Icon(Icons.remove, size: 16, color: Colors.black),
                    const SizedBox(width: 8),
                    const Text("90%", style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 8),
                    const Icon(Icons.add, size: 16, color: Colors.black),
                  ],
                ),
                // Icons
                Row(
                  children: const [
                    Icon(Icons.favorite_border, size: 20, color: kTextGrey),
                    SizedBox(width: 15),
                    Icon(Icons.share_outlined, size: 20, color: kTextGrey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Page 1: Title Page
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              color: Colors.white,
              child: Column(
                children: [
                  const Text("Hakikat Kitabevi Publications No: 17", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Text("ETHICS\nOF\nISLAM",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2)
                  ),
                  const SizedBox(height: 20),
                  const Text("Written by", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Ali bin Emrullah", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      SizedBox(width: 30),
                      Text("Muhammed Hadimi", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Huseyn Hilmi Isik", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Twelfth Edition", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // Stamp Mockup
                  Container(
                    height: 50, width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: const Center(child: Text("SEAL", style: TextStyle(fontSize: 8))),
                  ),
                  const SizedBox(height: 10),
                  const Text("Hakikat Kitabevi\nDarussafaka Cad. No: 57/A P.K. 35\n34083 Fatih-ISTANBUL/TURKEY",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 9, color: Colors.black87)
                  ),
                  const SizedBox(height: 5),
                  const Text("NOVEMBER-2006", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Page 2: Text Content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Publisher's Note:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(
                    "Anyone who wishes to print this book in its original form or to translate it into any other language is granted beforehand our permission to do so; and people who undertake this beneficial feat are accredited to the benedictions that we in advance offer to Allahu ta'ala in their name...",
                    style: TextStyle(fontSize: 10, height: 1.4, color: Colors.black87),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Center(child: Text("----------------------", style: TextStyle(color: Colors.grey))),
                  SizedBox(height: 20),
                  Text("A Warning:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(
                    "Missionaries are striving to advertise Christianity; Jews are working to spread the concocted words of Jewish rabbis; Hakikat Kitabevi (Bookstore), in Istanbul, is struggling to publicize Islam; and freemasons are trying to annihilate religions.",
                    style: TextStyle(fontSize: 10, height: 1.4, color: Colors.black87),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "A person with wisdom, knowledge and conscience will identify and adopt the right one among these alternatives and will help to spread the wisest of these choices for salvation of all humanity.",
                    style: TextStyle(fontSize: 10, height: 1.4, color: Colors.black87),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}