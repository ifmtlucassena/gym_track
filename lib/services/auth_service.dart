import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/usuario_model.dart';
import '../core/constants/firebase_constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UsuarioModel?> cadastrarComEmail(String email, String senha, String nome) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Pequeno delay para garantir que o Auth propagou o token antes de escrever no Firestore
      await Future.delayed(const Duration(milliseconds: 500));

      final usuario = UsuarioModel(
        id: userCredential.user!.uid,
        nome: nome,
        email: email,
        dataCadastro: DateTime.now(),
        isAnonimo: false,
      );

      await _firestore
          .collection(FirebaseConstants.usuarios)
          .doc(usuario.id)
          .set(usuario.toFirestore());

      return usuario;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException no cadastro: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      print('Erro genérico no cadastro: $e');
      throw Exception('Erro ao cadastrar: ${e.toString()}');
    }
  }

  Future<UsuarioModel?> loginComEmail(String email, String senha) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      return await buscarUsuario(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException no login: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      print('Erro genérico no login: $e');
      throw Exception('Erro ao fazer login: ${e.toString()}');
    }
  }

  Future<UsuarioModel?> loginComGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final uid = userCredential.user!.uid;

      // Delay para garantir propagação do token
      await Future.delayed(const Duration(milliseconds: 500));

      final usuarioExiste = await _firestore
          .collection(FirebaseConstants.usuarios)
          .doc(uid)
          .get();

      if (!usuarioExiste.exists) {
        final usuario = UsuarioModel(
          id: uid,
          nome: userCredential.user!.displayName,
          email: userCredential.user!.email,
          fotoUrl: userCredential.user!.photoURL,
          dataCadastro: DateTime.now(),
          isAnonimo: false,
        );

        await _firestore
            .collection(FirebaseConstants.usuarios)
            .doc(uid)
            .set(usuario.toFirestore());

        return usuario;
      }

      return await buscarUsuario(uid);
    } catch (e) {
      print('Erro no login com Google: $e');
      throw Exception('Erro ao fazer login com Google: ${e.toString()}');
    }
  }

  Future<UsuarioModel?> loginAnonimo() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final uid = userCredential.user!.uid;

      // Delay para garantir propagação do token
      await Future.delayed(const Duration(milliseconds: 500));

      final usuario = UsuarioModel(
        id: uid,
        nome: 'Visitante',
        dataCadastro: DateTime.now(),
        isAnonimo: true,
      );

      await _firestore
          .collection(FirebaseConstants.usuarios)
          .doc(uid)
          .set(usuario.toFirestore());

      return usuario;
    } catch (e) {
      print('Erro no login anônimo: $e');
      throw Exception('Erro ao entrar como visitante: ${e.toString()}');
    }
  }

  Future<UsuarioModel?> buscarUsuario(String uid) async {
    final doc = await _firestore
        .collection(FirebaseConstants.usuarios)
        .doc(uid)
        .get();

    if (!doc.exists) return null;
    return UsuarioModel.fromFirestore(doc.data()!, doc.id);
  }

  Future<void> atualizarUsuario(UsuarioModel usuario) async {
    await _firestore
        .collection(FirebaseConstants.usuarios)
        .doc(usuario.id)
        .update(usuario.toFirestore());
  }

  Future<void> marcarOnboardingCompleto(String uid) async {
    await _firestore
        .collection(FirebaseConstants.usuarios)
        .doc(uid)
        .update({'onboarding_completo': true});
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}