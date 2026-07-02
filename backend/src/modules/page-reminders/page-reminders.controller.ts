import { Controller, Get, Param, ParseIntPipe, UseGuards } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { PageRemindersService } from './page-reminders.service';

@ApiTags('Page Reminders')
@Controller('page-reminders')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class PageRemindersController {
  constructor(private readonly pageRemindersService: PageRemindersService) {}

  @Get()
  @ApiOperation({ summary: 'Lista todos os vídeos lembrete ativos' })
  @ApiResponse({ status: 200, description: 'Vídeos lembrete retornados com sucesso' })
  async findAll() {
    return this.pageRemindersService.findAll();
  }

  @Get('page/:pageKey')
  @ApiOperation({ summary: 'Retorna vídeo lembrete por chave de página' })
  @ApiParam({ name: 'pageKey', description: 'Chave da página' })
  @ApiResponse({ status: 200, description: 'Vídeo lembrete retornado com sucesso' })
  @ApiResponse({ status: 404, description: 'Vídeo lembrete não encontrado' })
  async findByPageKey(@Param('pageKey') pageKey: string) {
    return this.pageRemindersService.findByPageKey(pageKey);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Retorna detalhes de um vídeo lembrete' })
  @ApiParam({ name: 'id', description: 'ID do vídeo lembrete' })
  @ApiResponse({ status: 200, description: 'Vídeo lembrete retornado com sucesso' })
  @ApiResponse({ status: 404, description: 'Vídeo lembrete não encontrado' })
  async findOne(@Param('id', ParseIntPipe) id: number) {
    return this.pageRemindersService.findOne(id);
  }
}
