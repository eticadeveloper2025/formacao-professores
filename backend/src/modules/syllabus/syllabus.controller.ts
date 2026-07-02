import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { SyllabusService } from './syllabus.service';

@ApiTags('Syllabus')
@Controller('syllabus')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class SyllabusController {
  constructor(private readonly syllabusService: SyllabusService) {}

  @Get()
  @ApiOperation({ summary: 'Retorna as seções ativas da ementa do projeto' })
  @ApiResponse({ status: 200, description: 'Ementa retornada com sucesso' })
  async findAll() {
    return this.syllabusService.findAll();
  }
}
