// lib/views/widgets/password_ card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';

class PasswordCard extends StatefulWidget {
  final String title;
  final String username;
  final String password;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PasswordCard({
    super.key,
    required this.title,
    required this.username,
    required this.password,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? kCardColorDark : kCardColorLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [kPrimaryColorDark, kPrimaryColorDark.withOpacity(0.7)]
                  : [kPrimaryColorLight, kPrimaryColorLight.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.vpn_key_rounded, color: Colors.white, size: 24),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: isDark ? kTextColorDark : kTextColorLight,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.username,
              style: TextStyle(
                color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _showPassword ? widget.password : "•••••••••",
                    style: TextStyle(
                      color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
                      fontSize: 14,
                      letterSpacing: _showPassword ? 0.5 : 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: _showPassword ? null : 1,
                    overflow: _showPassword ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () {
                    setState(() => _showPassword = !_showPassword);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      _showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.password));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password copied to clipboard"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 18,
                      color: isDark ? kSecondaryColorDark : kSecondaryColorLight,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: (isDark ? kPrimaryColorDark : kPrimaryColorLight).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.edit_rounded,
                  color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
                  size: 20,
                ),
                onPressed: widget.onEdit,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: kAccentColorLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.delete_rounded,
                  color: kAccentColorLight,
                  size: 20,
                ),
                onPressed: () => _showDeleteConfirmation(context, isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? kCardColorDark : kCardColorLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: kAccentColorLight,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Delete Password?',
                style: TextStyle(
                  color: isDark ? kTextColorDark : kTextColorLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this password? This action cannot be undone.',
            style: TextStyle(
              color: isDark ? kTextSecondaryDark : kTextSecondaryLight,
              fontSize: 16,
            ),
          ),
          actions: [
            // No Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'No',
                style: TextStyle(
                  color: isDark ? kTextColorDark : kTextColorLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Yes Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentColorLight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Yes, Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
