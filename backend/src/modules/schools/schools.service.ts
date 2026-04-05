import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { School } from './entities/school.entity';

@Injectable()
export class SchoolsService {
  constructor(
    @InjectRepository(School)
    private schoolsRepository: Repository<School>,
  ) {}

  async findAll() {
    const schools = await this.schoolsRepository.find({ order: { nome: 'ASC' } });
    return { data: schools, message: 'Escolas retornadas com sucesso' };
  }
}
