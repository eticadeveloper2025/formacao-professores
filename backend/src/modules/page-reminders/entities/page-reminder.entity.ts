import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('page_reminders')
export class PageReminder {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'page_key', length: 100, unique: true })
  pageKey: string;

  @Column({ length: 200 })
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ name: 'media_url', length: 500 })
  mediaUrl: string;

  @Column({ name: 'thumbnail_url', length: 500, nullable: true })
  thumbnailUrl?: string;

  @Column({ type: 'text' })
  transcript: string;

  @Column({ name: 'duration_seconds', default: 0 })
  durationSeconds: number;

  @Column({ default: true })
  active: boolean;

  @Column({ default: 0 })
  order: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
