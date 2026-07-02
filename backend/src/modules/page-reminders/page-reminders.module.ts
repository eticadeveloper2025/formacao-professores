import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PageReminder } from './entities/page-reminder.entity';
import { PageRemindersController } from './page-reminders.controller';
import { PageRemindersService } from './page-reminders.service';

@Module({
  imports: [TypeOrmModule.forFeature([PageReminder])],
  controllers: [PageRemindersController],
  providers: [PageRemindersService],
  exports: [PageRemindersService, TypeOrmModule],
})
export class PageRemindersModule {}
