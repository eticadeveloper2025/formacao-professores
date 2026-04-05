import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { School } from '../../schools/entities/school.entity';
import { AccessCode } from './access-code.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 200 })
  nome: string;

  @Column({ unique: true, length: 200 })
  email: string;

  @Column()
  senha_hash: string;

  @ManyToOne(() => School, { nullable: true })
  @JoinColumn({ name: 'school_id' })
  school: School;

  @Column({ length: 50, default: 'professor' })
  nivel_acesso: string;

  @ManyToOne(() => AccessCode, { nullable: true })
  @JoinColumn({ name: 'access_code_id' })
  access_code: AccessCode;

  @Column({ nullable: true })
  avatar_url: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;
}
