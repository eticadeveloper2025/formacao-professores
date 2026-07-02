import { Controller, Get, Param, ParseIntPipe, Query, UseGuards } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { LessonPlansQueryDto } from './dto/lesson-plans-query.dto';
import { LessonPlansService } from './lesson-plans.service';

@ApiTags('Lesson Plans')
@Controller('lesson-plans')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class LessonPlansController {
  constructor(private readonly lessonPlansService: LessonPlansService) {}

  @Get()
  @ApiOperation({ summary: 'Lista planos de aula ativos com filtros opcionais' })
  @ApiResponse({ status: 200, description: 'Planos de aula retornados com sucesso' })
  async findAll(@Query() query: LessonPlansQueryDto) {
    return this.lessonPlansService.findAll(query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Retorna detalhes de um plano de aula' })
  @ApiParam({ name: 'id', description: 'ID do plano de aula' })
  @ApiResponse({ status: 200, description: 'Plano de aula retornado com sucesso' })
  @ApiResponse({ status: 404, description: 'Plano de aula não encontrado' })
  async findOne(@Param('id', ParseIntPipe) id: number) {
    return this.lessonPlansService.findOne(id);
  }
}
