import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { SchoolsModule } from './modules/schools/schools.module';
import { FormationsModule } from './modules/formations/formations.module';
import { ProgressModule } from './modules/progress/progress.module';
import { BadgesModule } from './modules/badges/badges.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { SyllabusModule } from './modules/syllabus/syllabus.module';
import { CalendarModule } from './modules/calendar/calendar.module';
import { LessonPlansModule } from './modules/lesson-plans/lesson-plans.module';
import { PageRemindersModule } from './modules/page-reminders/page-reminders.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        url: configService.get('DATABASE_URL'),
        autoLoadEntities: true,
        synchronize: false,
        ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
      }),
      inject: [ConfigService],
    }),
    AuthModule,
    UsersModule,
    SchoolsModule,
    FormationsModule,
    ProgressModule,
    BadgesModule,
    NotificationsModule,
    SyllabusModule,
    CalendarModule,
    LessonPlansModule,
    PageRemindersModule,
  ],
})
export class AppModule {}
