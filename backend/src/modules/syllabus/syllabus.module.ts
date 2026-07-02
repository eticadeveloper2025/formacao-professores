import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SyllabusSection } from './entities/syllabus-section.entity';
import { SyllabusController } from './syllabus.controller';
import { SyllabusService } from './syllabus.service';

@Module({
  imports: [TypeOrmModule.forFeature([SyllabusSection])],
  controllers: [SyllabusController],
  providers: [SyllabusService],
})
export class SyllabusModule {}
