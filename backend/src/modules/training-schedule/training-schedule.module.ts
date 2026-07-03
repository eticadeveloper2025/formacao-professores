import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TrainingScheduleItem } from './entities/training-schedule-item.entity';
import { TrainingScheduleController } from './training-schedule.controller';
import { TrainingScheduleService } from './training-schedule.service';

@Module({
  imports: [TypeOrmModule.forFeature([TrainingScheduleItem])],
  controllers: [TrainingScheduleController],
  providers: [TrainingScheduleService],
})
export class TrainingScheduleModule {}
