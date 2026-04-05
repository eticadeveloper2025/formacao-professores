import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Formation } from '../../formations/entities/formation.entity';

@Entity('badges')
export class Badge {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Formation, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'formation_id' })
  formation: Formation;

  @Column({ length: 200 })
  nome: string;

  @Column({ type: 'text', nullable: true })
  descricao: string;

  @Column({ nullable: true })
  imagem_url: string;

  @Column({ type: 'int', default: 100 })
  criterio_percentual: number;

  @CreateDateColumn()
  created_at: Date;
}
