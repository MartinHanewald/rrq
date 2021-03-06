# rrq 0.2.8

* Expand documentation (mrc-1800)

# rrq 0.2.7

* rrq progress now passes all fields in underlying condition (mrc-1772)

# rrq 0.2.6

* Update `worker_spawn` to work with breaking change in docopt (mrc-1667)

# rrq 0.2.5

* New `$task_data` method for getting underlying task data (mrc-1304)

# rrq 0.2.4

* Better error message is given whe non-existant task is cancelled (mrc-1259)

# rrq 0.2.3

* New `$worker_detect_exited` for detecting exited workers when a heartbeat is used (mrc-1231)

# rrq 0.2.2

* Tasks can now be interrupted with `$task_cancel` if running with a heartbeat enabled (mrc-734)

# rrq 0.2.1

* Add support for within-task progress updates, using the `rrq::rrq_task_progress_update` function, which can be called from any task run from `rrq` and queried with `$task_progress` from a `rrq_controller` (mrc-600)

# rrq 0.2.0

* Rewrite of the package to simplify queue creation and dependency chain (mrc-538 / #9, mrc-519 / #8, mrc-472 / #7)
