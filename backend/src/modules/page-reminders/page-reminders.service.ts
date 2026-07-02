import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PageReminder } from './entities/page-reminder.entity';

@Injectable()
export class PageRemindersService {
  constructor(
    @InjectRepository(PageReminder)
    private readonly pageRemindersRepository: Repository<PageReminder>,
  ) {}

  async findAll() {
    const reminders = await this.pageRemindersRepository.find({
      where: { active: true },
      order: { order: 'ASC', title: 'ASC' },
    });

    return { data: reminders, message: 'Vídeos lembrete retornados com sucesso' };
  }

  async findByPageKey(pageKey: string) {
    const reminder = await this.pageRemindersRepository.findOne({
      where: { pageKey, active: true },
    });

    if (!reminder) {
      throw new NotFoundException('Vídeo lembrete não encontrado');
    }

    return { data: reminder, message: 'Vídeo lembrete retornado com sucesso' };
  }

  async findOne(id: number) {
    const reminder = await this.pageRemindersRepository.findOne({
      where: { id, active: true },
    });

    if (!reminder) {
      throw new NotFoundException('Vídeo lembrete não encontrado');
    }

    return { data: reminder, message: 'Vídeo lembrete retornado com sucesso' };
  }
}
