import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Formation } from './entities/formation.entity';
import { FormationModule } from './entities/formation-module.entity';

@Injectable()
export class FormationsService {
  constructor(
    @InjectRepository(Formation)
    private formationsRepository: Repository<Formation>,
    @InjectRepository(FormationModule)
    private modulesRepository: Repository<FormationModule>,
  ) {}

  async findAll() {
    const formations = await this.formationsRepository.find({
      where: { ativo: true },
      order: { ordem: 'ASC' },
    });
    return { data: formations, message: 'Formações retornadas com sucesso' };
  }

  async findOne(id: number) {
    const formation = await this.formationsRepository.findOne({
      where: { id },
      relations: ['modules'],
    });

    if (!formation) {
      throw new NotFoundException('Formação não encontrada');
    }

    return { data: formation, message: 'Formação retornada com sucesso' };
  }

  async findModules(formationId: number) {
    const modules = await this.modulesRepository.find({
      where: { formation: { id: formationId } },
      order: { ordem: 'ASC' },
    });
    return { data: modules, message: 'Módulos retornados com sucesso' };
  }
}
