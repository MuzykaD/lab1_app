import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class DataTablesPage extends StatefulWidget {
  const DataTablesPage({super.key});

  @override
  State<DataTablesPage> createState() => _DataTablesPageState();
}

class _DataTablesPageState extends State<DataTablesPage> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<Post> _posts = [];
  List<User> _users = [];
  bool _isLoading = true;
  late TabController _tabController;

  // Pagination settings
  int _rowsPerPage = 10;
  final List<int> _availableRowsPerPage = [5, 10, 20, 50];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final posts = await _apiService.getPosts();
      final users = await _apiService.getUsers();
      setState(() {
        _posts = posts;
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Widget _buildUsersTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Users Table',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          PaginatedDataTable(
            header: const Text('User Information'),
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: _availableRowsPerPage,
            onRowsPerPageChanged: (value) {
              if (value != null) {
                setState(() {
                  _rowsPerPage = value;
                });
              }
            },
            columns: const [
              DataColumn(
                label: Text('ID'),
                numeric: true,
              ),
              DataColumn(
                label: Text('Name'),
              ),
              DataColumn(
                label: Text('Username'),
              ),
              DataColumn(
                label: Text('Email'),
              ),
            ],
            source: _UserDataSource(_users),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Posts Table',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          PaginatedDataTable(
            header: const Text('Post Information'),
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: _availableRowsPerPage,
            onRowsPerPageChanged: (value) {
              if (value != null) {
                setState(() {
                  _rowsPerPage = value;
                });
              }
            },
            columns: const [
              DataColumn(
                label: Text('ID'),
                numeric: true,
              ),
              DataColumn(
                label: Text('User ID'),
                numeric: true,
              ),
              DataColumn(
                label: Text('Title'),
              ),
              DataColumn(
                label: Text('Body'),
              ),
            ],
            source: _PostDataSource(_posts),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSONPlaceholder Data'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.people),
              text: 'Users',
            ),
            Tab(
              icon: Icon(Icons.article),
              text: 'Posts',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildUsersTable(),
                _buildPostsTable(),
              ],
            ),
    );
  }
}

class _UserDataSource extends DataTableSource {
  final List<User> _users;

  _UserDataSource(this._users);

  @override
  DataRow? getRow(int index) {
    if (index >= _users.length) return null;
    final user = _users[index];
    return DataRow(
      cells: [
        DataCell(Text(user.id.toString())),
        DataCell(Text(user.name)),
        DataCell(Text(user.username)),
        DataCell(Text(user.email)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _users.length;

  @override
  int get selectedRowCount => 0;
}

class _PostDataSource extends DataTableSource {
  final List<Post> _posts;

  _PostDataSource(this._posts);

  @override
  DataRow? getRow(int index) {
    if (index >= _posts.length) return null;
    final post = _posts[index];
    return DataRow(
      cells: [
        DataCell(Text(post.id.toString())),
        DataCell(Text(post.userId.toString())),
        DataCell(Text(post.title)),
        DataCell(Text(post.body)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _posts.length;

  @override
  int get selectedRowCount => 0;
} 