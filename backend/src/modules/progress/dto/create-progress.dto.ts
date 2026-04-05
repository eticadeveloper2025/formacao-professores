import { ApiProperty } from '@nestjs/swagger';
import { IsNumber } from 'class-validator';

export class CreateProgressDto {
  @ApiProperty({ example: 1, description: 'ID do módulo a ser marcado como concluído' })
  @IsNumber()
  moduleId: number;
}
