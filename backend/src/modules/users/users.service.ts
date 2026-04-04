import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) {}

  async findById(id: number) {
    const user = await this.usersRepository.findOne({
      where: { id },
      relations: ['school'],
    });

    if (!user) {
      throw new NotFoundException('Usuário não encontrado');
    }

    const { senha_hash, ...result } = user;
    return { data: result, message: 'Perfil retornado com sucesso' };
  }

  async update(id: number, updateUserDto: UpdateUserDto) {
    await this.usersRepository.update(id, updateUserDto);
    return this.findById(id);
  }
}
