import { Controller, Get, Param, ParseIntPipe, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth, ApiParam } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { BadgesService } from './badges.service';
import { User } from '../users/entities/user.entity';

@ApiTags('Badges')
@Controller('badges')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class BadgesController {
  constructor(private readonly badgesService: BadgesService) {}

  @Get('me')
  @ApiOperation({ summary: 'Retorna todas as conquistas do professor logado' })
  @ApiResponse({ status: 200, description: 'Conquistas retornadas com sucesso' })
  async getMyBadges(@CurrentUser() user: User) {
    return this.badgesService.getMyBadges(user.id);
  }

  @Get('formation/:id')
  @ApiOperation({ summary: 'Retorna badges de uma formação específica' })
  @ApiParam({ name: 'id', description: 'ID da formação' })
  @ApiResponse({ status: 200, description: 'Badges da formação retornados com sucesso' })
  async getFormationBadges(
    @CurrentUser() user: User,
    @Param('id', ParseIntPipe) formationId: number,
  ) {
    return this.badgesService.getFormationBadges(user.id, formationId);
  }
}
