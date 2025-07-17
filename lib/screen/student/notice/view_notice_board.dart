import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom; // Use prefix to avoid conflict
import 'package:html/parser.dart' as html_parser;
import 'package:html_unescape/html_unescape.dart';
import 'package:lbef/model/notice_model.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../resource/colors.dart';
import '../../../utils/format_time.dart';
import '../../../utils/utils.dart';
import '../../../view_model/notice_board/notice_board_view_model.dart';
import '../../../view_model/theme_provider.dart';

class ViewNoticeBoard extends StatefulWidget {
  final NoticeModel noticeData;

  const ViewNoticeBoard({super.key, required this.noticeData});

  @override
  State<ViewNoticeBoard> createState() => _ViewNoticeBoardState();
}

class _ViewNoticeBoardState extends State<ViewNoticeBoard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetch());
  }

  void fetch() async {
    final id = widget.noticeData.noticeId?.toString();
    if (id == null || id.isEmpty) {
      if (context.mounted) {
        Utils.flushBarErrorMessage("Invalid notice ID", context);
      }
      return;
    }
    await Provider.of<NoticeBoardViewModel>(context, listen: false)
        .getNoticeDetails(id, context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text(
          "Notice Details",
          style: TextStyle(fontFamily: 'poppins'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: AppColors.primary,
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Image(
              image: AssetImage('assets/images/lbef.png'),
              width: 70,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Consumer<NoticeBoardViewModel>(
          builder: (context, provider, child) {
            final isLoading = provider.isLoading;
            final notice = provider.currentDetails ?? widget.noticeData;

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      notice.subject ?? 'No Title',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Published on ${notice.noticeDate != null ? parseDate(notice.noticeDate!) : 'N/A'}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (isLoading)
                    _buildLoadingSkeleton()
                  else
                    _parseTextWithLinks(stripHtmlTags(
                        notice.noticeText ?? 'No content available.')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 16 + (index % 2 == 0 ? 12 : 8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }

  Widget _parseTextWithLinks(String htmlText) {
    final unescape = HtmlUnescape();
    final String unescapedText = unescape.convert(htmlText);
    final document = html_parser.parse(unescapedText);
    final List<TextSpan> spans = [];
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    void parseNode(dom.Node node) {
      if (node is dom.Text) {
        // Handle plain text
        if (node.text.trim().isNotEmpty) {
          spans.add(TextSpan(
            text: node.text,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              fontFamily: 'poppins',
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            ),
          ));
        }
      } else if (node is dom.Element && node.localName == 'a') {
        // Handle anchor tags
        final linkUrl = node.attributes['href'] ?? '';
        final linkText = node.text.isNotEmpty ? node.text : linkUrl;

        spans.add(TextSpan(
          text: linkText,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            fontFamily: 'poppins',
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final Uri url = Uri.parse(linkUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                if (context.mounted) {
                  Utils.flushBarErrorMessage("Cannot open link", context);
                }
              }
            },
        ));
      } else if (node.hasChildNodes()) {
        // Recursively process child nodes
        for (var child in node.nodes) {
          parseNode(child);
        }
      }
    }

    // Parse all nodes in the document body
    for (var node in document.body?.nodes ?? []) {
      parseNode(node);
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
