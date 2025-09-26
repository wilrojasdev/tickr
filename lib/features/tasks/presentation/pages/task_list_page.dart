import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/list/list_widgets.dart';
import 'task_form_page.dart';
import '../widgets/common/appbar_custom.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _authProvider.addListener(_authListener);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_authListener);
    _tabController.dispose();
    super.dispose();
  }

  void _authListener() {
    if (!_authProvider.isAuthenticated) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TaskAppBar(
        leading: null,
        title: Row(
          children: [
            Container(
              width: Responsive.scaleWidth(context, 32),
              height: Responsive.scaleWidth(context, 32),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius:
                    BorderRadius.circular(Responsive.scaleWidth(context, 8)),
              ),
              child: Icon(
                Icons.task_alt_rounded,
                color: AppColors.white,
                size: Responsive.scaleWidth(context, 20),
              ),
            ),
            SizedBox(width: Responsive.scaleWidth(context, 12)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tickr',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: Responsive.scaleFont(context, 20),
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Text(
                      authProvider.user?.username ?? 'Usuario',
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.9),
                        fontSize: Responsive.scaleFont(context, 14),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        action: IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: _showLogoutDialog,
          tooltip: 'Cerrar sesión',
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Column(
            children: [
              // Header con título y botón de agregar
              TaskListHeader(
                title: 'Mis Tareas',
                taskCount: taskProvider.tasks.length,
                onAddTask: _navigateToTaskForm,
                onFilter: _toggleSort,
              ),

              // Tabs para filtrar tareas
              Container(
                color: AppColors.white,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  isScrollable: true,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: AppTypography.button.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.scaleFont(
                        context, AppTypography.fontSizeMedium),
                  ),
                  tabs: [
                    Tab(text: 'Todas (${taskProvider.tasks.length})'),
                    Tab(
                        text:
                            'Pendientes (${taskProvider.pendingTasks.length})'),
                    Tab(
                        text:
                            'Completadas (${taskProvider.completedTasks.length})'),
                  ],
                ),
              ),

              // Contenido de las tabs
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Todas las tareas
                    TaskListContent(
                      tasks: taskProvider.tasks,
                      isLoading: taskProvider.isLoading,
                      onTaskTap: _navigateToTaskDetail,
                      onToggleComplete: _toggleTaskComplete,
                      onEditTask: _navigateToTaskForm,
                      onDeleteTask: _deleteTask,
                      isTaskLoading: (taskId) =>
                          taskProvider.isTaskBeingUpdated(taskId),
                      isTaskDeleting: (taskId) =>
                          taskProvider.isTaskBeingDeleted(taskId),
                    ),

                    // Tareas pendientes
                    TaskListContent(
                      tasks: taskProvider.pendingTasks,
                      isLoading: taskProvider.isLoading,
                      onTaskTap: _navigateToTaskDetail,
                      onToggleComplete: _toggleTaskComplete,
                      onEditTask: _navigateToTaskForm,
                      onDeleteTask: _deleteTask,
                      isTaskLoading: (taskId) =>
                          taskProvider.isTaskBeingUpdated(taskId),
                      isTaskDeleting: (taskId) =>
                          taskProvider.isTaskBeingDeleted(taskId),
                    ),

                    // Tareas completadas
                    TaskListContent(
                      tasks: taskProvider.completedTasks,
                      isLoading: taskProvider.isLoading,
                      onTaskTap: _navigateToTaskDetail,
                      onToggleComplete: _toggleTaskComplete,
                      onEditTask: _navigateToTaskForm,
                      onDeleteTask: _deleteTask,
                      isTaskLoading: (taskId) =>
                          taskProvider.isTaskBeingUpdated(taskId),
                      isTaskDeleting: (taskId) =>
                          taskProvider.isTaskBeingDeleted(taskId),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToTaskForm([task]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormPage(task: task),
      ),
    );

    if (result == true) {
      if (mounted) {
        context.read<TaskProvider>().loadTasks();
      }
    }
  }

  void _navigateToTaskDetail(task) {
    Navigator.pushNamed(
      context,
      '/task-detail',
      arguments: task,
    );
  }

  void _toggleTaskComplete(task) {
    context.read<TaskProvider>().toggleTaskCompletion(task);
  }

  void _deleteTask(task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Tarea'),
        content: Text('¿Estás seguro de que quieres eliminar "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TaskProvider>().deleteTask(task.id);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _toggleSort() {
    context.read<TaskProvider>().toggleSortByDueDate();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
