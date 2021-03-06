context("progress")

test_that("basic use", {
  obj <- test_rrq()
  w <- test_worker_blocking(obj)
  t <- obj$enqueue(sin(1))
  w$poll(TRUE)
  worker_run_task_start(w, t)

  ## Status is NULL by default (actually missing in Redis)
  expect_null(obj$task_progress(t))

  ## Status can be set
  expect_null(task_progress_update("status1", w, TRUE))
  expect_equal(obj$task_progress(t), "status1")

  ## Status can be updated
  expect_null(task_progress_update("status2", w, TRUE))
  expect_equal(obj$task_progress(t), "status2")

  ## Completing a task retains its status
  worker_run_task(w, t)
  expect_equal(obj$task_progress(t), "status2")

  ## Deleting a task removes its status
  obj$task_delete(t)
  expect_null(obj$task_progress(t))
})


test_that("update progress from interface function", {
  obj <- test_rrq("myfuns.R")
  wid <- test_worker_spawn(obj, 1)

  t <- obj$enqueue(run_with_progress(5, 0))
  res <- obj$task_wait(t)
  expect_equal(res, 5)
  expect_equal(obj$task_progress(t), "iteration 5")
})


test_that("update progress multiple times in task", {
  obj <- test_rrq("myfuns.R")
  wid <- test_worker_spawn(obj, 1)
  p <- tempfile()

  t <- obj$enqueue(run_with_progress_interactive(p))
  wait_status(t, obj)

  expect_equal(obj$task_progress(t),
               "Waiting for file")

  writeLines("something", p)
  Sys.sleep(0.2)
  expect_equal(obj$task_progress(t),
               "Got contents 'something'")

  writeLines("another thing", p)
  Sys.sleep(0.2)
  expect_equal(obj$task_progress(t),
               "Got contents 'another thing'")

  writeLines("STOP", p)
  wait_status(t, obj, status = TASK_RUNNING)
  expect_equal(obj$task_progress(t),
               "Finishing")
})


test_that("can't register progress with no active worker", {
  cache$active_worker <- NULL
  expect_error(
    rrq_task_progress_update("value", TRUE),
    "rrq_task_progress_update called with no active worker")
  expect_silent(
    rrq_task_progress_update("value", FALSE))
})


test_that("can't register progress with no active task", {
  obj <- test_rrq()
  w <- test_worker_blocking(obj)
  expect_error(
    task_progress_update("value", w, TRUE),
    "rrq_task_progress_update called with no active task")
  expect_silent(
    task_progress_update("value", w, FALSE))
})


test_that("collect progress from signal", {
  obj <- test_rrq("myfuns.R")
  w <- test_worker_blocking(obj)
  t <- obj$enqueue(run_with_progress_signal(5, 0))
  w$step(TRUE)
  expect_equal(obj$task_result(t), 5)
  expect_equal(obj$task_progress(t), list(message = "iteration 5"))
})
