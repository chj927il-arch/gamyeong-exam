import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _newCheckController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _newCheckController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_newController.text != _newCheckController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('새 비밀번호가 일치하지 않습니다.')));
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('변경 완료'),
        content: const Text('비밀번호가 변경되었습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('비밀번호 변경')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            TextFormField(
              controller: _currentController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '현재 비밀번호'),
              validator: (v) => (v == null || v.isEmpty) ? '현재 비밀번호를 입력해주세요' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _newController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '새 비밀번호', hintText: '영문/숫자/특수문자 조합 8자 이상'),
              validator: (v) => (v == null || v.length < 4) ? '4자 이상 입력해주세요' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _newCheckController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '새 비밀번호 확인'),
              validator: (v) => (v == null || v.isEmpty) ? '새 비밀번호를 다시 입력해주세요' : null,
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: ElevatedButton(onPressed: _submit, child: const Text('변경하기')),
            ),
          ],
        ),
      ),
    );
  }
}
