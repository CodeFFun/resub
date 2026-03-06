import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/app/theme/theme_mode_provider.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/auth/presentation/pages/login_screen.dart';
import 'package:resub/features/payment/presentation/pages/payment_page_screen.dart';
import 'package:resub/features/profile/presentation/pages/personal_info_page.dart';
import 'package:resub/features/profile/presentation/state/profile_state.dart';
import 'package:resub/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:resub/features/settings/presentation/widgets/profile_menu_item.dart';

class CustomerPageScreen extends ConsumerStatefulWidget {
  const CustomerPageScreen({super.key});

  @override
  ConsumerState<CustomerPageScreen> createState() => _CustomerPageScreenState();
}

class _CustomerPageScreenState extends ConsumerState<CustomerPageScreen> {
  String _userName = '';
  String? _profilePicture;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();
    if (userId != null && mounted) {
      await ref
          .read(profileViewModelProvider.notifier)
          .getProfileById(userId: userId);
    }
  }

  Future<void> _handleLogout() async {
    final userSession = ref.read(userSessionServiceProvider);
    final tokenSession = ref.read(tokenServiceProvider);
    await userSession.clearSession();
    await tokenSession.removeToken();

    ref.invalidate(userSessionServiceProvider);

    if (mounted) {
      AppRoutes.pushReplacement(context, const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.status == ProfileStatus.loaded && next.user != null) {
        setState(() {
          _profilePicture = next.user!.profilePicture;
          _userName = next.user!.userName ?? '';
        });
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: appColors?.cardBackground ?? theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: appColors?.border ?? theme.dividerColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: colorScheme.surface,
                      backgroundImage:
                          _profilePicture != null && _profilePicture!.isNotEmpty
                          ? NetworkImage(
                              '${ApiEndpoints.baseUrl}$_profilePicture',
                            )
                          : null,
                      child: _profilePicture == null || _profilePicture!.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 35,
                              color:
                                  appColors?.mutedText ??
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            )
                          : null,
                    ),
                    const SizedBox(width: 46),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName.isEmpty ? 'Loading...' : _userName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'Account Details',
                subtitle: 'Manage your Account Details',
                onTap: () {
                  AppRoutes.push(context, const PersonalInfoPage());
                },
              ),
              ProfileMenuItem(
                icon: isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                title: 'Appearance',
                subtitle: isDarkMode
                    ? 'Dark mode enabled'
                    : 'Light mode enabled',
                showChevron: false,
                trailing: Switch.adaptive(
                  value: isDarkMode,
                  activeThumbColor: colorScheme.primary,
                  activeTrackColor: colorScheme.primary.withValues(alpha: 0.35),
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).toggleTheme(value);
                  },
                ),
              ),
              const SizedBox(height: 16),
              ProfileMenuItem(
                icon: Icons.payment,
                title: 'Payments',
                onTap: () {
                  AppRoutes.push(context, const PaymentPageScreen());
                },
              ),
              const SizedBox(height: 16),
              // Logout Button
              ProfileMenuItem(
                icon: Icons.logout,
                title: 'Log out',
                onTap: _handleLogout,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
