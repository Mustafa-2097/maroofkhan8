import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../controller/book_controller.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kOrangeBook = Color(0xFFF57C00);

// ==========================================
// SCREEN 1: BOOK LIST SCREEN
// ==========================================
class IslamicBooksListScreen extends StatelessWidget {
  const IslamicBooksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: HeaderSection(title: tr("islamic_books")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white70 : Colors.grey,
            size: sw * 0.05,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
        child: Column(
          children: [
            SizedBox(height: sh * 0.012),
            // Search Bar Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: sh * 0.055,
                    padding: EdgeInsets.symmetric(horizontal: sw * 0.04),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: TextField(
                      onChanged: controller.updateSearchQuery,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: tr("search_hint"),
                        hintStyle: TextStyle(
                          fontSize: sw * 0.035,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: sh * 0.015),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sh * 0.025),

            // List of Books
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryBrown),
                  );
                }
                if (controller.filteredBookList.isEmpty) {
                  return Center(
                    child: Text(
                      tr("no_books_found"),
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(bottom: sh * 0.02),
                  itemCount: controller.filteredBookList.length,
                  itemBuilder: (context, index) {
                    final book = controller.filteredBookList[index];
                    return _BookListItem(
                      title: book.title ?? tr("untitled"),
                      subtitle: book.subtitle ?? "",
                      imageUrl: book.image,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookReaderScreen(
                              title: book.title ?? tr("book"),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: sh * 0.018),
        padding: EdgeInsets.all(sw * 0.03),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Book Cover
            Container(
              width: sw * 0.12,
              height: sh * 0.08,
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
                            width: sw * 0.07,
                            color: Colors.black12,
                          ),
                          SizedBox(height: sh * 0.005),
                          Text(
                            title.length > 10 ? title.substring(0, 10) : title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: sw * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: sh * 0.005),
                          Container(
                            height: 2,
                            width: sw * 0.07,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
            SizedBox(width: sw * 0.04),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: sw * 0.04,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: sh * 0.006),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: sw * 0.03,
                      color: isDark
                          ? Colors.grey[400]
                          : const Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Button
            Container(
              height: sw * 0.09,
              width: sw * 0.09,
              decoration: BoxDecoration(
                color: kPrimaryBrown,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: sw * 0.045,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white70 : Colors.grey,
            size: sw * 0.05,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              tr("islamic_books"),
              style: GoogleFonts.playfairDisplay(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: sw * 0.045,
              ),
            ),
            SizedBox(height: sh * 0.005),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: sw * 0.03,
                color: isDark ? Colors.grey[400] : Colors.black54,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(sh * 0.05),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                ),
                bottom: BorderSide(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                ),
              ),
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: sw * 0.05,
              vertical: sh * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page Controls
                Row(
                  children: [
                    Text(
                      "$_currentPage/$_pageCount",
                      style: TextStyle(
                        fontSize: sw * 0.03,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(width: sw * 0.04),
                    InkWell(
                      onTap: () {
                        _pdfViewerController.zoomLevel = (_zoomLevel - 0.25)
                            .clamp(1.0, 4.0);
                      },
                      child: Icon(
                        Icons.remove,
                        size: sw * 0.04,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(width: sw * 0.02),
                    Text(
                      "${(_zoomLevel * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: sw * 0.03,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(width: sw * 0.02),
                    InkWell(
                      onTap: () {
                        _pdfViewerController.zoomLevel = (_zoomLevel + 0.25)
                            .clamp(1.0, 4.0);
                      },
                      child: Icon(
                        Icons.add,
                        size: sw * 0.04,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                // Icons
                Row(
                  children: [
                    SizedBox(width: sw * 0.04),
                    InkWell(
                      onTap: () {
                        if (widget.pdfUrl != null &&
                            widget.pdfUrl!.isNotEmpty) {
                          Share.share(
                            '${tr("check_out_this_book")} ${widget.pdfUrl}',
                          );
                        }
                      },
                      child: Icon(
                        Icons.share_outlined,
                        size: sw * 0.05,
                        color: isDark
                            ? Colors.grey[400]
                            : const Color(0xFF757575),
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
                if (mounted) {
                  setState(() {
                    _pageCount = details.document.pages.count;
                  });
                }
              },
              onPageChanged: (PdfPageChangedDetails details) {
                if (mounted) {
                  setState(() {
                    _currentPage = details.newPageNumber;
                  });
                }
              },
              onZoomLevelChanged: (PdfZoomDetails details) {
                if (mounted) {
                  setState(() {
                    _zoomLevel = details.newZoomLevel;
                  });
                }
              },
            )
          : Center(
              child: Text(
                tr("no_pdf_available"),
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
              ),
            ),
    );
  }
}
