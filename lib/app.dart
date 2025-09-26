import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/tasks/presentation/pages/task_list_page.dart';
import 'features/tasks/presentation/pages/task_detail_page.dart';
import 'features/tasks/presentation/pages/task_form_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/tasks/presentation/providers/task_provider.dart';
import 'injection.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => sl<TaskProvider>()),
      ],
      child: MaterialApp(
        title: 'Tickr',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        scaffoldMessengerKey: NotificationService.scaffoldMessengerKey,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const TaskListPage(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/task-detail':
              final task = settings.arguments as dynamic;
              return MaterialPageRoute(
                builder: (context) => TaskDetailPage(task: task),
              );
            case '/task-form':
              final task = settings.arguments as dynamic;
              return MaterialPageRoute(
                builder: (context) => TaskFormPage(task: task),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const SplashPage(),
              );
          }
        },
      ),
    );
  }
}
