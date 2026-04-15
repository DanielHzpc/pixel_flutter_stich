import 'package:flutter/material.dart';
import 'shared/customBottonNav.dart';
import 'shared/customTopBar.dart';

// ============================================================
//  MODELOS DE DATOS
//  Cuando integres las APIs, solo reemplaza los datos estáticos
//  de abajo por llamadas a tus repositorios/servicios.
// ============================================================

class WorkflowJob {
  final String title;
  final String jobId;
  final String sku;
  final String method;
  final int quantity;
  final String deadline;
  final String priority;
  final String status; // 'EN PRODUCCIÓN', 'ENVIADO', 'EN COLA', etc.
  final double progressPercent;
  final String progressLabel;
  final List<JobStep> steps;

  const WorkflowJob({
    required this.title,
    required this.jobId,
    required this.sku,
    required this.method,
    required this.quantity,
    required this.deadline,
    required this.priority,
    required this.status,
    required this.progressPercent,
    required this.progressLabel,
    required this.steps,
  });
}

class JobStep {
  final String name;
  final String time;
  final StepStatus status;

  const JobStep({
    required this.name,
    required this.time,
    required this.status,
  });
}

enum StepStatus { completed, inProgress, pending }

class MachineStatus {
  final String name;
  final String status; // 'EN LÍNEA', 'ENFRIANDO', 'ACTIVO'

  const MachineStatus({required this.name, required this.status});
}

class PendingOrder {
  final String title;
  final String badge; // 'SUBLIMACIÓN', 'TRANSFERENCIA DTF'
  final String lot;
  final String client;
  final int quantity;
  final String deadline;
  final String actionStatus; // 'ENVIADO', 'EN COLA'
  final String imageAsset; // TODO: reemplazar por URL de API

  const PendingOrder({
    required this.title,
    required this.badge,
    required this.lot,
    required this.client,
    required this.quantity,
    required this.deadline,
    required this.actionStatus,
    required this.imageAsset,
  });
}

// ============================================================
//  DATOS ESTÁTICOS (reemplazar por API calls en el futuro)
// ============================================================

const _activeJob = WorkflowJob(
  title: 'Bolso de\nAlgodón\nPremium',
  jobId: '#PX-88291',
  sku: 'SKU-CT-BLK-20',
  method: 'Transferencia\nDTF',
  quantity: 250,
  deadline: '24 Oct, 2023',
  priority: 'Alta',
  status: 'EN PRODUCCIÓN',
  progressPercent: 0.68,
  progressLabel: 'PROGRESO DEL PASO: FASE DE IMPRESIÓN',
  steps: [
    JobStep(
        name: 'Archivo Preparado',
        time: 'Ayer, 14:20',
        status: StepStatus.completed),
    JobStep(
        name: 'Control de Tinta',
        time: 'Hoy, 08:45',
        status: StepStatus.completed),
    JobStep(
        name: 'Aplicando Calor',
        time: 'En progreso...',
        status: StepStatus.inProgress),
  ],
);

final _machines = const [
  MachineStatus(name: 'DTF-Jet 5000', status: 'EN LÍNEA'),
  MachineStatus(name: 'Subli-Master X', status: 'ENFRIANDO'),
  MachineStatus(name: 'Hydra-Press v2', status: 'ACTIVO'),
];

final _pendingOrders = const [
  PendingOrder(
      title: 'Camiseta Sublimada Oversize',
      badge: 'SUBLIMACIÓN',
      lot: '#PX-88294',
      client: 'Art Collective Co.',
      quantity: 50,
      deadline: '26 Oct',
      actionStatus: 'ENVIADO',
      imageAsset:
          'https://media.istockphoto.com/id/1726263781/es/vector/plantilla-de-camiseta-negra-en-blanco.jpg?s=612x612&w=0&k=20&c=xzXCdDAsRlVZ3JeleziDE6wNVpZ9m4o2GDrXhhQQwPo='),
  PendingOrder(
      title: 'Sudadera Tech Midnight',
      badge: 'TRANSFERENCIA DTF',
      lot: '#PX-88295',
      client: 'Velocity Esports',
      quantity: 120,
      deadline: '28 Oct',
      actionStatus: 'EN COLA',
      imageAsset:
          'https://www.shutterstock.com/image-vector/gray-sportive-hoodies-copy-space-260nw-2514236121.jpg'),
];

// ============================================================
//  COLORES Y TEMA
// ============================================================

