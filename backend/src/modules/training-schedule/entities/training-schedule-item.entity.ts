import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('training_schedule_items')
export class TrainingScheduleItem {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 200 })
  title: string;

  @Column({ length: 240, nullable: true })
  subtitle?: string;

  @Column({ length: 80, nullable: true })
  chapter?: string;

  @Column({ default: 0 })
  order: number;

  @Column({ name: 'document_id' })
  documentId: number;

  @Column({ name: 'document_url', length: 500 })
  documentUrl: string;

  @Column({ name: 'start_page', nullable: true })
  startPage?: number;

  @Column({ name: 'thumbnail_url', length: 500, nullable: true })
  thumbnailUrl?: string;

  @Column({ default: true })
  active: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
