import '../../models/dia_treino_model.dart';
import '../../models/exercicio_model.dart';
import '../../models/serie_model.dart';

class FichaTemplate {
  final String id;
  final String nome;
  final String descricao;
  final String nivel;
  final int diasPorSemana;
  final List<DiaTreinoModel> diasTreino;

  FichaTemplate({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.nivel,
    required this.diasPorSemana,
    required this.diasTreino,
  });
}

class FichaTemplates {
  static final List<FichaTemplate> templates = [
    // TEMPLATE INICIANTE
    FichaTemplate(
      id: 'iniciante',
      nome: 'Ficha Iniciante - Full Body',
      descricao: '3x por semana, treino completo do corpo em cada sessão. Ideal para quem está começando.',
      nivel: 'iniciante',
      diasPorSemana: 3,
      diasTreino: [
        // TREINO A - Segunda-feira
        DiaTreinoModel(
          id: 'treino_a',
          nome: 'Treino A - Full Body',
          descricao: 'Treino completo do corpo focando em exercícios compostos',
          diaSemana: 1,
          ordem: 0,
          exercicios: [
            ExercicioModel(
              id: 'ex1',
              nome: 'Agachamento Livre',
              grupo_muscular: 'Pernas',
              ordem: 0,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex2',
              nome: 'Supino Reto',
              grupo_muscular: 'Peito',
              ordem: 1,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex3',
              nome: 'Remada Curvada',
              grupo_muscular: 'Costas',
              ordem: 2,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex4',
              nome: 'Desenvolvimento com Halteres',
              grupo_muscular: 'Ombros',
              ordem: 3,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex5',
              nome: 'Rosca Direta',
              grupo_muscular: 'Bíceps',
              ordem: 4,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex6',
              nome: 'Tríceps Corda',
              grupo_muscular: 'Tríceps',
              ordem: 5,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
          ],
        ),
        // TREINO B - Quarta-feira
        DiaTreinoModel(
          id: 'treino_b',
          nome: 'Treino B - Full Body',
          descricao: 'Variação do treino completo com exercícios diferentes',
          diaSemana: 3,
          ordem: 1,
          exercicios: [
            ExercicioModel(
              id: 'ex7',
              nome: 'Leg Press 45°',
              grupo_muscular: 'Pernas',
              ordem: 0,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex8',
              nome: 'Supino Inclinado',
              grupo_muscular: 'Peito',
              ordem: 1,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex9',
              nome: 'Puxada Frontal',
              grupo_muscular: 'Costas',
              ordem: 2,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex10',
              nome: 'Elevação Lateral',
              grupo_muscular: 'Ombros',
              ordem: 3,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex11',
              nome: 'Rosca Alternada',
              grupo_muscular: 'Bíceps',
              ordem: 4,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex12',
              nome: 'Tríceps Testa',
              grupo_muscular: 'Tríceps',
              ordem: 5,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
          ],
        ),
        // TREINO C - Sexta-feira
        DiaTreinoModel(
          id: 'treino_c',
          nome: 'Treino C - Full Body',
          descricao: 'Terceira variação do treino completo',
          diaSemana: 5,
          ordem: 2,
          exercicios: [
            ExercicioModel(
              id: 'ex13',
              nome: 'Stiff',
              grupo_muscular: 'Pernas',
              ordem: 0,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex14',
              nome: 'Crucifixo Reto',
              grupo_muscular: 'Peito',
              ordem: 1,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex15',
              nome: 'Remada Cavalinho',
              grupo_muscular: 'Costas',
              ordem: 2,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex16',
              nome: 'Desenvolvimento Máquina',
              grupo_muscular: 'Ombros',
              ordem: 3,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex17',
              nome: 'Rosca Martelo',
              grupo_muscular: 'Bíceps',
              ordem: 4,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex18',
              nome: 'Tríceps Mergulho',
              grupo_muscular: 'Tríceps',
              ordem: 5,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
          ],
        ),
      ],
    ),

    // TEMPLATE INTERMEDIÁRIO
    FichaTemplate(
      id: 'intermediario',
      nome: 'Ficha Intermediário - Push/Pull/Legs',
      descricao: '5x por semana, dividindo entre empurrar, puxar e pernas. Para quem já tem experiência.',
      nivel: 'intermediario',
      diasPorSemana: 5,
      diasTreino: [
        // PUSH A - Segunda
        DiaTreinoModel(
          id: 'push_a',
          nome: 'Push A - Peito, Ombro e Tríceps',
          descricao: 'Treino de empurrão focando em peito',
          diaSemana: 1,
          ordem: 0,
          exercicios: [
            ExercicioModel(
              id: 'ex19',
              nome: 'Supino Reto',
              grupo_muscular: 'Peito',
              ordem: 0,
              descanso: 120,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 8, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 8, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 8, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 8, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex20',
              nome: 'Supino Inclinado',
              grupo_muscular: 'Peito',
              ordem: 1,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex21',
              nome: 'Crucifixo Inclinado',
              grupo_muscular: 'Peito',
              ordem: 2,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex22',
              nome: 'Desenvolvimento com Halteres',
              grupo_muscular: 'Ombros',
              ordem: 3,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex23',
              nome: 'Elevação Lateral',
              grupo_muscular: 'Ombros',
              ordem: 4,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex24',
              nome: 'Tríceps Corda',
              grupo_muscular: 'Tríceps',
              ordem: 5,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex25',
              nome: 'Tríceps Testa',
              grupo_muscular: 'Tríceps',
              ordem: 6,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
          ],
        ),
        // PULL A - Terça
        DiaTreinoModel(
          id: 'pull_a',
          nome: 'Pull A - Costas e Bíceps',
          descricao: 'Treino de puxada focando em costas',
          diaSemana: 2,
          ordem: 1,
          exercicios: [
            ExercicioModel(
              id: 'ex26',
              nome: 'Barra Fixa',
              grupo_muscular: 'Costas',
              ordem: 0,
              descanso: 120,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 8, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 8, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 8, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 8, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex27',
              nome: 'Remada Curvada',
              grupo_muscular: 'Costas',
              ordem: 1,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex28',
              nome: 'Puxada Frontal',
              grupo_muscular: 'Costas',
              ordem: 2,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex29',
              nome: 'Remada Cavalinho',
              grupo_muscular: 'Costas',
              ordem: 3,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex30',
              nome: 'Rosca Direta',
              grupo_muscular: 'Bíceps',
              ordem: 4,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex31',
              nome: 'Rosca Martelo',
              grupo_muscular: 'Bíceps',
              ordem: 5,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
          ],
        ),
        // LEGS A - Quarta
        DiaTreinoModel(
          id: 'legs_a',
          nome: 'Legs A - Pernas Completo',
          descricao: 'Treino de pernas focando em posterior',
          diaSemana: 3,
          ordem: 2,
          exercicios: [
            ExercicioModel(
              id: 'ex32',
              nome: 'Agachamento Livre',
              grupo_muscular: 'Pernas',
              ordem: 0,
              descanso: 180,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 8, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 8, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 8, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 8, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex33',
              nome: 'Leg Press 45°',
              grupo_muscular: 'Pernas',
              ordem: 1,
              descanso: 120,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex34',
              nome: 'Stiff',
              grupo_muscular: 'Pernas',
              ordem: 2,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex35',
              nome: 'Cadeira Extensora',
              grupo_muscular: 'Pernas',
              ordem: 3,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex36',
              nome: 'Cadeira Flexora',
              grupo_muscular: 'Pernas',
              ordem: 4,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex37',
              nome: 'Panturrilha em Pé',
              grupo_muscular: 'Panturrilha',
              ordem: 5,
              descanso: 45,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 20, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 20, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 20, peso: 0),
              ],
            ),
          ],
        ),
        // PUSH B - Quinta
        DiaTreinoModel(
          id: 'push_b',
          nome: 'Push B - Peito, Ombro e Tríceps',
          descricao: 'Treino de empurrão focando em ombros',
          diaSemana: 4,
          ordem: 3,
          exercicios: [
            ExercicioModel(
              id: 'ex38',
              nome: 'Desenvolvimento Militar',
              grupo_muscular: 'Ombros',
              ordem: 0,
              descanso: 120,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 8, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 8, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 8, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 8, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex39',
              nome: 'Elevação Lateral',
              grupo_muscular: 'Ombros',
              ordem: 1,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex40',
              nome: 'Crucifixo Inverso',
              grupo_muscular: 'Ombros',
              ordem: 2,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex41',
              nome: 'Supino Reto',
              grupo_muscular: 'Peito',
              ordem: 3,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex42',
              nome: 'Crossover',
              grupo_muscular: 'Peito',
              ordem: 4,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex43',
              nome: 'Tríceps Francês',
              grupo_muscular: 'Tríceps',
              ordem: 5,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
          ],
        ),
        // PULL B - Sexta
        DiaTreinoModel(
          id: 'pull_b',
          nome: 'Pull B - Costas e Bíceps',
          descricao: 'Treino de puxada variado',
          diaSemana: 5,
          ordem: 4,
          exercicios: [
            ExercicioModel(
              id: 'ex44',
              nome: 'Levantamento Terra',
              grupo_muscular: 'Costas',
              ordem: 0,
              descanso: 180,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 6, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 6, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 6, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex45',
              nome: 'Puxada Triângulo',
              grupo_muscular: 'Costas',
              ordem: 1,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex46',
              nome: 'Remada Baixa',
              grupo_muscular: 'Costas',
              ordem: 2,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex47',
              nome: 'Encolhimento',
              grupo_muscular: 'Trapézio',
              ordem: 3,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex48',
              nome: 'Rosca 21',
              grupo_muscular: 'Bíceps',
              ordem: 4,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 21, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 21, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 21, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex49',
              nome: 'Rosca Concentrada',
              grupo_muscular: 'Bíceps',
              ordem: 5,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
          ],
        ),
      ],
    ),

    // TEMPLATE AVANÇADO
    FichaTemplate(
      id: 'avancado',
      nome: 'Ficha Avançado - Split Específico',
      descricao: '6x por semana, cada grupo muscular isolado. Para avançados com boa recuperação.',
      nivel: 'avancado',
      diasPorSemana: 6,
      diasTreino: [
        // PEITO - Segunda
        DiaTreinoModel(
          id: 'peito',
          nome: 'Peito',
          descricao: 'Treino focado em peito com alto volume',
          diaSemana: 1,
          ordem: 0,
          exercicios: [
            ExercicioModel(
              id: 'ex50',
              nome: 'Supino Reto',
              grupo_muscular: 'Peito',
              ordem: 0,
              descanso: 120,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 6, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 6, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 6, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 6, peso: 0),
                SerieModel(id: 's5', numeroSerie: 5, repeticoes: 6, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex51',
              nome: 'Supino Inclinado',
              grupo_muscular: 'Peito',
              ordem: 1,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 8, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 8, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 8, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 8, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex52',
              nome: 'Supino Declinado',
              grupo_muscular: 'Peito',
              ordem: 2,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex53',
              nome: 'Crucifixo Inclinado',
              grupo_muscular: 'Peito',
              ordem: 3,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex54',
              nome: 'Crossover',
              grupo_muscular: 'Peito',
              ordem: 4,
              descanso: 45,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 15, peso: 0),
              ],
            ),
          ],
        ),
        // COSTAS - Terça
        DiaTreinoModel(
          id: 'costas',
          nome: 'Costas',
          descricao: 'Treino focado em costas com alto volume',
          diaSemana: 2,
          ordem: 1,
          exercicios: [
            ExercicioModel(
              id: 'ex55',
              nome: 'Levantamento Terra',
              grupo_muscular: 'Costas',
              ordem: 0,
              descanso: 180,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 5, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 5, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 5, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 5, peso: 0),
                SerieModel(id: 's5', numeroSerie: 5, repeticoes: 5, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex56',
              nome: 'Barra Fixa',
              grupo_muscular: 'Costas',
              ordem: 1,
              descanso: 120,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 8, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 8, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 8, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 8, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex57',
              nome: 'Remada Curvada',
              grupo_muscular: 'Costas',
              ordem: 2,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 8, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 8, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 8, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 8, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex58',
              nome: 'Puxada Frontal',
              grupo_muscular: 'Costas',
              ordem: 3,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex59',
              nome: 'Remada Baixa',
              grupo_muscular: 'Costas',
              ordem: 4,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex60',
              nome: 'Pulldown Reto',
              grupo_muscular: 'Costas',
              ordem: 5,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
          ],
        ),
        // OMBROS - Quarta
        DiaTreinoModel(
          id: 'ombros',
          nome: 'Ombros e Trapézio',
          descricao: 'Treino focado em ombros com alto volume',
          diaSemana: 3,
          ordem: 2,
          exercicios: [
            ExercicioModel(
              id: 'ex61',
              nome: 'Desenvolvimento Militar',
              grupo_muscular: 'Ombros',
              ordem: 0,
              descanso: 120,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 8, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 8, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 8, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 8, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex62',
              nome: 'Desenvolvimento com Halteres',
              grupo_muscular: 'Ombros',
              ordem: 1,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex63',
              nome: 'Elevação Lateral',
              grupo_muscular: 'Ombros',
              ordem: 2,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex64',
              nome: 'Elevação Frontal',
              grupo_muscular: 'Ombros',
              ordem: 3,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex65',
              nome: 'Crucifixo Inverso',
              grupo_muscular: 'Ombros',
              ordem: 4,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex66',
              nome: 'Encolhimento',
              grupo_muscular: 'Trapézio',
              ordem: 5,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 15, peso: 0),
              ],
            ),
          ],
        ),
        // PERNAS - Quinta
        DiaTreinoModel(
          id: 'pernas',
          nome: 'Pernas Completo',
          descricao: 'Treino focado em pernas com alto volume',
          diaSemana: 4,
          ordem: 3,
          exercicios: [
            ExercicioModel(
              id: 'ex67',
              nome: 'Agachamento Livre',
              grupo_muscular: 'Pernas',
              ordem: 0,
              descanso: 180,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 6, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 6, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 6, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 6, peso: 0),
                SerieModel(id: 's5', numeroSerie: 5, repeticoes: 6, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex68',
              nome: 'Leg Press 45°',
              grupo_muscular: 'Pernas',
              ordem: 1,
              descanso: 120,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex69',
              nome: 'Stiff',
              grupo_muscular: 'Pernas',
              ordem: 2,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex70',
              nome: 'Cadeira Extensora',
              grupo_muscular: 'Pernas',
              ordem: 3,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex71',
              nome: 'Cadeira Flexora',
              grupo_muscular: 'Pernas',
              ordem: 4,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex72',
              nome: 'Panturrilha em Pé',
              grupo_muscular: 'Panturrilha',
              ordem: 5,
              descanso: 45,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 20, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 20, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 20, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 20, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex73',
              nome: 'Panturrilha Sentado',
              grupo_muscular: 'Panturrilha',
              ordem: 6,
              descanso: 45,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 20, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 20, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 20, peso: 0),
              ],
            ),
          ],
        ),
        // BÍCEPS E TRÍCEPS - Sexta
        DiaTreinoModel(
          id: 'biceps_triceps',
          nome: 'Bíceps e Tríceps',
          descricao: 'Treino focado em braços com alto volume',
          diaSemana: 5,
          ordem: 4,
          exercicios: [
            ExercicioModel(
              id: 'ex74',
              nome: 'Rosca Direta',
              grupo_muscular: 'Bíceps',
              ordem: 0,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 8, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 8, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 8, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 8, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex75',
              nome: 'Rosca Alternada',
              grupo_muscular: 'Bíceps',
              ordem: 1,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex76',
              nome: 'Rosca Martelo',
              grupo_muscular: 'Bíceps',
              ordem: 2,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex77',
              nome: 'Rosca Concentrada',
              grupo_muscular: 'Bíceps',
              ordem: 3,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex78',
              nome: 'Tríceps Corda',
              grupo_muscular: 'Tríceps',
              ordem: 4,
              descanso: 90,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 10, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 10, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 10, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 10, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex79',
              nome: 'Tríceps Testa',
              grupo_muscular: 'Tríceps',
              ordem: 5,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex80',
              nome: 'Tríceps Francês',
              grupo_muscular: 'Tríceps',
              ordem: 6,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 12, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 12, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 12, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex81',
              nome: 'Tríceps Coice',
              grupo_muscular: 'Tríceps',
              ordem: 7,
              descanso: 60,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
              ],
            ),
          ],
        ),
        // ABDÔMEN E CARDIO - Sábado
        DiaTreinoModel(
          id: 'abdomen_cardio',
          nome: 'Abdômen e Cardio',
          descricao: 'Treino focado em core e condicionamento',
          diaSemana: 6,
          ordem: 5,
          exercicios: [
            ExercicioModel(
              id: 'ex82',
              nome: 'Abdominal Supra',
              grupo_muscular: 'Abdômen',
              ordem: 0,
              descanso: 45,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 20, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 20, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 20, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 20, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex83',
              nome: 'Abdominal Infra',
              grupo_muscular: 'Abdômen',
              ordem: 1,
              descanso: 45,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 15, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 15, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 15, peso: 0),
                SerieModel(id: 's4', numeroSerie: 4, repeticoes: 15, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex84',
              nome: 'Prancha',
              grupo_muscular: 'Abdômen',
              ordem: 2,
              descanso: 60,
              observacao: 'Tempo em segundos',
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 60, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 60, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 60, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex85',
              nome: 'Abdominal Oblíquo',
              grupo_muscular: 'Abdômen',
              ordem: 3,
              descanso: 45,
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 20, peso: 0),
                SerieModel(id: 's2', numeroSerie: 2, repeticoes: 20, peso: 0),
                SerieModel(id: 's3', numeroSerie: 3, repeticoes: 20, peso: 0),
              ],
            ),
            ExercicioModel(
              id: 'ex86',
              nome: 'Esteira - Caminhada Inclinada',
              grupo_muscular: 'Cardio',
              ordem: 4,
              descanso: 0,
              observacao: 'Tempo em minutos',
              series: [
                SerieModel(id: 's1', numeroSerie: 1, repeticoes: 20, peso: 0),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

  static FichaTemplate? buscarPorId(String id) {
    try {
      return templates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<FichaTemplate> buscarPorNivel(String nivel) {
    return templates.where((template) => template.nivel == nivel).toList();
  }
}
