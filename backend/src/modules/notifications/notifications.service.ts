import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notification } from './entities/notification.entity';

@Injectable()
export class NotificationsService {
  constructor(
    @InjectRepository(Notification)
    private notificationsRepository: Repository<Notification>,
  ) {}

  async getMyNotifications(userId: number) {
    const notifications = await this.notificationsRepository.find({
      where: { user: { id: userId } },
      relations: ['formation'],
      order: { created_at: 'DESC' },
    });
    return { data: notifications, message: 'Notificações retornadas com sucesso' };
  }

  async markAsRead(userId: number, notificationId: number) {
    const notification = await this.notificationsRepository.findOne({
      where: { id: notificationId },
      relations: ['user'],
    });

    if (!notification) {
      throw new NotFoundException('Notificação não encontrada');
    }

    if (notification.user.id !== userId) {
      throw new ForbiddenException('Sem permissão para acessar esta notificação');
    }

    notification.lida = true;
    await this.notificationsRepository.save(notification);

    return { data: notification, message: 'Notificação marcada como lida' };
  }
}
