import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { SchoolsService } from './schools.service';

@ApiTags('Schools')
@Controller('schools')
export class SchoolsController {
  constructor(private readonly schoolsService: SchoolsService) {}

  @Get()
  @ApiOperation({ summary: 'Lista todas as escolas' })
  @ApiResponse({ status: 200, description: 'Lista de escolas retornada com sucesso' })
  async findAll() {
    return this.schoolsService.findAll();
  }
}
