import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PageReminder } from '../page-reminders/entities/page-reminder.entity';
import { LessonPlan } from './entities/lesson-plan.entity';
import { LessonPlansController } from './lesson-plans.controller';
import { LessonPlansService } from './lesson-plans.service';

@Module({
  imports: [TypeOrmModule.forFeature([LessonPlan, PageReminder])],
  controllers: [LessonPlansController],
  providers: [LessonPlansService],
  exports: [LessonPlansService, TypeOrmModule],
})
export class LessonPlansModule {}
