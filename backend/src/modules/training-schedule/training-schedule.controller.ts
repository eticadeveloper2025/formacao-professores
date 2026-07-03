import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { TrainingScheduleService } from './training-schedule.service';

@ApiTags('Training Schedule')
@Controller('training-schedule')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class TrainingScheduleController {
  constructor(
    private readonly trainingScheduleService: TrainingScheduleService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Lista o cronograma formativo ativo' })
  @ApiResponse({
    status: 200,
    description: 'Cronograma formativo retornado com sucesso',
  })
  async findAll() {
    return this.trainingScheduleService.findAll();
  }
}
