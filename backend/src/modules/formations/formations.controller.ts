import { Controller, Get, Param, ParseIntPipe, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth, ApiParam } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { FormationsService } from './formations.service';

@ApiTags('Formations')
@Controller('formations')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class FormationsController {
  constructor(private readonly formationsService: FormationsService) {}

  @Get()
  @ApiOperation({ summary: 'Lista todas as formações ativas' })
  @ApiResponse({ status: 200, description: 'Lista de formações retornada' })
  async findAll() {
    return this.formationsService.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Retorna detalhes de uma formação' })
  @ApiParam({ name: 'id', description: 'ID da formação' })
  @ApiResponse({ status: 200, description: 'Formação retornada com sucesso' })
  @ApiResponse({ status: 404, description: 'Formação não encontrada' })
  async findOne(@Param('id', ParseIntPipe) id: number) {
    return this.formationsService.findOne(id);
  }

  @Get(':id/modules')
  @ApiOperation({ summary: 'Lista módulos de uma formação' })
  @ApiParam({ name: 'id', description: 'ID da formação' })
  @ApiResponse({ status: 200, description: 'Módulos retornados com sucesso' })
  async findModules(@Param('id', ParseIntPipe) id: number) {
    return this.formationsService.findModules(id);
  }
}
