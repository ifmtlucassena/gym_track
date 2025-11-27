import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';

class SobreSection extends StatefulWidget {
  const SobreSection({super.key});

  @override
  State<SobreSection> createState() => _SobreSectionState();
}

class _SobreSectionState extends State<SobreSection> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${info.version} (Build ${info.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ℹ️ Sobre',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.smartphone, color: AppColors.primary),
                  title: const Text('Versão do App', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(_version, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ),
                const Divider(height: 1),
                _buildLinkItem(
                  context,
                  'Termos de Uso',
                  Icons.description_outlined,
                  () => _launchUrl('https://gymtrack.com/terms'),
                ),
                const Divider(height: 1),
                _buildLinkItem(
                  context,
                  'Política de Privacidade',
                  Icons.privacy_tip_outlined,
                  () => _launchUrl('https://gymtrack.com/privacy'),
                ),
                const Divider(height: 1),
                _buildLinkItem(
                  context,
                  'Fale Conosco',
                  Icons.chat_bubble_outline,
                  () => _launchUrl('mailto:contato@gymtrack.com'),
                ),
                const Divider(height: 1),
                _buildLinkItem(
                  context,
                  'Avaliar o App',
                  Icons.star_outline,
                  () {
                    // TODO: Implementar link da loja
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
