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
import { PageReminder } from '../../page-reminders/entities/page-reminder.entity';

@Entity('lesson_plans')
export class LessonPlan {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 200 })
  title: string;

  @Column({ length: 80 })
  chapter: string;

  @Column({ length: 200 })
  theme: string;

  @Column({ name: 'week_number' })
  weekNumber: number;

  @Column({ name: 'lesson_number' })
  lessonNumber: number;

  @Column({ name: 'duration_minutes', default: 50 })
  durationMinutes: number;

  @Column({ name: 'general_objective', type: 'text' })
  generalObjective: string;

  @Column({ name: 'specific_objectives', type: 'jsonb', default: [] })
  specificObjectives: string[];

  @Column({ name: 'main_activity', type: 'text' })
  mainActivity: string;

  @Column({ type: 'text' })
  methodology: string;

  @Column({ name: 'required_resources', type: 'jsonb', default: [] })
  requiredResources: string[];

  @Column({ name: 'bncc_skills', type: 'jsonb', default: [] })
  bnccSkills: string[];

  @Column({ name: 'bncc_competencies', type: 'jsonb', default: [] })
  bnccCompetencies: string[];

  @Column({ name: 'teacher_guidance', type: 'text' })
  teacherGuidance: string;

  @Column({ type: 'text' })
  assessment: string;

  @Column({ name: 'complementary_materials', type: 'jsonb', default: [] })
  complementaryMaterials: string[];

  @Column({ name: 'attachment_url', length: 500, nullable: true })
  attachmentUrl?: string;

  @ManyToOne(() => PageReminder, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn({ name: 'reminder_id' })
  reminder?: PageReminder;

  @RelationId((lessonPlan: LessonPlan) => lessonPlan.reminder)
  reminderId?: number;

  @Column({ default: true })
  active: boolean;

  @Column({ default: 0 })
  order: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
