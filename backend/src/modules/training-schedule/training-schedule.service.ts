import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TrainingScheduleItem } from './entities/training-schedule-item.entity';

@Injectable()
export class TrainingScheduleService {
  constructor(
    @InjectRepository(TrainingScheduleItem)
    private readonly scheduleRepository: Repository<TrainingScheduleItem>,
  ) {}

  async findAll() {
    const items = await this.scheduleRepository.find({
      where: { active: true },
      order: { order: 'ASC' },
    });

    return {
      data: items,
      message: 'Cronograma formativo retornado com sucesso',
    };
  }
}
