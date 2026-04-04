import {
  Injectable,
  UnauthorizedException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from '../users/entities/user.entity';
import { AccessCode } from '../users/entities/access-code.entity';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
    @InjectRepository(AccessCode)
    private accessCodesRepository: Repository<AccessCode>,
    private jwtService: JwtService,
  ) {}

  async login(loginDto: LoginDto) {
    const user = await this.usersRepository.findOne({
      where: { email: loginDto.email },
      relations: ['school'],
    });

    if (!user) {
      throw new UnauthorizedException('Email ou senha inválidos');
    }

    const isPasswordValid = await bcrypt.compare(loginDto.senha, user.senha_hash);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Email ou senha inválidos');
    }

    const tokens = await this.generateTokens(user);

    return {
      data: {
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
        user: {
          id: user.id,
          nome: user.nome,
          email: user.email,
          nivel_acesso: user.nivel_acesso,
          avatar_url: user.avatar_url,
          school: user.school,
        },
      },
      message: 'Login realizado com sucesso',
    };
  }

  async register(registerDto: RegisterDto) {
    const existingUser = await this.usersRepository.findOne({
      where: { email: registerDto.email },
    });

    if (existingUser) {
      throw new ConflictException('Email já cadastrado');
    }

    const accessCode = await this.accessCodesRepository.findOne({
      where: { code: registerDto.codigoAcesso, used: false },
    });

    if (!accessCode) {
      throw new BadRequestException('Código de acesso inválido ou já utilizado');
    }

    const salt = await bcrypt.genSalt(10);
    const senha_hash = await bcrypt.hash(registerDto.senha, salt);

    const user = this.usersRepository.create({
      nome: registerDto.nome,
      email: registerDto.email,
      senha_hash,
      school: { id: registerDto.schoolId },
      nivel_acesso: registerDto.nivelAcesso,
      access_code: { id: accessCode.id },
    });

    await this.usersRepository.save(user);

    accessCode.used = true;
    accessCode.used_by = user.id;
    await this.accessCodesRepository.save(accessCode);

    const tokens = await this.generateTokens(user);

    return {
      data: {
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
        user: {
          id: user.id,
          nome: user.nome,
          email: user.email,
          nivel_acesso: user.nivel_acesso,
        },
      },
      message: 'Professor cadastrado com sucesso',
    };
  }

  async refreshToken(token: string) {
    try {
      const payload = this.jwtService.verify(token, {
        secret: process.env.JWT_SECRET,
      });

      const user = await this.usersRepository.findOne({
        where: { id: payload.sub },
      });

      if (!user) {
        throw new UnauthorizedException('Usuário não encontrado');
      }

      const tokens = await this.generateTokens(user);

      return {
        data: { accessToken: tokens.accessToken },
        message: 'Token renovado com sucesso',
      };
    } catch {
      throw new UnauthorizedException('Refresh token inválido');
    }
  }

  private async generateTokens(user: User) {
    const payload = { sub: user.id, email: user.email };

    const accessToken = this.jwtService.sign(payload);
    const refreshToken = this.jwtService.sign(payload, {
      expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
    });

    return { accessToken, refreshToken };
  }
}
