# Energy and Performance-Aware Task Scheduling in Mobile Cloud Computing

An implementation of the theoretical framework presented in the Energy and Performance-Aware Task Scheduling in a Mobile Cloud Computing Environment paper.The implementation constructs a Directed Acyclic Graph (DAG) of tasks and assigns local and cloud execution times.The implementation performs an initial phase of task assignment and prioritization to determine an initial schedule that minimizes total completion time, adhering to the paper’s outlined equations and heuristics for computing tasks’ priority scores and selecting their initial execution units. Once the baseline schedule is established, the code systematically explores migrating tasks between local cores and the cloud to achieve better energy efficiency. Each candidate migration scenario triggers a linear-time kernel rescheduling algorithm, recomputing all task start and finish times while ensuring all precedence constraints and resource capacities remain satisfied. After evaluating the new completion time and total energy consumption resulting from each migration, the code retains changes that reduce energy without exceeding permissible completion time thresholds. This iterative optimization loop directly mirrors the paper’s approach to jointly optimizing both performance (makespan) and energy consumption in a mobile cloud computing environment.

## Key Implementation Components

- **Task Graph Representation:**  
  Tasks are represented as nodes in a Directed Acyclic Graph (DAG). Edges define task precedence constraints.

- **Execution Units:**  
  - **Local Execution:** Multiple heterogeneous cores on the mobile device, each with different execution times and power consumption levels.
  - **Cloud Execution:** Offloading tasks to the cloud involves sending data, cloud computation, and receiving results phases.

- **Scheduling Phases:**
  1. **Primary Assignment:** Determines initial task placements (local vs. cloud) based on best execution times.
  2. **Task Prioritization:** Assigns priorities to tasks using a combination of local/cloud times and topological properties, ensuring that critical tasks get scheduled earlier.
  3. **Initial Scheduling:** Schedules tasks on cores or cloud to minimize delay.
  4. **Energy Optimization (Migration):** Iteratively improves the schedule by migrating tasks between cores and cloud using a kernel algorithm for rescheduling, aiming to reduce energy consumption without violating the deadline constraints.

- **Metrics:**
  - **Completion Time (T_total):** Maximum finish time across all exit tasks.
  - **Energy Consumption (E_total):** Computed for both local and cloud task execution.

- **Validation:**
  Ensures that the final schedule meets all constraints (no resource conflicts, correct task ordering, no deadline violations).
