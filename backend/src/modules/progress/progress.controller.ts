import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  ParseIntPipe,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth, ApiParam } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { ProgressService } from './progress.service';
import { CreateProgressDto } from './dto/create-progress.dto';
import { User } from '../users/entities/user.entity';

@ApiTags('Progress')
@Controller('progress')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class ProgressController {
  constructor(private readonly progressService: ProgressService) {}

  @Get('me')
  @ApiOperation({ summary: 'Retorna progresso geral do professor logado' })
  @ApiResponse({ status: 200, description: 'Progresso retornado com sucesso' })
  async getMyProgress(@CurrentUser() user: User) {
    return this.progressService.getMyProgress(user.id);
  }

  @Post()
  @ApiOperation({ summary: 'Marca módulo como concluído' })
  @ApiResponse({ status: 201, description: 'Progresso registrado com sucesso' })
  async createProgress(
    @CurrentUser() user: User,
    @Body() createProgressDto: CreateProgressDto,
  ) {
    return this.progressService.markModuleCompleted(user.id, createProgressDto.moduleId);
  }

  @Get('formation/:id')
  @ApiOperation({ summary: 'Retorna progresso detalhado em uma formação' })
  @ApiParam({ name: 'id', description: 'ID da formação' })
  @ApiResponse({ status: 200, description: 'Progresso por formação retornado' })
  async getFormationProgress(
    @CurrentUser() user: User,
    @Param('id', ParseIntPipe) formationId: number,
  ) {
    return this.progressService.getFormationProgress(user.id, formationId);
  }
}
