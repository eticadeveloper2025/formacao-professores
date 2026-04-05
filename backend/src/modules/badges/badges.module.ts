import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BadgesController } from './badges.controller';
import { BadgesService } from './badges.service';
import { Badge } from './entities/badge.entity';
import { UserBadge } from './entities/user-badge.entity';
import { FormationModule } from '../formations/entities/formation-module.entity';
import { UserProgress } from '../progress/entities/user-progress.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Badge, UserBadge, FormationModule, UserProgress])],
  controllers: [BadgesController],
  providers: [BadgesService],
  exports: [BadgesService],
})
export class BadgesModule {}
