import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsNumber, IsOptional } from 'class-validator';

export class CreateNotificationDto {
  @ApiProperty({ example: 1, description: 'ID do usuário' })
  @IsNumber()
  userId: number;

  @ApiPropertyOptional({ example: 1, description: 'ID da formação' })
  @IsOptional()
  @IsNumber()
  formationId?: number;

  @ApiProperty({ example: 'Nova formação disponível!' })
  @IsString()
  titulo: string;

  @ApiProperty({ example: 'A formação Paz nas Escolas está disponível para você.' })
  @IsString()
  mensagem: string;
}
