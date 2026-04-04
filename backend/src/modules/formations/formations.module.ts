import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FormationsController } from './formations.controller';
import { FormationsService } from './formations.service';
import { Formation } from './entities/formation.entity';
import { FormationModule } from './entities/formation-module.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Formation, FormationModule])],
  controllers: [FormationsController],
  providers: [FormationsService],
  exports: [FormationsService],
})
export class FormationsModule {}
