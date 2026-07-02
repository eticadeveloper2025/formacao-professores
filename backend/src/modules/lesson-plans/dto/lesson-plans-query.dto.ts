import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsInt, IsOptional, IsString, Min } from 'class-validator';

export class LessonPlansQueryDto {
  @ApiPropertyOptional({ example: '1', description: 'Capítulo do plano' })
  @IsOptional()
  @IsString()
  chapter?: string;

  @ApiPropertyOptional({ example: 2, description: 'Número da semana' })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  week?: number;

  @ApiPropertyOptional({ example: 'EF06ER09', description: 'Habilidade BNCC' })
  @IsOptional()
  @IsString()
  bnccSkill?: string;

  @ApiPropertyOptional({ example: 'relações', description: 'Busca por título ou tema' })
  @IsOptional()
  @IsString()
  search?: string;
}
