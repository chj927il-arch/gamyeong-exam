import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FindAccountScreen extends StatefulWidget {
  const FindAccountScreen({super.key});

  @override
  State<FindAccountScreen> createState() => _FindAccountScreenState();
}

class _FindAccountScreenState extends State<FindAccountScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아이디/비밀번호 찾기'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800),
          tabs: const [
            Tab(text: '아이디 찾기'),
            Tab(text: '비밀번호 찾기'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _FindIdTab(),
          _FindPasswordTab(),
        ],
      ),
    );
  }
}

class _FindIdTab extends StatefulWidget {
  const _FindIdTab();

  @override
  State<_FindIdTab> createState() => _FindIdTabState();
}

class _FindIdTabState extends State<_FindIdTab> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _result;

  void _submit() {
    if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('이름과 이메일을 모두 입력해주세요.')));
      return;
    }
    setState(() => _result = '가입하신 아이디는 gam****exam 입니다.');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        const Text('가입 시 등록한 이름과 이메일로 아이디를 찾을 수 있어요.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
        const SizedBox(height: 20),
        TextField(controller: _nameController, decoration: const InputDecoration(labelText: '이름')),
        const SizedBox(height: 14),
        TextField(controller: _emailController, decoration: const InputDecoration(labelText: '이메일')),
        const SizedBox(height: 24),
        SizedBox(height: 52, child: ElevatedButton(onPressed: _submit, child: const Text('아이디 찾기'))),
        if (_result != null) ...[
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(12)),
            child: Text(_result!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
          ),
        ],
      ],
    );
  }
}

class _FindPasswordTab extends StatefulWidget {
  const _FindPasswordTab();

  @override
  State<_FindPasswordTab> createState() => _FindPasswordTabState();
}

class _FindPasswordTabState extends State<_FindPasswordTab> {
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  bool _sent = false;

  void _submit() {
    if (_idController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('아이디와 이메일을 모두 입력해주세요.')));
      return;
    }
    setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        const Text('가입 시 등록한 아이디와 이메일로 임시 비밀번호를 보내드려요.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
        const SizedBox(height: 20),
        TextField(controller: _idController, decoration: const InputDecoration(labelText: '아이디')),
        const SizedBox(height: 14),
        TextField(controller: _emailController, decoration: const InputDecoration(labelText: '이메일')),
        const SizedBox(height: 24),
        SizedBox(height: 52, child: ElevatedButton(onPressed: _submit, child: const Text('임시 비밀번호 받기'))),
        if (_sent) ...[
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(12)),
            child: const Text(
              '입력하신 이메일로 임시 비밀번호를 발송했어요.\n로그인 후 반드시 비밀번호를 변경해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, height: 1.5),
            ),
          ),
        ],
      ],
    );
  }
}
