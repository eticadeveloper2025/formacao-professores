import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Badge } from './entities/badge.entity';
import { UserBadge } from './entities/user-badge.entity';
import { FormationModule } from '../formations/entities/formation-module.entity';
import { UserProgress } from '../progress/entities/user-progress.entity';

@Injectable()
export class BadgesService {
  constructor(
    @InjectRepository(Badge)
    private badgesRepository: Repository<Badge>,
    @InjectRepository(UserBadge)
    private userBadgesRepository: Repository<UserBadge>,
    @InjectRepository(FormationModule)
    private modulesRepository: Repository<FormationModule>,
    @InjectRepository(UserProgress)
    private progressRepository: Repository<UserProgress>,
  ) {}

  async getMyBadges(userId: number) {
    const badges = await this.badgesRepository.find({
      relations: ['formation'],
      order: { formation: { ordem: 'ASC' } },
    });

    const userBadges = await this.userBadgesRepository.find({
      where: { user: { id: userId } },
      relations: ['badge'],
    });

    const earnedBadgeIds = userBadges.map((ub) => ub.badge.id);

    const result = badges.map((badge) => ({
      ...badge,
      conquistado: earnedBadgeIds.includes(badge.id),
      conquistado_em: userBadges.find((ub) => ub.badge.id === badge.id)?.conquistado_em || null,
    }));

    return { data: result, message: 'Conquistas retornadas com sucesso' };
  }

  async getFormationBadges(userId: number, formationId: number) {
    const badges = await this.badgesRepository.find({
      where: { formation: { id: formationId } },
      relations: ['formation'],
    });

    const userBadges = await this.userBadgesRepository.find({
      where: { user: { id: userId } },
      relations: ['badge'],
    });

    const earnedBadgeIds = userBadges.map((ub) => ub.badge.id);

    const result = badges.map((badge) => ({
      ...badge,
      conquistado: earnedBadgeIds.includes(badge.id),
      conquistado_em: userBadges.find((ub) => ub.badge.id === badge.id)?.conquistado_em || null,
    }));

    return { data: result, message: 'Badges da formação retornados com sucesso' };
  }

  async checkAndAwardBadges(userId: number, formationId: number) {
    const totalModules = await this.modulesRepository.count({
      where: { formation: { id: formationId } },
    });

    const completedModules = await this.progressRepository.count({
      where: {
        user: { id: userId },
        module: { formation: { id: formationId } },
        completed: true,
      },
    });

    const percentual = totalModules > 0 ? Math.round((completedModules / totalModules) * 100) : 0;

    const badges = await this.badgesRepository.find({
      where: { formation: { id: formationId } },
    });

    for (const badge of badges) {
      if (percentual >= badge.criterio_percentual) {
        const exists = await this.userBadgesRepository.findOne({
          where: { user: { id: userId }, badge: { id: badge.id } },
        });

        if (!exists) {
          const userBadge = this.userBadgesRepository.create({
            user: { id: userId },
            badge: { id: badge.id },
          });
          await this.userBadgesRepository.save(userBadge);
        }
      }
    }
  }
}
