import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add GetX
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../controller/book_controller.dart'; // Add Controller

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFFDFDFD);
const Color kTextGrey = Color(0xFF757575);
const Color kOrangeBook = Color(
  0xFFF57C00,
); // Color for the book cover placeholder

// ==========================================
// SCREEN 1: BOOK LIST SCREEN
// ==========================================
class IslamicBooksListScreen extends StatelessWidget {
  const IslamicBooksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookController());

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const HeaderSection(title: "Islamic Books"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: Padding(
      //     padding: const EdgeInsets.only(left: 20),
      //     child: GestureDetector(
      //       onTap: () => Navigator.pop(context),
      //       child: Container(
      //         margin: const EdgeInsets.all(8),
      //         decoration: BoxDecoration(
      //           border: Border.all(color: Colors.grey.shade300),
      //           borderRadius: BorderRadius.circular(8),
      //         ),
      //         child: const Icon(
      //           Icons.arrow_back_ios,
      //           color: Colors.grey,
      //           // Icons.chevron_left,
      //           // color: Colors.grey,
      //           size: 20,
      //         ),
      //       ),
      //     ),
      //   ),
      //   centerTitle: true,
      //   title: Text(
      //     "Islamic Book's",
      //     style: GoogleFonts.playfairDisplay(
      //       color: Colors.black,
      //       fontWeight: FontWeight.bold,
      //       fontSize: 20,
      //     ),
      //   ),
      // ),
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
                    child: TextField(
                      onChanged: controller.updateSearchQuery,
                      decoration: const InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Container(
                //   height: 45,
                //   width: 45,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     border: Border.all(color: Colors.grey.shade200),
                //     color: Colors.white,
                //   ),
                //   child: const Icon(
                //     Icons.bookmark_border,
                //     color: Colors.grey,
                //     size: 20,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 20),

            // List of Books
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredBookList.isEmpty) {
                  return const Center(child: Text("No books found"));
                }

                return ListView.builder(
                  itemCount: controller.filteredBookList.length,
                  itemBuilder: (context, index) {
                    final book = controller.filteredBookList[index];
                    return _BookListItem(
                      title: book.title ?? "Untitled",
                      subtitle: book.subtitle ?? "",
                      imageUrl: book.image,
                      onTap: () {
                        // For now navigation to static reader, passing book info if needed
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookReaderScreen(
                              title: book.title ?? "Book",
                              pdfUrl: book.file,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
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
  final String? imageUrl;
  final VoidCallback onTap;

  const _BookListItem({
    required this.title,
    required this.subtitle,
    this.imageUrl,
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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Book Cover
            Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: kOrangeBook,
                borderRadius: BorderRadius.circular(4),
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 2,
                            width: 30,
                            color: Colors.black12,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title.length > 10 ? title.substring(0, 10) : title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 2,
                            width: 30,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    )
                  : null,
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
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 18,
              ),
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
class BookReaderScreen extends StatefulWidget {
  final String title;
  final String? pdfUrl;

  const BookReaderScreen({super.key, required this.title, this.pdfUrl});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPage = 1;
  int _pageCount = 1;
  double _zoomLevel = 1.0;

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
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 20,
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
            Text(
              widget.title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
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
                    Text(
                      "$_currentPage/$_pageCount",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        _pdfViewerController.zoomLevel = (_zoomLevel - 0.25)
                            .clamp(1.0, 4.0);
                      },
                      child: const Icon(
                        Icons.remove,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${(_zoomLevel * 100).toInt()}%",
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        _pdfViewerController.zoomLevel = (_zoomLevel + 0.25)
                            .clamp(1.0, 4.0);
                      },
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                // Icons
                Row(
                  children: [
                    // const Icon(Icons.favorite_border, size: 20, color: kTextGrey),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        if (widget.pdfUrl != null &&
                            widget.pdfUrl!.isNotEmpty) {
                          Share.share('Check out this book: ${widget.pdfUrl}');
                        }
                      },
                      child: const Icon(
                        Icons.share_outlined,
                        size: 20,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: widget.pdfUrl != null && widget.pdfUrl!.isNotEmpty
          ? SfPdfViewer.network(
              widget.pdfUrl!,
              controller: _pdfViewerController,
              canShowScrollHead: false,
              canShowScrollStatus: false,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                setState(() {
                  _pageCount = details.document.pages.count;
                });
              },
              onPageChanged: (PdfPageChangedDetails details) {
                setState(() {
                  _currentPage = details.newPageNumber;
                });
              },
              onZoomLevelChanged: (PdfZoomDetails details) {
                setState(() {
                  _zoomLevel = details.newZoomLevel;
                });
              },
            )
          : const Center(
              child: Text(
                "No PDF file available",
                style: TextStyle(color: Colors.grey),
              ),
            ),
    );
  }
}