const _purple = Color(0xFF6B2FD9);
const _pink = Color(0xFFE91E8C);
const _green = Color(0xFF22C55E);
const _orange = Color(0xFFF97316);
const _bgGray = Color(0xFFF5F5F7);
const _cardWhite = Colors.white;
const _textDark = Color(0xFF111111);
const _textMid = Color(0xFF555555);
const _textLight = Color(0xFF999999);

// ============================================================
//  PANTALLA PRINCIPAL
// ============================================================

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  int _selectedTab = 0; // 0 = Todos, 1 = Prioridad
  int currentIndex = 2; // 0 = Pedidos, 1 = Pagos, 2 = Rastreo, 3 = Perfil

  // TODO: conectar con API de búsqueda
  final TextEditingController _searchController = TextEditingController();

  // TODO: conectar con API de filtros
  String _methodFilter = 'DTF';
  String _stateFilter = 'IMPRIMIENDO';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGray,
      body: SafeArea(
        child: Column(
          children: [
            CustomTopBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildTabBar(),
                    const SizedBox(height: 16), // espacio entre tabs y search
                    _buildSearchAndFilters(),
                    _buildActiveJobCard(),
                    _buildMachineStatus(),
                    _buildAnalytics(),
                    _buildPendingSection(),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
            CustomBottomNav(currentIndex: 2),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  //  HEADER
  //  FIX: sin Container con color blanco → hereda _bgGray del Scaffold
  // ----------------------------------------------------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COLA DE PRODUCCIÓN EN VIVO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _purple,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Flujos de Trabajo\nActivos',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: _textDark,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  //  TAB BAR
  //  FIX: sin Container con color blanco → hereda _bgGray
  // ----------------------------------------------------------
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          _tabButton('Todos los Trabajos', 0),
          const SizedBox(width: 8),
          _tabButton('Prioridad', 1),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final selected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? _textDark : _cardWhite,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: selected ? _textDark : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : _textMid,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  //  SEARCH + FILTROS
  //  FIX: hint/texto más grande (15px), chips más grandes (12px),
  //       fondo blanco con borde sutil en lugar de _bgGray
  // ----------------------------------------------------------
  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          // Barra de búsqueda
          Container(
            decoration: BoxDecoration(
              color: _cardWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 15, color: _textDark),
              decoration: InputDecoration(
                hintText: 'Buscar pedidos, SKU, o técnico...',
                hintStyle: TextStyle(color: _textLight, fontSize: 15),
                prefixIcon: Icon(Icons.search, color: _textLight, size: 22),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              // TODO: onChanged -> llamar API de búsqueda
            ),
          ),
          const SizedBox(height: 10),
          // Filtros
          Row(
            children: [
              _filterChip('MÉTODO: $_methodFilter', () {
                // TODO: abrir modal de filtro de método
              }),
              const SizedBox(width: 8),
              _filterChip('ESTADO: $_stateFilter', () {
                // TODO: abrir modal de filtro de estado
              }),
            ],
          ),
          const SizedBox(height: 8),
          // Línea indicador (decorativa)
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.35,
              child: Container(
                decoration: BoxDecoration(
                  color: _purple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _cardWhite,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _textMid,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: _textMid),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  //  TARJETA JOB ACTIVO
  // ----------------------------------------------------------
  Widget _buildActiveJobCard() {
    final job = _activeJob;
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(Icons.shopping_bag_outlined, color: _pink, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _textDark,
                              height: 1.2)),
                      const SizedBox(height: 4),
                      Text('ID Trabajo: ${job.jobId} • ${job.sku}',
                          style:
                              const TextStyle(fontSize: 11, color: _textLight)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _pink,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(job.status,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                _infoBox('MÉTODO', job.method),
                const SizedBox(width: 10),
                _infoBox('CANTIDAD', '${job.quantity} Unidades'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                _infoBox('FECHA LÍMITE', job.deadline),
                const SizedBox(width: 10),
                _infoBoxColored('PRIORIDAD', job.priority, _purple),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(job.progressLabel,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _textLight,
                        letterSpacing: 0.3)),
                Text('${(job.progressPercent * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _purple)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: job.progressPercent,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(_purple),
              ),
            ),
          ),
          ...job.steps.map((step) => _buildStep(step)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _infoBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _bgGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _textLight,
                    letterSpacing: 0.4)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textDark)),
          ],
        ),
      ),
    );
  }

  Widget _infoBoxColored(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _bgGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _textLight,
                    letterSpacing: 0.4)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: valueColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(JobStep step) {
    IconData icon;
    Color iconColor;

    switch (step.status) {
      case StepStatus.completed:
        icon = Icons.check_circle_rounded;
        iconColor = _purple;
        break;
      case StepStatus.inProgress:
        icon = Icons.sync_rounded;
        iconColor = Colors.orange;
        break;
      case StepStatus.pending:
        icon = Icons.radio_button_unchecked_rounded;
        iconColor = _textLight;
        break;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: step.status == StepStatus.inProgress
            ? Colors.orange.shade50.withOpacity(0.5)
            : _bgGray,
        borderRadius: BorderRadius.circular(10),
        border: step.status == StepStatus.inProgress
            ? Border.all(color: Colors.orange.shade200, width: 1)
            : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(step.name,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textDark)),
              Text(step.time,
                  style: const TextStyle(fontSize: 11, color: _textLight)),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  //  ESTADO DE LA MÁQUINA
  // ----------------------------------------------------------
  Widget _buildMachineStatus() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: _cardWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Icon(Icons.precision_manufacturing_rounded,
                    color: _purple, size: 20),
                const SizedBox(width: 8),
                const Text('Estado de la Máquina',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _textDark)),
              ],
            ),
          ),
          ..._machines.map((m) => _machineRow(m)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _machineRow(MachineStatus m) {
    Color dotColor;
    Color textColor;
    switch (m.status) {
      case 'EN LÍNEA':
        dotColor = _green;
        textColor = _green;
        break;
      case 'ENFRIANDO':
        dotColor = _orange;
        textColor = _orange;
        break;
      default:
        dotColor = _green;
        textColor = _green;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(m.name,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500, color: _textDark)),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(m.status,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: textColor)),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  //  ANALÍTICA DE PRODUCCIÓN
  // ----------------------------------------------------------
  Widget _buildAnalytics() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(30),
      width: 390,
      decoration: BoxDecoration(
        color: _purple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(Icons.bar_chart_rounded,
                size: 100, color: Colors.white.withOpacity(0.08)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Analítica de Producción',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(height: 6),
              Text('La eficiencia de salida aumentó un 12% hoy.',
                  style: TextStyle(
                      fontSize: 13, color: Colors.white.withOpacity(0.85))),
              const SizedBox(height: 16),
              const Text('1,240',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
              Text('TOTAL DE UNIDADES PROCESADAS',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 0.5)),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  //  PRODUCCIÓN PENDIENTE
  // ----------------------------------------------------------
  Widget _buildPendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Text('PRODUCCIÓN PENDIENTE',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _textMid,
                  letterSpacing: 0.6)),
        ),
        ..._pendingOrders.map((order) => _buildPendingCard(order)),
      ],
    );
  }

  Widget _buildPendingCard(PendingOrder order) {
    Color badgeBg;
    Color badgeText;
    if (order.badge == 'SUBLIMACIÓN') {
      badgeBg = _purple.withOpacity(0.12);
      badgeText = _purple;
    } else {
      badgeBg = Colors.blue.shade50;
      badgeText = Colors.blue.shade700;
    }

    bool isEnviado = order.actionStatus == 'ENVIADO';
    Color btnBg = isEnviado ? Colors.blue.shade700 : Colors.grey.shade200;
    Color btnText = isEnviado ? Colors.white : _textMid;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: _cardWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Container(
                height: 140,
                width: double.infinity,
                color: Colors.grey.shade200,
                // TODO: reemplazar con Image.network(order.imageUrl) desde API
                child: Image.network(
                  order.imageAsset,
                  fit: BoxFit.cover,
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _textDark)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(order.badge,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: badgeText,
                          letterSpacing: 0.4)),
                ),
                const SizedBox(height: 8),
                Text('Lote: ${order.lot} • Cliente: ${order.client}',
                    style: const TextStyle(fontSize: 11, color: _textLight)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('${order.quantity}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _textDark)),
                    const SizedBox(width: 6),
                    const Text('UNIDADES',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _textLight)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(order.deadline,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _textDark)),
                    const SizedBox(width: 6),
                    const Text('FECHA LÍMITE',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _textLight)),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: conectar con API de acción (enviar / poner en cola)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnBg,
                      foregroundColor: btnText,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(order.actionStatus,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Icon(Icons.more_horiz_rounded,
                      color: _textLight, size: 22),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
