import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SyllabusSection } from './entities/syllabus-section.entity';

@Injectable()
export class SyllabusService {
  constructor(
    @InjectRepository(SyllabusSection)
    private readonly syllabusRepository: Repository<SyllabusSection>,
  ) {}

  async findAll() {
    const sections = await this.syllabusRepository.find({
      where: { active: true },
      order: { order: 'ASC' },
    });

    return { data: sections, message: 'Ementa retornada com sucesso' };
  }
}
