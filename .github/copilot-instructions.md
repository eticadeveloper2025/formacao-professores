# GitHub Copilot Instructions — Formação para Professores

## Contexto do Projeto

App mobile de formação continuada para professores da Ética Editora.
Stack: Flutter 3.x + NestJS 10.x + PostgreSQL 15 + Riverpod + Dio + TypeORM

## Padrões Flutter

### ConsumerWidget (tela padrão)
```dart
class ExampleScreen extends ConsumerWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(exampleProvider);
    return Scaffold(
      body: dataAsync.when(
        data: (data) => Text(data.toString()),
        loading: () => const CircularProgressIndicator(color: AppTheme.orange),
        error: (e, _) => Text('Erro: $e', style: const TextStyle(color: AppTheme.error)),
      ),
    );
  }
}
```

### Provider (FutureProvider)
```dart
final exampleProvider = FutureProvider<List<Example>>((ref) async {
  return ref.watch(exampleServiceProvider).getAll();
});
```

### StateNotifier (estado com ações)
```dart
class ExampleNotifier extends StateNotifier<ExampleState> {
  ExampleNotifier(this._service) : super(ExampleState());
  final ExampleService _service;

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await _service.getAll();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final exampleNotifierProvider = StateNotifierProvider<ExampleNotifier, ExampleState>((ref) {
  return ExampleNotifier(ref.watch(exampleServiceProvider));
});
```

### Service
```dart
class ExampleService {
  final Dio _dio;
  ExampleService(this._dio);

  Future<List<Example>> getAll() async {
    final response = await _dio.get('/examples');
    final data = response.data['data'] as List;
    return data.map((e) => Example.fromJson(e)).toList();
  }
}

final exampleServiceProvider = Provider<ExampleService>((ref) {
  return ExampleService(ref.watch(dioClientProvider));
});
```

### Model
```dart
class Example {
  final int id;
  final String nome;

  Example({required this.id, required this.nome});

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      id: json['id'] as int,
      nome: json['nome'] as String,
    );
  }
}
```

## Padrões NestJS

### Controller
```typescript
@ApiTags('Examples')
@Controller('examples')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class ExamplesController {
  constructor(private readonly examplesService: ExamplesService) {}

  @Get()
  @ApiOperation({ summary: 'Lista todos os exemplos' })
  @ApiResponse({ status: 200, description: 'Lista retornada com sucesso' })
  async findAll(@CurrentUser() user: User) {
    return this.examplesService.findAll(user.id);
  }
}
```

### DTO
```typescript
export class CreateExampleDto {
  @ApiProperty({ example: 'Meu Exemplo', description: 'Nome do exemplo' })
  @IsString()
  nome: string;

  @ApiPropertyOptional({ example: 'Descrição', description: 'Descrição opcional' })
  @IsOptional()
  @IsString()
  descricao?: string;
}
```

### Service
```typescript
@Injectable()
export class ExamplesService {
  constructor(
    @InjectRepository(Example)
    private examplesRepository: Repository<Example>,
  ) {}

  async findAll(userId: number) {
    const examples = await this.examplesRepository.find({
      where: { user: { id: userId } },
    });
    return { data: examples, message: 'Exemplos retornados com sucesso' };
  }
}
```

### Entity
```typescript
@Entity('examples')
export class Example {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 200 })
  nome: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;
}
```

## Regras para Geração de Código

1. **NUNCA** expor `senha_hash` nas respostas
2. **SEMPRE** usar a paleta de cores definida em `AppTheme`
3. **SEMPRE** adicionar `@ApiTags`, `@ApiOperation`, `@ApiResponse` em controllers
4. **SEMPRE** proteger rotas com `@UseGuards(JwtAuthGuard)` (exceto auth e schools)
5. **NUNCA** usar `any` no TypeScript
6. **SEMPRE** usar `ref.watch()` no build, `ref.read()` nos handlers
7. **SEMPRE** tratar loading e error states no Flutter
8. **SEMPRE** usar `ON CONFLICT DO NOTHING` em seed data SQL
