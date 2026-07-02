import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  RelationId,
} from 'typeorm';
import { LessonPlan } from '../../lesson-plans/entities/lesson-plan.entity';
import { PageReminder } from '../../page-reminders/entities/page-reminder.entity';

@Entity('calendar_entries')
export class CalendarEntry {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'date' })
  date: string;

  @Column({ name: 'week_number' })
  weekNumber: number;

  @Column({ name: 'lesson_number' })
  lessonNumber: number;

  @Column({ length: 80 })
  chapter: string;

  @Column({ length: 200 })
  theme: string;

  @Column({ type: 'text' })
  objective: string;

  @Column({ type: 'text' })
  activity: string;

  @Column({ name: 'activity_type', length: 80 })
  activityType: string;

  @Column({ name: 'bncc_skills', type: 'jsonb', default: [] })
  bnccSkills: string[];

  @Column({ name: 'bncc_competency', type: 'text' })
  bnccCompetency: string;

  @Column({ length: 80, default: 'planejado' })
  status: string;

  @Column({ name: 'complementary_material', length: 500, nullable: true })
  complementaryMaterial?: string;

  @Column({ name: 'video_url', length: 500, nullable: true })
  videoUrl?: string;

  @ManyToOne(() => LessonPlan, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn({ name: 'lesson_plan_id' })
  lessonPlan?: LessonPlan;

  @RelationId((entry: CalendarEntry) => entry.lessonPlan)
  lessonPlanId?: number;

  @ManyToOne(() => PageReminder, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn({ name: 'reminder_id' })
  reminder?: PageReminder;

  @RelationId((entry: CalendarEntry) => entry.reminder)
  reminderId?: number;

  @Column({ default: true })
  active: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
