import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controller/dua_controller.dart';
import '../model/dua_model.dart';
import '../../../core/constant/widgets/header.dart';
import '../../ai_murshid/views/ai_murshid_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import '../../profile/controller/profile_controller.dart';

// --- Common UI Constants ---
const Color kBrown = Color(0xFF8D4B33);
const Color kBlack = Color(0xFF1E1E1E);

// --- Reusable Widgets ---

class FilterChipRow extends StatelessWidget {
  const FilterChipRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = DuaController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(controller.categories.length, (index) {
            bool isActive = index == controller.selectedCategoryIndex.value;
            return GestureDetector(
              onTap: () => controller.updateCategory(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? kBrown
                      : isDark
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tr(controller.getCategoryKey(index)),
                  style: GoogleFonts.ebGaramond(
                    color: isActive
                        ? Colors.white
                        : isDark
                        ? Colors.black
                        : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class DuaCard extends StatelessWidget {
  final String arabic;
  final String title;

  const DuaCard({super.key, required this.arabic, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arabic,
                  textAlign: TextAlign.right,
                  textDirection: ui.TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade400 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: kBrown,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Screens ---

class DuaListScreen extends StatefulWidget {
  final bool hideBack;
  const DuaListScreen({super.key, this.hideBack = false});

  @override
  State<DuaListScreen> createState() => _DuaListScreenState();
}

class _DuaListScreenState extends State<DuaListScreen> {
  @override
  Widget build(BuildContext context) {
    context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DuaController controller = Get.put(DuaController());
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: HeaderSection(title: tr("dua")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.hideBack
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.2 : 0.02,
                        ),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    onChanged: (v) => controller.updateSearch(v),
                    decoration: InputDecoration(
                      hintText: tr("search_duas"),
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      icon: const Icon(Icons.search, size: 20, color: kBrown),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const FilterChipRow(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: kBrown),
                );
              }

              final displayList = controller.filteredDuaList;

              if (displayList.isEmpty) {
                return Center(child: Text(tr("no_duas_found")));
              }

              return ListView.builder(
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final dua = displayList[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => DuaDetailScreen(dua: dua),
                      ),
                    ),
                    child: DuaCard(
                      arabic: dua.arabic ?? "",
                      title: dua.title ?? "",
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class DuaDetailScreen extends StatefulWidget {
  final DuaData dua;
  const DuaDetailScreen({super.key, required this.dua});

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  late DuaData _currentDua;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentDua = widget.dua;
    _fetchDuaDetails();
  }

  Future<void> _fetchDuaDetails() async {
    if (widget.dua.id == null) return;
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.get(
        ApiEndpoints.singleDua(widget.dua.id!),
        showErrorSnackbar: false,
      );
      if (response['success'] == true && mounted) {
        setState(() {
          _currentDua = DuaData.fromJson(response['data']);
        });
      }
    } catch (e) {
      debugPrint("Failed to fetch dua details: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _downloadDua() async {
    try {
      if (Platform.isAndroid) {
        await Permission.storage.request();
      }

      Directory? directory;
      if (Platform.isAndroid) {
        final dirs = await getExternalStorageDirectories(
          type: StorageDirectory.downloads,
        );
        if (dirs != null && dirs.isNotEmpty) {
          directory = dirs.first;
        } else {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName =
            'Dua_${_currentDua.title?.replaceAll(' ', '_') ?? 'Unnamed'}_$timestamp.txt';
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);

        final textToSave =
            "${_currentDua.title ?? ''}\n\n${tr("arabic_label")}: ${_currentDua.arabic ?? ''}\n\n${tr("pronunciation_label")}: ${_currentDua.pronunciation ?? ''}\n\n${tr("meaning_label")}: ${_currentDua.meaning ?? ''}\n\n${tr("shared_via")}";

        await file.writeAsString(textToSave);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${tr("dua_download_success")}\n${tr("path_colon")} $filePath",
            ),
            backgroundColor: kBrown,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: HeaderSection(title: tr("duas")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Top Pills for Detail
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildSmallPill(tr("dua"), true, isDark)],
            ),
            const SizedBox(height: 25),
            // Dua Content Card
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: kBrown),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.03,
                      ),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _currentDua.arabic ?? "",
                      textAlign: TextAlign.center,
                      textDirection: ui.TextDirection.rtl,
                      style: GoogleFonts.amiri(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _currentDua.pronunciation ?? "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ebGaramond(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: isDark ? Colors.grey.shade400 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            // Actions Row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: kBrown.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //_actionIcon(Icons.headset_outlined, tr("listen")),
                  _actionIcon(
                    Icons.auto_awesome_outlined,
                    tr("ai_explanation"),
                    onTap: () {
                      Get.to(() => const ChatScreen());
                    },
                  ),
                  _actionIcon(
                    Icons.share_outlined,
                    tr("share"),
                    onTap: () {
                      final shareText =
                          "${_currentDua.title ?? ''}\n\n"
                          "${_currentDua.arabic ?? ''}\n\n"
                          "${_currentDua.pronunciation ?? ''}\n\n"
                          "${tr("meaning_colon")} ${_currentDua.meaning ?? ''}\n\n"
                          "${tr("shared_via")}";
                      Share.share(shareText);
                    },
                  ),
                  _actionIcon(
                    Icons.download_outlined,
                    tr("download"),
                    onTap: () {
                      ProfileController.instance.handleDownloadAction(
                        _downloadDua,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Meaning Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr("meaning_colon"),
                    style: GoogleFonts.ebGaramond(
                      color: kBrown,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentDua.meaning ?? "",
                    style: GoogleFonts.ebGaramond(
                      fontSize: 14,
                      height: 1.4,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallPill(String text, bool active, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: active
            ? kBrown
            : isDark
            ? Colors.white
            : Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.ebGaramond(
          color: active
              ? Colors.white
              : isDark
              ? Colors.black
              : Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: kBrown, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.ebGaramond(fontSize: 10, color: kBrown),
          ),
        ],
      ),
    );
  }
}
