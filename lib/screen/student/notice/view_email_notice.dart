import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:html_unescape/html_unescape.dart';
import 'package:lbef/model/email_notice_model.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../resource/colors.dart';
import '../../../utils/format_time.dart';
import '../../../utils/utils.dart';
import '../../../view_model/notice_board/email_view_model.dart';
import '../../../view_model/theme_provider.dart';

class ViewEmail extends StatefulWidget {
  final EmailNoticeModel emailData;

  const ViewEmail({super.key, required this.emailData});

  @override
  State<ViewEmail> createState() => _ViewEmailState();
}

class _ViewEmailState extends State<ViewEmail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetch());
  }

  void fetch() async {
    final id = widget.emailData.mailId?.toString();
    if (id == null || id.isEmpty) {
      if (context.mounted) {
        Utils.flushBarErrorMessage("Invalid email ID", context);
      }
      return;
    }
    await Provider.of<EmailViewModel>(context, listen: false)
        .getNoticeDetails(id, context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text(
          "Email Details",
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
        child: Consumer<EmailViewModel>(
          builder: (context, provider, child) {
            final isLoading = provider.isLoading;
            final email = provider.currentDetails ?? widget.emailData;

            String date = 'N/A';
            String time = 'N/A';
            if (email.sentOn != null && email.sentOn!.contains(' ')) {
              final parts = email.sentOn!.split(' ');
              date = parseDate(parts[0]);
              time = formatTimeTo12Hour(parts[1]);
            }
            if (isLoading) {
              return _buildLoadingSkeleton();
            }
            return Consumer<ThemeProvider>(builder: (context, provider, child) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: provider.isDarkMode ? Colors.black : Colors.white,
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
                        email.subject ?? 'No Subject',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: provider.isDarkMode
                              ? Colors.white
                              : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Sent on $date at $time',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'From: ${email.mailFromname ?? 'Unknown'} <${email.mailFrom ?? ''}>',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            provider.isDarkMode ? Colors.white : Colors.black,
                        fontFamily: 'poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'To: ${email.mailToname ?? 'Unknown'} <${email.mailTo ?? ''}>',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            provider.isDarkMode ? Colors.white : Colors.black,
                        fontFamily: 'poppins',
                      ),
                    ),
                    const SizedBox(height: 24),
                    _parseTextWithLinks(
                        stripHtmlTags(
                            email.emailText ?? 'No content available.'),
                        context),
                  ],
                ),
              );
            });
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

  Widget _parseTextWithLinks(String htmlText, BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    final unescape = HtmlUnescape();
    final String unescapedText = unescape.convert(htmlText);
    final document = html_parser.parse(unescapedText);
    final List<TextSpan> spans = [];

    void parseNode(dom.Node node) {
      if (node is dom.Text) {
        if (node.text.trim().isNotEmpty) {
          spans.add(TextSpan(
            text: node.text,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              fontFamily: 'poppins',
              color: textColor,
            ),
          ));
        }
      } else if (node is dom.Element && node.localName == 'a') {
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
        for (var child in node.nodes) {
          parseNode(child);
        }
      }
    }

    for (var node in document.body?.nodes ?? []) {
      parseNode(node);
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

}
