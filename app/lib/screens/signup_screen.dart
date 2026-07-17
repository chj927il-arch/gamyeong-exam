import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwCheckController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _idChecked = false;
  bool _agreeAll = false;
  bool _agreeTerms = false;
  bool _agreePrivacy = false;
  bool _agreeMarketing = false;

  void _updateAgreeAll() {
    setState(() {
      _agreeAll = _agreeTerms && _agreePrivacy && _agreeMarketing;
    });
  }

  void _toggleAll(bool? v) {
    final value = v ?? false;
    setState(() {
      _agreeAll = value;
      _agreeTerms = value;
      _agreePrivacy = value;
      _agreeMarketing = value;
    });
  }

  void _checkDuplicate() {
    if (_idController.text.trim().isEmpty) return;
    setState(() => _idChecked = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('사용 가능한 아이디입니다.')),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_idChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('아이디 중복확인을 해주세요.')));
      return;
    }
    if (!_agreeTerms || !_agreePrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('필수 약관에 동의해주세요.')));
      return;
    }
    if (_pwController.text != _pwCheckController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('가입 완료'),
        content: const Text('회원가입이 완료되었습니다.\n로그인 화면으로 돌아갑니다.'),
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
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _pwCheckController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              const Text('기본 정보', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _idController,
                      decoration: const InputDecoration(labelText: '아이디', hintText: '영문/숫자 4~16자'),
                      onChanged: (_) => setState(() => _idChecked = false),
                      validator: (v) => (v == null || v.trim().isEmpty) ? '아이디를 입력해주세요' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: OutlinedButton(
                      onPressed: _checkDuplicate,
                      child: Text(_idChecked ? '확인완료' : '중복확인'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _pwController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호', hintText: '영문/숫자/특수문자 조합 8자 이상'),
                validator: (v) => (v == null || v.length < 4) ? '비밀번호는 4자 이상 입력해주세요' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _pwCheckController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호 확인'),
                validator: (v) => (v == null || v.isEmpty) ? '비밀번호를 다시 입력해주세요' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름', prefixIcon: Icon(Icons.badge_outlined)),
                validator: (v) => (v == null || v.trim().isEmpty) ? '이름을 입력해주세요' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: '이메일', hintText: 'example@email.com', prefixIcon: Icon(Icons.mail_outline_rounded)),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '이메일을 입력해주세요';
                  if (!v.contains('@')) return '올바른 이메일 형식이 아닙니다';
                  return null;
                },
              ),
              const SizedBox(height: 28),
              const Text('약관 동의', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.glassBorder),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: _agreeAll,
                      onChanged: _toggleAll,
                      title: const Text('전체 동의', style: TextStyle(fontWeight: FontWeight.w800)),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const Divider(height: 1),
                    CheckboxListTile(
                      value: _agreeTerms,
                      onChanged: (v) {
                        _agreeTerms = v ?? false;
                        _updateAgreeAll();
                      },
                      title: const Text('[필수] 이용약관 동의'),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                    CheckboxListTile(
                      value: _agreePrivacy,
                      onChanged: (v) {
                        _agreePrivacy = v ?? false;
                        _updateAgreeAll();
                      },
                      title: const Text('[필수] 개인정보 수집 및 이용 동의'),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                    CheckboxListTile(
                      value: _agreeMarketing,
                      onChanged: (v) {
                        _agreeMarketing = v ?? false;
                        _updateAgreeAll();
                      },
                      title: const Text('[선택] 마케팅 정보 수신 동의'),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('가입하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
