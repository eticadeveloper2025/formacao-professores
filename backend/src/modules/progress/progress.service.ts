import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserProgress } from './entities/user-progress.entity';
import { FormationModule } from '../formations/entities/formation-module.entity';
import { Formation } from '../formations/entities/formation.entity';
import { BadgesService } from '../badges/badges.service';

@Injectable()
export class ProgressService {
  constructor(
    @InjectRepository(UserProgress)
    private progressRepository: Repository<UserProgress>,
    @InjectRepository(FormationModule)
    private modulesRepository: Repository<FormationModule>,
    @InjectRepository(Formation)
    private formationsRepository: Repository<Formation>,
    private badgesService: BadgesService,
  ) {}

  async getMyProgress(userId: number) {
    const formations = await this.formationsRepository.find({
      where: { ativo: true },
      order: { ordem: 'ASC' },
    });

    const progressData = await Promise.all(
      formations.map(async (formation) => {
        const totalModules = await this.modulesRepository.count({
          where: { formation: { id: formation.id } },
        });

        const completedModules = await this.progressRepository.count({
          where: {
            user: { id: userId },
            module: { formation: { id: formation.id } },
            completed: true,
          },
        });

        const percentual = totalModules > 0 ? Math.round((completedModules / totalModules) * 100) : 0;

        return {
          formation_id: formation.id,
          formation_nome: formation.nome,
          thumb_url: formation.thumb_url,
          total_modulos: totalModules,
          modulos_concluidos: completedModules,
          percentual,
        };
      }),
    );

    return { data: progressData, message: 'Progresso retornado com sucesso' };
  }

  async markModuleCompleted(userId: number, moduleId: number) {
    let progress = await this.progressRepository.findOne({
      where: { user: { id: userId }, module: { id: moduleId } },
    });

    if (!progress) {
      progress = this.progressRepository.create({
        user: { id: userId },
        module: { id: moduleId },
        completed: true,
        completed_at: new Date(),
      });
    } else {
      progress.completed = true;
      progress.completed_at = new Date();
    }

    await this.progressRepository.save(progress);

    // Check and award badges
    const module = await this.modulesRepository.findOne({
      where: { id: moduleId },
      relations: ['formation'],
    });

    if (module) {
      await this.badgesService.checkAndAwardBadges(userId, module.formation.id);
    }

    return { data: progress, message: 'Módulo marcado como concluído' };
  }

  async getFormationProgress(userId: number, formationId: number) {
    const modules = await this.modulesRepository.find({
      where: { formation: { id: formationId } },
      order: { ordem: 'ASC' },
    });

    const progressData = await Promise.all(
      modules.map(async (module) => {
        const progress = await this.progressRepository.findOne({
          where: { user: { id: userId }, module: { id: module.id } },
        });

        return {
          module_id: module.id,
          titulo: module.titulo,
          video_url: module.video_url,
          ordem: module.ordem,
          completed: progress?.completed || false,
          completed_at: progress?.completed_at || null,
        };
      }),
    );

    const completedCount = progressData.filter((p) => p.completed).length;
    const percentual = modules.length > 0 ? Math.round((completedCount / modules.length) * 100) : 0;

    return {
      data: {
        formation_id: formationId,
        modulos: progressData,
        percentual,
        total: modules.length,
        concluidos: completedCount,
      },
      message: 'Progresso da formação retornado com sucesso',
    };
  }
}
