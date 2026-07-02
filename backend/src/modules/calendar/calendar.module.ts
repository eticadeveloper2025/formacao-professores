import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LessonPlan } from '../lesson-plans/entities/lesson-plan.entity';
import { PageReminder } from '../page-reminders/entities/page-reminder.entity';
import { CalendarController } from './calendar.controller';
import { CalendarService } from './calendar.service';
import { CalendarEntry } from './entities/calendar-entry.entity';

@Module({
  imports: [TypeOrmModule.forFeature([CalendarEntry, LessonPlan, PageReminder])],
  controllers: [CalendarController],
  providers: [CalendarService],
})
export class CalendarModule {}
