import { Controller, Get, Param, ParseIntPipe, Query, UseGuards } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CalendarService } from './calendar.service';
import { CalendarQueryDto } from './dto/calendar-query.dto';

@ApiTags('Calendar')
@Controller('calendar')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class CalendarController {
  constructor(private readonly calendarService: CalendarService) {}

  @Get()
  @ApiOperation({ summary: 'Lista entradas do calendário pedagógico com filtros' })
  @ApiResponse({ status: 200, description: 'Calendário retornado com sucesso' })
  async findAll(@Query() query: CalendarQueryDto) {
    return this.calendarService.findAll(query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Retorna detalhes de uma entrada do calendário' })
  @ApiParam({ name: 'id', description: 'ID da entrada do calendário' })
  @ApiResponse({ status: 200, description: 'Entrada do calendário retornada com sucesso' })
  @ApiResponse({ status: 404, description: 'Entrada do calendário não encontrada' })
  async findOne(@Param('id', ParseIntPipe) id: number) {
    return this.calendarService.findOne(id);
  }
}
