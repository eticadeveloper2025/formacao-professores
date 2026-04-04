import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { School } from '../../schools/entities/school.entity';

@Entity('access_codes')
export class AccessCode {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true, length: 50 })
  code: string;

  @ManyToOne(() => School, { nullable: true })
  @JoinColumn({ name: 'school_id' })
  school: School;

  @Column({ length: 50, default: 'professor' })
  nivel_acesso: string;

  @Column({ default: false })
  used: boolean;

  @Column({ nullable: true })
  used_by: number;

  @CreateDateColumn()
  created_at: Date;
}
