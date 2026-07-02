import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LessonPlansQueryDto } from './dto/lesson-plans-query.dto';
import { LessonPlan } from './entities/lesson-plan.entity';

@Injectable()
export class LessonPlansService {
  constructor(
    @InjectRepository(LessonPlan)
    private readonly lessonPlansRepository: Repository<LessonPlan>,
  ) {}

  async findAll(query: LessonPlansQueryDto) {
    const builder = this.lessonPlansRepository
      .createQueryBuilder('plan')
      .leftJoinAndSelect('plan.reminder', 'reminder')
      .where('plan.active = :active', { active: true });

    if (query.chapter) {
      builder.andWhere('plan.chapter = :chapter', { chapter: query.chapter });
    }

    if (query.week) {
      builder.andWhere('plan.week_number = :week', { week: query.week });
    }

    if (query.bnccSkill) {
      builder.andWhere('plan.bncc_skills @> :bnccSkill::jsonb', {
        bnccSkill: JSON.stringify([query.bnccSkill]),
      });
    }

    if (query.search) {
      builder.andWhere(
        '(LOWER(plan.title) LIKE :search OR LOWER(plan.theme) LIKE :search)',
        { search: `%${query.search.toLowerCase()}%` },
      );
    }

    const plans = await builder
      .orderBy('plan.order', 'ASC')
      .addOrderBy('plan.week_number', 'ASC')
      .addOrderBy('plan.lesson_number', 'ASC')
      .getMany();

    return { data: plans, message: 'Planos de aula retornados com sucesso' };
  }

  async findOne(id: number) {
    const plan = await this.lessonPlansRepository.findOne({
      where: { id, active: true },
      relations: ['reminder'],
    });

    if (!plan) {
      throw new NotFoundException('Plano de aula não encontrado');
    }

    return { data: plan, message: 'Plano de aula retornado com sucesso' };
  }
}
