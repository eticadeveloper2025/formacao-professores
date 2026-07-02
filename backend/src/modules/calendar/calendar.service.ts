import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CalendarQueryDto } from './dto/calendar-query.dto';
import { CalendarEntry } from './entities/calendar-entry.entity';

@Injectable()
export class CalendarService {
  constructor(
    @InjectRepository(CalendarEntry)
    private readonly calendarRepository: Repository<CalendarEntry>,
  ) {}

  async findAll(query: CalendarQueryDto) {
    const builder = this.calendarRepository
      .createQueryBuilder('entry')
      .leftJoinAndSelect('entry.lessonPlan', 'lessonPlan')
      .leftJoinAndSelect('entry.reminder', 'reminder')
      .where('entry.active = :active', { active: true });

    if (query.startDate) {
      builder.andWhere('entry.date >= :startDate', { startDate: query.startDate });
    }

    if (query.endDate) {
      builder.andWhere('entry.date <= :endDate', { endDate: query.endDate });
    }

    if (query.month) {
      builder.andWhere('EXTRACT(MONTH FROM entry.date) = :month', { month: query.month });
    }

    if (query.year) {
      builder.andWhere('EXTRACT(YEAR FROM entry.date) = :year', { year: query.year });
    }

    if (query.type) {
      builder.andWhere('entry.activity_type = :type', { type: query.type });
    }

    if (query.week) {
      builder.andWhere('entry.week_number = :week', { week: query.week });
    }

    if (query.chapter) {
      builder.andWhere('entry.chapter = :chapter', { chapter: query.chapter });
    }

    if (query.search) {
      builder.andWhere(
        '(LOWER(entry.theme) LIKE :search OR LOWER(entry.activity) LIKE :search)',
        { search: `%${query.search.toLowerCase()}%` },
      );
    }

    const entries = await builder
      .orderBy('entry.date', 'ASC')
      .addOrderBy('entry.lesson_number', 'ASC')
      .getMany();

    return { data: entries, message: 'Calendário retornado com sucesso' };
  }

  async findOne(id: number) {
    const entry = await this.calendarRepository.findOne({
      where: { id, active: true },
      relations: ['lessonPlan', 'reminder'],
    });

    if (!entry) {
      throw new NotFoundException('Entrada do calendário não encontrada');
    }

    return { data: entry, message: 'Entrada do calendário retornada com sucesso' };
  }
}
