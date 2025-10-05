# Energy and Performance-Aware Task Scheduling in Mobile Cloud Computing

An implementation of the theoretical framework presented in:
**"Energy and Performance-Aware Task Scheduling in a Mobile Cloud Computing Environment"**
[📄 IEEE Xplore](https://ieeexplore.ieee.org/document/6973741)

This implementation addresses the fundamental challenge in Mobile Cloud Computing (MCC) environments: how to schedule task graphs across heterogeneous local cores and cloud resources while jointly optimizing two competing objectives:

- **Energy Efficiency**: Minimize mobile device energy consumption
- **Performance**: Meet application completion time deadlines (hard deadline constraints)

The algorithm implements a two-phase approach:
1. **Initial Scheduling**: Generate a minimal-delay schedule using priority-based task assignment
2. **Energy Optimization**: Iteratively migrate tasks to reduce energy while respecting deadline constraints (T_max = 1.5 × initial completion time)

**Keywords**: Mobile Cloud Computing (MCC), Energy Minimization, Task Scheduling, Mobile Handsets, Wireless Communication, Cloud Computing, Processor Scheduling, Hard Deadline Constraint

## Algorithm Architecture

### Two-Phase Scheduling

#### **Phase 1: Initial Scheduling (Minimal-Delay)**

```
Primary Assignment → Task Prioritization → Execution Unit Selection
```

1. **Primary Assignment** (`primary_assignment`)
   - Compares best local execution time (min across cores) vs cloud execution time
   - Initial placement decision: local cores vs cloud
   - Implements Equations 11-12 from paper

2. **Task Prioritization** (`task_prioritizing`)
   - Computes priority scores using task graph topology
   - Uses computation costs (w_i) and successor priorities
   - Implements Equations 13-16 from paper

3. **Execution Unit Selection** (`execution_unit_selection`)
   - Schedules tasks in priority order
   - Computes ready times and finish times for all execution phases
   - Generates initial task sequences for each resource
   - Implements Equations 3-6 from paper

#### **Phase 2: Energy Optimization (Migration-Based)**

```
Migration Evaluation → Kernel Rescheduling → Energy Assessment → Accept/Reject
```

1. **Migration Evaluation** (`optimize_task_scheduling`)
   - Systematically evaluates moving tasks between cores and cloud
   - Uses caching to avoid redundant evaluations
   - Filters migrations that violate deadline (T_max)

2. **Kernel Algorithm** (`kernel_algorithm`)
   - Linear-time O(n) rescheduling after each migration
   - Maintains precedence constraints via dependency tracking
   - Recomputes all ready times and finish times

3. **Migration Selection** (`identify_optimal_migration`)
   - Two-phase selection strategy:
     - **Phase 1**: Prioritize migrations that reduce energy without increasing time
     - **Phase 2**: Consider time-energy tradeoffs using efficiency metric (energy saved / time increase)

### Execution Model

#### **Local Execution (Heterogeneous Cores)**
- 3 cores with different speeds and power consumption
- Core powers: [1W, 2W, 4W] (faster cores consume more power)
- Each task has different execution times per core
- No preemption: tasks run to completion

#### **Cloud Execution (3-Phase Pipeline)**
```
Mobile Device → [RF Send] → Cloud → [Compute] → Mobile Device → [RF Receive]
```

- **Sending Phase** (T_send = 3): Upload task data via wireless channel
- **Cloud Computing** (T_cloud = 1): Execute in cloud (assumed fast)
- **Receiving Phase** (T_receive = 1): Download results via wireless channel

**Key Constraint**: Wireless sending/receiving channels are shared resources that serialize communication.

### Metrics

**Completion Time** (Equation 10):
```
T_total = max(max(FT_l, FT_wr)) for all exit tasks
```

**Energy Consumption** (Equations 7-9):
```
Local:  E_i^l = P_k × T_i^l
Cloud:  E_i^c = P^s × T_i^s
Total:  E_total = Σ E_i for all tasks
```

## Key Implementation Components

### Task Graph (DAG)
- **Nodes**: Tasks with execution time requirements
- **Edges**: Precedence constraints (task dependencies)
- **Properties**:
  - `pred_tasks`: Immediate predecessors (must complete first)
  - `succ_tasks`: Immediate successors (depend on this task)

### Scheduling States
Tasks transition through three states:
1. `UNSCHEDULED` → Initial state
2. `SCHEDULED` → After Phase 1 (initial scheduling)
3. `KERNEL_SCHEDULED` → After Phase 2 (rescheduling)

### Timing Model
- **Ready Times (RT)**: Earliest start time for each execution phase
  - `RT_l`: Ready for local execution
  - `RT_ws`: Ready for wireless sending
  - `RT_c`: Ready for cloud computation
  - `RT_wr`: Ready for wireless receiving

- **Finish Times (FT)**: Actual completion time for each phase
  - `FT_l`: Local execution finish
  - `FT_ws`: Sending complete
  - `FT_c`: Cloud computation complete
  - `FT_wr`: Results received

## Test Graphs

The implementation includes 5 predefined task graphs:

| Graph | Tasks | Topology | Description |
|-------|-------|----------|-------------|
| 1 | 10 | Fan-out dominant | Tests parallel task handling |
| 2 | 10 | Balanced | Tests mixed dependencies |
| 3 | 20 | Deep pipeline | Tests long dependency chains |
| 4 | 20 | Wide parallelism | Tests resource contention |
| 5 | 20 | Irregular | Tests general case |

## Technical Details

### Complexity Analysis
- **Initial Scheduling**: O(n² log n) where n = number of tasks
  - Priority calculation: O(n²) (dynamic programming)
  - Task ordering: O(n log n)
  - Scheduling: O(n × k) where k = number of cores

- **Kernel Rescheduling**: O(n) linear time
  - Queue-based processing ensures each task processed once

- **Migration Phase**: O(n × m × k) where m = migration iterations
  - Typically m << n, so practical complexity is manageable

### Memory Optimization
- Migration caching prevents redundant evaluations
- Cache limit: 1000 entries (prevents unbounded growth)
- Memoization in priority calculation
