import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsOptional, IsNumber, IsBoolean } from 'class-validator';

export class CreateFormationDto {
  @ApiProperty({ example: 'Paz nas Escolas' })
  @IsString()
  nome: string;

  @ApiPropertyOptional({ example: 'Formação sobre cultura de paz nas escolas' })
  @IsOptional()
  @IsString()
  descricao?: string;

  @ApiPropertyOptional({ example: 'https://...' })
  @IsOptional()
  @IsString()
  thumb_url?: string;

  @ApiPropertyOptional({ example: 1 })
  @IsOptional()
  @IsNumber()
  ordem?: number;
}
