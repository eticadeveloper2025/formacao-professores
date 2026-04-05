import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, MinLength, IsNumber } from 'class-validator';

export class RegisterDto {
  @ApiProperty({ example: 'João Silva', description: 'Nome completo do professor' })
  @IsString()
  nome: string;

  @ApiProperty({ example: 'joao@escola.com', description: 'Email do professor' })
  @IsEmail({}, { message: 'Email inválido' })
  email: string;

  @ApiProperty({ example: 'teste123', description: 'Senha' })
  @IsString()
  @MinLength(6)
  senha: string;

  @ApiProperty({ example: 'ACCESS001', description: 'Código de acesso fornecido pela Ética Editora' })
  @IsString()
  codigoAcesso: string;

  @ApiProperty({ example: 1, description: 'ID da escola' })
  @IsNumber()
  schoolId: number;

  @ApiProperty({ example: 'professor', description: 'Nível de acesso: professor, coordenador, diretor' })
  @IsString()
  nivelAcesso: string;
}
