import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioModel {
  final String id;
  final String? nome;
  final String? email;
  final String? fotoUrl;
  final double? pesoAtual;
  final DateTime? dataNascimento;
  final String? objetivo; // 'massa', 'perda_peso', 'manutencao', 'forca', 'saude'
  final DateTime dataCadastro;
  final bool onboardingCompleto;
  final bool isAnonimo;
  
  // Novos campos para migração
  final String? dadosMigradosDe; // UID do usuário anônimo
  final String? migradoPara; // UID do novo usuário (se foi migrado)
  final DateTime? dataMigracao;
  
  // Configurações
  final bool notificacoesAtivadas;
  final String unidadePeso; // 'kg' ou 'lb'
  final String tema; // 'claro', 'escuro', 'sistema'

  UsuarioModel({
    required this.id,
    this.nome,
    this.email,
    this.fotoUrl,
    this.pesoAtual,
    this.dataNascimento,
    this.objetivo,
    required this.dataCadastro,
    this.onboardingCompleto = false,
    this.isAnonimo = false,
    this.dadosMigradosDe,
    this.migradoPara,
    this.dataMigracao,
    this.notificacoesAtivadas = true,
    this.unidadePeso = 'kg',
    this.tema = 'sistema',
  });

  factory UsuarioModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UsuarioModel(
      id: id,
      nome: data['nome'],
      email: data['email'],
      fotoUrl: data['foto_url'],
      pesoAtual: data['peso_atual']?.toDouble(),
      dataNascimento: data['data_nascimento'] != null 
          ? (data['data_nascimento'] as Timestamp).toDate() 
          : null,
      objetivo: data['objetivo'],
      dataCadastro: (data['data_cadastro'] as Timestamp).toDate(),
      onboardingCompleto: data['onboarding_completo'] ?? false,
      isAnonimo: data['is_anonimo'] ?? false,
      dadosMigradosDe: data['dados_migrados_de'],
      migradoPara: data['migrado_para'],
      dataMigracao: data['data_migracao'] != null 
          ? (data['data_migracao'] as Timestamp).toDate() 
          : null,
      notificacoesAtivadas: data['notificacoes_ativadas'] ?? true,
      unidadePeso: data['unidade_peso'] ?? 'kg',
      tema: data['tema'] ?? 'sistema',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'email': email,
      'foto_url': fotoUrl,
      'peso_atual': pesoAtual,
      'data_nascimento': dataNascimento != null ? Timestamp.fromDate(dataNascimento!) : null,
      'objetivo': objetivo,
      'data_cadastro': Timestamp.fromDate(dataCadastro),
      'onboarding_completo': onboardingCompleto,
      'is_anonimo': isAnonimo,
      'dados_migrados_de': dadosMigradosDe,
      'migrado_para': migradoPara,
      'data_migracao': dataMigracao != null ? Timestamp.fromDate(dataMigracao!) : null,
      'notificacoes_ativadas': notificacoesAtivadas,
      'unidade_peso': unidadePeso,
      'tema': tema,
    };
  }

  UsuarioModel copyWith({
    String? nome,
    String? email,
    String? fotoUrl,
    double? pesoAtual,
    DateTime? dataNascimento,
    String? objetivo,
    bool? onboardingCompleto,
    bool? isAnonimo,
    String? dadosMigradosDe,
    String? migradoPara,
    DateTime? dataMigracao,
    bool? notificacoesAtivadas,
    String? unidadePeso,
    String? tema,
  }) {
    return UsuarioModel(
      id: id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      pesoAtual: pesoAtual ?? this.pesoAtual,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      objetivo: objetivo ?? this.objetivo,
      dataCadastro: dataCadastro,
      onboardingCompleto: onboardingCompleto ?? this.onboardingCompleto,
      isAnonimo: isAnonimo ?? this.isAnonimo,
      dadosMigradosDe: dadosMigradosDe ?? this.dadosMigradosDe,
      migradoPara: migradoPara ?? this.migradoPara,
      dataMigracao: dataMigracao ?? this.dataMigracao,
      notificacoesAtivadas: notificacoesAtivadas ?? this.notificacoesAtivadas,
      unidadePeso: unidadePeso ?? this.unidadePeso,
      tema: tema ?? this.tema,
    );
  }
}