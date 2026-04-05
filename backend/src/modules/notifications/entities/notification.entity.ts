import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Formation } from '../../formations/entities/formation.entity';

@Entity('notifications')
export class Notification {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Formation, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn({ name: 'formation_id' })
  formation: Formation;

  @Column({ length: 200 })
  titulo: string;

  @Column({ type: 'text' })
  mensagem: string;

  @Column({ default: false })
  lida: boolean;

  @CreateDateColumn()
  created_at: Date;
}
