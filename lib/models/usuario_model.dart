import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioModel {
  final String id;
  final String? nome;
  final String? email;
  final String? fotoUrl;
  final double? pesoAtual;
  final DateTime dataCadastro;
  final bool onboardingCompleto;
  final bool isAnonimo;

  UsuarioModel({
    required this.id,
    this.nome,
    this.email,
    this.fotoUrl,
    this.pesoAtual,
    required this.dataCadastro,
    this.onboardingCompleto = false,
    this.isAnonimo = false,
  });

  factory UsuarioModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UsuarioModel(
      id: id,
      nome: data['nome'],
      email: data['email'],
      fotoUrl: data['foto_url'],
      pesoAtual: data['peso_atual']?.toDouble(),
      dataCadastro: (data['data_cadastro'] as Timestamp).toDate(),
      onboardingCompleto: data['onboarding_completo'] ?? false,
      isAnonimo: data['is_anonimo'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'email': email,
      'foto_url': fotoUrl,
      'peso_atual': pesoAtual,
      'data_cadastro': Timestamp.fromDate(dataCadastro),
      'onboarding_completo': onboardingCompleto,
      'is_anonimo': isAnonimo,
    };
  }

  UsuarioModel copyWith({
    String? nome,
    String? email,
    String? fotoUrl,
    double? pesoAtual,
    bool? onboardingCompleto,
    bool? isAnonimo,
  }) {
    return UsuarioModel(
      id: id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      pesoAtual: pesoAtual ?? this.pesoAtual,
      dataCadastro: dataCadastro,
      onboardingCompleto: onboardingCompleto ?? this.onboardingCompleto,
      isAnonimo: isAnonimo ?? this.isAnonimo,
    );
  }
}